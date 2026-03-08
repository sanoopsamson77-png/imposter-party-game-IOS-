import SwiftUI

struct RevealView: View {
    @EnvironmentObject private var viewModel: GameViewModel
    @State private var isRevealed: Bool = false

    var body: some View {
        let currentIndex = viewModel.revealIndex
        guard currentIndex < viewModel.players.count else {
            return AnyView(EmptyView())
        }

        let player = viewModel.players[currentIndex]

        return AnyView(
            VStack(spacing: 24) {
                Spacer(minLength: 12)

                Text("Pass the phone to")
                    .font(.headline)
                    .foregroundStyle(.white.opacity(0.82))

                Text(player.name)
                    .font(.system(size: 36, weight: .heavy, design: .rounded))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)

                if isRevealed {
                    revealContent(for: player)
                        .partyCard()
                } else {
                    VStack(spacing: 14) {
                        Text("Keep it secret")
                            .font(.title2.weight(.bold))
                            .foregroundStyle(.white)

                        Text("Let only \(player.name) look at the screen.")
                            .foregroundStyle(.white.opacity(0.76))

                        Button(action: { isRevealed = true }) {
                            Text("Reveal Role")
                                .partyPrimaryButton()
                        }
                    }
                    .partyCard()
                }

                Spacer()

                if isRevealed {
                    Button(action: continueAction) {
                        Text(currentIndex == viewModel.players.count - 1 ? "Start Discussion" : "Next Player")
                            .partySecondaryButton()
                    }
                }
            }
            .padding(20)
            .partyBackground()
            .navigationBarTitle("Player \(currentIndex + 1)/\(viewModel.players.count)", displayMode: .inline)
        )
    }

    @ViewBuilder
    private func revealContent(for player: Player) -> some View {
        VStack(spacing: 16) {
            switch player.role {
            case .civilian:
                Text("👥 Civilian")
                    .font(.system(size: 30, weight: .heavy, design: .rounded))
                    .foregroundStyle(PartyTheme.gold)

                Text("Secret word")
                    .foregroundStyle(.white.opacity(0.76))

                Text(viewModel.secretWord)
                    .font(.system(size: 36, weight: .black, design: .rounded))
                    .foregroundStyle(.white)

            case .impostor:
                Text("🕵️ Impostor")
                    .font(.system(size: 30, weight: .heavy, design: .rounded))
                    .foregroundStyle(.red)

                Text("You don’t know the word. Blend in, listen hard, and fake it till you make it.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white.opacity(0.84))

            case .mrWhite:
                Text("🎭 Mr. White")
                    .font(.system(size: 30, weight: .heavy, design: .rounded))
                    .foregroundStyle(PartyTheme.neonBlue)

                Text("You get no word at all. Survive the round or guess the word when eliminated.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white.opacity(0.84))
            }
        }
        .frame(maxWidth: .infinity)
    }

    private func continueAction() {
        isRevealed = false
        viewModel.nextReveal()
    }
}
