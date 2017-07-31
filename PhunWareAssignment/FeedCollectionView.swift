//
//  ViewController.swift
//  PhunWareAssignment
//
//  Created by Piyush Singh on 5/4/17.
//  Copyright © 2017 Piyush Singh. All rights reserved.
//

import UIKit


class FeedCollectionView: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var data:[FeedItemModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        getFeedItems()
    }
    
    func setUpView() {
        navigationController?.view.backgroundColor = UIColor.groupTableViewBackground
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.collectionViewLayout = FeedItemCellLayout()
        collectionView?.register(UINib.init(nibName: "FeedItemModelCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
    }
    
    func getFeedItems(){
        APIManager.sharedInstance.getDataWithPath(urlPath:Constants.FeedItemsURLString) { (results:Results) in
            switch results {
            case .Success:self.handleSuccess(results: results)
            case .Failure:self.handleSuccess(results: results)
            }
        }
    }
    
    func handleSuccess(results:Results<Any>){
        let dataArray = results.associatedValue as! [FeedItemModel]
        DispatchQueue.main.async {
            self.data = dataArray
            self.collectionView.reloadData()
        }
       
    }
    
    func handleError(results:Results<HTTPError>) {
        print("error getting data \(results.associatedValue)")
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        guard let flowLayout = collectionView?.collectionViewLayout as? FeedItemCellLayout else {
            return
        }
        flowLayout.invalidateLayout()
    }
}



// add methods to NavigationController class to make navbar transparent
extension UINavigationController {
    
    public func makeTransparentNavigationBar() {

        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.isTranslucent = true
        navigationBar.shadowImage = UIImage()
        navigationBar.backgroundColor = UIColor.clear
    }
    
    public func hideTransparentNavigationBar() {

        UIView.animate(withDuration: 0.1, delay: 0.0, usingSpringWithDamping: 1.4, initialSpringVelocity: 1.0, options: .beginFromCurrentState, animations: {
             self.navigationController?.view.backgroundColor = UIColor.groupTableViewBackground
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.navigationBar.setBackgroundImage(UINavigationBar.appearance().backgroundImage(for: UIBarMetrics.default), for:.default)
        }, completion: nil)
    }
    
}
