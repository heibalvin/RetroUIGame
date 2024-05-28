//
//  ContentView.swift
//  RetroUIGame
//
//  Created by Alvin Heib on 25/05/2024.
//

import SwiftUI

struct RetroGameListView: View {
    @ObservedObject var games: RetroGameList
    
    var body: some View {
        NavigationView {
            List {
                ForEach(games.list) { game in
                    if game.isCompleted {
                        NavigationLink(destination: RetroGameView(id: game.id)) {
                            Image(game.imagename)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 120, height: 192)
                        }
                    } else {
                        NavigationLink(destination: Text("WORK IN PROGRESS")) {
                            Image(game.imagename)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 120, height: 192)
                                .opacity(game.isCompleted ? 0.8 : 0.2)
                        }
                    }
                }
            }
//            .navigationBarTitle(Text("Image Gallery"))
        }.padding()
    }
}

#Preview {
    RetroGameListView(games: RetroGameList())
}
