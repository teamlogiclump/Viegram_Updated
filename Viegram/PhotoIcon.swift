//
//  PhotoIcon.swift
//  Viegram
//
//  Created by Avatar Singh on 2017-09-12.
//  Copyright © 2017 Relinns. All rights reserved.
//

import UIKit
protocol showfullImagesdelegates {
    func showallfullImages(imageArr:[UIImage] ,view : PhotoIcon)
}
class PhotoIcon: UIView {
    @IBOutlet weak var imgViewRight: UIImageView!
     @IBOutlet weak var imgViewLeft: UIImageView!
     var uiView:UIView?
      var imageArr = [UIImage]()
    
    @IBOutlet weak var btnCount: UIButton!
    
    @IBOutlet weak var width: NSLayoutConstraint!
    
    var  delegates : showfullImagesdelegates?
    required init(coder aDecoder: NSCoder)  {
        super.init(coder: aDecoder)!
        
        
        self.setup()
    }
    override init(frame: CGRect)   {
        super.init(frame: frame)
        self.setup()
    }
    func setup() {
        
        self.uiView = Bundle.main.loadNibNamed("PhotoIcon", owner: self, options: nil)?[0] as? UIView
        self.uiView?.frame = self.bounds
        self.btnCount.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.1)
        self.addSubview(self.uiView!)
    }
    @IBAction func btnAllImagetapped(_ sender: UIButton) {
        print(sender.tag)
        delegates?.showallfullImages(imageArr: imageArr, view: self)
    }

    func setupframe(){
        print(imageArr.count)
        
        if imageArr.count == 1 {
            width.constant = 50
            imgViewLeft.image = imageArr[0]
            btnCount.setTitle("", for: .normal)
            self.layoutIfNeeded()
            
        }
        else if  imageArr.count == 2{
            width.constant = 25
           btnCount.setTitle("", for: .normal)
            imgViewLeft.image = imageArr[0]
            imgViewRight.image = imageArr[1]
        self.layoutIfNeeded()
        }
        else{
            width.constant = 25
            imgViewLeft.image = imageArr[0]
            imgViewRight.image = imageArr[1]
            btnCount.setTitle("+\(imageArr.count - 2)", for: .normal)
            self.layoutIfNeeded()
           
        }
    }
}
