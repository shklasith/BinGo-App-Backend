import admin from 'firebase-admin';

type PushMessage = {
    tokens: string[];
    title: string;
    body: string;
    data?: Record<string, string>;
};

const getFirebaseApp = () => {
    if (admin.apps.length > 0) {
        return admin.app();
    }

    const serviceAccountJson = process.env.FIREBASE_SERVICE_ACCOUNT_JSON;
    const projectId = process.env.FIREBASE_PROJECT_ID;
    const clientEmail = process.env.FIREBASE_CLIENT_EMAIL;
    const privateKey = process.env.FIREBASE_PRIVATE_KEY?.replace(/\\n/g, '\n');

    if (serviceAccountJson) {
        const serviceAccount = JSON.parse(serviceAccountJson);
        return admin.initializeApp({
            credential: admin.credential.cert(serviceAccount),
        });
    }

    if (projectId && clientEmail && privateKey) {
        return admin.initializeApp({
            credential: admin.credential.cert({
                projectId,
                clientEmail,
                privateKey,
            }),
        });
    }

    throw new Error('Firebase credentials are not configured');
};

export const sendPushNotification = async ({
    tokens,
    title,
    body,
    data,
}: PushMessage) => {
    const uniqueTokens = Array.from(new Set(tokens.filter(Boolean)));
    if (uniqueTokens.length === 0) {
        return { successCount: 0, failureCount: 0, invalidTokens: [] as string[] };
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
            return (
                code === 'messaging/invalid-registration-token' ||
                code === 'messaging/registration-token-not-registered'
            );
        })
        .map(({ token }) => token);

    return {
        successCount: response.successCount,
        failureCount: response.failureCount,
        invalidTokens,
    };
};
