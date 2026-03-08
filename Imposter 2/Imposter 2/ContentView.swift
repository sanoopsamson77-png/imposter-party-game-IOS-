import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: GameViewModel

    var body: some View {
        Group {
            switch viewModel.stage {
            case .setup:
                SetupView()
            case .reveal:
                RevealView()
            case .discussion:
                DiscussionView()
            case .voting:
                VotingView()
            case .elimination:
                EliminationView()
            case .gameOver:
                GameOverView()
            }
        }
        .preferredColorScheme(.dark)
        .animation(.spring(response: 0.35, dampingFraction: 0.88), value: viewModel.stage)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(GameViewModel())
    }
}
