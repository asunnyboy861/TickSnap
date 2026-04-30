import SwiftUI

struct TimerCardView: View {
    
    let timer: TimerEngine
    let onDelete: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(timer.name.isEmpty ? "Timer" : timer.name)
                        .font(.headline)
                    
                    if timer.autoRepeat {
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.triangle.2.circlepath")
                                .font(.caption2)
                            Text("Auto Repeat")
                                .font(.caption2)
                        }
                        .foregroundStyle(.orange)
                    }
                }
                
                Spacer()
                
                if timer.isFinished {
                    Text("Done!")
                        .font(.headline)
                        .foregroundStyle(.green)
                } else {
                    Circle()
                        .fill(timer.isRunning ? .green : .orange)
                        .frame(width: 8, height: 8)
                }
            }
            
            ZStack {
                TimerBackdrop(isRunning: timer.isRunning)
                
                CircularProgressView(
                    progress: timer.progress,
                    lineWidth: 8,
                    gradient: AngularGradient(
                        colors: [.orange, .cyan, .orange],
                        center: .center
                    )
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
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
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
