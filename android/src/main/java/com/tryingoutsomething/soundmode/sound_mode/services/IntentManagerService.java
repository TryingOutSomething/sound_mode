package com.tryingoutsomething.soundmode.sound_mode.services;

import android.content.Context;

/**
 * Interface for managing system intents.
 */
public interface IntentManagerService {
    boolean permissionsGranted();
    void launchSettings(Context context);
}
