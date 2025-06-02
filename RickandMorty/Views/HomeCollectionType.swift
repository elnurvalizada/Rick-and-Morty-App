//
//  HomeCollectionType.swift
//  RickandMorty
//
//  Created by Elnur Valizada on 02.06.25.
//

import UIKit

enum HomeCollectionType {
    case filter
    case character
    
    static func from(_ collectionView : UICollectionView, in controller: HomeViewController) -> HomeCollectionType? {
        if collectionView == controller.filterCollectionView {
            return .filter
        }
        else if collectionView == controller.characterCollectionView {
            return .character
        } else {
            return nil
        }
    }
}
