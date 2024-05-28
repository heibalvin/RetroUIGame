//
//  TiledGameEngine.swift
//  RetroUIGame
//
//  Created by Alvin Heib on 27/05/2024.
//

import Foundation

struct TiledMap: Codable {
    var type: String
    var version: String
    var tiledversion: String
    var renderorder: String
    var orientation: String
    
    var width: Int
    var height: Int
    var tilewidth: Int
    var tileheight: Int
    
    var nextlayerid: Int
    var nextobjectid: Int
    var layers: [TiledLayer]
    var tilesets: [TiledSet]
}

struct TiledLayer: Codable {
    var id: Int
    var name: String
    var type: String
    
    var visible: Bool
    var opacity: Double
    
    var width: Int
    var height: Int
    var x: Int
    var y: Int
    
    var data: [Int]
}

struct TiledSet: Codable {
    var name: String
    var firstgid: Int
    
    var image: String
    var imagewidth: Int
    var imageheight: Int
    
    var tilewidth: Int
    var tileheight: Int
    var tilecount: Int
    var margin: Int
    var spacing: Int
}

class AHGame: NSObject {
    
}

class AHTileset: NSObject {
    var conf: TiledSet
    
    init(conf: TiledSet) {
        self.conf = conf
        super.init()
    }
    
    init(imagenamed: String, ext: String) {
        
    }
}
