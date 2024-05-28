//
//  RetroGameList.swift
//  RetroUIGame
//
//  Created by Alvin Heib on 25/05/2024.
//

import Foundation

struct RetroGame: Identifiable, Hashable, Codable {
    var id: Int
    var hex: String
    var name: String
    var imagename: String
    var isCompleted: Bool
}

class RetroGameList: ObservableObject {
    @Published var list = [RetroGame]()
    
    init(_ debug: Bool = false) {
        if debug {
            load(filename: "retro-game-list-debug", ext: "json")
        } else {
            load(filename: "retro-game-list", ext: "json")
        }
        list = list.sorted(by: { $0.id <= $1.id ? true : false })
    }
    
    func strToList() {
        let strs = [
            "best-arcade-games-1-618be09a69c16-120",
            "best-arcade-games-10-618cd1b6a83ee-120",
            "best-arcade-games-100-61922db2061ff-120",
            "best-arcade-games-101-61922f396619a-120",
            "best-arcade-games-102-619230dc3eb69-120",
            "best-arcade-games-103-619233044af35-120",
            "best-arcade-games-104-6192343dc6ac3-120",
            "best-arcade-games-105-619236442cb6b-120",
            "best-arcade-games-106-6192377d4e8df-120",
            "best-arcade-games-107-619239eb46d93-120",
            "best-arcade-games-108-619251b04fd84-120",
            "best-arcade-games-109-619256785ece2-120",
            "best-arcade-games-11-618cd2c01a2b3-120",
            "best-arcade-games-110-61925973cc93a-120",
            "best-arcade-games-111-61925aa152dd3-120",
            "best-arcade-games-12-618cd47d6945a-120",
            "best-arcade-games-13-618cd6192cf33-120",
            "best-arcade-games-14-61926e7d07362-120",
            "best-arcade-games-15-618cdb13572c1-120",
            "best-arcade-games-16-618cdcc1a1e5f-120",
            "best-arcade-games-17-61926ed0ee524-120",
            "best-arcade-games-18-618ce0719a7c8-120",
            "best-arcade-games-19-61926ee57dd94-120",
            "best-arcade-games-2-618be5a8aa3d8-120",
            "best-arcade-games-20-618ce61d93a7a-120",
            "best-arcade-games-21-61926f4ee0d7a-120",
            "best-arcade-games-22-618ce82f22ca0-120",
            "best-arcade-games-23-61926f67df865-120",
            "best-arcade-games-24-618ceceb63305-120",
            "best-arcade-games-25-618ceaba05d37-120",
            "best-arcade-games-26-61926f7eebc21-120",
            "best-arcade-games-27-618cf08077dce-120",
            "best-arcade-games-28-61926f9ce54df-120",
            "best-arcade-games-29-618cf3f5f3f13-120",
            "best-arcade-games-3-618be755780fc-120",
            "best-arcade-games-30-618cf7ef63c60-120",
            "best-arcade-games-31-618d0c861beb2-120",
            "best-arcade-games-32-618d0d7f8de5c-120",
            "best-arcade-games-33-618d0ef1ef9b4-120",
            "best-arcade-games-34-61926ff6a147a-120",
            "best-arcade-games-35-6192700d0bc31-120",
            "best-arcade-games-36-618d149874261-120",
            "best-arcade-games-37-619270444d0d9-120",
            "best-arcade-games-38-619270595adcb-120",
            "best-arcade-games-39-619270728263b-120",
            "best-arcade-games-4-618ccb2422b80-120",
            "best-arcade-games-40-618d2d76164a2-120",
            "best-arcade-games-41-618d31b4da182-120",
            "best-arcade-games-42-618d33c319be6-120",
            "best-arcade-games-43-618d3500b8aa4-120",
            "best-arcade-games-44-618d369a1b071-120",
            "best-arcade-games-45-618d37bab8920-120",
            "best-arcade-games-46-618d389c7fd3a-120",
            "best-arcade-games-47-618d3a7d49548-120",
            "best-arcade-games-48-618e171e2fda6-120",
            "best-arcade-games-49-618e183b031e7-120",
            "best-arcade-games-5-618ccb2a50d05-120",
            "best-arcade-games-50-618e1941ddfec-120",
            "best-arcade-games-51-618e1aba2d2ab-120",
            "best-arcade-games-52-618e1c1d117b9-120",
            "best-arcade-games-53-618e1d2bc0642-120",
            "best-arcade-games-54-618e2617c62c4-120",
            "best-arcade-games-55-618e26dc3e2d1-120",
            "best-arcade-games-56-618e286fbef38-120",
            "best-arcade-games-57-618e298d2b690-120",
            "best-arcade-games-58-618e2afb54a70-120",
            "best-arcade-games-59-618e2c1bad7cf-120",
            "best-arcade-games-6-618ccc50ca288-120",
            "best-arcade-games-60-618e2d4fab0e9-120",
            "best-arcade-games-61-618e3fed5ca29-120",
            "best-arcade-games-62-618e408c0bfe1-120",
            "best-arcade-games-63-618e413332c6a-120",
            "best-arcade-games-64-618e42944bc74-120",
            "best-arcade-games-65-618e43baf323c-120",
            "best-arcade-games-66-618e4489615e7-120",
            "best-arcade-games-67-618e46d3e557a-120",
            "best-arcade-games-68-618e48419180b-120",
            "best-arcade-games-69-618e6228abc6d-120",
            "best-arcade-games-7-618ccd70e7c79-120",
            "best-arcade-games-70-618e696e1db10-120",
            "best-arcade-games-71-618e6a1e4535d-120",
            "best-arcade-games-72-618e6afac79f4-120",
            "best-arcade-games-73-618e6ba5b91b6-120",
            "best-arcade-games-74-618e6c8b983cb-120",
            "best-arcade-games-75-618e6db700cfe-120",
            "best-arcade-games-76-618e6e9e8c2e7-120",
            "best-arcade-games-77-618e6fa6a5d6a-120",
            "best-arcade-games-78-618e7075462ed-120",
            "best-arcade-games-79-618e719381fc1-120",
            "best-arcade-games-8-618ccfab7ef3b-120",
            "best-arcade-games-80-618e728d2d0a0-120",
            "best-arcade-games-81-618e87fcd9719-120",
            "best-arcade-games-82-618e89e69bce6-120",
            "best-arcade-games-83-61921234a0d82-120",
            "best-arcade-games-84-619213ee25d77-120",
            "best-arcade-games-85-61921567a86f0-120",
            "best-arcade-games-86-6192175d59310-120",
            "best-arcade-games-87-6192185d94d35-120",
            "best-arcade-games-88-61921925745c8-120",
            "best-arcade-games-89-61921a66afa9f-120",
            "best-arcade-games-9-618cd068cd286-120",
            "best-arcade-games-91-61921d3878ae3-120",
            "best-arcade-games-92-61921e4165cee-120",
            "best-arcade-games-93-61921f5fa81a3-120",
            "best-arcade-games-94-619220b9861af-120",
            "best-arcade-games-95-619225c509652-120",
            "best-arcade-games-97-6192271b002e2-120",
            "best-arcade-games-98-6192281d18d93-120",
            "best-arcade-games-99-61922c7266c34-120"]
        for str in strs {
            let components = str.split(separator: "-")
            list.append(RetroGame(id: Int(components[3])!, hex: String(components[4]), name: "", imagename: str, isCompleted: false))
        }
    }
    
    func toJSON() -> String {
        let encoder = JSONEncoder()
        do {
            encoder.outputFormatting = JSONEncoder.OutputFormatting([.prettyPrinted, .sortedKeys])
            let data = try encoder.encode(list)
            let jsonString = String(data: data, encoding: .utf8)!
            return jsonString
        } catch {
            print("ERROR: Cannot encode RetroGameList")
        }
        return ""
    }
    
    func load(filename: String, ext: String) {
        guard let url = Bundle.main.url(forResource: filename, withExtension: ext) else {
            print("ERROR: Cannot find file \(filename).\(ext)")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            
            let decoder = JSONDecoder()
            list = try decoder.decode([RetroGame].self, from: data)
        } catch {
            print("ERROR: Cannot decode \(filename).\(ext)")
        }
    }
}
