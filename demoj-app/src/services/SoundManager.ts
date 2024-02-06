enum SoundEnum {
    ALERT_ERROR_01 = "alert_error-01.wav",
    ALERT_ERROR_02 = "alert_error-02.wav",
    ALERT_HIGH_INTENSITY = "alert_high-intensity.wav",
    HERO_SIMPLE_CELEBRATION_01 = "hero_simple-celebration-01.wav",
    HERO_SIMPLE_CELEBRATION_02 = "hero_simple-celebration-02.wav",
    HERO_SIMPLE_CELEBRATION_03 = "hero_simple-celebration-03.wav",
    NAVIGATION_CANCEL = "navigation_cancel.wav",
    NAVIGATION_BACKWARD_SELECTION_MINIMAL = "navigation_backward-selection-minimal.wav",
    NAVIGATION_BACKWARD_SELECTION = "navigation_backward-selection.wav",
    NAVIGATION_FORWARD_SELECTION_MINIMAL = "navigation_forward-selection-minimal.wav",
    NAVIGATION_FORWARD_SELECTION = "navigation_forward-selection.wav",
    NAVIGATION_SELECTION_COMPLETE_CELEBRATION = "navigation_selection-complete-celebration.wav",
    NAVIGATION_UNAVAILABLE_SELECTION = "navigation_unavailable-selection.wav",
    NOTIFICATION_DECORATIVE_01 = "notification_decorative-01.wav",
    NOTIFICATION_HIGH_INTENSITY = "notification_high-intensity.wav",
    NOTIFICATION_SIMPLE_01 = "notification_simple-01.wav",
    NOTIFICATION_SIMPLE_02 = "notification_simple-02.wav",
    UI_LOADING = "ui_loading.wav",
    UI_UNLOCK = "ui_unlock.wav"
}

class SoundManager {
    private sounds: Record<SoundEnum, HTMLAudioElement>;

    constructor() {
        this.sounds = {} as Record<SoundEnum, HTMLAudioElement>;
    }

    loadSounds(soundList: SoundEnum[]) {
        for (const sound of soundList) {
            this.sounds[sound] = new Audio(`/app/assets/sounds/${sound}`);
            this.sounds[sound].autoplay = true;
            this.sounds[sound].muted = true;
        }
    }

    playSound(sound: SoundEnum) {
        if (this.sounds[sound]) {
            this.sounds[sound].muted = false;
            this.sounds[sound].play();
        } else {
            console.error(`Sound ${sound} not found`);
        }
    }
}

export { SoundEnum, SoundManager };

