//
//  CharacterModel.swift
//  RickandMorty
//
//  Created by Elnur Valizada on 16.05.25.
//

import UIKit

struct CharacterResponse : Codable {
    let info : Info
    let characters : [Character]
    
    enum CodingKeys: String, CodingKey {
        case info
        case characters = "results"
    }
    
    struct Info : Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
    
    struct Character : Codable, Identifiable, Hashable {
        let id : Int
        let name : String
        let status : String
        let species : String
        let gender : String
        let image : String
        let type : String
        
        var genderType : GenderType? {
            return GenderType(rawValue: gender)
        }
        
        var genderBackgroundColor : UIColor? {
            return genderType?.color
        }
        
        var genderIcon : UIImage? {
            return genderType?.icon
        }
    }
}

enum GenderType : String {
    case male = "Male"
    case female = "Female"
    case unknown = "Unknown"
    case genderless = "Genderless"
    
    var icon : UIImage? {
        switch self {
        case .male:
            return UIImage(systemName: "person.circle.fill")
        case .female:
            return UIImage(systemName: "person.fill")
        case .genderless:
            return UIImage(systemName: "person.circle")
        case .unknown:
            return UIImage(systemName: "questionmark.circle")
        }
    }
    
    var color : UIColor {
        switch self {
        case .male:
            return .systemBlue
        case .female:
            return .systemPink
        case .genderless:
            return .systemGray
        case .unknown:
            return .black
        }
    }
}
