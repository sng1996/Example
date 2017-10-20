//
//  DescriptionViewController.swift
//  Example
//
//  Created by Сергей Гаврилко on 27.09.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import ImageSource
import Paparazzo
import UIKit

class DescriptionViewController: UIViewController, UITextViewDelegate {

    var kPreferredTextViewToKeyboardOffset: CGFloat = 0.0
    var keyboardFrame: CGRect = CGRect.null
    var keyboardIsShowing: Bool = false
    
    var order:Order!
    var photos = [ImageSource]()
    var myMediaPickerItems = [MediaPickerItem]()
    @IBOutlet var myTextView: UITextView!
    @IBOutlet var myView: UIView!
    
    var numLbl: UILabel!
    var redRound: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        let gray = UIColor(red: 200.0/255.0, green: 200.0/255.0, blue: 200.0/255.0, alpha: 1.0)
        myView.layer.borderColor = gray.cgColor
        myView.layer.borderWidth = 0.5
        myTextView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        myTextView.placeholder = "Описание"
        
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        customView.backgroundColor = UIColor.white
        let continueBtn = UIButton(frame: CGRect(x: 180, y: 11, width: 120, height: 22))
        continueBtn.setTitle("Продолжить", for: .normal)
        continueBtn.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
        continueBtn.setTitleColor(UIColor(red: (100/255.0), green: (64/255.0), blue: (111/255.0), alpha: 1), for: .normal)
        continueBtn.addTarget(self, action: #selector(pressNext), for: .touchUpInside)
        customView.addSubview(continueBtn)
        let goImg = UIImageView(frame: CGRect(x: 300, y: 18.5, width: 6, height: 10))
        goImg.image = UIImage(named: "Go_color")
        customView.addSubview(goImg)
        let photoBtn = UIButton(frame: CGRect(x: 15, y: 4, width: 40, height: 36))
        photoBtn.setImage(UIImage(named: "Photo"), for: .normal)
        photoBtn.addTarget(self, action: #selector(addPhoto), for: .touchUpInside)
        redRound = UIView(frame: CGRect(x: 25, y: -3, width: 20, height: 20))
        redRound.backgroundColor = .red
        redRound.layer.cornerRadius = 10
        redRound.clipsToBounds = true
        numLbl = UILabel(frame: CGRect(x: 5, y: 5, width: 10, height: 10))
        numLbl.text = ""
        numLbl.font = UIFont(name: numLbl.font.fontName, size: 12)
        numLbl.textColor = .white
        numLbl.textAlignment = .center
        redRound.addSubview(numLbl)
        photoBtn.addSubview(redRound)
        customView.addSubview(photoBtn)
        customView.layer.borderColor = UIColor(red: (180/255.0), green: (180/255.0), blue: (180/255.0), alpha: 1).cgColor
        customView.layer.borderWidth = 0.5
        myTextView.inputAccessoryView = customView
        
        self.navigationItem.titleView = setTitle(title: "ДОБАВЬТЕ ОПИСАНИЕ", subtitle: "5 из 6")
        
        
        //////////ATTENTION!!!!! Add some sheet
        
        order.startDate = "20.02.17"
        order.finishDate = "20.11.17"
        order.des = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        UIApplication.shared.setStatusBarHidden(false, with: .fade)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        myTextView.becomeFirstResponder()
        numLbl.text = String(photos.count)
        if (photos.count == 0){
            redRound.isHidden = true
        }
        else{
            redRound.isHidden = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(notification: NSNotification){
        
        self.keyboardIsShowing = true
        
    }
    
    func keyboardWillHide(notification: NSNotification){
        
        self.keyboardIsShowing = false
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }

    @IBAction func next(){
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AboutOrderViewController") as! AboutOrderViewController
        nextViewController.order = order
        nextViewController.photos = photos
        self.navigationController?.pushViewController(nextViewController, animated:true)
        
    }
    
    @IBAction func back(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func pressNext(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AboutOrderViewController") as! AboutOrderViewController
        nextViewController.order = order
        nextViewController.photos = photos
        self.navigationController?.pushViewController(nextViewController, animated:true)
    }
    
    func addPhoto(){
        let assemblyFactory = Paparazzo.AssemblyFactory(theme: PaparazzoUITheme.appSpecificTheme())
        let assembly = assemblyFactory.mediaPickerAssembly()
        
        let data = MediaPickerData(items: myMediaPickerItems, selectedItem: nil, maxItemsCount: 20, cropEnabled: true, autocorrectEnabled: true, cropCanvasSize: CGSize(width: 1280, height: 960))
        
        let mediaPickerController = assembly.module(
            data: data,
            configure: { [weak self] module in
                weak var module = module
                
                module?.setContinueButtonTitle("Done")
                
                module?.onFinish = { mediaPickerItems in
                    module?.dismissModule()
                    self?.photos = mediaPickerItems.map { $0.image }
                    self?.myMediaPickerItems = mediaPickerItems
                }
                module?.onCancel = {
                    module?.dismissModule()
                }
            }
        )
        
        navigationController?.pushViewController(mediaPickerController, animated: true)
    }
    
    func setTitle(title:String, subtitle:String) -> UIView {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 2, width: 0, height: 0))
        
        titleLabel.backgroundColor = .clear
        titleLabel.textColor = .black
        titleLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
        titleLabel.text = title
        titleLabel.sizeToFit()
        
        let subtitleLabel = UILabel(frame: CGRect(x: 0, y: 20, width: 0, height: 0))
        subtitleLabel.backgroundColor = .clear
        subtitleLabel.textColor = .gray
        subtitleLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 11)
        subtitleLabel.text = subtitle
        subtitleLabel.sizeToFit()
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: max(titleLabel.frame.size.width, subtitleLabel.frame.size.width), height: 30))
        titleView.addSubview(titleLabel)
        titleView.addSubview(subtitleLabel)
        
        let widthDiff = subtitleLabel.frame.size.width - titleLabel.frame.size.width
        
        if widthDiff < 0 {
            let newX = widthDiff / 2
            subtitleLabel.frame.origin.x = abs(newX)
        } else {
            let newX = widthDiff / 2
            titleLabel.frame.origin.x = newX
        }
        
        return titleView
    }

}
