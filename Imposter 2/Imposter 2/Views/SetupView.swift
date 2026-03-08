import SwiftUI

struct SetupView: View {
    @EnvironmentObject private var viewModel: GameViewModel

    @AppStorage("savedPlayerCount") private var savedPlayerCount: Int = 3
    @AppStorage("savedIncludeMrWhite") private var savedIncludeMrWhite: Bool = false
    @AppStorage("savedCategory") private var savedCategory: String = WordList.categories.first ?? ""

    @State private var numPlayers: Int = 3 {
        didSet { adjustNameArray() }
    }
    @State private var includeMrWhite: Bool = false
    @State private var selectedCategory: String = WordList.categories.first ?? ""
    @State private var names: [String] = ["", "", ""]
    @State private var showAlert: Bool = false

    private let namesKey = "savedPlayerNames"

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 18) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("🎉 Impostor Party")
                            .font(.system(size: 34, weight: .heavy, design: .rounded))
                            .foregroundStyle(.white)

                        Text("Same phone. Big laughs. Hidden roles. Start a new round in seconds.")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.78))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    VStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Players")
                                .font(.headline)
                                .foregroundStyle(.white)

                            Stepper(value: $numPlayers, in: 3...24) {
                                Text("Number of players: \(numPlayers)")
                                    .foregroundStyle(.white)
                            }

                            Toggle("Include Mr. White", isOn: $includeMrWhite)
                                .tint(PartyTheme.hotPink)
                                .foregroundStyle(.white)
                        }
                        .partyCard()

                        VStack(alignment: .leading, spacing: 12) {
                            Text("Word Pack")
                                .font(.headline)
                                .foregroundStyle(.white)

                            Picker("Category", selection: $selectedCategory) {
                                ForEach(Array(WordList.categories), id: \.self) { category in
                                    Text(category).tag(category as String)
                                }
                            }
                            .pickerStyle(.menu)
                            .tint(.white)
                        }
                        .partyCard()

                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Player Names")
                                    .font(.headline)
                                    .foregroundStyle(.white)

                                Spacer()

                                Button("Clear") {
                                    names = Array(repeating: "", count: numPlayers)
                                    saveNames()
                                }
                                .foregroundStyle(PartyTheme.gold)
                                .font(.subheadline.weight(.semibold))
                            }

                            ForEach(Array(names.indices), id: \.self) { index in
                                TextField("Player \(index + 1) Name", text: $names[index])
                                    .padding(14)
                                    .background(Color.white.opacity(0.10))
                                    .foregroundStyle(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14)
                                            .stroke(Color.white.opacity(0.08), lineWidth: 1)
                                    )
                                    .textInputAutocapitalization(.words)
                                    .onChange(of: names[index]) { _ in
                                        saveNames()
                                    }
                            }
                        }
                        .partyCard()

                        Button(action: startGame) {
                            Text("Start Game")
                                .partyPrimaryButton()
                        }
                        .disabled(!canStart)
                        .opacity(canStart ? 1 : 0.55)
                    }
                }
                .padding(20)
            }
            .partyBackground()
            .navigationBarTitleDisplayMode(.inline)
            .alert("Missing Names", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Please enter a name for each player.")
            }
        }
        .onAppear {
            numPlayers = min(max(savedPlayerCount, 3), 24)
            includeMrWhite = savedIncludeMrWhite
            selectedCategory = WordList.categories.contains(savedCategory) ? savedCategory : (WordList.categories.first ?? "")
            loadNames()
            adjustNameArray()
        }
        .onChange(of: numPlayers) { value in
            savedPlayerCount = value
            saveNames()
        }
        .onChange(of: includeMrWhite) { value in
            savedIncludeMrWhite = value
        }
        .onChange(of: selectedCategory) { value in
            savedCategory = value
        }
    }

    private var canStart: Bool {
        names.prefix(numPlayers).allSatisfy { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    }

    private func adjustNameArray() {
        if names.count < numPlayers {
            names.append(contentsOf: Array(repeating: "", count: numPlayers - names.count))
        } else if names.count > numPlayers {
            names.removeLast(names.count - numPlayers)
        }
    }

    private func startGame() {
        let trimmed = Array(names.prefix(numPlayers)).map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        guard trimmed.allSatisfy({ !$0.isEmpty }) else {
            showAlert = true
            return
        }

        saveNames()
        viewModel.startGame(names: trimmed, includeMrWhite: includeMrWhite, selectedCategory: selectedCategory)
    }

    private func saveNames() {
        if let data = try? JSONEncoder().encode(names) {
            UserDefaults.standard.set(data, forKey: namesKey)
        }
    }

    private func loadNames() {
        guard
            let data = UserDefaults.standard.data(forKey: namesKey),
            let saved = try? JSONDecoder().decode([String].self, from: data)
        else {
            names = Array(repeating: "", count: numPlayers)
            return
        }

        names = saved
    }
}

struct SetupView_Previews: PreviewProvider {
    static var previews: some View {
        SetupView().environmentObject(GameViewModel())
    }
}
