import SwiftUI

struct GameOverView: View {
    @EnvironmentObject private var viewModel: GameViewModel

    var body: some View {
        VStack(spacing: 18) {
            Spacer(minLength: 20)

            VStack(spacing: 10) {
                Text("🏆 Round Over")
                    .font(.system(size: 34, weight: .heavy, design: .rounded))
                    .foregroundStyle(.white)

                if let winner = viewModel.winner {
                    Text("\(winner) win!")
                        .font(.title2.weight(.bold))
                        .foregroundStyle(PartyTheme.gold)
                }
            }
            .partyCard()

            ScrollView {
                VStack(spacing: 12) {
                    ForEach(viewModel.players) { player in
                        HStack(spacing: 12) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(player.name)
                                    .font(.headline)
                                    .foregroundStyle(.white)

                                Text(player.role.rawValue + (player.isEliminated ? " • Eliminated" : " • Survived"))
                                    .font(.subheadline)
                                    .foregroundStyle(.white.opacity(0.75))
                            }

                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .partyCard()
                    }
                }
            }

            Button(action: { viewModel.resetGame() }) {
                Text("Play Again")
                    .partyPrimaryButton()
            }
        }
        .padding(20)
        .partyBackground()
        .navigationBarTitleDisplayMode(.inline)
    }
}
