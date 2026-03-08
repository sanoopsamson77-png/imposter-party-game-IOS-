import Foundation

/// Defines the current phase of the game.  The view presented to the user
/// depends on this stage.
enum Stage: String, Codable {
    case setup       // Players choose settings and names
    case reveal      // Pass‑and‑play word reveal
    case discussion  // Players discuss the word and try to root out impostors
    case voting      // Each player votes on who to eliminate
    case elimination // A player is eliminated and potentially guesses the word
    case gameOver    // The game has concluded and displays the winner
}