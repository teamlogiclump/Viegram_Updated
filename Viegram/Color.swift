//
//  Color.swift
//  Viegram
//
//  Created by Avatar Singh on 2017-09-06.
//  Copyright © 2017 Relinns. All rights reserved.
//

import UIKit
protocol selectColor {
    func colorTapped(color:UIColor)
    func dismissView()
}
class Color: UIView ,colorDelegate{
    var delegates : selectColor?
    @IBOutlet weak var colorPicker: ColorPicker!
    var uiView:UIView?
    
    @IBOutlet weak var selectedColorview: UIView!
    
    @IBAction func cancelClicked(_ sender: Any) {
        self.delegates?.dismissView()
        self.removeFromSuperview()
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
        
        self.uiView = Bundle.main.loadNibNamed("ColorPicker", owner: self, options: nil)?[0] as? UIView
        self.uiView?.frame = self.bounds
       colorPicker.delegate = self
        self.addSubview(self.uiView!)
    }
    func pickedColor(color: UIColor) {
        selectedColorview.backgroundColor = color
        delegates?.colorTapped(color: color)
    }

    @IBAction func dismissViewAction(_ sender: UITapGestureRecognizer) {
        self.delegates?.dismissView()
        self.removeFromSuperview()
    }
}
