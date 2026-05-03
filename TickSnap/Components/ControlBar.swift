import SwiftUI

struct ControlBar: View {
    
    let isRunning: Bool
    let onStart: () -> Void
    let onPause: () -> Void
    let onReset: () -> Void
    
    var body: some View {
        HStack(spacing: 40) {
            CircleButton(icon: "arrow.counterclockwise", color: .secondary) {
                onReset()
            }
            
            CircleButton(
                icon: isRunning ? "pause.fill" : "play.fill",
                color: .orange,
                isPrimary: true
            ) {
                if isRunning {
                    onPause()
                } else {
                    onStart()
                }
            }
            
            CircleButton(icon: "stop.fill", color: .secondary) {
                onReset()
            }
        }
        .padding(.vertical, 12)
    }
}
