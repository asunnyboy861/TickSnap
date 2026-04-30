import SwiftUI
import SwiftData
import AudioToolbox

struct ContentView: View {
    
    @Environment(\.modelContext) private var modelContext
    @State private var timerManager = TimerManager()
    @State private var showingNewTimer = false
    @State private var showingSettings = false
    @Query(sort: \TimerPreset.sortOrder) var presets: [TimerPreset]
    
    private var selectedSoundID: SystemSoundID {
        let saved = UserDefaults.standard.integer(forKey: "selectedSoundID")
        return saved == 0 ? 1005 : SystemSoundID(saved)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    if timerManager.timers.isEmpty {
                        presetSection
                    } else {
                        activeTimersSection
                        presetSection
                    }
                }
                .padding()
            }
            .navigationTitle("TickSnap")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingNewTimer = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
            .sheet(isPresented: $showingNewTimer) {
                NewTimerSheet(timerManager: timerManager)
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
            .onAppear {
                loadDefaultPresetsIfNeeded()
                Task {
                    _ = await NotificationManager.shared.requestAuthorization()
                }
            }
        }
    }
    
    private var presetSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Start")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ], spacing: 12) {
                ForEach(presets) { preset in
                    PresetCard(preset: preset) {
                        let timer = timerManager.addTimerFromPreset(
                            preset,
                            soundID: selectedSoundID
                        )
                        timer.start()
                        NotificationManager.shared.scheduleTimerCompletion(
                            id: timer.id,
                            name: timer.name,
                            remainingSeconds: timer.remainingSeconds
                        )
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    }
                }
            }
        }
    }
    
    private var activeTimersSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Active Timers")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                if timerManager.timers.contains(where: { $0.isFinished }) {
                    Button("Clear Done") {
                        withAnimation {
                            timerManager.removeFinishedTimers()
                        }
                    }
                    .font(.subheadline)
                    .foregroundStyle(.orange)
                }
            }
            
            ForEach(timerManager.timers, id: \.id) { timer in
                TimerCardView(timer: timer) {
                    withAnimation {
                        timerManager.removeTimer(timer)
                    }
                }
            }
        }
    }
    
    private func loadDefaultPresetsIfNeeded() {
        guard presets.isEmpty else { return }
        
        for preset in TimerPreset.defaults {
            modelContext.insert(preset)
        }
        try? modelContext.save()
    }
}

struct PresetCard: View {
    
    let preset: TimerPreset
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                Image(systemName: preset.iconName)
                    .font(.title2)
                    .foregroundStyle(.orange)
                
                Text(preset.name)
                    .font(.subheadline.bold())
                    .foregroundStyle(.primary)
                
                Text(formatDuration(preset.duration))
                    .font(.caption)
                    .monospacedDigit()
                    .foregroundStyle(.secondary)
                
                if preset.autoRepeat {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .font(.caption2)
                        .foregroundStyle(.orange)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
        }
        .buttonStyle(.plain)
    }
    
    private func formatDuration(_ seconds: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = seconds >= 3600 ? [.hour, .minute, .second] : [.minute, .second]
        formatter.zeroFormattingBehavior = [.pad]
        return formatter.string(from: seconds) ?? "00:00"
    }
}
