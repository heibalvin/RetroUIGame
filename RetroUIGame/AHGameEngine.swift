//
//  TiledGameEngine.swift
//  RetroUIGame
//
//  Created by Alvin Heib on 27/05/2024.
//

import SpriteKit

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
    var opacity: Float
    
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

class AHTileMap: NSObject {
    var cols: Int = 28
    var rows: Int = 30
    var tilewidth: Int = 8
    var tileheight: Int = 8
    
    var nextlayerid: Int = 1
    var nextobjectid: Int = 1
    var tilelayers: [AHTileLayer] = []
    var tilesets: [AHTileSet] = []
    
    var node = SKNode()
    
    func load(bundle filename: String, ext: String = "json") {
        guard let url = Bundle.main.url(forResource: filename, withExtension: ext) else {
            print("ERROR: cannot read file \(filename).\(ext)")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            
            let decoder = JSONDecoder()
            let conf = try decoder.decode(TiledMap.self, from: data)
            fromTiled(conf)
        } catch {
            print("ERROR: Cannot load or decode filename \(filename). \(error)")
        }
    }
    
    func toJSON() -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        let data = try! encoder.encode(toTiled())
        return String(data: data, encoding: .utf8)!
    }
    
    func toTiled() -> TiledMap {
        var tiledlayers = [TiledLayer]()
        for tilelayer in tilelayers {
            tiledlayers.append(tilelayer.toTiled())
        }
        
        var tiledsets = [TiledSet]()
        for tileset in tilesets {
            tiledsets.append(tileset.toTiled())
        }
        
        return TiledMap(type: "map", version: "1.10", tiledversion: "1.10.2", renderorder: "right-down", orientation: "orthogonal", width: cols, height: rows, tilewidth: tilewidth, tileheight: tileheight, nextlayerid: nextlayerid, nextobjectid: nextobjectid, layers: tiledlayers, tilesets: tiledsets)
    }
    
    func fromTiled(_ conf: TiledMap) {
        cols = conf.width
        rows = conf.height
        tilewidth = conf.tilewidth
        tileheight = conf.tileheight
        nextlayerid = conf.nextlayerid
        nextobjectid = conf.nextobjectid
        
        tilesets = []
        for tiledset in conf.tilesets {
            let tileset = AHTileSet()
            tileset.fromTiled(tiledset, id: tilesets.count + 1)
            tilesets.append(tileset)
        }
        
        tilelayers = []
        for tiledlayer in conf.layers {
            let tilelayer = AHTileLayer(map: self)
            tilelayer.fromTiled(tiledlayer)
            tilelayers.append(tilelayer)
            node.addChild(tilelayer.node)
        }
    }
}

enum AHMetaTileLayout: Int {
    case twoByTwoPretty     = 1
    case threeByTwoPretty
    case fourByTwoPretty
}

struct AHMetaTile {
    var dx: Int
    var dy: Int
    var dg: Int
}

class AHTileLayer: NSObject {
    var map: AHTileMap
    var id: Int = 1
    var name: String = "default"
    
    var cols: Int = 28
    var rows: Int = 32
    var datas: [Int] = []
    var tiles: [AHTile?] = []
    
    var node: SKNode = SKNode()
    
    init(map: AHTileMap) {
        self.map = map
        super.init()
    }
    
    func coord2pos(col: Int, row: Int) -> CGPoint {
        return CGPoint(x: col * map.tilewidth + map.tilewidth / 2, y: (rows - row - 1) * map.tileheight + map.tileheight / 2)
    }
    
    func coord2index(col: Int, row: Int) -> Int {
        return row * cols + col
    }
    
    func toJSON() -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        let data = try! encoder.encode(toTiled())
        return String(data: data, encoding: .utf8)!
    }
    
    func toTiled() -> TiledLayer {
        return TiledLayer(id: id, name: name, type: "tilelayer", visible: !(node.isHidden), opacity: Float(node.alpha), width: cols, height: rows, x: Int(node.position.x), y: Int(node.position.y), data: datas)
    }
    
    func fromTiled(_ conf: TiledLayer) {
        id = conf.id
        name = conf.name
        
        cols = conf.width
        rows = conf.height
        
        node.isHidden = !(conf.visible)
        node.alpha = CGFloat(conf.opacity)
        node.position = CGPoint(x: conf.x, y: conf.y)
        datas = conf.data
        tiles = Array(repeating: nil, count: datas.count)
        
        updateTiles()
    }
    
    func updateTiles() {
        for row in 0...rows-1 {
            for col in 0...cols-1 {
                let gid = datas[coord2index(col: col, row: row)]
                if gid == 0 {
                    continue
                }
                for tilesetId in 0...map.tilesets.count-1 {
                    let id = gid - map.tilesets[tilesetId].firstgid
                    if (id >= 0) && (id < map.tilesets[tilesetId].tilecount) {
                        addNode(col: col, row: row, gid: gid, tilesetId: tilesetId)
                        break
                    }
                }
            }
        }
    }
    
    func addNode(col: Int, row: Int, gid: Int, tilesetId: Int) {
        let tile = AHTile(position: coord2pos(col: col, row: row), gid: gid, tileset: map.tilesets[tilesetId])
        tiles[coord2index(col: col, row: row)] = tile
        node.addChild(tile)
    }
    
    func add(col: Int, row: Int, gid: Int, tilesetId: Int) {
        let index = coord2index(col: col, row: row)
        if datas[index] != 0 {
            rem(index: index)
        }
        if gid == 0 {
            return
        }
        set(col: col, row: row, gid: gid, tilesetId: tilesetId)
    }
            
    func set(col: Int, row: Int, gid: Int, tilesetId: Int) {
        datas[coord2index(col: col, row: row)] = gid
        addNode(col: col, row: row, gid: gid, tilesetId: tilesetId)
    }
    
    func get(index: Int) -> Int {
        return datas[index]
    }
    
    func get(col: Int, row: Int) -> Int {
        let index = coord2index(col: col, row: row)
        return get(index: index)
    }
    
    func rem(index: Int) {
        if datas[index] == 0 {
            return
        }
        datas[index] = 0
        tiles[index]!.removeFromParent()
        tiles[index] = nil
    }
    
    func rem(col: Int, row: Int) {
        let index = coord2index(col: col, row: row)
        rem(index: index)
    }
    
    let metaTileLayouts: [[AHMetaTile]] = [
        [],
        [ AHMetaTile(dx: 0, dy: 0, dg: 0), AHMetaTile(dx: 1, dy: 0, dg: 1), AHMetaTile(dx: 0, dy: 1, dg: 16), AHMetaTile(dx: 1, dy: 1, dg: 17)],
        [ AHMetaTile(dx: 0, dy: 0, dg: 0), AHMetaTile(dx: 1, dy: 0, dg: 1), AHMetaTile(dx: 2, dy: 0, dg: 2), AHMetaTile(dx: 0, dy: 1, dg: 16), AHMetaTile(dx: 1, dy: 1, dg: 17), AHMetaTile(dx: 2, dy: 1, dg: 18)],
        [ AHMetaTile(dx: 0, dy: 0, dg: 0), AHMetaTile(dx: 1, dy: 0, dg: 1), AHMetaTile(dx: 2, dy: 0, dg: 2), AHMetaTile(dx: 3, dy: 0, dg: 3), AHMetaTile(dx: 0, dy: 1, dg: 16), AHMetaTile(dx: 1, dy: 1, dg: 17), AHMetaTile(dx: 2, dy: 1, dg: 18), AHMetaTile(dx: 3, dy: 1, dg: 19)],
    ]
    
    func setMetaTile(col: Int, row: Int, gid: Int, tilesetId: Int, layout: AHMetaTileLayout) {
        for meta in metaTileLayouts[layout.rawValue] {
            set(col: col + meta.dx, row: row + meta.dy, gid: gid + meta.dg, tilesetId: tilesetId)
        }
    }
}

class AHTileSet: NSObject {
    var id: Int = 0
    var name: String = "default"
    var firstgid: Int = 1
    
    var imagename: String = "default"
    var imagewidth: Int = 128
    var imageheight: Int = 128
    
    var tilewidth: Int = 8
    var tileheight: Int = 8
    var tilecount: Int = 0
    var margin: Int = 0
    var spacing: Int = 0
    
    var image: CGImage? = nil
    
    subscript(index: Int) -> CGImage {
        get {
            let id = index - firstgid
            let columns = Int(imagewidth/tilewidth)
            let row = Int(id / columns)
            let col = id - (row * columns)
            let rect = CGRect(x: col * tilewidth, y: row * tileheight, width: tilewidth, height: tileheight)
            return image!.cropping(to: rect)!
        }
    }
    
    func toJSON() -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        let data = try! encoder.encode(toTiled())
        return String(data: data, encoding: .utf8)!
    }
    
    func fromTiled(_ conf: TiledSet, id: Int) {
        self.id = id
        self.name = conf.name
        self.firstgid = conf.firstgid
        
        self.imagename = conf.image
        self.imagewidth = conf.imagewidth
        self.imageheight = conf.imageheight
        
        self.tilewidth = conf.tilewidth
        self.tileheight = conf.tileheight
        self.tilecount = conf.tilecount
        self.margin = conf.margin
        self.spacing = conf.spacing
        
        let segments = conf.image.components(separatedBy: ".")
        self.image = SKTexture(imageNamed: segments[0]).cgImage()
    }
    
    func toTiled() -> TiledSet {
        return TiledSet(name: name, firstgid: firstgid, image: imagename, imagewidth: imagewidth, imageheight: imageheight, tilewidth: tilewidth, tileheight: tileheight, tilecount: tilecount, margin: margin, spacing: spacing)
    }
    
    func split(imagenamed: String, ext: String, id: Int, firstgid: Int, tilewidth: Int, tileheight: Int, tilecount: Int = -1, margin: Int = 0, spacing: Int = 0) {
        self.image = SKTexture(imageNamed: imagenamed).cgImage()
        
        self.id = id
        self.name = imagenamed
        self.firstgid = firstgid
        
        self.imagename = "\(imagenamed).\(ext)"
        self.imagewidth = image!.width
        self.imageheight = image!.height
        
        self.tilewidth = tilewidth
        self.tileheight = tileheight
        
        self.tilecount = tilecount == -1 ? Int(imagewidth / tilewidth) * Int(imageheight / tileheight) : tilecount
        self.margin = margin
        self.spacing = spacing
    }
}

class AHTile: SKSpriteNode {
    init(position: CGPoint, gid: Int, tileset: AHTileSet) {
        let tex = SKTexture(cgImage: tileset[gid])
        tex.filteringMode = .nearest
        super.init(texture: tex, color: SKColor.red, size: tex.size())
        
        self.name = "\(gid)"
        self.position = position
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
