import SwiftUI

struct TimerBackdrop: View {
    
    let isRunning: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            .orange.opacity(isRunning ? 0.15 : 0.05),
                            .clear
                        ],
                        center: .center,
                        startRadius: 50,
                        endRadius: 200
                    )
                )
                .frame(width: 300, height: 300)
        }
    }
}
