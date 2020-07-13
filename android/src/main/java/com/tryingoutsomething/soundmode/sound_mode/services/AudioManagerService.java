package com.tryingoutsomething.soundmode.sound_mode.services;

/**
 * @author TryingOutSomething
 */
public interface AudioManagerService {

    String getCurrentRingerMode();
    String setRingerMode(int updatedRingerMode);
}
