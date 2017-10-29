//
//  EditorViewController.swift
//  Example
//
//  Created by Сергей Гаврилко on 27.10.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import ImageSource
import UIKit

class EditorViewController: UIViewController{
    
    //VIEW
    
    @IBOutlet var myView: UIView!
    @IBOutlet var myButton: UIButton!
    @IBOutlet var myScrollView: UIScrollView!
    
    //CONTROLLER
    
    var points: [EditPoint] = []
    var order: Order!
    var photos: [ImageSource] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGradient()
        setupPoints()
        setupMyButton()
        setupScrollView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        designNavbar()
    }
    
    //ACTION
    
    @IBAction func back(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ShowPhotosViewController") as! ShowPhotosViewController
        nextViewController.photos = photos
        nextViewController.numOfPhoto = tappedImage.tag
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    //DESIGN
    
    func designNavbar(){
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationController?.navigationBar.layer.dropBottomBorder()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = UIColor(red: (100/255.0), green: (64/255.0), blue: (111/255.0), alpha: 1)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: (100/255.0), green: (64/255.0), blue: (111/255.0), alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: ".HelveticaNeueDeskInterface-Regular", size: 17)!, NSForegroundColorAttributeName : UIColor.white]
    }
    
    func setupPoints(){
        var point = EditPoint(title: "ТИП РАБОТЫ", icon: UIImage(named: "TypeIcon")!, name: types[order.type])
        points.append(point)
        point = EditPoint(title: "ПРЕДМЕТ", icon: UIImage(named: "SubjectIcon")!, name: order.subject)
        points.append(point)
        point = EditPoint(title: "СРОК", icon: UIImage(named: "TimeIcon")!, name: order.finishDate)
        points.append(point)
        point = EditPoint(title: "СТОИМОСТЬ", icon: UIImage(named: "MoneyIcon")!, name: String(order.cost))
        points.append(point)
        point = EditPoint(title: "ОПИСАНИЕ", icon: UIImage(named: "DescriptionIcon")!, name: order.des)
        points.append(point)
    }
    
    func setupGradient(){
        let gradientColors: [CGColor] = [UIColor.clear.cgColor, UIColor.white.cgColor]
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = [0.0, 0.5]
        gradientLayer.frame = myView.bounds
        myView.layer.mask = gradientLayer
    }
    
    func setupMyButton(){
        myButton.layer.cornerRadius = 20
    }
    
    func updateLabelFrame(label: UILabel){
        label.numberOfLines = 20
        let maxSize = CGSize(width: 240, height: 300)
        let size = label.sizeThatFits(maxSize)
        label.frame = CGRect(origin: CGPoint(x: label.frame.origin.x, y: label.frame.origin.y), size: size)
    }
    
    func checkHeight(myText: String) -> CGFloat{
        let label: UILabel = UILabel()
        label.font = UIFont(name: ".HelveticaNeueDeskInterface-Regular", size: 15)!
        label.text = myText
        label.numberOfLines = 20
        let maxSize = CGSize(width: 240, height: 300)
        let size = label.sizeThatFits(maxSize)
        return size.height
    }
    
    func setupScrollView(){
        myScrollView.contentSize = CGSize(width: (myScrollView.frame.height + 15.0)*CGFloat(photos.count) + 15.0, height: myScrollView.frame.height)
        
        for i in 0..<photos.count{
            let myImageView = UIImageView(frame: CGRect(x:CGFloat(Int(myScrollView.frame.height+15.0)*i + 15), y: 0, width:myScrollView.frame.height, height:myScrollView.frame.height))
            myImageView.contentMode = .scaleAspectFill
            myImageView.clipsToBounds = true
            myImageView.setImage(fromSource: photos[i])
            myImageView.tag = i
            myImageView.layer.cornerRadius = 4
            let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            myImageView.isUserInteractionEnabled = true
            myImageView.addGestureRecognizer(tap)
            myScrollView.addSubview(myImageView)
        }
    }

}

extension EditorViewController: UITableViewDelegate, UITableViewDataSource{
    
    public func tableView(_ tableView:UITableView, numberOfRowsInSection section: Int) -> Int{
        return points.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return (checkHeight(myText: points[indexPath.row].name) + 70.0)
    }
    
    public func tableView(_ tableView:UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "editCell", for: indexPath) as! EditCell
        
        cell.titleLbl.text = points[indexPath.row].title
        cell.icon.image = points[indexPath.row].icon
        if (indexPath.row == 3){
            cell.nameLbl.text = points[indexPath.row].name + " ₽"
        }
        else{
            cell.nameLbl.text = points[indexPath.row].name
        }
        cell.createLine(lenth: self.view.frame.size.width - 65)
        updateLabelFrame(label: cell.nameLbl)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        switch(indexPath.row){
        case 0: let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TypeViewController") as! TypeViewController
        nextViewController.order = order
        self.navigationController?.pushViewController(nextViewController, animated: true)
        break;
        case 1: let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ExactScienceViewController") as! ExactScienceViewController
        nextViewController.order = order
        self.navigationController?.pushViewController(nextViewController, animated: true)
        break;
        case 2: let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CalendarViewController") as! CalendarViewController
        nextViewController.order = order
        self.navigationController?.pushViewController(nextViewController, animated: true)
        break;
        case 3: let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CostViewController") as! CostViewController
        nextViewController.order = order
        self.navigationController?.pushViewController(nextViewController, animated: true)
        case 4: let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DescriptionViewController") as! DescriptionViewController
        nextViewController.order = order
        self.navigationController?.pushViewController(nextViewController, animated: true)
        break;
        default: break;
        }
        
    }
    
}
