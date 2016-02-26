//
//  CPFShelfCells.swift
//  TVTest
//
//  Created by Dominik Arnhof on 26.02.16.
//  Copyright © 2016 Tailored Apps. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

enum CPFPosterTitleType {
    case Always
    case FocusedOnly
}

class CPFPosterCell: UICollectionViewCell {
    
    
    let imageView: UIImageView
    let titleLabel: UILabel
    
    var model: CPFPosterModel? {
        didSet {
            titleLabel.text = model?.title
            imageView.image = nil
            if let urlString = model?.imageURL {
                imageView.sd_setImageWithURL(NSURL(string: urlString))
            }
            if let image = model?.image {
                imageView.image = image
            }
            titleLabel.alpha = model?.titleType == .Always ? 1.0 : 0.0
        }
    }
    
    var labelConstraint: Constraint?
    
    override init(frame: CGRect) {
        imageView = UIImageView()
        titleLabel = UILabel()
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        titleLabel.textColor = UIColor.grayColor()
        super.init(frame: frame)
        
        imageView.image = UIImage(named: "emtyheader")
        
//        #if TARGET_OS_TV
        imageView.adjustsImageWhenAncestorFocused = true
//        #endif
        contentView.addSubview(imageView)
        
        imageView.snp_makeConstraints { make in
            make.edges.equalTo(self.contentView)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp_makeConstraints { make in
            make.leading.equalTo(contentView.snp_leading)
            make.trailing.equalTo(contentView.snp_trailing)
            labelConstraint = make.top.equalTo(contentView.snp_bottom).constraint
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocusInContext(context, withAnimationCoordinator: coordinator)
        let focused = context.nextFocusedView == self
        let offset = focused ? 40 : 0
        labelConstraint?.updateOffset(offset)

        if self.model?.titleType == .FocusedOnly {
            self.titleLabel.alpha = focused ? 1.0 : 0.0
        }
        
        coordinator.addCoordinatedAnimations({ 
            self.contentView.layoutIfNeeded()
            self.titleLabel.textColor = focused ? UIColor.whiteColor() : UIColor.grayColor()
        }, completion: nil)
    }
    
}

class HorizontalCollectionViewCell : UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    weak var dataSource: ShelfViewDataSource?
    weak var delegate: ShelfViewDelegate?
    
    var section = 0
    
    override var preferredFocusedView: UIView? {
        return collectionView
    }
    
    lazy var header: HeaderView = {
        let header = HeaderView()
        header.titleLabel.text = "abcdefghijklmnopqrstuvwxyz"
        return header
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Horizontal
        layout.minimumLineSpacing = 30
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self)
        collectionView.register(CPFPosterCell.self)
        collectionView.clipsToBounds = false
        return collectionView
    }()
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.cpf_collectionView(collectionView, numberOfItemsInSection: 0) ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = dataSource?.cpf_collectionView(collectionView, cellForItemAtIndexPath: indexPath) else {
            return collectionView.dequeueReusableCell(forIndexPath: indexPath) as UICollectionViewCell
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return delegate?.cpf_collectionView(collectionView, layout: collectionViewLayout, sizeForItemAtIndexPath: adjustedIndexPathForIndexPath(indexPath)) ?? CGSizeZero
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
        
        
        
        
    }
    
    override var bounds: CGRect {
        didSet {
            header.frame = CGRect(x: 0, y: -10, width: headerSize().width, height: headerSize().height)
        }
    }
    
    func headerSize() -> CGSize {
        let size = header.titleLabel.sizeThatFits(CGSizeZero)
        return size
    }
    
    func adjustedIndexPathForIndexPath(indexPath: NSIndexPath) -> NSIndexPath {
        return NSIndexPath(forItem: indexPath.item, inSection: section)
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
            self.header.frame = CGRect(x: 0, y: adjustOffset ? -50 : -10, width: self.headerSize().width, height: self.headerSize().height)
            }, completion: {
                
        })
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        delegate?.cpf_collectionView(collectionView, didSelectItemAtIndexPath: adjustedIndexPathForIndexPath(indexPath))
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func register(cells: [String]) {
        for cell in cells {
            collectionView.registerClass(NSClassFromString(cell), forCellWithReuseIdentifier: cell)
        }
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
