import SwiftUI

struct CircularProgressView: View {
    
    let progress: CGFloat
    let lineWidth: CGFloat
    let gradient: AngularGradient
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: lineWidth)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    gradient,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.smooth(duration: 0.35), value: progress)
        }
    }
}
