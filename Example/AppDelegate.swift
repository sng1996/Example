//
//  AppDelegate.swift
//  NoChat-Swift-Example
//
//  Copyright (c) 2016-present, little2s.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
//Надо сделать массив своих заказов для того, чтобы не отображать его в основной ленте

import UIKit
import Marshroute
import Paparazzo

var orders: [Order] = []
var sciences: [String] = ["Все области", "Математика", "Физика", "Химия", "Философия", "Экономика", "История"]
var types: [String] = ["Все типы", "Домашняя работа", "Контрольная работа", "Курсовой проект", "Дипломная работа"]
//var colors: [UIColor] = [UIColor(red: 252/255.0, green: 235/255.0, blue: 191/255.0, alpha: 1.0), UIColor(red: 246/255.0, green: 194/255.0, blue: 216/255.0, alpha: 1.0), UIColor(red: 123/255.0, green: 171/255.0, blue: 237/255.0, alpha: 1.0), UIColor(red: 173/255.0, green: 239/255.0, blue: 190/255.0, alpha: 1.0)]
var colors: [UIColor] = [UIColor(red: 255/255.0, green: 207/255.0, blue: 81/255.0, alpha: 1.0), UIColor(red: 255/255.0, green: 131/255.0, blue: 131/255.0, alpha: 1.0), UIColor(red: 30/255.0, green: 182/255.0, blue: 64/255.0, alpha: 1.0), UIColor(red: 84/255.0, green: 156/255.0, blue: 255/255.0, alpha: 1.0)]
//var gradientColors: [[CGColor]] = [[colors[0].cgColor, UIColor.white.cgColor], [colors[1].cgColor, UIColor.white.cgColor], [colors[2].cgColor, UIColor.white.cgColor], [colors[3].cgColor, UIColor.white.cgColor]]

var myId: Int = 0
//var way: String = "https://fast-basin-97049.herokuapp.com"
var way: String = "http://localhost:8080"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        return true
    }

}

