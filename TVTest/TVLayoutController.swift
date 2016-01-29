//
//  FirstViewController.swift
//  TVLayout
//
//  Created by MarioHahn on 29/01/16.
//  Copyright © 2016 Mario Hahn. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

class ImageCollectionViewCell : UICollectionViewCell {
    
    
    var imageView: UIImageView

    
    override init(frame: CGRect) {
        imageView = UIImageView()
        super.init(frame: frame)
        
        
        
        imageView.image = UIImage(named: "emtyheader")
        imageView.sd_setImageWithURL(NSURL(string: "https://placehold.it/1280x720"))
//        #if TARGET_OS_TV
        imageView.adjustsImageWhenAncestorFocused = true
//        #endif
        contentView.addSubview(imageView)
        
        imageView.snp_makeConstraints { make in
            make.edges.equalTo(self.contentView)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class HorizontalCollectionViewCell : UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    override var preferredFocusedView: UIView? {
        return collectionView
    }
    
    lazy var header: HeaderView = {
        let header = HeaderView()
        header.titleLabel.text = "oachkatzlschwoaf ole ole ole ole"
        return header
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Horizontal
        layout.minimumLineSpacing = 30
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerClass(ImageCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(ImageCollectionViewCell.self))
        collectionView.clipsToBounds = false
        return collectionView
    }()
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(NSStringFromClass(ImageCollectionViewCell.self), forIndexPath: indexPath) as! ImageCollectionViewCell
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let cellHeight = collectionView.bounds.height
        
        return CGSize(width: cellHeight / 1.3, height: cellHeight)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = false
        
        addSubview(header)
        
        addSubview(collectionView)
        collectionView.snp_makeConstraints { make in
            make.edges.equalTo(snp_edges).inset(UIEdgeInsets(top: 60, left: 0, bottom: 0, right: 0))
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        header.frame = CGRect(x: 0, y: 0, width: headerSize().width, height: headerSize().height)
        

    }
    
    func headerSize() -> CGSize {
        let size = header.titleLabel.sizeThatFits(CGSizeZero)
        return size
    }
    
    func collectionView(collectionView: UICollectionView, didUpdateFocusInContext context: UICollectionViewFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        
        var adjustOffset = false

        if let cell = context.nextFocusedView where cell.isDescendantOfView(collectionView) {
            let cellFrameConverted = convertRect(cell.frame, fromView: collectionView)
            print(cellFrameConverted.minX)
            print(header.frame.maxX)
            adjustOffset = cellFrameConverted.minX <= header.frame.maxX
        }
        
        coordinator.addCoordinatedAnimations({
            self.header.frame = CGRect(x: 0, y: adjustOffset ? -50 : 0, width: self.headerSize().width, height: self.headerSize().height)
            }, completion: {

        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class HeaderView: UIView {
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle2)
        titleLabel.textColor = UIColor.grayColor()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.frame = bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class LayoutController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Horizontal
        
        super.init(collectionViewLayout: layout)
    }

    required init?(coder aDecoder: NSCoder) {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Vertical
        
        super.init(collectionViewLayout: layout)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        collectionView?.registerClass(HorizontalCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(HorizontalCollectionViewCell.self))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 10
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(NSStringFromClass(HorizontalCollectionViewCell.self), forIndexPath: indexPath) as! HorizontalCollectionViewCell
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 350)
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 50, left: 10, bottom: 50, right: 10)
    }
    
    override func collectionView(collectionView: UICollectionView, canFocusItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
}

