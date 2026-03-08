import SwiftUI

enum PartyTheme {
    static let background = LinearGradient(
        colors: [
            Color(red: 0.08, green: 0.03, blue: 0.18),
            Color(red: 0.18, green: 0.05, blue: 0.32),
            Color(red: 0.02, green: 0.35, blue: 0.45)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let card = LinearGradient(
        colors: [
            Color.white.opacity(0.16),
            Color.white.opacity(0.08)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let hotPink = Color(red: 1.0, green: 0.24, blue: 0.62)
    static let neonBlue = Color(red: 0.30, green: 0.80, blue: 1.0)
    static let electricPurple = Color(red: 0.58, green: 0.34, blue: 1.0)
    static let gold = Color(red: 1.0, green: 0.84, blue: 0.28)
}

struct PartyBackground: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            PartyTheme.background
                .ignoresSafeArea()

            Circle()
                .fill(PartyTheme.hotPink.opacity(0.22))
                .frame(width: 260, height: 260)
                .blur(radius: 12)
                .offset(x: -130, y: -280)

            Circle()
                .fill(PartyTheme.neonBlue.opacity(0.20))
                .frame(width: 220, height: 220)
                .blur(radius: 10)
                .offset(x: 150, y: -180)

            Circle()
                .fill(PartyTheme.gold.opacity(0.14))
                .frame(width: 180, height: 180)
                .blur(radius: 12)
                .offset(x: 120, y: 300)

            content
        }
    }
}

struct PartyCard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(20)
            .background(PartyTheme.card)
            .overlay(
                RoundedRectangle(cornerRadius: 26)
                    .stroke(Color.white.opacity(0.14), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
            .shadow(color: Color.black.opacity(0.18), radius: 16, x: 0, y: 12)
    }
}

extension View {
    func partyBackground() -> some View { modifier(PartyBackground()) }
    func partyCard() -> some View { modifier(PartyCard()) }

    func partyPrimaryButton() -> some View {
        self
            .font(.headline.weight(.bold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: [PartyTheme.hotPink, PartyTheme.electricPurple],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .shadow(color: PartyTheme.hotPink.opacity(0.35), radius: 16, x: 0, y: 10)
    }

    func partySecondaryButton() -> some View {
        self
            .font(.headline.weight(.semibold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(Color.white.opacity(0.12))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color.white.opacity(0.14), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}
