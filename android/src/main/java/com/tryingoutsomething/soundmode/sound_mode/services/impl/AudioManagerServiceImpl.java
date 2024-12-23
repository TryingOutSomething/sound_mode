package com.tryingoutsomething.soundmode.sound_mode.services.impl;

import android.app.NotificationManager;
import android.content.Context;
import android.media.AudioManager;
import android.os.Build;

import com.tryingoutsomething.soundmode.sound_mode.services.AudioManagerService;

public class AudioManagerServiceImpl implements AudioManagerService {

    private final String NORMAL_MODE_PROFILE = "normal";
    private final String VIBRATE_MODE_PROFILE = "vibrate";
    private final String SILENT_MODE_PROFILE = "silent";
    private final String DND_MODE_PROFILE = "dnd";

    private final AudioManager audioManager;
    private final NotificationManager notificationManager;

    public AudioManagerServiceImpl(AudioManager audioManager, NotificationManager notificationManager) {
        this.audioManager = audioManager;
        this.notificationManager = notificationManager;
    }

    @Override
    public String getCurrentRingerMode() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            int interruptionFilter = notificationManager.getCurrentInterruptionFilter();
            if (interruptionFilter == NotificationManager.INTERRUPTION_FILTER_NONE) {
                return DND_MODE_PROFILE;
            }
        }

        switch (audioManager.getRingerMode()) {
            case AudioManager.RINGER_MODE_NORMAL:
                return NORMAL_MODE_PROFILE;
            case AudioManager.RINGER_MODE_VIBRATE:
                return VIBRATE_MODE_PROFILE;
            case AudioManager.RINGER_MODE_SILENT:
                return SILENT_MODE_PROFILE;
            default:
                return null;
        }
    }

    @Override
    public String setRingerMode(int mode) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && mode == AudioManager.RINGER_MODE_SILENT) {
            if (!notificationManager.isNotificationPolicyAccessGranted()) {
                return null;
            }
            notificationManager.setInterruptionFilter(NotificationManager.INTERRUPTION_FILTER_NONE);
            return DND_MODE_PROFILE;
        }

        audioManager.setRingerMode(mode);
        return mode == AudioManager.RINGER_MODE_VIBRATE ? VIBRATE_MODE_PROFILE : NORMAL_MODE_PROFILE;
    }
}
