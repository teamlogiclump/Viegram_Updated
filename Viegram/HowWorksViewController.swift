//
//  HowWorksViewController.swift
//  Viegram
//
//  Created by Relinns on 05/06/17.
//  Copyright © 2017 Relinns. All rights reserved.
//

import UIKit

class HowWorksViewController: UIViewController {
    let loader = UIActivityIndicatorView()
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var webview: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "imgMenuBar"), for: .default)
        // Do any additional setup after loading the view.
        
        //without adding the view
        
        self.navigationBar.layer.masksToBounds = false
        self.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navigationBar.layer.shadowOpacity = 0.3
        self.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.navigationBar.layer.shadowRadius = 2.5
        self.webview.delegate = self
        // Do any additional setup after loading the view.
        
         loadHtmlFile()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        addLoader()
    }
    func addLoader(){
        
        self.loader.center = self.webview.center
        self.loader.startAnimating()
        self.loader.activityIndicatorViewStyle = .gray
        self.loader.hidesWhenStopped = true
        self.view.addSubview(self.loader)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        _=self.navigationController?.popViewController(animated: true)
    }
    func loadHtmlFile() {
        
        let url = URL(string: howitworks)!
        let request = URLRequest(url: url)
        webview.loadRequest(request)
    }
   
}
extension HowWorksViewController:UIWebViewDelegate{
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.loader.stopAnimating()
    }
}
