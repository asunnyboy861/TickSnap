import SwiftUI
import SwiftData
import AudioToolbox

struct SettingsView: View {
    
    @Environment(\.dismiss) private var dismiss
    @AppStorage("selectedSoundID") private var selectedSoundID: Int = 1005
    @Query(filter: #Predicate<TimerPreset> { !$0.isDefault }) var customPresets: [TimerPreset]
    @Environment(\.modelContext) private var modelContext
    
    private let supportURL = "https://asunnyboy861.github.io/TickSnap/support.html"
    private let privacyURL = "https://asunnyboy861.github.io/TickSnap/privacy.html"
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Alert Sound") {
                    Picker("Sound", selection: $selectedSoundID) {
                        ForEach(SystemSounds.allCases) { sound in
                            Text(sound.displayName).tag(Int(sound.rawValue))
                        }
                    }
                    .onChange(of: selectedSoundID) { _, newValue in
                        AudioServicesPlaySystemSound(SystemSoundID(newValue))
                    }
                }
                
                Section("Custom Presets") {
                    if customPresets.isEmpty {
                        Text("No custom presets yet")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(customPresets) { preset in
                            HStack {
                                Image(systemName: preset.iconName)
                                    .foregroundStyle(.orange)
                                Text(preset.name)
                                Spacer()
                                Text(formatDuration(preset.duration))
                                    .monospacedDigit()
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .onDelete(perform: deleteCustomPreset)
                    }
                }
                
                Section("About") {
                    Link("Support", destination: URL(string: supportURL)!)
                    Link("Privacy Policy", destination: URL(string: privacyURL)!)
                    NavigationLink("Contact Support") {
                        ContactSupportView()
                    }
                }
                
                Section {
                    HStack {
                        Spacer()
                        Text("TickSnap v1.0.0")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                        Spacer()
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
    
    private func deleteCustomPreset(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(customPresets[index])
        }
        try? modelContext.save()
    }
    
    private func formatDuration(_ seconds: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = seconds >= 3600 ? [.hour, .minute, .second] : [.minute, .second]
        formatter.zeroFormattingBehavior = [.pad]
        return formatter.string(from: seconds) ?? "00:00"
    }
}
