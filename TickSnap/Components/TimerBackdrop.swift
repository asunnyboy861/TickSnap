import SwiftUI

struct TimerBackdrop: View {
    
    let isRunning: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            .orange.opacity(isRunning ? 0.08 : 0.03),
                            .clear
                        ],
                        center: .center,
                        startRadius: 40,
                        endRadius: 180
                    )
                )
                .frame(width: 280, height: 280)
        }
    }
}
