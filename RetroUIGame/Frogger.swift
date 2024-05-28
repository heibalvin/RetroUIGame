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
        
        let map = AHTileMap()
        map.load(bundle: "frogger-arcade-level", ext: "json")
        game.maps.append(map)
        game.addChild(map.node)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        game.stateMachine.enter(FroggerStartState.self)
    }
}

class FroggerStartState: GKState {
    var game: RetroGameScene
    
    init(_ game: RetroGameScene) {
        self.game = game
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        
        game.maps[0].tilelayers[0].setMetaTile(col: 24, row: 18, gid: 73, tilesetId: 0, layout: .fourByTwoPretty)
        
        game.maps[0].tilelayers[0].setMetaTile(col: 0, row: 20, gid: 71, tilesetId: 0, layout: .twoByTwoPretty)
        
        game.maps[0].tilelayers[0].setMetaTile(col: 26, row: 22, gid: 69, tilesetId: 0, layout: .twoByTwoPretty)
        
        game.maps[0].tilelayers[0].setMetaTile(col: 0, row: 24, gid: 67, tilesetId: 0, layout: .twoByTwoPretty)
        
        game.maps[0].tilelayers[0].setMetaTile(col: 26, row: 26, gid: 65, tilesetId: 0, layout: .twoByTwoPretty)
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
