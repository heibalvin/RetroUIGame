//
//  Frogger.swift
//  RetroUIGame
//
//  Created by Alvin Heib on 25/05/2024.
//

import GameplayKit

class FroggerInitState: GKState {
    var game: RetroGameScene
    
    init(_ game: RetroGameScene) {
        self.game = game
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        game.size = CGSize(width: 224, height: 256)
        game.backgroundColor = SKColor.black
        
        game.maps.append(AHTileMap())
        game.maps[0].load(bundle: "frogger-arcade-level", ext: "json")
        game.addChild(game.maps[0].node)
        print("Nodes: \(game.maps[0].tilelayers[0].node.children.count)")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        game.stateMachine.enter(FroggerStartState.self)
    }
}

class FroggerStartState: GKState {
    var game: RetroGameScene
    var meta = AHMetaTile(col: 1, row: 4, gid: 77, type: .twoByTwo, gids: [], tilelayerId: 0)
    var id = 0
    
    init(_ game: RetroGameScene) {
        self.game = game
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
//        meta.gids = game.maps[0].tilelayers[0].add(col: meta.col, row: meta.row, gid: meta.gid, type: meta.type)
        let _ = game.maps[0].add(meta: 1, row: 4, gid: 77, type: .twoByTwo, tilelayerId: 0)
        print("Nodes: \(game.maps[0].tilelayers[0].node.children.count)")
        
        /*
        game.maps[0].tilelayers[0].set(col: 1, row: 4, gid: 77, type: .twoByTwoPretty)
        
        game.maps[0].tilelayers[0].set(col: 0, row: 6, gid: 107, type: .sixByTwoPretty)
        
        game.maps[0].tilelayers[0].set(col: 26, row: 8, gid: 97, type: .twoByTwoPretty)
        
        game.maps[0].tilelayers[0].set(col: 24, row: 18, gid: 73, type: .fourByTwoPretty)
        
        game.maps[0].tilelayers[0].set(col: 0, row: 20, gid: 71, type: .twoByTwoPretty)
        
        game.maps[0].tilelayers[0].set(col: 26, row: 22, gid: 69, type: .twoByTwoPretty)
        
        game.maps[0].tilelayers[0].set(col: 0, row: 24, gid: 67, type: .twoByTwoPretty)
        
        game.maps[0].tilelayers[0].set(col: 26, row: 26, gid: 65, type: .twoByTwoPretty)
         */
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        game.time += seconds
        if game.time > game.timer {
//            game.maps[0].tilelayers[0].rem(col: meta.col, row: meta.row, gids: meta.gids, type: meta.type)
//            meta.row += 1
//            meta.gids = game.maps[0].tilelayers[0].add(col: meta.col, row: meta.row, gid: meta.gid, type: meta.type)
            
            game.maps[0].mov(meta: 0, dx: 0, dy: 1)
            id = (id + 1) % 2
            game.maps[0].ani(meta: 0, gid: 77 + id * 2)
            
            print("Nodes: \(game.maps[0].tilelayers[0].node.children.count)")
            game.time = 0
        }
        
    }
}

class FroggerRunState: GKState {
    var game: RetroGameScene
    
    init(_ game: RetroGameScene) {
        self.game = game
        super.init()
    }
    
}

class FroggerPauseState: GKState {
    var game: RetroGameScene
    
    init(_ game: RetroGameScene) {
        self.game = game
        super.init()
    }
    
}

class FroggerLooseState: GKState {
    var game: RetroGameScene
    
    init(_ game: RetroGameScene) {
        self.game = game
        super.init()
    }
}

enum FroggerType {
    case sportcar
    case mowner
    case car
    case roadster
    case truck
}
