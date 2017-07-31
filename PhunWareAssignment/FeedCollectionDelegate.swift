//
//  FeedCollectionDelegate.swift
//  PhunWareAssignment
//
//  Created by Piyush Singh on 5/7/17.
//  Copyright © 2017 Piyush Singh. All rights reserved.
//

import UIKit
import SDWebImage
import SDWebImage.SDImageCache

// extension for UICollectionViewDelegate Methods and UICollectionViewDelegateFlowLayout
extension FeedCollectionView: UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:FeedItemModelCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! FeedItemModelCell
        return configureCell(cell: cell, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = data[indexPath.row]
        let detail = FeedDetailViewController(model:model)
        navigationController?.pushViewController(detail, animated: true)
    }
    
    //convineince method to set up cell
    func configureCell(cell:FeedItemModelCell,indexPath:IndexPath) -> FeedItemModelCell{
        
        if indexPath.row <= data.count {
            let model:FeedItemModel = data[indexPath.row]
            //set data model on cell
            cell.setModel(model: model)
            guard let imagePath = model.imageURL,let imageURL = URL(string:imagePath) else {
                return cell
            }
            
            // Check disk cache for existing image, if so set it and return it
            let image = SDImageCache.shared().imageFromDiskCache(forKey:String(model.id))
            if image != nil {
                cell.imageView.image = image
                return cell
            }
            // Download image asynchronously
            SDWebImageDownloader.shared().downloadImage(with: imageURL, options: .highPriority, progress: nil) { (image, data, error, suucess) in
                if let error = error {
                    print("Error getting image \(error.localizedDescription)")
                    return
                }
                // make sure we still have the old cell we requested image for
                guard let imageCell = self.collectionView.cellForItem(at: indexPath) as? FeedItemModelCell  else {
                        //if no cell return
                        return
                }
                
                // if cell, update image on main thread
                DispatchQueue.main.async {
                    imageCell.imageView.image = image
                }
                // Cache the image on disk for further retrieval
                SDImageCache.shared() .store(image, forKey: String(model.id))
                    
            }
            //return cell after setting data
            return cell
        }
        // if no data model, return cell immediately
        return cell
        
    }
    
    
//
}
















