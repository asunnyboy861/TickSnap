import SwiftUI

struct TimerCardView: View {
    
    let timer: TimerEngine
    let onDelete: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(timer.name.isEmpty ? "Timer" : timer.name)
                        .font(.headline.weight(.semibold))
                    
                    if timer.autoRepeat {
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.2.circlepath")
                                .font(.caption2.weight(.medium))
                            Text("Repeats")
                                .font(.caption2.weight(.medium))
                        }
                        .foregroundStyle(.orange)
                    }
                }
                
                Spacer()
                
                if timer.isFinished {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Done")
                    }
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.green)
                } else {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(timer.isRunning ? .green : .orange)
                            .frame(width: 6, height: 6)
                        Text(timer.isRunning ? "Running" : "Paused")
                            .font(.caption.weight(.medium))
                            .foregroundStyle(.secondary)
                    }
                }
            }
            
            ZStack {
                TimerBackdrop(isRunning: timer.isRunning)
                
                CircularProgressView(
                    progress: timer.progress,
                    lineWidth: 6,
                    color: timer.isFinished ? .green : .orange,
                    isRunning: timer.isRunning
                )
                .frame(width: 160, height: 160)
                
                ClockView(
                    timeString: timer.displayTime,
                    isRunning: timer.isRunning
                )
            }
            .frame(height: 180)
            
            ControlBar(
                isRunning: timer.isRunning,
                onStart: {
                    timer.start()
                    NotificationManager.shared.scheduleTimerCompletion(
                        id: timer.id,
                        name: timer.name,
                        remainingSeconds: timer.remainingSeconds
                    )
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                },
                onPause: {
                    timer.pause()
                    NotificationManager.shared.cancelNotification(id: timer.id)
                },
                onReset: {
                    timer.reset()
                    NotificationManager.shared.cancelNotification(id: timer.id)
                }
            )
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.gray.opacity(0.08), lineWidth: 1)
        )
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                withAnimation {
                    onDelete()
                }
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}
