import SwiftUI

struct DiscussionView: View {
    @EnvironmentObject private var viewModel: GameViewModel

    var body: some View {
        VStack(spacing: 24) {
            Spacer(minLength: 20)

            VStack(spacing: 12) {
                Text("🪩 Discussion Time")
                    .font(.system(size: 32, weight: .heavy, design: .rounded))
                    .foregroundStyle(.white)

                Text("Give clever hints. Listen for suspicious answers. Keep the party energy up and catch the liar.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white.opacity(0.82))
            }
            .partyCard()

            VStack(alignment: .leading, spacing: 12) {
                Label("Civilians: hint at the word without saying it.", systemImage: "person.3.fill")
                Label("Impostor: blend in and figure it out.", systemImage: "theatermasks.fill")
                Label("Mr. White: improvise like your life depends on it.", systemImage: "sparkles")
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
            .partyCard()

            Spacer()

            Button(action: { viewModel.startVoting() }) {
                Text("Start Voting")
                    .partyPrimaryButton()
            }
        }
        .padding(20)
        .partyBackground()
        .navigationBarTitleDisplayMode(.inline)
    }
}
