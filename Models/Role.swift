import Foundation

/// Represents the role of a player in the game.
enum Role: String, Codable {
    /// Regular player who knows the secret word.
    case civilian = "Civilian"
    /// The impostor does not know the secret word and must deduce it without being caught.
    case impostor = "Impostor"
    /// Mr. White also receives no word but wins instantly if they guess the word when eliminated.
    case mrWhite = "Mr. White"
}