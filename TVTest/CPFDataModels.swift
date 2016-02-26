//
//  CPFDataModels.swift
//  TVTest
//
//  Created by Dominik Arnhof on 26.02.16.
//  Copyright © 2016 Tailored Apps. All rights reserved.
//

import UIKit

class CPFPosterModel {
    let title: String
    let titleType: CPFPosterTitleType
    let image: UIImage?
    let imageURL: String?
    
    init(title: String, image: UIImage? = nil, imageURL: String? = nil, titleType: CPFPosterTitleType = .FocusedOnly) {
        self.title = title
        self.titleType = titleType
        self.image = image
        self.imageURL = imageURL
    }
}
