import SwiftUI

struct CircleButton: View {
    
    let icon: String
    let color: Color
    let action: () -> Void
    let isPrimary: Bool
    
    init(icon: String, color: Color, isPrimary: Bool = false, action: @escaping () -> Void) {
        self.icon = icon
        self.color = color
        self.isPrimary = isPrimary
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(isPrimary ? .title2 : .title3)
                .foregroundStyle(isPrimary ? .white : color)
                .frame(width: isPrimary ? 64 : 48, height: isPrimary ? 64 : 48)
                .background(
                    isPrimary
                        ? color
                        : color.opacity(0.12)
                )
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
        .pressEffect()
    }
}

struct PressEffect: ViewModifier {
    @State private var isPressed = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? 0.92 : 1.0)
            .opacity(isPressed ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: isPressed)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in isPressed = true }
                    .onEnded { _ in isPressed = false }
            )
    }
}

extension View {
    func pressEffect() -> some View {
        modifier(PressEffect())
    }
}
