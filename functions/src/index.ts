import * as admin from "firebase-admin";
import { onCall } from "firebase-functions/v2/https";
import { onDocumentWritten, onDocumentUpdated } from "firebase-functions/v2/firestore";
import * as logger from "firebase-functions/logger";
import { authenticator } from "otplib";
import * as qrcode from "qrcode";

admin.initializeApp();
const db = admin.firestore();

// Migrated 2FA functions
export const generate2fa = onCall(async (request) => {
  const secret = authenticator.generateSecret();
  const email = request.data.email || "colaborador@eurofarma.com";
  const otpauthUrl = authenticator.keyuri(email, "Euro Academy", secret);

  try {
    const qrCodeUri = await qrcode.toDataURL(otpauthUrl);
    return { secret, qrCodeUri };
  } catch (err) {
    return { error: "Erro no QR Code" };
  }
});

export const verify2fa = onCall((request) => {
  const isValid = authenticator.check(request.data.token, request.data.secret);
  return { isValid };
});

// Notifications functions
export const onCourseUpdated = onDocumentUpdated("courses/{courseId}", async (event) => {
  const courseId = event.params.courseId;
  const newValue = event.data?.after.data();
  const previousValue = event.data?.before.data();

  if (!newValue || !previousValue) {
    return;
  }

  const currentAssignedUsers = newValue.assignedUsers || [];
  const previousAssignedUsers = previousValue.assignedUsers || [];

  // Find users that are in current array but not in previous array
  const newUsers = currentAssignedUsers.filter((userId: string) => !previousAssignedUsers.includes(userId));

  if (newUsers.length === 0) {
    logger.info(`No new users assigned to course ${courseId}`);
    return;
  }

  logger.info(`New users assigned to course ${courseId}: ${newUsers.join(", ")}`);

  const courseTitle = newValue.title || "Novo Curso";

  // Create an assignment notification for each new user
  const batch = db.batch();

  for (const userId of newUsers) {
    const notificationsRef = db.collection(`users/${userId}/notifications`).doc();
    batch.set(notificationsRef, {
      id: notificationsRef.id,
      title: "Novo Curso Atribuído",
      message: `Você foi atribuído ao curso: ${courseTitle}.`,
      type: "assignment",
      isRead: false,
      createdAt: admin.firestore.FieldValue.serverTimestamp()
    });
  }

  await batch.commit();
  logger.info(`Successfully created assignment notifications for course ${courseId}`);
});

export const onScormProgressUpdated = onDocumentWritten("users/{userId}/scorm_progress/{courseId}", async (event) => {
  const userId = event.params.userId;
  const courseId = event.params.courseId;

  const newValue = event.data?.after?.data();
  const previousValue = event.data?.before?.data();

  if (!newValue) {
    return; // Document was deleted
  }

  const currentStatus = newValue.status;
  const previousStatus = previousValue?.status;

  // Check if status changed to completed
  if (currentStatus === "completed" && previousStatus !== "completed") {
    logger.info(`User ${userId} completed course ${courseId}`);

    // Try to fetch course title
    let courseTitle = "Curso concluído";
    try {
      const courseDoc = await db.collection("courses").doc(courseId).get();
      if (courseDoc.exists) {
        courseTitle = courseDoc.data()?.title || courseTitle;
      }
    } catch (e) {
      logger.error(`Error fetching course ${courseId}`, e);
    }

    const notificationsRef = db.collection(`users/${userId}/notifications`).doc();
    await notificationsRef.set({
      id: notificationsRef.id,
      title: "Curso Concluído",
      message: `Parabéns! Você concluiu o curso: ${courseTitle}.`,
      type: "completion",
      isRead: false,
      createdAt: admin.firestore.FieldValue.serverTimestamp()
    });

    logger.info(`Successfully created completion notification for user ${userId} on course ${courseId}`);
  }
});
