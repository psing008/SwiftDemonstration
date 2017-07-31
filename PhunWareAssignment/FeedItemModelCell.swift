//
//  FeedItemModelCell.swift
//  PhunWareAssignment
//
//  Created by Piyush Singh on 5/5/17.
//  Copyright © 2017 Piyush Singh. All rights reserved.
//

import UIKit

class FeedItemModelCell: UICollectionViewCell {

   
    var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var feedDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.translatesAutoresizingMaskIntoConstraints = false

        imageView = UIImageView(frame: self.frame)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        let backView = UIView(frame: self.frame)
        backView.backgroundColor = UIColor.init(white: 0.9, alpha: 0.6)
        self.addSubview(backView)
        self.sendSubview(toBack: backView)
        self.sendSubview(toBack: imageView)
 
        backView.translatesAutoresizingMaskIntoConstraints = false
        backView.contentMode = .scaleToFill
        
        //create constraints for ImageView and back view
        let imageleadingLayout = NSLayoutConstraint(item: imageView, attribute: .leading, relatedBy: .equal, toItem: contentView.superview, attribute: .leading, multiplier: 1.0, constant: 0.0)

        let imagetrailingLayout = NSLayoutConstraint(item: imageView, attribute: .trailing, relatedBy: .equal, toItem: contentView.superview, attribute: .trailing, multiplier: 1.0, constant: 0.0)

         let imagetopLayout = NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: contentView.superview, attribute: .top, multiplier: 1.0, constant: 0.0)
        
        let imagebottomLayout = NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: contentView.superview, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        
        let backleadingLayout = NSLayoutConstraint(item: backView, attribute: .leading, relatedBy: .equal, toItem: contentView.superview, attribute: .leading, multiplier: 1.0, constant: 0.0)
        
        let backtrailingLayout = NSLayoutConstraint(item: backView, attribute: .trailing, relatedBy: .equal, toItem: contentView.superview, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        
        let backtopLayout = NSLayoutConstraint(item: backView, attribute: .top, relatedBy: .equal, toItem: contentView.superview, attribute: .top, multiplier: 1.0, constant: 0.0)
        
        let backbottomLayout = NSLayoutConstraint(item: backView, attribute: .bottom, relatedBy: .equal, toItem: contentView.superview, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        self.addConstraints([imageleadingLayout,imagetrailingLayout,imagetopLayout,imagebottomLayout,backtrailingLayout,backleadingLayout,backtopLayout,backbottomLayout])
       
    }
    
    override func prepareForReuse() {
       
    }
    
    //helper method to set cell data to cell elements
    func setModel(model:FeedItemModel) {
        imageView.image = UIImage(named: "placeholder")
        if let date = model.date, let time = model.time {
            dateLabel.text = "\(date) at \(time)"
        }
        
        titleLabel.text = model.title
        
        if let loc1 = model.locationLine1, let loc2 = model.lcoationLine2 {
            locationLabel.text = "\(loc1), \(loc2)"
        }
        
        feedDescription.text = model.itemDescription
    }
}
