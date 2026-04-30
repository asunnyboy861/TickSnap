import Foundation
import SwiftData

@Model
final class TimerPreset {
    
    @Attribute(.unique) var id: UUID
    var name: String
    var duration: TimeInterval
    var autoRepeat: Bool
    var iconName: String
    var sortOrder: Int
    var isDefault: Bool
    
    init(name: String, duration: TimeInterval, autoRepeat: Bool = false, iconName: String = "timer", sortOrder: Int = 0, isDefault: Bool = false) {
        self.id = UUID()
        self.name = name
        self.duration = duration
        self.autoRepeat = autoRepeat
        self.iconName = iconName
        self.sortOrder = sortOrder
        self.isDefault = isDefault
    }
    
    static var defaults: [TimerPreset] {
        [
            TimerPreset(name: "Tea", duration: 180, autoRepeat: false, iconName: "mug.fill", sortOrder: 0, isDefault: true),
            TimerPreset(name: "Egg", duration: 360, autoRepeat: false, iconName: "egg.fill", sortOrder: 1, isDefault: true),
            TimerPreset(name: "Pasta", duration: 480, autoRepeat: false, iconName: "fork.knife", sortOrder: 2, isDefault: true),
            TimerPreset(name: "Rest", duration: 60, autoRepeat: true, iconName: "figure.walk", sortOrder: 3, isDefault: true),
            TimerPreset(name: "Stretch", duration: 30, autoRepeat: true, iconName: "figure.flexibility", sortOrder: 4, isDefault: true),
            TimerPreset(name: "Focus", duration: 1500, autoRepeat: false, iconName: "brain.head.profile.fill", sortOrder: 5, isDefault: true),
        ]
    }
}
