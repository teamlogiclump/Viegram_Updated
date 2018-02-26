//
//  FullImage.swift
//  PhotoSpot
//
//  Created by Avatar Singh on 2017-08-04.
//  Copyright © 2017 Avatar Singh. All rights reserved.
//

import UIKit

class FullImage: UIView,UIScrollViewDelegate {
  var uiView:UIView?
    @IBOutlet weak var scrollView: UIScrollView!
   
    @IBOutlet weak var imgView: UIImageView!

    @IBAction func cancelClicked(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView?{
        return imgView
    }
    required init(coder aDecoder: NSCoder)  {
        super.init(coder: aDecoder)!
        
        
        self.setup()
    }
    override init(frame: CGRect)   {
        super.init(frame: frame)
        self.setup()
    }
    func setup() {
        
        self.uiView = Bundle.main.loadNibNamed("FullImage", owner: self, options: nil)?[0] as? UIView
        self.uiView?.frame = self.bounds
       scrollView.minimumZoomScale = 1.0;
       scrollView.maximumZoomScale = 5.0;
        scrollView.delegate = self
        self.addSubview(self.uiView!)
    }
}
