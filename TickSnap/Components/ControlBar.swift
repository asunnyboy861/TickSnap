import SwiftUI

struct ControlBar: View {
    
    let isRunning: Bool
    let onStart: () -> Void
    let onPause: () -> Void
    let onReset: () -> Void
    
    var body: some View {
        HStack(spacing: 32) {
            CircleButton(icon: "arrow.counterclockwise", color: .orange) {
                onReset()
            }
            
            CircleButton(
                icon: isRunning ? "pause.fill" : "play.fill",
                color: isRunning ? .orange : .green
            ) {
                if isRunning {
                    onPause()
                } else {
                    onStart()
                }
            }
            
            CircleButton(icon: "stop.fill", color: .red.opacity(0.7)) {
                onReset()
            }
        }
        .padding(.vertical, 8)
    }
}
