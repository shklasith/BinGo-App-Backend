import { Request, Response } from 'express';

import { AuthRequest } from '../middleware/auth';
import User from '../models/User';
import generateToken from '../utils/generateToken';

const defaultSettings = {
    darkMode: false,
    scanReminders: true,
    recyclingTips: true,
};

const allowedSettingsKeys = ['darkMode', 'scanReminders', 'recyclingTips'] as const;

const normalizeSettings = (settings?: Partial<typeof defaultSettings>) => ({
    darkMode: settings?.darkMode ?? defaultSettings.darkMode,
    scanReminders: settings?.scanReminders ?? defaultSettings.scanReminders,
    recyclingTips: settings?.recyclingTips ?? defaultSettings.recyclingTips,
});
export const registerUser = async (req: Request, res: Response) => {
    try {
        const { username, email, password } = req.body;

        const userExists = await User.findOne({ $or: [{ email }, { username }] });
        if (userExists) {
            return res.status(400).json({ success: false, message: 'User already exists' });
        }

        const user = await User.create({
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
                token: generateToken(String(user._id))
            }
        });
    } catch (error: any) {
        return res.status(400).json({ success: false, message: error.message });
    }
};

export const loginUser = async (req: Request, res: Response) => {
    try {
        const { email, password } = req.body;
        const user = await User.findOne({ email });

        if (user && (await user.comparePassword(password))) {
            return res.status(200).json({
                success: true,
                data: {
                    _id: user._id,
                    username: user.username,
                    email: user.email,
                    points: user.points,
                    token: generateToken(String(user._id))
                }
            });
        }

        return res.status(401).json({ success: false, message: 'Invalid email or password' });
    } catch (error: any) {
        return res.status(500).json({ success: false, message: error.message });
    }
};

export const getProfile = async (req: AuthRequest, res: Response) => {
    try {
        const user = req.user;
        if (!user) {
            return res.status(404).json({ success: false, message: 'User not found' });
        }

        return res.status(200).json({ success: true, data: user });
    } catch (error: any) {
        return res.status(500).json({ success: false, message: error.message });
    }
};

export const getUserById = async (req: AuthRequest, res: Response) => {
    try {
        if (!req.user) {
            return res.status(401).json({ success: false, message: 'Unauthorized' });
        }

        const { userId } = req.params;
        const user = await User.findById(userId).select('-passwordHash');

        if (!user) {
            return res.status(404).json({ success: false, message: 'User not found' });
        }

        return res.status(200).json({ success: true, data: user });
    } catch (error: any) {
        return res.status(500).json({ success: false, message: error.message });
    }
};

export const getLeaderboard = async (_req: Request, res: Response) => {
    try {
        const users = await User.find()
            .select('username points badges impactStats')
            .sort({ points: -1 })
            .limit(10);

        return res.status(200).json({ success: true, data: users });
    } catch (error: any) {
        return res.status(500).json({ success: false, message: error.message });
    }
};

export const getUserSettings = async (req: AuthRequest, res: Response) => {
    try {
        if (!req.user) {
            return res.status(401).json({ success: false, message: 'Unauthorized' });
        }

        return res.status(200).json({
            success: true,
            data: normalizeSettings(req.user.settings),
        });
    } catch (error: any) {
        return res.status(500).json({ success: false, message: error.message });
    }
};

export const updateUserSettings = async (req: AuthRequest, res: Response) => {
    try {
        if (!req.user) {
            return res.status(401).json({ success: false, message: 'Unauthorized' });
        }

        const updates = req.body as Record<string, unknown>;
        const keys = Object.keys(updates);

        const unknownKeys = keys.filter(
            (key) => !allowedSettingsKeys.includes(key as typeof allowedSettingsKeys[number])
        );

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
    } catch (error: any) {
        return res.status(500).json({ success: false, message: error.message });
    }
};
