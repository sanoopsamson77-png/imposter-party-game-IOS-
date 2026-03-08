import SwiftUI

struct EliminationView: View {
    @EnvironmentObject private var viewModel: GameViewModel
    @State private var guess: String = ""
    @State private var showIncorrectGuess: Bool = false

    var body: some View {
        guard let eliminated = viewModel.eliminationCandidate else {
            DispatchQueue.main.async {
                viewModel.continueAfterElimination()
            }
            return AnyView(EmptyView())
        }

        return AnyView(
            VStack(spacing: 20) {
                Spacer(minLength: 20)

                VStack(spacing: 12) {
                    Text("💥 Eliminated")
                        .font(.system(size: 32, weight: .heavy, design: .rounded))
                        .foregroundStyle(.white)

                    Text("\(eliminated.name) is out.")
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(.white)

                    Text(eliminated.role.rawValue)
                        .font(.title2.weight(.bold))
                        .foregroundStyle(roleColor(for: eliminated.role))
                }
                .partyCard()

                if eliminated.role == .mrWhite {
                    VStack(spacing: 14) {
                        Text("Final chance")
                            .font(.headline)
                            .foregroundStyle(.white)

                        Text("Mr. White can still steal the win by guessing the secret word.")
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.white.opacity(0.8))

                        TextField("Enter your guess", text: $guess)
                            .padding(14)
                            .background(Color.white.opacity(0.10))
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                        Button(action: submitGuess) {
                            Text("Submit Guess")
                                .partyPrimaryButton()
                        }
                        .disabled(guess.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

                        if showIncorrectGuess {
                            Text("Wrong guess. The round continues.")
                                .foregroundStyle(.red)
                        }
                    }
                    .partyCard()
                } else {
                    Button(action: { viewModel.continueAfterElimination() }) {
                        Text("Continue")
                            .partyPrimaryButton()
                    }
                }

                Spacer()
            }
            .padding(20)
            .partyBackground()
            .navigationBarTitleDisplayMode(.inline)
        )
    }

    private func submitGuess() {
        let trimmed = guess.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        viewModel.handleMrWhiteGuess(guess: trimmed)
        if viewModel.stage != .gameOver {
            showIncorrectGuess = true
            guess = ""
        }
    }

    private func roleColor(for role: Role) -> Color {
        switch role {
        case .civilian: return PartyTheme.gold
        case .impostor: return .red
        case .mrWhite: return PartyTheme.neonBlue
        }
    }
}
