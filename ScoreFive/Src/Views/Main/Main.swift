// ScoreFive
// Main.swift
//
// MIT License
//
// Copyright (c) 2021 Varun Santhanam
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the  Software), to deal
//
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED  AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import CoreData
import Five
import SwiftUI

struct Main: View {

    // MARK: - API

    enum Sheets: String, Identifiable {
        case newGame
        case loadGame
        case more

        typealias ID = RawValue

        var id: ID { rawValue }
    }

    // MARK: - View

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            if let identifier = gameManager.activeGameRecord {
                ScoreCard(game: try! gameManager.game(for: identifier))
            } else {
                Menu(activeSheet: $activeSheet)
            }
        }
        .sheet(item: $activeSheet) { sheet in
            switch sheet {
            case .newGame:
                NewGame()
                    .saveOnAppear(gameManager)
            case .loadGame:
                LoadGame()
                    .saveOnAppear(gameManager)
            case .more:
                More()
            }
        }
    }

    // MARK: - Private

    @EnvironmentObject
    private var gameManager: GameManager

    @State
    private var activeSheet: Sheets?

}

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        Main()
            .environmentObject(GameManager.preview)
    }
}

private extension View {
    func saveOnAppear(_ manager: GameManager) -> some View {
        onAppear {
            Task { await MainActor.run { try! manager.save() } }
        }
    }
}
