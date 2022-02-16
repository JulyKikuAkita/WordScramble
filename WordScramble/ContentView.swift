//
//  ContentView.swift
//  WordScramble
//
//  Created by Ifang Lee on 9/25/21.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""

    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    @State private var score = 0

    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Enter your word", text: $newWord)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .padding()
                }

                Section {
                    ForEach(usedWords, id:\.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel(word)
                        .accessibilityHint("\(word.count) letters")
                    }
                }

                Text("Score: \(score)")
            }
            .navigationBarTitle(rootWord)
            .onSubmit {
                addNewWord()
            }
            .navigationBarItems(leading: Button("New Game", action: startGame))
            .onAppear(perform: startGame)
            .alert(isPresented: $showingError) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    func addNewWord() {
        let answer = newWord.trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else {
            return
        }

        guard isOriginal(word: answer) else {
            minusPoints()
            wordError(title: "Word used already", message: "Be more original")
            return
        }

        guard isPossible(word: answer) else {
            minusPoints()
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }

        guard isReal(word: answer) else {
            minusPoints()
            wordError(title: "Word not possible", message: "That isn't a real word.")
            return
        }

        guard isNotCheating(word: answer) else {
            minusPoints()
            wordError(title: "AI dectects cheating", message: "Don't use the same word or letters")
            return
        }

        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        newWord = ""
        addPoints()

    }

    func startGame() {
        if let startWroldsUrl = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try?
                String(contentsOf: startWroldsUrl) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                usedWords = []
                return
            }
        }

        // If were are *here* then there was a problem – trigger a crash and report the error
        fatalError("Could not load start.txt from bundle.")
    }

    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }

    func isPossible(word: String) -> Bool {
        var tmpWord = rootWord.lowercased()
        for letter in word {
            if let pos = tmpWord.firstIndex(of: letter) {
                tmpWord.remove(at: pos)
            } else {
                return false
            }
        }
        return true
    }

    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return  misspelledRange.location == NSNotFound
    }

    func isNotCheating(word: String) -> Bool {
        word.count != 1 && word != rootWord.lowercased()
    }

    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }

    func minusPoints() {
        score -= 5
    }

    func addPoints() {
        score += 25
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }

}
