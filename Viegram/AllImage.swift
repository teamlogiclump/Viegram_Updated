//
//  AllImage.swift
//  Viegram
//
//  Created by Avatar Singh on 2017-09-12.
//  Copyright © 2017 Relinns. All rights reserved.
//

import UIKit
protocol editPhotodelegates {
    func  editPhoto(index:Int , imageArr : [UIImage],imageArrIDs: [String],view: AllImage,view1: PhotoIcon)
    
    func  addPhotos(index:Int , imageArr : [UIImage],imageArrIDs: [String],view: AllImage,view1: PhotoIcon)
}

class AllImage: UIView {
     var uiView:UIView?
     var imageArr = [UIImage]()
     var imageArrIDs = [String]()
      var currentIndex = Int()
    var viewTapped: PhotoIcon?
    var delegates : editPhotodelegates?
    @IBOutlet var view: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    init(frame: CGRect,imgArr: [UIImage],imgIds : [String] ,view1 : PhotoIcon) {
        
        super.init(frame: frame)
        imageArrIDs = imgIds
        imageArr = imgArr
         viewTapped = view1
        self.setup()
    }
    required init(coder aDecoder: NSCoder)  {
        super.init(coder: aDecoder)!
        
    }
    
    func setup() {
        
        self.view = Bundle.main.loadNibNamed("AllImage", owner: self, options: nil)?[0] as? UIView
        self.view?.frame = self.bounds
        self.scrollViewWithImages()
        self.addSubview(self.view)
    }
    
    @IBAction func btnBackTapped(_ sender: Any) {
        self.removeFromSuperview()
    }

    func scrollViewWithImages(){
        for i in 0..<imageArr.count {
            
         let xOrigin = CGFloat(i) * self.view.frame.size.width
            
            let imageView = UIImageView.init(frame: CGRect(x: xOrigin, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - 64))
            
            imageView.image = imageArr[i]
            scrollView.addSubview(imageView)
            
            
        }
        scrollView.contentSize = CGSize.init(width: self.view.frame.size.width * CGFloat(imageArr.count), height: self.view.frame.size.height - 64)
        
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let indexOfPage = scrollView.contentOffset.x / scrollView.frame.size.width
        currentIndex = Int(indexOfPage)
        
    }
    
    
    @IBAction func btnRemoveImage(_ sender: Any) {
        delegates?.editPhoto(index: currentIndex, imageArr: imageArr, imageArrIDs: imageArrIDs, view: self, view1: viewTapped!)
    }
    @IBAction func btnAddImage(_ sender: Any) {
        delegates?.addPhotos(index: currentIndex, imageArr: imageArr, imageArrIDs: imageArrIDs, view: self, view1: viewTapped!)
    }

}
