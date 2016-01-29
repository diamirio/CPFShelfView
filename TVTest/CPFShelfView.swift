//
//  CPFShelfView.swift
//  TVTest
//
//  Created by Dominik Arnhof on 29.01.16.
//  Copyright © 2016 Tailored Apps. All rights reserved.
//

import UIKit

class CPFShelfView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Vertical
        super.init(frame: CGRectZero, collectionViewLayout: layout)
        registerClass(HorizontalCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(HorizontalCollectionViewCell.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(NSStringFromClass(HorizontalCollectionViewCell.self), forIndexPath: indexPath) as! HorizontalCollectionViewCell
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 350)
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 50, left: 10, bottom: 50, right: 10)
    }
    
    func collectionView(collectionView: UICollectionView, canFocusItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
}
