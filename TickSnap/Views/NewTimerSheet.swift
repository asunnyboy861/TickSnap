import SwiftUI
import AudioToolbox

struct NewTimerSheet: View {
    
    let timerManager: TimerManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var hours: Int = 0
    @State private var minutes: Int = 5
    @State private var seconds: Int = 0
    @State private var autoRepeat: Bool = false
    
    private var selectedSoundID: SystemSoundID {
        let saved = UserDefaults.standard.integer(forKey: "selectedSoundID")
        return saved == 0 ? 1005 : SystemSoundID(saved)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Timer Name") {
                    TextField("e.g. Boil Eggs", text: $name)
                }
                
                Section("Duration") {
                    HStack {
                        Picker("Hours", selection: $hours) {
                            ForEach(0..<24, id: \.self) { h in
                                Text("\(h)h").tag(h)
                            }
                        }
                        .pickerStyle(.wheel)
                        
                        Picker("Minutes", selection: $minutes) {
                            ForEach(0..<60, id: \.self) { m in
                                Text("\(m)m").tag(m)
                            }
                        }
                        .pickerStyle(.wheel)
                        
                        Picker("Seconds", selection: $seconds) {
                            ForEach(0..<60, id: \.self) { s in
                                Text("\(s)s").tag(s)
                            }
                        }
                        .pickerStyle(.wheel)
                    }
                    .frame(height: 120)
                }
                
                Section {
                    Toggle("Auto Repeat", isOn: $autoRepeat)
                } footer: {
                    Text("Timer will automatically restart when it finishes.")
                }
            }
            .navigationTitle("New Timer")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Start") {
                        startTimer()
                    }
                    .disabled(hours == 0 && minutes == 0 && seconds == 0)
                }
            }
        }
    }
    
    private func startTimer() {
        let totalSeconds = TimeInterval(hours * 3600 + minutes * 60 + seconds)
        guard totalSeconds > 0 else { return }
        
        let timer = timerManager.addTimer(
            name: name,
            duration: totalSeconds,
            autoRepeat: autoRepeat,
            soundID: selectedSoundID
        )
        timer.start()
        NotificationManager.shared.scheduleTimerCompletion(
            id: timer.id,
            name: timer.name,
            remainingSeconds: timer.remainingSeconds
        )
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        dismiss()
    }
}
