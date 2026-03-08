import SwiftUI

struct VotingView: View {
    @EnvironmentObject private var viewModel: GameViewModel

    var body: some View {
        let sequence = viewModel.activePlayers
        guard !sequence.isEmpty else { return AnyView(Text("No players.")) }

        let voterIndex = viewModel.votingIndex

        if voterIndex >= sequence.count {
            return AnyView(
                VStack(spacing: 16) {
                    Text("Calculating results...")
                        .foregroundStyle(.white)
                    ProgressView()
                        .tint(.white)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .partyBackground()
            )
        }

        let voter = sequence[voterIndex]
        let candidates = sequence.filter { $0.id != voter.id }

        return AnyView(
            ScrollView {
                VStack(spacing: 18) {
                    VStack(spacing: 10) {
                        Text("🗳️ Voting")
                            .font(.system(size: 32, weight: .heavy, design: .rounded))
                            .foregroundStyle(.white)

                        Text("\(voter.name), choose who feels the most suspicious.")
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.white.opacity(0.8))
                    }
                    .partyCard()

                    ForEach(candidates) { candidate in
                        Button(action: {
                            viewModel.castVote(for: candidate.id)
                        }) {
                            HStack {
                                Text(candidate.name)
                                Spacer()
                                Image(systemName: "arrow.right.circle.fill")
                            }
                            .partyPrimaryButton()
                        }
                    }
                }
                .padding(20)
            }
            .partyBackground()
            .navigationBarTitle("Vote \(voterIndex + 1)/\(sequence.count)", displayMode: .inline)
        )
    }
}
