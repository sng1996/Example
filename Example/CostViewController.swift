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
        
        costTxtFld.becomeFirstResponder()
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: ".HelveticaNeueDeskInterface-Regular", size: 17)!]
        
        let leftColor = UIColor(red: (100/255.0), green: (64/255.0), blue: (111/255.0), alpha: 1)
        let rightColor = UIColor(red: (100/255.0), green: (64/255.0), blue: (111/255.0), alpha: 1)
        let gradientColors: [CGColor] = [leftColor.cgColor, rightColor.cgColor]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        gradientLayer.frame = myView.bounds
        myView.layer.insertSublayer(gradientLayer, at: 0)
        
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
        costTxtFld.inputAccessoryView = customView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        costTxtFld.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.layer.dropBottomBorder()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: ".HelveticaNeueDeskInterface-Regular", size: 17)!, NSForegroundColorAttributeName : UIColor.white]
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.black]
        self.navigationController?.navigationBar.layer.setBottomBorder()
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: ".HelveticaNeueDeskInterface-Regular", size: 17)!]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func next(){
        
        order.cost = Int(costTxtFld.text ?? "") ?? 0
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DescriptionViewController") as! DescriptionViewController
        nextViewController.order = order
        self.navigationController?.pushViewController(nextViewController, animated:true)
        
    }
    
    class Colors {
        var gl:CAGradientLayer!
        
        init() {
            let colorTop = UIColor(red: 192.0 / 255.0, green: 38.0 / 255.0, blue: 42.0 / 255.0, alpha: 1.0).cgColor
            let colorBottom = UIColor(red: 35.0 / 255.0, green: 2.0 / 255.0, blue: 2.0 / 255.0, alpha: 1.0).cgColor
            
            self.gl = CAGradientLayer()
            self.gl.colors = [colorTop, colorBottom]
            self.gl.locations = [0.0, 1.0]
        }
    }
    
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
    
    func pressWallet(){
        print("pressWallet")
    }

}
