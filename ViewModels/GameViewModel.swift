import Foundation
import SwiftUI
import Combine

final class GameViewModel: ObservableObject {
    @Published var players: [Player] = []
    @Published var secretWord: String = ""
    @Published var stage: Stage = .setup
    @Published var revealIndex: Int = 0
    @Published var votingIndex: Int = 0
    @Published var eliminationCandidate: Player? = nil
    @Published var winner: String? = nil
    @Published var includeMrWhite: Bool = false
    @Published var selectedCategory: String = WordList.categories.first ?? ""

    private var votingSequence: [Player] = []
    private var rng = SystemRandomNumberGenerator()

    var activePlayers: [Player] {
        players.filter { !$0.isEliminated }
    }

    func resetGame() {
        players = []
        secretWord = ""
        stage = .setup
        revealIndex = 0
        votingIndex = 0
        eliminationCandidate = nil
        winner = nil
        votingSequence = []
    }

    func startGame(names: [String], includeMrWhite: Bool, selectedCategory: String) {
        guard names.count >= 3 else { return }

        self.includeMrWhite = includeMrWhite
        self.selectedCategory = selectedCategory

        if let words = WordList.wordCategories[selectedCategory], !words.isEmpty {
            secretWord = words.randomElement(using: &rng) ?? "Secret"
        } else {
            secretWord = WordList.wordCategories.values.first?.randomElement(using: &rng) ?? "Secret"
        }

        let playerCount = names.count
        var roles: [Role] = Array(repeating: .civilian, count: playerCount)

        let impostorIndex = Int.random(in: 0..<playerCount, using: &rng)
        roles[impostorIndex] = .impostor

        if includeMrWhite && playerCount > 3 {
            var mrWhiteIndex: Int
            repeat {
                mrWhiteIndex = Int.random(in: 0..<playerCount, using: &rng)
            } while mrWhiteIndex == impostorIndex
            roles[mrWhiteIndex] = .mrWhite
        }

        players = names.enumerated().map { index, name in
            let cleanName = name.trimmingCharacters(in: .whitespacesAndNewlines)
            return Player(name: cleanName.isEmpty ? "Player \(index + 1)" : cleanName,
                          role: roles[index])
        }

        stage = .reveal
        revealIndex = 0
        votingIndex = 0
        eliminationCandidate = nil
        winner = nil
        votingSequence = []
    }

    func nextReveal() {
        if revealIndex + 1 < players.count {
            revealIndex += 1
        } else {
            stage = .discussion
        }
    }

    func startVoting() {
        votingSequence = activePlayers
        votingIndex = 0
        for index in players.indices {
            players[index].vote = nil
        }
        stage = .voting
    }

    func castVote(for candidateId: UUID) {
        guard stage == .voting, votingIndex < votingSequence.count else { return }

        let voter = votingSequence[votingIndex]
        if let idx = players.firstIndex(where: { $0.id == voter.id }) {
            players[idx].vote = candidateId
        }

        votingIndex += 1
        if votingIndex >= votingSequence.count {
            computeElimination()
        }
    }

    private func computeElimination() {
        var tally: [UUID: Int] = [:]
        for player in players {
            if let voteFor = player.vote {
                tally[voteFor, default: 0] += 1
            }
        }

        let highestCount = tally.values.max() ?? 0
        let candidates = tally.filter { $0.value == highestCount }.map(\.key)

        guard highestCount > 0 else {
            stage = .discussion
            return
        }

        let eliminatedId = candidates.count == 1 ? candidates[0] : candidates.randomElement(using: &rng)!

        if let idx = players.firstIndex(where: { $0.id == eliminatedId }) {
            players[idx].isEliminated = true
            eliminationCandidate = players[idx]
        }

        stage = .elimination
    }

    func handleMrWhiteGuess(guess: String) {
        let trimmedGuess = guess.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let target = secretWord.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        if !trimmedGuess.isEmpty && trimmedGuess == target {
            winner = Role.mrWhite.rawValue
            stage = .gameOver
        } else {
            continueAfterElimination()
        }
    }

    func continueAfterElimination() {
        eliminationCandidate = nil
        for index in players.indices {
            players[index].vote = nil
        }

        if !checkWinConditions() {
            stage = .discussion
        }
    }

    private func checkWinConditions() -> Bool {
        let alive = activePlayers
        let impostorAlive = alive.contains(where: { $0.role == .impostor })
        let civiliansAlive = alive.filter { $0.role == .civilian }.count
        let mrWhiteAlive = alive.contains(where: { $0.role == .mrWhite })

        if !impostorAlive {
            winner = "Civilians"
            stage = .gameOver
            return true
        }

        if civiliansAlive <= 1 {
            winner = Role.impostor.rawValue
            stage = .gameOver
            return true
        }

        if civiliansAlive == 0 && impostorAlive && mrWhiteAlive {
            winner = Role.impostor.rawValue
            stage = .gameOver
            return true
        }

        return false
    }
}
