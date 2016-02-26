//
//  CPFShelfView.swift
//  TVTest
//
//  Created by Dominik Arnhof on 29.01.16.
//  Copyright © 2016 Tailored Apps. All rights reserved.
//

import UIKit

protocol ShelfViewDataSource: class {
    func cpf_collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    func cpf_collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    func cpf_numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
}

protocol ShelfViewDelegate: class {
    func cpf_collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    func cpf_collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
}

class CPFShelfView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    weak var dataSource: ShelfViewDataSource?
    weak var delegate: ShelfViewDelegate?
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Vertical
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        
        collectionView.register(HorizontalCollectionViewCell.self)
        
        return collectionView
    }()
    
    private(set) var registeredCells = [String]()
    
    init() {
        super.init(frame: CGRectZero)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        addSubview(collectionView)
        collectionView.snp_makeConstraints { (make) in
            make.edges.equalTo(snp_edges)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func register<T: UICollectionViewCell where T: ReusableView>(cells: [T.Type]) {
        for cell in cells {
            registeredCells.append(cell.defaultReuseIdentifier)
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return dataSource?.cpf_numberOfSectionsInCollectionView(collectionView) ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(NSStringFromClass(HorizontalCollectionViewCell.self), forIndexPath: indexPath) as! HorizontalCollectionViewCell
        cell.dataSource = dataSource
        cell.delegate = delegate
        cell.section = indexPath.section
        cell.register(registeredCells)
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
