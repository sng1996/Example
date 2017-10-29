//
//  CostViewController.swift
//  Example
//
//  Created by Сергей Гаврилко on 27.09.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit

class CostViewController: UIViewController {
    
    @IBOutlet var myView: UIView!
    @IBOutlet var costTxtFld: UITextField!
    var order:Order!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        designNavbar()
        setupTextField()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    override func viewWillAppear(_ animated: Bool) {
        designNavbar()
        costTxtFld.becomeFirstResponder()
    }

    //ACTIONS
    
    @IBAction func back(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func pressNext(){
        order.cost = Int(costTxtFld.text ?? "") ?? 0
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DescriptionViewController") as! DescriptionViewController
        nextViewController.order = order
        self.navigationController?.pushViewController(nextViewController, animated:true)
    }
    
    //DESIGN VIEW
    
    func designNavbar(){
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationController?.navigationBar.layer.dropBottomBorder()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: ".HelveticaNeueDeskInterface-Regular", size: 17)!, NSForegroundColorAttributeName : UIColor.white]
    }
    
    func setupTextField(){
        costTxtFld.inputAccessoryView = designAboveKeyboardView()
    }
    
    func designAboveKeyboardView() -> UIView {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        customView.backgroundColor = UIColor.white
        let continueBtn = UIButton(frame: CGRect(x: 180, y: 11, width: 120, height: 22))
        continueBtn.setTitle("Продолжить", for: .normal)
        continueBtn.setTitleColor(UIColor(red: (100/255.0), green: (64/255.0), blue: (111/255.0), alpha: 1), for: .normal)
        continueBtn.titleLabel?.font = UIFont(name: ".HelveticaNeueDeskInterface-Regular", size: 15)
        continueBtn.addTarget(self, action: #selector(pressNext), for: .touchUpInside)
        customView.addSubview(continueBtn)
        let goImg = UIImageView(frame: CGRect(x: 300, y: 18.5, width: 6, height: 10))
        goImg.image = UIImage(named: "Go_color")
        customView.addSubview(goImg)
        customView.layer.borderColor = UIColor(red: (180/255.0), green: (180/255.0), blue: (180/255.0), alpha: 1).cgColor
        customView.layer.borderWidth = 0.5
        return customView
    }

}
