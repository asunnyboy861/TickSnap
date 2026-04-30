import SwiftUI
import Observation
import AudioToolbox

@MainActor
@Observable
final class TimerEngine {
    
    var id: UUID = UUID()
    var name: String = ""
    var duration: TimeInterval = 0
    var elapsedSeconds: TimeInterval = 0
    var isRunning: Bool = false
    var isFinished: Bool = false
    var autoRepeat: Bool = false
    
    @ObservationIgnored private var timerTask: Task<Void, Never>?
    @ObservationIgnored var soundID: SystemSoundID = 1005
    
    var progress: CGFloat {
        guard duration > 0 else { return 0 }
        return min(CGFloat(elapsedSeconds / duration), 1)
    }
    
    var remainingSeconds: TimeInterval {
        max(duration - elapsedSeconds, 0)
    }
    
    var displayTime: String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = duration >= 3600 ? [.hour, .minute, .second] : [.minute, .second]
        formatter.zeroFormattingBehavior = [.pad]
        return formatter.string(from: remainingSeconds) ?? "00:00"
    }
    
    var canStart: Bool {
        duration > 0 && !isFinished
    }
    
    deinit {
        timerTask?.cancel()
    }
    
    func start() {
        guard canStart, !isRunning else { return }
        isRunning = true
        isFinished = false
        
        timerTask?.cancel()
        timerTask = Task { @MainActor [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(1))
                guard !Task.isCancelled, let self else { return }
                self.tick()
            }
        }
    }
    
    func pause() {
        isRunning = false
        timerTask?.cancel()
        timerTask = nil
    }
    
    func reset() {
        pause()
        elapsedSeconds = 0
        isFinished = false
    }
    
    func toggle() {
        isRunning ? pause() : start()
    }
    
    private func tick() {
        guard isRunning else { return }
        elapsedSeconds = min(elapsedSeconds + 1, duration)
        
        if elapsedSeconds >= duration {
            finishTimer()
        }
    }
    
    private func finishTimer() {
        isRunning = false
        isFinished = true
        timerTask?.cancel()
        timerTask = nil
        
        AudioServicesPlaySystemSound(soundID)
        
        if autoRepeat {
            elapsedSeconds = 0
            isFinished = false
            start()
        }
    }
}
