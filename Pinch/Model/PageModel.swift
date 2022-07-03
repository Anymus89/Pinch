//
//  PageModel.swift
//  Pinch
//
//  Created by Manuel Martinez on 02/07/22.
//

import Foundation

struct Page: Identifiable {
    let id: Int
    let imageName: String 
}

extension Page {
    var thumbnailName: String {
        return "thumb-" + imageName
    }
}
