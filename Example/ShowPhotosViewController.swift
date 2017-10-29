//
//  ShowPhotosViewController.swift
//  Example
//
//  Created by Сергей Гаврилко on 20.10.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import ImageSource
import UIKit

class ShowPhotosViewController: UIViewController, UIScrollViewDelegate {
    
    //VIEW
    
    @IBOutlet var okButton: UIButton!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var myScrollView: UIScrollView!
    
    //CONTROLLER
    
    var photos: [ImageSource] = []
    var numOfPhoto: Int = 0
    var imageViews: [UIImageView] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setupPageControl()
        setupScrollView(imageSource: photos)
        setupMyScrollView()
        setupOkButton()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(myScrollView.contentOffset.x/self.view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageViews[Int(myScrollView.contentOffset.x/self.view.frame.width)]
    }
    
    //ACTION
    
    @IBAction func ok(){
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.popViewController(animated: true)
    }
    
    //CONTROLLER
    
    func setupScrollView(imageSource: [ImageSource]){
        myScrollView.contentSize = CGSize(width: self.view.frame.width*CGFloat(photos.count), height: myScrollView.frame.height)
        myScrollView.isPagingEnabled = true
        
        for i in 0..<imageSource.count{
            
            let myImageView = UIImageView(frame: CGRect(x:0, y: 0, width:self.view.frame.width, height:myScrollView.frame.height))
            myImageView.contentMode = .scaleAspectFit
            myImageView.clipsToBounds = true
            myImageView.setImage(fromSource: imageSource[i])
            myImageView.isUserInteractionEnabled = true
            let subScrollView = UIScrollView(frame: CGRect(x:self.view.frame.width*CGFloat(i), y: 0, width:self.view.frame.width, height:myScrollView.frame.height))
            subScrollView.minimumZoomScale = 1.0
            subScrollView.maximumZoomScale = 6.0
            subScrollView.delegate = self
            subScrollView.addSubview(myImageView)
            myScrollView.addSubview(subScrollView)
            imageViews.append(myImageView)
        }
    }
    
    //DESIGN
    
    func setupPageControl(){
        pageControl.numberOfPages = photos.count
        pageControl.currentPage = numOfPhoto
        pageControl.frame.size.width = CGFloat(24 * photos.count)
        pageControl.layer.cornerRadius = 19
    }
    
    func setupMyScrollView(){
        myScrollView.contentOffset.x = self.view.frame.width * CGFloat(numOfPhoto)
    }
    
    func setupOkButton(){
        okButton.layer.borderColor = UIColor.white.cgColor
        okButton.layer.borderWidth = 0.5
        okButton.layer.cornerRadius = 3
    }


}
