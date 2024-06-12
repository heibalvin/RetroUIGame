//
//  AHGameEngine.swift
//  RetroUIGame
//
//  Created by Alvin Heib on 27/05/2024.
//

import SpriteKit

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
    var metas: [AHMetaTile] = []
    
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
    
    func add(meta col: Int, row: Int, gid: Int, type: AHMetaTileType, tilelayerId: Int) -> Int {
        let gids: [Int] = tilelayers[tilelayerId].add(col: col, row: row, gid: gid, type: type)
        let meta = AHMetaTile(col: col, row: row, gid: gid, type: type, gids: gids, tilelayerId: tilelayerId)
        metas.append(meta)
        return metas.count - 1
    }
    
    func rem(meta id: Int) {
        let meta = metas[id]
        tilelayers[meta.tilelayerId].rem(col: meta.col, row: meta.row, gids: meta.gids, type: meta.type)
        metas.remove(at: id)
    }
    
    func mov(meta id: Int, dx: Int, dy: Int) {
        tilelayers[metas[id].tilelayerId].rem(col: metas[id].col, row: metas[id].row, gids: metas[id].gids, type: metas[id].type)
        metas[id].col += dx
        metas[id].row += dy
        metas[id].gids = tilelayers[metas[id].tilelayerId].add(col: metas[id].col, row: metas[id].row, gid: metas[id].gid, type: metas[id].type)
    }
    
    func ani(meta id: Int, gid: Int) {
        let meta = metas[id]
        tilelayers[metas[id].tilelayerId].rem(col: metas[id].col, row: metas[id].row, gids: metas[id].gids, type: metas[id].type)
        metas[id].gid = gid
        metas[id].gids = tilelayers[metas[id].tilelayerId].add(col: metas[id].col, row: metas[id].row, gid: metas[id].gid, type: metas[id].type)
    }
}

enum AHTileLayerAttibute: Int {
    case none               = 0
    case horizontalFlip
    case verticalFlip
    case bothFlip
}

class AHTileLayer: NSObject {
    var map: AHTileMap
    var id: Int = 1
    var name: String = "default"
    var cols: Int = 28
    var rows: Int = 32
    var datas: [[Int]] = []
    var attributes: [[AHTileLayerAttibute]] = []
    var nodes: [[AHTileNode?]] = []
    
    var node: SKNode = SKNode()
    
    init(map: AHTileMap) {
        self.map = map
        super.init()
    }
    
    func tilesetId(gid: Int) -> Int {
        var id = 0
        for tileset in map.tilesets {
            if (gid >= tileset.firstgid) && (gid <= tileset.firstgid + tileset.tilecount - 1) {
                return id
            }
            id += 1
        }
        
        return map.tilesets.count - 1
    }
    
    func coord2pos(col: Int, row: Int) -> CGPoint {
        return CGPoint(x: col * map.tilewidth + map.tilewidth / 2, y: (rows - row - 1) * map.tileheight + map.tileheight / 2)
    }
    
//    func coord2index(col: Int, row: Int) -> Int {
//        return row * cols + col
//    }
    
    func toJSON() -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        let data = try! encoder.encode(toTiled())
        return String(data: data, encoding: .utf8)!
    }
    
    func toTiled() -> TiledLayer {
        var gids = Array(repeating: 0x00, count: cols * rows)
        var id = 0
        for row in 0...rows-1 {
            for col in 0...cols-1 {
                var data = datas[row][col]
                if attributes[row][col] == .horizontalFlip {
                    data = data | 0x80000000
                } else if attributes[row][col] == .verticalFlip {
                    data = data | 0x40000000
                } else if attributes[row][col] == .bothFlip {
                    data = data | 0xC0000000
                }
                gids[id] = data
                id += 1
            }
        }
        return TiledLayer(id: id, name: name, type: "tilelayer", visible: !(node.isHidden), opacity: Float(node.alpha), width: cols, height: rows, x: Int(node.position.x), y: Int(node.position.y), data: gids)
    }
    
    func fromTiled(_ conf: TiledLayer) {
        id = conf.id
        name = conf.name
        
        cols = conf.width
        rows = conf.height
        
        node.isHidden = !(conf.visible)
        node.alpha = CGFloat(conf.opacity)
        node.position = CGPoint(x: conf.x, y: conf.y)
        datas = Array(repeating: Array(repeating: 0x00, count: cols), count: rows)
        attributes = Array(repeating: Array(repeating: .none, count: cols), count: rows)
        nodes = Array(repeating: Array(repeating: nil, count: cols), count: rows)
        
        var id = 0
        for row in 0...rows-1 {
            for col in 0...cols-1 {
                let data = conf.data[id]
                if data & 0x80000000 == 0x80000000 {
                    attributes[row][col] = .horizontalFlip
                } else if data & 0x40000000 == 0x40000000 {
                    attributes[row][col] = .verticalFlip
                } else if data & 0xC0000000 == 0xC0000000 {
                    attributes[row][col] = .bothFlip
                }
                datas[row][col] = data & 0x3FFFFFFF
                id += 1
            }
        }
        
        update()
    }
    
    func update() {
        node.removeAllChildren()
        for row in 0...rows-1 {
            for col in 0...cols-1 {
                let gid = datas[row][col]
                if gid == 0 {
                    continue
                }
                addNode(col: col, row: row, gid: gid)
            }
        }
    }
    
    func get(col: Int, row: Int) -> Int {
        if (col < 0) || (col >= cols) || (row < 0) || (row >= rows) {
            return -1
        }
        return datas[row][col]
    }
    
    func get(col: Int, row: Int, type: AHMetaTileType) -> [Int] {
        var gids = [Int]()
        for meta in AHMetaTileLayouts[type.rawValue] {
            gids.append(get(col: col + meta.dx, row: row + meta.dy))
        }
        return gids
    }
    
    func set(col: Int, row: Int, gid: Int) {
        if gid == 0 {
            return
        }
        if (col < 0) || (col >= cols) || (row < 0) || (row >= rows) {
            return
        }
        datas[row][col] = gid
        addNode(col: col, row: row, gid: gid)
    }
    
    func set(col: Int, row: Int, gid: Int, type: AHMetaTileType) {
        for meta in AHMetaTileLayouts[type.rawValue] {
            set(col: col + meta.dx, row: row + meta.dy, gid: gid + meta.dg)
        }
    }
    
    func set(col: Int, row: Int, gids: [Int], type: AHMetaTileType) {
        var id = 0
        for meta in AHMetaTileLayouts[type.rawValue] {
            set(col: col + meta.dx, row: row + meta.dy, gid: gids[id])
            id += 1
        }
    }
    
    func addNode(col: Int, row: Int, gid: Int) {
        if gid == 0 {
            return
        }
        if (col < 0) || (col >= cols) || (row < 0) || (row >= rows) {
            return
        }
        let id = tilesetId(gid: gid)
        let tilenode = AHTileNode(position: coord2pos(col: col, row: row), gid: gid, tileset: map.tilesets[id])
        nodes[row][col] = tilenode
        node.addChild(tilenode)
    }
    
    func add(col: Int, row: Int, gid: Int) -> Int {
        let id = get(col: col, row: row)
        if id != 0 {
            rem(col: col, row: row)
        }
        set(col: col, row: row, gid: gid)
        return id
    }
    
    func add(col: Int, row: Int, gid: Int, type: AHMetaTileType) -> [Int] {
        var gids = [Int]()
        for meta in AHMetaTileLayouts[type.rawValue] {
            gids.append(add(col: col + meta.dx, row: row + meta.dy, gid: gid + meta.dg))
        }
        return gids
    }
    
    func rem(col: Int, row: Int) {
        if (col < 0) || (col >= cols) || (row < 0) || (row >= rows) {
            return
        }
        if datas[row][col] == 0 {
            return
        }
        
        datas[row][col] = 0
        nodes[row][col]!.removeFromParent()
        nodes[row][col] = nil
    }
    
    func rem(col: Int, row: Int, gids: [Int], type: AHMetaTileType) {
        var id = 0
        for meta in AHMetaTileLayouts[type.rawValue] {
            rem(col: col + meta.dx, row: row + meta.dy)
            set(col: col + meta.dx, row: row + meta.dy, gid: gids[id])
            id += 1
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

class AHTileNode: SKSpriteNode {
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

struct AHMetaTile {
    var col: Int
    var row: Int
    var gid: Int
    var type: AHMetaTileType
    var gids: [Int]
    var tilelayerId: Int
}

struct AHMetaTileComponent {
    var dx: Int
    var dy: Int
    var dg: Int
}

enum AHMetaTileType: Int {
    case one                = 0
    case oneByTwo
    case twoByTwo
}

let AHMetaTileLayouts: [[AHMetaTileComponent]] = [
    [ AHMetaTileComponent(dx: 0, dy: 0, dg: 0)],
    [ AHMetaTileComponent(dx: 0, dy: 0, dg: 0), AHMetaTileComponent(dx: 0, dy: 1, dg: 16)],
    [ AHMetaTileComponent(dx: 0, dy: 0, dg: 0), AHMetaTileComponent(dx: 1, dy: 0, dg: 1), AHMetaTileComponent(dx: 0, dy: 1, dg: 16), AHMetaTileComponent(dx: 1, dy: 1, dg: 17)]]

