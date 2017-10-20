//
//  PhotoViewController.swift
//  Example
//
//  Created by Сергей Гаврилко on 27.09.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import ImageSource
import Paparazzo
import UIKit

class PhotoViewController: UIViewController {

    var order:Order!
    @IBOutlet var myCollectionView: UICollectionView!
    @IBOutlet var myLabel: UILabel!
    @IBOutlet var myImageView: UIImageView!
    @IBOutlet var myButton: UIButton!
    var photos = [ImageSource]()
    
    let gapWidth = 4.0
    var imageWidth: CGFloat!
    
    private func updateUI() {
        
        //imageView.setImage(fromSource: photos.first)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageWidth = (self.view.frame.size.width - CGFloat(gapWidth))/3.0
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: imageWidth, height: imageWidth)
        layout.minimumInteritemSpacing = 2.0
        layout.minimumLineSpacing = 2.0
        myCollectionView!.collectionViewLayout = layout
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        UIApplication.shared.setStatusBarHidden(false, with: .fade)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (photos.count == 0){
            myLabel.isHidden = false
            myButton.isHidden = false
            myImageView.isHidden = false
        }
        else{
            myLabel.isHidden = true
            myButton.isHidden = true
            myImageView.isHidden = true
        }
        myCollectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func nextView(){
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TabBarController") as! TabViewController
        self.present(nextViewController, animated:true, completion: nil)
        
    }
    
    @IBAction func back(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func showMediaPicker() {
        
        let assemblyFactory = Paparazzo.AssemblyFactory(theme: PaparazzoUITheme.appSpecificTheme())
        let assembly = assemblyFactory.mediaPickerAssembly()
        
        let data = MediaPickerData(items: [], selectedItem: nil, maxItemsCount: 20, cropEnabled: true, autocorrectEnabled: true, cropCanvasSize: CGSize(width: 1280, height: 960))
        
        let mediaPickerController = assembly.module(
            data: data,
            configure: { [weak self] module in
                weak var module = module
                
                module?.setContinueButtonTitle("Done")
                
                module?.onFinish = { mediaPickerItems in
                    module?.dismissModule()
                    
                    // storing picked photos in instance var and updating UI
                    self?.photos = mediaPickerItems.map { $0.image }
                    self?.updateUI()
                }
                module?.onCancel = {
                    module?.dismissModule()
                }
            }
        )
        
        navigationController?.pushViewController(mediaPickerController, animated: true)
    }
    
    

}

extension PhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (photos.count == 0){
            myCollectionView.isHidden = true
            return 0
        }
        else{
            myCollectionView.isHidden = false
            return photos.count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellWithImage", for: indexPath) as! WithImageCell
        
        if(indexPath.row < photos.count){
            
            cell.frame.size = CGSize(width: imageWidth, height: imageWidth)
            cell.image.frame.size = CGSize(width: imageWidth, height: imageWidth)
            cell.image.setImage(fromSource: photos[indexPath.row])
            
        }
        else{
            
            cell.frame.size = CGSize(width: imageWidth, height: imageWidth)
            //cell.image.frame.size = CGSize(width: imageWidth, height: imageWidth)
            //cell.image.setImage(fromSource: photos[indexPath.row])
            
        }
        
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("kek")
    }
    
}
