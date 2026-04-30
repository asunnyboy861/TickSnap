import SwiftUI
import Observation
import AudioToolbox

@MainActor
@Observable
final class TimerManager {
    
    var timers: [TimerEngine] = []
    
    func addTimer(name: String, duration: TimeInterval, autoRepeat: Bool = false, soundID: SystemSoundID = 1005) -> TimerEngine {
        let engine = TimerEngine()
        engine.name = name
        engine.duration = duration
        engine.autoRepeat = autoRepeat
        engine.soundID = soundID
        timers.append(engine)
        return engine
    }
    
    func addTimerFromPreset(_ preset: TimerPreset, soundID: SystemSoundID = 1005) -> TimerEngine {
        addTimer(name: preset.name, duration: preset.duration, autoRepeat: preset.autoRepeat, soundID: soundID)
    }
    
    func removeTimer(_ timer: TimerEngine) {
        timer.pause()
        NotificationManager.shared.cancelNotification(id: timer.id)
        timers.removeAll { $0.id == timer.id }
    }
    
    func removeFinishedTimers() {
        let finished = timers.filter { $0.isFinished }
        for timer in finished {
            NotificationManager.shared.cancelNotification(id: timer.id)
        }
        timers.removeAll { $0.isFinished }
    }
    
    var activeTimers: [TimerEngine] {
        timers.filter { $0.isRunning }
    }
    
    var hasActiveTimers: Bool {
        timers.contains { $0.isRunning }
    }
}
