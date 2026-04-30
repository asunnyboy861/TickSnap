import UserNotifications
import AudioToolbox

final class NotificationManager {
    
    static let shared = NotificationManager()
    
    private init() {}
    
    func requestAuthorization() async -> Bool {
        do {
            return try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .sound, .badge])
        } catch {
            return false
        }
    }
    
    func scheduleTimerCompletion(id: UUID, name: String, remainingSeconds: TimeInterval) {
        guard remainingSeconds > 0 else { return }
        
        let content = UNMutableNotificationContent()
        content.title = name.isEmpty ? "Timer Done!" : "\(name) Done!"
        content.body = "Your countdown timer has finished."
        content.sound = .default
        content.categoryIdentifier = "TIMER_DONE"
        
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: remainingSeconds,
            repeats: false
        )
        
        let request = UNNotificationRequest(
            identifier: id.uuidString,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func cancelNotification(id: UUID) {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [id.uuidString])
    }
}
