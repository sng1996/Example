//
//  AboutOrderViewController.swift
//  Smart-as
//
//  Created by Сергей Гаврилко on 05.08.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import ImageSource
import UIKit

class AboutOrderViewController: UIViewController, UIScrollViewDelegate {
    
    //VIEW
    
    @IBOutlet var type: UILabel!
    @IBOutlet var subject: UILabel!
    @IBOutlet var startDate: UILabel!
    @IBOutlet var finishDate: UILabel!
    @IBOutlet var cost: UILabel!
    @IBOutlet var des: UITextView!
    @IBOutlet var myButton: UIButton!
    @IBOutlet var myView: UIView!
    @IBOutlet var myScrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var heightScrollView: UIScrollView!
    @IBOutlet var startImg: UIImageView!
    @IBOutlet var finishImg: UIImageView!
    @IBOutlet var colorView: UIView!
    
    //CONTROLLER
    
    var isMyOrder: Bool = false
    var order: Order!
    var photos: [ImageSource] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        //SOME SHIT!!!!
        
        order.status = 0
        isMyOrder = true
        
        setData()
        setupTextView() //I should change it to UILable
        setupGradient()
        setupMyButton()
        setupHeightScrollView()
        setupPageControl()
        setupScrollView(imageSource: photos)
        updateLabelFrame()
        setupColorView()
        setViewsPosition()
        
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        designNavbar()
        updateLabelFrame()
        
    }
    
    @IBAction func actionSheet(sender: UIButton){
        
        if (isMyOrder){
            switch(order.status){
            case 0:
                myStatus0()
                break
            case 1:
                myStatus1()
                break
            case 2:
                myStatus2()
                break
            case 3:
                break
            default:
                myStatus4()
                break
            }
        }else{
            switch(order.status){
            case 0:
                status0()
                break
            case 1:
                status1()
                break
            case 2:
                status2()
                break
            case 3:
                break
            default:
                status4()
                break
            }
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/self.view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
    
    //ACTION
    
    @IBAction func back(){
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func showPerformers(){
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ChoosePerformer") as! ChoosePerformerViewController
        nextViewController.order = order
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    
    func editOrder(){
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "EditorViewController") as! EditorViewController
        nextViewController.order = order
        nextViewController.photos = photos
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    
    func deleteOrder(){
        
        let url = URL(string: way + "/order/remove/?id=" + String(self.order.id))
        URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print("error")
            }else{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                    let code = json["code"] as? Int

                    
                    if (code == 101){
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                }catch let error as NSError{
                    print(error)
                }
            }
        }).resume()
        
    }
    
    func getOrder(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy hh:mm"
        let dateTmp = formatter.string(from: NSDate() as Date)
        var request = URLRequest(url: URL(string: way + "/order/take")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameters = ["id": self.order.id, "executor": myId, "cost": self.order.cost, "date": dateTmp] as [String : Any]
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print("error")
            }else{
                do{
                    _ = try JSONSerialization.jsonObject(with: data!, options: []) as! [String : AnyObject]
                    OperationQueue.main.addOperation({
                        _ = self.navigationController?.popViewController(animated: true)
                    })
                }catch let error as NSError{
                    print(error)
                }
            }
        }).resume()
        
    }

    func getOrderWithOwnCost(){
        
        let alertController: UIAlertController = UIAlertController(title: "Предложи свою цену", message: "", preferredStyle: .alert)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
        
        }
        alertController.addAction(cancelAction)
        
        let nextAction: UIAlertAction = UIAlertAction(title: "Ok", style: .default) { action -> Void in
            let text = (alertController.textFields?.first)?.text
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy hh:mm"
            let dateTmp = formatter.string(from: NSDate() as Date)
            var request = URLRequest(url: URL(string: way + "/order/take")!)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let parameters = ["id": self.order.id, "executor": myId, "cost": Int(text!) ?? self.order.cost, "date": dateTmp] as [String : Any]
            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
            request.httpBody = httpBody
            URLSession.shared.dataTask(with: request, completionHandler: {
                (data, response, error) in
                if(error != nil){
                    print("error")
                }else{
                    do{
                        _ = try JSONSerialization.jsonObject(with: data!, options: []) as! [String : AnyObject]
                        OperationQueue.main.addOperation({
                            _ = self.navigationController?.popViewController(animated: true)
                        })
                    }catch let error as NSError{
                        print(error)
                    }
                }
            }).resume()
            
        }
        alertController.addAction(nextAction)
        
        alertController.addTextField { (textField) -> Void in
            textField.textColor = UIColor.black
        }

        self.present(alertController, animated: true, completion: nil)
    
    }

    func goToChat(){
        
    }

    func cancelOrder(){
        //Деньги переходят исполнителю
        //Заказ удаляется
    }

    func complain(){
        //Пожаловаться администратору, либо долго выполняет и просрочил все сроки, либо на некачественное выполнение
        //Если заказ просрочился, то нам должно приходить уведомление
    }

    func refuse(){
        //Деньги возвращаются клиенту, заказ переходит в новые, получет статус 0
    }

    func doneOrder(){
        //Заказ получает статус 2
    }

    func approve(){
        //Деньги переходят исполнителю, заказ получает статус 3 и переходит в историю
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
    
    //CONTROLLER
    
    func setData(){
        subject.text = "Методы и анализ проектных решений"
        type.text = types[order.type]
        startDate.text = order.startDate
        finishDate.text = order.finishDate
        cost.text = String(order.cost) + " ₽"
        /*if (order.customer.id == myId){
         isMyOrder = true
         }*/
    }
    
    func setupScrollView(imageSource: [ImageSource]){
        
        myScrollView.contentSize = CGSize(width: self.view.frame.width*CGFloat(photos.count), height: myScrollView.frame.height)
        myScrollView.isPagingEnabled = true
        
        for i in 0..<imageSource.count{
            
            let myImageView = UIImageView(frame: CGRect(x:self.view.frame.width*CGFloat(i), y: 0, width:self.view.frame.width, height:myScrollView.frame.height))
            myImageView.contentMode = .scaleAspectFill
            myImageView.clipsToBounds = true
            myImageView.setImage(fromSource: imageSource[i])
            myImageView.tag = i
            let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            myImageView.isUserInteractionEnabled = true
            myImageView.addGestureRecognizer(tap)
            myScrollView.addSubview(myImageView)
            
        }

    }
    
    func myStatus0(){
        let sheet = UIAlertController(title: "Выбери действие", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Посмотреть заявки", style: .default, handler: { _ in
            self.showPerformers()
        }))
        sheet.addAction(UIAlertAction(title: "Редактировать", style: .default, handler: { _ in
            self.editOrder()
        }))
        sheet.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { _ in
            self.editOrder()
        }))
        sheet.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { _ in
        }))
        present(sheet, animated: true, completion: nil)
    }
    
    func myStatus1(){
        let sheet = UIAlertController(title: "Выбери действие", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Перейти к чату", style: .default, handler: { _ in
            self.goToChat()
        }))
        sheet.addAction(UIAlertAction(title: "Редактировать", style: .default, handler: { _ in
            self.editOrder()
        }))
        sheet.addAction(UIAlertAction(title: "Пожаловаться", style: .default, handler: { _ in
            self.complain()
        }))
        sheet.addAction(UIAlertAction(title: "Отменить заказ", style: .destructive, handler: { _ in
            self.cancelOrder()
        }))
        sheet.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { _ in
        }))
        present(sheet, animated: true, completion: nil)
    }
    
    func myStatus2(){
        let sheet = UIAlertController(title: "Выбери действие", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Перейти к чату", style: .default, handler: { _ in
            self.goToChat()
        }))
        sheet.addAction(UIAlertAction(title: "Одобрить", style: .default, handler: { _ in
            self.approve()
        }))
        sheet.addAction(UIAlertAction(title: "Пожаловаться", style: .default, handler: { _ in
            self.complain()
        }))
        sheet.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { _ in
        }))
        present(sheet, animated: true, completion: nil)
    }
    
    func myStatus4(){
        let sheet = UIAlertController(title: "Выбери действие", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Перейти к чату", style: .default, handler: { _ in
            self.goToChat()
        }))
        sheet.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { _ in
        }))
        present(sheet, animated: true, completion: nil)
    }
    
    func status0(){
        let sheet = UIAlertController(title: "Выбери действие", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Взять заказ", style: .default, handler: { _ in
            self.getOrder()
        }))
        sheet.addAction(UIAlertAction(title: "Своя цена", style: .default, handler: { _ in
            self.getOrderWithOwnCost()
        }))
        sheet.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { _ in
        }))
        present(sheet, animated: true, completion: nil)
    }
    
    func status1(){
        let sheet = UIAlertController(title: "Выбери действие", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Перейти к чату", style: .default, handler: { _ in
            self.goToChat()
        }))
        sheet.addAction(UIAlertAction(title: "Отказаться", style: .default, handler: { _ in
            self.refuse()
        }))
        sheet.addAction(UIAlertAction(title: "Готово", style: .default, handler: { _ in
            self.doneOrder()
        }))
        sheet.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { _ in
        }))
        present(sheet, animated: true, completion: nil)
    }
    
    func status2(){
        let sheet = UIAlertController(title: "Выбери действие", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Перейти к чату", style: .default, handler: { _ in
            self.goToChat()
        }))
        sheet.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { _ in
        }))
        present(sheet, animated: true, completion: nil)
    }
    
    func status4(){
        let sheet = UIAlertController(title: "Выбери действие", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Перейти к чату", style: .default, handler: { _ in
            self.goToChat()
        }))
        sheet.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { _ in
        }))
        present(sheet, animated: true, completion: nil)
    }
    
    
    //DESIGN
    
    func designNavbar(){
        self.tabBarController?.tabBar.isHidden = true;
        self.navigationController?.navigationBar.layer.dropBottomBorder()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
    }
    
    func setupTextView(){
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5
        let attributes = [NSParagraphStyleAttributeName : style, NSFontAttributeName: UIFont(name: ".HelveticaNeueDeskInterface-Regular", size: 14)!]
        des.attributedText = NSAttributedString(string: order.des, attributes:attributes)
        des.textColor = UIColor(red: 158/255.0, green: 171/255.0, blue: 205/255.0, alpha: 1.0)
        let contentSize = self.des.sizeThatFits(self.des.bounds.size)
        var frame = self.des.frame
        frame.size.height = contentSize.height
        self.des.frame = frame
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
    
    func setupHeightScrollView(){
        heightScrollView.contentSize = CGSize(width: self.view.frame.width, height: des.frame.origin.y + des.frame.height + 20.0)
    }
    
    func setupPageControl(){
        pageControl.numberOfPages = photos.count
        pageControl.currentPage = 0
        pageControl.frame.size.width = CGFloat(24 * photos.count)
        pageControl.frame.origin.x = (self.view.frame.width - pageControl.frame.width)/2
        pageControl.layer.cornerRadius = 19
    }
    
    func setupColorView(){
        type.sizeToFit()
        colorView.frame.size.width = 10 + type.frame.size.width + 10
        colorView.layer.borderColor = UIColor(red: 100/255.0, green: 64/255.0, blue: 111/255.0, alpha: 1.0).cgColor
        colorView.layer.borderWidth = 0.5
        colorView.layer.cornerRadius = 4
    }
    
    func setViewsPosition(){
        colorView.frame.origin.y = subject.frame.origin.y + subject.frame.size.height + 10
        startDate.frame.origin.y = colorView.frame.origin.y + colorView.frame.size.height + 12
        startImg.frame.origin.y = startDate.frame.origin.y - 1
        finishDate.frame.origin.y = startDate.frame.origin.y
        finishImg.frame.origin.y = startDate.frame.origin.y
        des.frame.origin.y = startDate.frame.origin.y + startDate.frame.size.height + 20
    }
    
    func updateLabelFrame(){
        subject.numberOfLines = 10
        let maxSize = CGSize(width: 212, height: 100)
        let size = subject.sizeThatFits(maxSize)
        subject.frame = CGRect(origin: CGPoint(x: subject.frame.origin.x, y: subject.frame.origin.y), size: size)
    }


}
