"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.sendPushToUser = exports.removePushToken = exports.registerPushToken = exports.updateUserSettings = exports.getUserSettings = exports.getAdminUserList = exports.getLeaderboard = exports.getUserById = exports.getProfile = exports.loginUser = exports.registerUser = void 0;
const User_1 = __importDefault(require("../models/User"));
const notification_service_1 = require("../services/notification.service");
const generateToken_1 = __importDefault(require("../utils/generateToken"));
const defaultSettings = {
    darkMode: false,
    scanReminders: true,
    recyclingTips: true,
};
const allowedSettingsKeys = ['darkMode', 'scanReminders', 'recyclingTips'];
const normalizeSettings = (settings) => ({
    darkMode: settings?.darkMode ?? defaultSettings.darkMode,
    scanReminders: settings?.scanReminders ?? defaultSettings.scanReminders,
    recyclingTips: settings?.recyclingTips ?? defaultSettings.recyclingTips,
});
const registerUser = async (req, res) => {
    try {
        const { username, email, password } = req.body;
        const userExists = await User_1.default.findOne({ $or: [{ email }, { username }] });
        if (userExists) {
            return res.status(400).json({ success: false, message: 'User already exists' });
        }
        const user = await User_1.default.create({
            username,
            email,
            passwordHash: password, // This will be hashed by the pre-save hook
            settings: defaultSettings,
        });
        if (!user) {
            return res.status(400).json({ success: false, message: 'Invalid user data' });
        }
        return res.status(201).json({
            success: true,
            data: {
                _id: user._id,
                username: user.username,
                email: user.email,
                points: user.points,
                token: (0, generateToken_1.default)(String(user._id))
            }
        });
    }
    catch (error) {
        return res.status(400).json({ success: false, message: error.message });
    }
};
exports.registerUser = registerUser;
const loginUser = async (req, res) => {
    try {
        const { email, password } = req.body;
        const user = await User_1.default.findOne({ email });
        if (user && (await user.comparePassword(password))) {
            return res.status(200).json({
                success: true,
                data: {
                    _id: user._id,
                    username: user.username,
                    email: user.email,
                    points: user.points,
                    token: (0, generateToken_1.default)(String(user._id))
                }
            });
        }
        return res.status(401).json({ success: false, message: 'Invalid email or password' });
    }
    catch (error) {
        return res.status(500).json({ success: false, message: error.message });
    }
};
exports.loginUser = loginUser;
const getProfile = async (req, res) => {
    try {
        const user = req.user;
        if (!user) {
            return res.status(404).json({ success: false, message: 'User not found' });
        }
        return res.status(200).json({ success: true, data: user });
    }
    catch (error) {
        return res.status(500).json({ success: false, message: error.message });
    }
};
exports.getProfile = getProfile;
const getUserById = async (req, res) => {
    try {
        if (!req.user) {
            return res.status(401).json({ success: false, message: 'Unauthorized' });
        }
        const { userId } = req.params;
        const user = await User_1.default.findById(userId).select('-passwordHash');
        if (!user) {
            return res.status(404).json({ success: false, message: 'User not found' });
        }
        return res.status(200).json({ success: true, data: user });
    }
    catch (error) {
        return res.status(500).json({ success: false, message: error.message });
    }
};
exports.getUserById = getUserById;
const getLeaderboard = async (_req, res) => {
    try {
        const users = await User_1.default.find()
            .select('username points badges impactStats')
            .sort({ points: -1 })
            .limit(10);
        return res.status(200).json({ success: true, data: users });
    }
    catch (error) {
        return res.status(500).json({ success: false, message: error.message });
    }
};
exports.getLeaderboard = getLeaderboard;
const getAdminUserList = async (req, res) => {
    try {
        if (!req.user) {
            return res.status(401).json({ success: false, message: 'Unauthorized' });
        }
        const users = await User_1.default.find()
            .select('username email points badges impactStats settings createdAt updatedAt')
            .sort({ createdAt: -1 });
        return res.status(200).json({ success: true, data: users });
    }
    catch (error) {
        return res.status(500).json({ success: false, message: error.message });
    }
};
exports.getAdminUserList = getAdminUserList;
const getUserSettings = async (req, res) => {
    try {
        if (!req.user) {
            return res.status(401).json({ success: false, message: 'Unauthorized' });
        }
        return res.status(200).json({
            success: true,
            data: normalizeSettings(req.user.settings),
        });
    }
    catch (error) {
        return res.status(500).json({ success: false, message: error.message });
    }
};
exports.getUserSettings = getUserSettings;
const updateUserSettings = async (req, res) => {
    try {
        if (!req.user) {
            return res.status(401).json({ success: false, message: 'Unauthorized' });
        }
        const updates = req.body;
        const keys = Object.keys(updates);
        const unknownKeys = keys.filter((key) => !allowedSettingsKeys.includes(key));
        if (unknownKeys.length > 0) {
            return res.status(400).json({
                success: false,
                message: `Unknown settings fields: ${unknownKeys.join(', ')}`,
            });
        }
        for (const key of keys) {
            if (typeof updates[key] !== 'boolean') {
                return res.status(400).json({
                    success: false,
                    message: `${key} must be a boolean`,
                });
            }
        }
        const currentSettings = normalizeSettings(req.user.settings);
        const nextSettings = {
            ...currentSettings,
            ...updates,
        };
        req.user.settings = nextSettings;
        await req.user.save();
        return res.status(200).json({
            success: true,
            data: normalizeSettings(req.user.settings),
        });
    }
    catch (error) {
        return res.status(500).json({ success: false, message: error.message });
    }
};
exports.updateUserSettings = updateUserSettings;
const registerPushToken = async (req, res) => {
    try {
        if (!req.user) {
            return res.status(401).json({ success: false, message: 'Unauthorized' });
        }
        const token = req.body.token?.toString().trim();
        if (!token) {
            return res.status(400).json({ success: false, message: 'Push token is required' });
        }
        await User_1.default.findByIdAndUpdate(req.user._id, {
            $addToSet: { fcmTokens: token },
        });
        return res.status(200).json({ success: true, data: { registered: true } });
    }
    catch (error) {
        return res.status(500).json({ success: false, message: error.message });
    }
};
exports.registerPushToken = registerPushToken;
const removePushToken = async (req, res) => {
    try {
        if (!req.user) {
            return res.status(401).json({ success: false, message: 'Unauthorized' });
        }
        const token = req.body.token?.toString().trim();
        if (!token) {
            return res.status(400).json({ success: false, message: 'Push token is required' });
        }
        await User_1.default.findByIdAndUpdate(req.user._id, {
            $pull: { fcmTokens: token },
        });
        return res.status(200).json({ success: true, data: { removed: true } });
    }
    catch (error) {
        return res.status(500).json({ success: false, message: error.message });
    }
};
exports.removePushToken = removePushToken;
const sendPushToUser = async (req, res) => {
    try {
        if (!req.user) {
            return res.status(401).json({ success: false, message: 'Unauthorized' });
        }
        const { userId } = req.params;
        const title = req.body.title?.toString().trim();
        const body = req.body.body?.toString().trim();
        const data = req.body.data && typeof req.body.data === 'object'
            ? Object.fromEntries(Object.entries(req.body.data).map(([key, value]) => [
                key,
                String(value),
            ]))
            : undefined;
        if (!title || !body) {
            return res.status(400).json({
                success: false,
                message: 'Notification title and body are required',
            });
        }
        const user = await User_1.default.findById(userId).select('fcmTokens');
        if (!user) {
            return res.status(404).json({ success: false, message: 'User not found' });
        }
        const result = await (0, notification_service_1.sendPushNotification)({
            tokens: user.fcmTokens,
            title,
            body,
            data,
        });
        if (result.invalidTokens.length > 0) {
            await User_1.default.findByIdAndUpdate(userId, {
                $pull: { fcmTokens: { $in: result.invalidTokens } },
            });
        }
        return res.status(200).json({ success: true, data: result });
    }
    catch (error) {
        return res.status(500).json({ success: false, message: error.message });
    }
};
exports.sendPushToUser = sendPushToUser;
