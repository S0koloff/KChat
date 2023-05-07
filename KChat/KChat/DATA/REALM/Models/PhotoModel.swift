//
//  PhotoModel.swift
//  KChat
//
//  Created by Sokolov on 28.04.2023.
//

import UIKit
import RealmSwift

final class PhotoModel: Object {
    @Persisted var photo = ""
}
