//
//  ProfileViewController.swift
//  Smart-as
//
//  Created by Сергей Гаврилко on 05.08.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var tableView1: UITableView!
    @IBOutlet var tableView2: UITableView!
    @IBOutlet var tableView3: UITableView!
    @IBOutlet var tableView4: UITableView!
    
    var pageIndex:Int = 0
    
    
    var tableViews: [UITableView] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self
        createSlides()
        setupScrollView(slides: tableViews)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return 3
    }
    
    public func tableView(_ tableView:UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OrderTableViewCell
       
        return cell
    }
    
    func createSlides(){
        
        tableViews.append(tableView1)
        tableViews.append(tableView2)
        tableViews.append(tableView3)
        tableViews.append(tableView4)
        
    }
    
    func setupScrollView(slides: [UITableView]){
        
        scrollView.contentSize = CGSize(width: view.frame.width * 4.0, height: scrollView.frame.size.height)
        scrollView.isPagingEnabled = true
        
        for i in 0..<4{
            tableViews[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height)
            scrollView.addSubview(tableViews[i])
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        pageIndex = Int(round(scrollView.contentOffset.x/view.frame.width))
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
