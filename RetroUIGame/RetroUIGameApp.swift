//
//  RetroUIGameApp.swift
//  RetroUIGame
//
//  Created by Alvin Heib on 25/05/2024.
//

import SwiftUI

@main
struct RetroUIGameApp: App {
    @StateObject var games = RetroGameList(true)
    
    var body: some Scene {
        WindowGroup {
            RetroGameListView(games: games)
        }
    }
}
