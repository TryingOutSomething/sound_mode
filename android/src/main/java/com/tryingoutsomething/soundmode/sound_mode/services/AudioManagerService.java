package com.tryingoutsomething.soundmode.sound_mode.services;

/**
 * Interface to handle audio profile modes.
 */
public interface AudioManagerService {
    String getCurrentRingerMode();
    String setRingerMode(int updatedRingerMode);
}
