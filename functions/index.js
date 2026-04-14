const { onCall } = require("firebase-functions/v2/https");
const { authenticator } = require("otplib");
const qrcode = require("qrcode");

exports.generate2fa = onCall(async (request) => {
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

exports.verify2fa = onCall((request) => {
  const isValid = authenticator.check(request.data.token, request.data.secret);
  return { isValid };
});