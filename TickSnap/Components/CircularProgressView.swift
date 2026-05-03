import SwiftUI

struct CircularProgressView: View {
    
    let progress: CGFloat
    let lineWidth: CGFloat
    let color: Color
    let isRunning: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.12), lineWidth: lineWidth)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    color,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.smooth(duration: 0.35), value: progress)
            
            if isRunning && progress > 0 && progress < 1 {
                Circle()
                    .fill(color)
                    .frame(width: lineWidth * 1.5, height: lineWidth * 1.5)
                    .offset(y: -80)
                    .rotationEffect(.degrees(360 * Double(progress)))
                    .animation(.smooth(duration: 0.35), value: progress)
            }
        }
    }
}
