//
//  FeedItemCellLayout.swift
//  PhunWareAssignment
//
//  Created by Piyush Singh on 5/5/17.
//  Copyright © 2017 Piyush Singh. All rights reserved.
//

import UIKit

class FeedItemCellLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        setUpLayout()
        
    }
    
    func setUpLayout()  {
        minimumLineSpacing = 0.0
        minimumInteritemSpacing = 0.0
        scrollDirection = .vertical
       
       
       
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpLayout()
    
    }
    
    override var itemSize: CGSize {
        set {
            
        }
        get {
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad) {
            return CGSize(width: (self.collectionView?.frame.width)!/2.0, height: 200)
            }
            
            return CGSize(width:(self.collectionView?.frame.width)!,height: 200)
        }
    }
}
