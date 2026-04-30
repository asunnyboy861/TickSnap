import SwiftUI

struct ClockView: View {
    
    let timeString: String
    let isRunning: Bool
    
    var body: some View {
        Text(timeString)
            .font(.system(size: 64, weight: .bold, design: .rounded))
            .monospacedDigit()
            .foregroundStyle(isRunning ? .primary : .secondary)
            .contentTransition(.numericText())
            .animation(.smooth(duration: 0.3), value: timeString)
    }
}
