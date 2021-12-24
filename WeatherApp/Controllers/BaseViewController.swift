//
//  BaseViewController.swift
//WeatherApp
//
//  Created by Mithun on 09/04/20.
//  Copyright © 2020 Mithun. All rights reserved.


import UIKit

class BaseViewController: UIViewController {
    var loader = UIActivityIndicatorView(style: .whiteLarge)
    var loaderView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        loaderView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        
        loaderView.addSubview(loader)
        
        // Do any additional setup after loading the view.
    }
    

    func showLoader(){
        self.view.endEditing(true)
        self.loaderView.frame = UIScreen.main.bounds
        loader.center         = loaderView.center
        loader.startAnimating()
        self.navigationController?.view.addSubview(loaderView)
    }
    func hideLoader(){
        self.loader.stopAnimating()
        self.loaderView.removeFromSuperview()
    }
}
