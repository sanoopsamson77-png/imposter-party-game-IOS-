import Foundation

/// A participant in the game.  Players are identified by a UUID and hold state
/// such as their name, assigned role, whether they have been eliminated and
/// who they voted for during the current round.
struct Player: Identifiable, Codable {
    /// A unique identifier for the player.  Generated automatically when the
    /// player is created.
    let id: UUID
    /// The display name chosen by the player during setup.
    var name: String
    /// The role assigned at the beginning of the game.
    var role: Role
    /// Indicates whether this player has been eliminated.
    var isEliminated: Bool
    /// The identifier of the player this participant voted for in the current round.
    var vote: UUID?
    
    init(name: String, role: Role) {
        self.id = UUID()
        self.name = name
        self.role = role
        self.isEliminated = false
        self.vote = nil
    }
}