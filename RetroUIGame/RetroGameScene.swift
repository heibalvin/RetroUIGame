//
//  RetroGameScene.swift
//  RetroUIGame
//
//  Created by Alvin Heib on 25/05/2024.
//

import GameplayKit

enum RetroGameType: Int {
    case frogger    = 9
}

class RetroGameScene: SKScene {
    var type: RetroGameType
    var stateMachine: GKStateMachine!
    var maps = [AHTileMap]()
    
    var graphs = [String: GKGraph]()
    var entities = [GKEntity]()
    
    var previousTime: TimeInterval = 0
    var deltaTime: TimeInterval = 0
    
    init(id: Int) {
        self.type = RetroGameType(rawValue: id)!
        super.init(size: CGSize(width: 320, height: 224))
        
        switch type {
        case .frogger:
            stateMachine = GKStateMachine(states: [FroggerInitState(self), FroggerStartState(self), FroggerRunState(self), FroggerPauseState(self), FroggerLooseState(self)])
            break
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        switch type {
        case .frogger:
            stateMachine.enter(FroggerInitState.self)
            break
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        deltaTime = currentTime - previousTime
        
        stateMachine.currentState?.update(deltaTime: deltaTime)
        
        previousTime = currentTime
    }
}
