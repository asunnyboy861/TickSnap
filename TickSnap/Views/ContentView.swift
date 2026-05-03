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
                VStack(spacing: 28) {
                    if timerManager.timers.isEmpty {
                        presetSection
                    } else {
                        activeTimersSection
                        presetSection
                    }
                }
                .padding()
                .frame(maxWidth: 720)
                .frame(maxWidth: .infinity)
            }
            .navigationTitle("TickSnap")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundStyle(.secondary)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingNewTimer = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(.orange)
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
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Quick Start")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.primary)
                
                Spacer()
            }
            
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
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Active")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.primary)
                
                Spacer()
                
                if timerManager.timers.contains(where: { $0.isFinished }) {
                    Button("Clear Done") {
                        withAnimation {
                            timerManager.removeFinishedTimers()
                        }
                    }
                    .font(.subheadline.weight(.medium))
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
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.orange.opacity(0.1))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: preset.iconName)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(.orange)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(preset.name)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary)
                    
                    HStack(spacing: 6) {
                        Text(formatDuration(preset.duration))
                            .font(.caption)
                            .monospacedDigit()
                            .foregroundStyle(.secondary)
                        
                        if preset.autoRepeat {
                            Image(systemName: "arrow.2.circlepath")
                                .font(.caption2)
                                .foregroundStyle(.orange.opacity(0.7))
                        }
                    }
                }
                
                Spacer()
                
                Image(systemName: "play.fill")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.orange.opacity(0.5))
            }
            .padding()
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.gray.opacity(0.08), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .pressEffect()
    }
    
    private func formatDuration(_ seconds: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = seconds >= 3600 ? [.hour, .minute, .second] : [.minute, .second]
        formatter.zeroFormattingBehavior = [.pad]
        return formatter.string(from: seconds) ?? "00:00"
    }
}
