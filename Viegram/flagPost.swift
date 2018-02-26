//
//  flagPost.swift
//  Viegram
//
//  Created by Apple on 11/18/17.
//  Copyright © 2017 Relinns. All rights reserved.
//

import UIKit

protocol flagPostDelegate: class {
    func flagSuccessAction(view: flagPost, postId: String, index: IndexPath) -> Void
    }
class flagPost: UIView {
    var postId: String = ""
    var indexPath = IndexPath()
    weak var delegate : flagPostDelegate?
    @IBOutlet var view: UIView!
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var successBtn: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    init(frame: CGRect,postId:String, index: IndexPath,messageTitle:String,successTitle:String,image:String) {
        super.init(frame: frame)
        self.setUpScreen(postId:postId, index: index,messageTitle:messageTitle,successTitle:successTitle,image:image)
        
    }
    func setUpScreen(postId:String, index: IndexPath,messageTitle:String,successTitle:String,image:String){
        
        self.view = Bundle.main.loadNibNamed("flagPost", owner: self, options: nil)?[0] as? UIView
        self.view.frame = self.bounds
        self.postId = postId
         self.indexPath = index
        self.statusImage.image = UIImage.init(named: image)
        self.lblTitle.text = messageTitle
        self.successBtn.setTitle(successTitle, for: .normal)
        //add code for the view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapgesture(sender:)))
        self.view.addGestureRecognizer(tapGesture)
        self.addSubview(self.view)
    }
    @IBAction func cancelAction(_ sender: Any) {
        self.removeFromSuperview()
    }

    func tapgesture(sender:UITapGestureRecognizer){
        self.removeFromSuperview()
    }
    @IBAction func reportAction(_ sender: Any) {
        print(postId)
      self.delegate?.flagSuccessAction(view: self, postId: self.postId, index: self.indexPath)
    }
    
}
