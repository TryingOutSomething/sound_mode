package com.tryingoutsomething.soundmode.sound_mode.services.impl;

import android.media.AudioManager;

import com.tryingoutsomething.soundmode.sound_mode.services.AudioManagerService;

/**
 * @author TryingOutSomething
 */
public class AudioManagerServiceImpl implements AudioManagerService {

    private final String NORMAL_MODE_PROFILE = "Normal Mode";
    private final String VIBRATE_MODE_PROFILE = "Vibrate Mode";
    private final String SILENT_MODE_PROFILE = "Silent Mode";

    private final AudioManager audioManager;

    public AudioManagerServiceImpl(AudioManager am) {
        this.audioManager = am;
    }

    @Override
    public String getCurrentRingerMode() {
        int ringerMode = audioManager.getRingerMode();

        switch (ringerMode) {
            case AudioManager.RINGER_MODE_NORMAL:
                return NORMAL_MODE_PROFILE;
            case AudioManager.RINGER_MODE_SILENT:
                return SILENT_MODE_PROFILE;
            case AudioManager.RINGER_MODE_VIBRATE:
                return VIBRATE_MODE_PROFILE;
            default:
                return null;
        }
    }

    @Override
    public String setRingerMode(int mode) {
        switch (mode) {
            case AudioManager.RINGER_MODE_NORMAL:
                audioManager.setRingerMode(mode);
                return NORMAL_MODE_PROFILE;

            case AudioManager.RINGER_MODE_SILENT:
                audioManager.setRingerMode(mode);
                return SILENT_MODE_PROFILE;

            case AudioManager.RINGER_MODE_VIBRATE:
                audioManager.setRingerMode(mode);
                return VIBRATE_MODE_PROFILE;

            default:
                return null;
        }
    }
}
