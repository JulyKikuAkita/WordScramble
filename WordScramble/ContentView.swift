//
//  ContentView.swift
//  WordScramble
//
//  Created by Ifang Lee on 9/25/21.
//

import SwiftUI

struct ContentView: View {
    let people = ["Nancy Pelosi", "Alex Padilla", "Dianne Feinsten", "Gavin Newsom"]
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""

    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter your word", text: $newWord, onCommit: addNewWord)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .padding()

                List(usedWords, id: \.self) {
                    Label($0, systemImage: "\($0.count).circle")
                }
                .listStyle(GroupedListStyle())
            }
        }.navigationTitle(rootWord)
    }

    func addNewWord() {
        let answer = newWord.trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else {
            return
        }

        usedWords.insert(answer, at: 0)
        newWord = ""
    }


}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }

}
