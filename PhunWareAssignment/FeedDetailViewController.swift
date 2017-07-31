//
//  FeedDetailViewController.swift
//  PhunWareAssignment
//
//  Created by Piyush Singh on 5/7/17.
//  Copyright © 2017 Piyush Singh. All rights reserved.
//

import UIKit
import SDWebImage.SDImageCache
class FeedDetailViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var feedScrollView: UIScrollView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    var model:FeedItemModel!
    
    init(model:FeedItemModel){
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    override func viewDidLoad() {super.viewDidLoad()
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // after subviews have been laid out, tell ContentView to re-layout its' subviews, so we can calculate height after auto-layout changes
        contentView.layoutIfNeeded()
        // calculate scrollable height, by adding up subviews heights. This works on .phone and .pad
        feedScrollView.contentSize = CGSize(width: 0, height:sizeForContentView())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.hideTransparentNavigationBar()
        navigationItem.rightBarButtonItem = nil
        super.viewWillDisappear(animated)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.makeTransparentNavigationBar()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(addTapped))
        
    }
    
    func setUpView()  {
        automaticallyAdjustsScrollViewInsets = false
        titleLabel.text = model.title
        if let date = model.date,let time = model.time {
            dateLabel.text = "\(date) at \(time)"
        }
        descriptionLabel.text = model.itemDescription
        //Get cached image and display it
        let image = SDImageCache.shared().imageFromDiskCache(forKey:String(model.id))
        if image != nil{
            imageView.image = image
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()}
    
}


extension FeedDetailViewController {
    //Share action handler
    func displayShareSheet(shareContent:String,sender:UIBarButtonItem) {
        let activityViewController = UIActivityViewController(activityItems: [shareContent as NSString], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.popoverPresentationController?.barButtonItem = sender
        present(activityViewController, animated: true, completion: {})
    }
    func addTapped(sender:UIBarButtonItem)  {
        displayShareSheet(shareContent: "Reading \(model.title) from Phun App \n \(model.itemDescription)",sender: sender)
    }
    // calculate overall content height so scroll view has correct content size
    func sizeForContentView()-> CGFloat {
        var contentHeight:CGFloat = 25
        for view in (contentView.subviews) {
            contentHeight += view.frame.size.height
        }
        return contentHeight
    }
    

    
}
