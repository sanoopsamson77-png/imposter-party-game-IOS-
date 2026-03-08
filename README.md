# Impostor Game (iOS)

This repository contains the source code for **Impostor Game**, a pass‑and‑play social deduction game inspired by party games like *Undercover* and *Spyfall*.  The objective is simple: players all receive the same secret word—except for one **Impostor** and an optional **Mr. White**.  Everyone discusses the word by asking and answering subtle questions.  The **Impostor** tries to deduce the word without being discovered; **Mr. White** receives no word at all and must bluff their way through the round.

## Features

* **3–24 Players:** The game scales to large groups.  A single device is passed around the table.
* **Roles:** Each round has one Impostor, zero or one Mr. White and the rest Civilians.  Civilians all share the secret word, while the Impostor and Mr. White see nothing.
* **Multiple word categories:** Built‑in packs include food, animals, activities and more.  You can easily extend the `WordList.swift` file with your own words.
* **Sequential reveal:** During setup, players enter their names.  The app then passes through each player, privately showing their role and secret word.
* **Voting mechanics:** After a discussion phase, players vote one by one on who they think is suspicious.  If the eliminated player is Mr. White, they get a chance to guess the word for an instant win.  If the Impostor is eliminated, civilians win.  If the round narrows to two players, the Impostor wins by default.

## Requirements

* Xcode 13 or newer
* iOS 15 or later

This project is written in **Swift 5** using the **SwiftUI** framework.  To run it on your device:

1. Open Xcode and choose **File → Open…**, then select this folder (`ImpostorGame`).  Xcode will create a workspace automatically.
2. Ensure the deployment target is set to iOS 15 or later.
3. Build and run on an iPhone or in the simulator.

## Overview of Key Files

* `ImpostorGameApp.swift` – The application entry point.
* `ContentView.swift` – Top‑level wrapper that decides which screen to show based on the current game stage.
* `GameViewModel.swift` – The central view‑model that manages game state, role assignment, voting logic and win conditions.
* `SetupView.swift` – Allows players to configure the game (player count, names, word category, inclusion of Mr. White).
* `RevealView.swift` – Handles the pass‑and‑play word/role reveal for each player.
* `DiscussionView.swift` – Instructs players to discuss before voting.
* `VotingView.swift` – Implements sequential voting and calculates which player should be eliminated.
* `EliminationView.swift` – Displays the result of a vote, reveals the eliminated player’s role and handles Mr. White’s guess.
* `GameOverView.swift` – Presents the winning team and offers to restart the game.
* `WordList.swift` – Contains predefined word categories.  Feel free to expand these arrays with your own themes.  The initial lists draw inspiration from common charades topics such as food and animals【514595842079526†L18-L33】【514595842079526†L39-L53】.

## Extending the Game

To add more categories or words, open `WordList.swift` and modify the `wordCategories` dictionary.  You can include hundreds of words or even load them from a JSON file.

If you wish to customise the voting rules (for example, handle ties differently) or change the win conditions, look inside `GameViewModel.swift`.  The logic is contained in a handful of methods with descriptive names.

Enjoy the game, and feel free to adapt it to your group’s play style!