import SwiftUI

struct CircleButton: View {
    
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.white)
                .frame(width: 56, height: 56)
                .background(color)
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
    }
}
