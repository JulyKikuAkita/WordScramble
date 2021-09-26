//
//  ContentView.swift
//  WordScramble
//
//  Created by Ifang Lee on 9/25/21.
//

import SwiftUI

struct ContentView: View {
    let people = ["Nancy Pelosi", "Alex Padilla", "Dianne Feinsten", "Gavin Newsom"]
    var body: some View {
        List {
            // spell checker API
            let word = "swift"
            let checker = UITextChecker()
            let range = NSRange(location: 0, length: word.utf16.count)
            let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
            let allGood = misspelledRange.location == NSNotFound

            //string API
            let input = """
                金
                蓬
                萊
            """
            let letters = input.components(separatedBy: "\n")
            let letter = letters.randomElement()
            let trimmed = letter?.trimmingCharacters(in: .whitespacesAndNewlines)

            Section(header: Text("People")) {
                ForEach(people, id:\.self) { person in
                    Text("\(person)")
                }
            }
        }
        .listStyle(GroupedListStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }

}
