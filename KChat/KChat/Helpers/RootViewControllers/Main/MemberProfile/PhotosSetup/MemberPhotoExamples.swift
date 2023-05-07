//
//  MemberPhotoExamples.swift
//  KChat
//
//  Created by Sokolov on 12.04.2023.
//

import UIKit

final class MemberPhotos {
    
    static let shared = MemberPhotos()
    
    let examples: [UIImage]
    
    private init() {
        var photos = [UIImage]()
        for i in 1...4 { photos.append((UIImage(named: "cat\(i)") ?? UIImage())) }
        examples = photos.shuffled()
    }
}
