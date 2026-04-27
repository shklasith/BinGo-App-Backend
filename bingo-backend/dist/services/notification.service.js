"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.sendPushNotification = void 0;
const firebase_admin_1 = __importDefault(require("firebase-admin"));
const getFirebaseApp = () => {
    if (firebase_admin_1.default.apps.length > 0) {
        return firebase_admin_1.default.app();
    }
    const serviceAccountJson = process.env.FIREBASE_SERVICE_ACCOUNT_JSON;
    const projectId = process.env.FIREBASE_PROJECT_ID;
    const clientEmail = process.env.FIREBASE_CLIENT_EMAIL;
    const privateKey = process.env.FIREBASE_PRIVATE_KEY?.replace(/\\n/g, '\n');
    if (serviceAccountJson) {
        const serviceAccount = JSON.parse(serviceAccountJson);
        return firebase_admin_1.default.initializeApp({
            credential: firebase_admin_1.default.credential.cert(serviceAccount),
        });
    }
    if (projectId && clientEmail && privateKey) {
        return firebase_admin_1.default.initializeApp({
            credential: firebase_admin_1.default.credential.cert({
                projectId,
                clientEmail,
                privateKey,
            }),
        });
    }
    throw new Error('Firebase credentials are not configured');
};
const sendPushNotification = async ({ tokens, title, body, data, }) => {
    const uniqueTokens = Array.from(new Set(tokens.filter(Boolean)));
    if (uniqueTokens.length === 0) {
        return { successCount: 0, failureCount: 0, invalidTokens: [] };
    }
    const messaging = getFirebaseApp().messaging();
    const response = await messaging.sendEachForMulticast({
        tokens: uniqueTokens,
        notification: { title, body },
        data,
    });
    const invalidTokens = response.responses
        .map((result, index) => ({ result, token: uniqueTokens[index] }))
        .filter(({ result }) => {
        const code = result.error?.code;
        return (code === 'messaging/invalid-registration-token' ||
            code === 'messaging/registration-token-not-registered');
    })
        .map(({ token }) => token);
    return {
        successCount: response.successCount,
        failureCount: response.failureCount,
        invalidTokens,
    };
};
exports.sendPushNotification = sendPushNotification;
