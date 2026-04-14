import * as functions from "firebase-functions/v2/https";
const { authenticator } = require("otplib");

// 1. Rota para gerar o Segredo
export const generate2fa = functions.onCall((request) => {
    // Na v2, os dados ficam dentro de request.data
    const email = request.data.email || "usuario@euro.com";
    
    const secret = authenticator.generateSecret();
    const qrCodeUri = authenticator.keyuri(email, "EuroAcademy", secret);

    return {
        secret: secret,
        qrCodeUri: qrCodeUri
    };
});

// 2. Rota para verificar o token
export const verify2fa = functions.onCall((request) => {
    // Na v2, acessamos request.data.secret e request.data.token
    const secret = request.data.secret;
    const token = request.data.token; 

    if (!secret || !token) {
        return { isValid: false, error: "Dados incompletos" };
    }

    try {
        const isValid = authenticator.verify({ token, secret });
        return { isValid: isValid };
    } catch (err) {
        return { isValid: false, error: "Falha na verificação" };
    }
});