import Foundation

/// Contains the secret word packs available to the game.  Feel free to extend
/// these lists with your own categories and words.  The initial words are
/// inspired by common charades themes, including food and animals【514595842079526†L18-L33】【514595842079526†L39-L53】.
struct WordList {
    /// Dictionary of categories to arrays of secret words.
    static let wordCategories: [String: [String]] = [
        "Food": [
            "Banana",
            "Hamburger",
            "Lollipop",
            "Tacos",
            "Cotton Candy",
            "Sandwich",
            "Chicken",
            "Ice Cream",
            "Spaghetti",
            "Donut"
        ],
        "Animals": [
            "Elephant",
            "Monkey",
            "Lion",
            "Snake",
            "Cat",
            "Butterfly",
            "Alligator",
            "Chicken",
            "Penguin",
            "Frog",
            "Kangaroo",
            "Bear"
        ],
        "AD": [
            "Alfred",
            "alfin",
            "sanoop",
            "alwin",
            "ullas",
            "johnu",
            "nishan",
            "sanay",
            "michelle",
            "rohan",
            "hari govind bose",
            "alan issac",
            "athul",
            "jairosh",
            "angela",
            "anna",
            "joju",
            "sanjoe",
            "nandhu ajith",
            "suni"
        ],
        "Activities": [
            "Ride a Bike",
            "Go Fishing",
            "Take a Nap",
            "Do the Limbo",
            "Juggling",
            "Rowing a Boat",
            "Play Soccer",
            "Play Basketball",
            "Play Tennis",
            "Read a Book"
        ],
        "Places": [
            "Park",
            "School",
            "Library",
            "Grocery Store",
            "Swimming Pool",
            "Zoo",
            "Beach",
            "Airport",
            "Home",
            "Museum"
        ],
        "Sports": [
            "Do Yoga",
            "Gymnastics",
            "Play Golf",
            "Play Volleyball",
            "Swimming",
            "Play Hockey",
            "Play Frisbee",
            "Play Soccer",
            "Play Baseball",
            "Boxing"
        ]
    ]
    
    /// Returns the category names in alphabetical order for display in a Picker.
    static var categories: [String] {
        return wordCategories.keys.sorted()
    }
}
