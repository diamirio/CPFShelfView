//
//  FirstViewController.swift
//  TVTest
//
//  Created by Dominik Arnhof on 29.01.16.
//  Copyright © 2016 Tailored Apps. All rights reserved.
//

import UIKit

class TestCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.redColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class FirstViewController: UIViewController, ShelfViewDataSource, ShelfViewDelegate {

    let shelfView = CPFShelfView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shelfView.dataSource = self
        shelfView.delegate = self
        
        shelfView.register([TestCell.self])
        
        view.addSubview(shelfView)
        shelfView.snp_makeConstraints { (make) in
            make.edges.equalTo(view.snp_edges)
        }
    }
    
    func cpf_numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func cpf_collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func cpf_collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(forIndexPath: indexPath) as TestCell
    }
    
    func cpf_collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print(indexPath)
    }
}

