//
//  menu.swift
//  Viegram
//
//  Created by Relinns on 11/07/17.
//  Copyright © 2017 Relinns. All rights reserved.
//

import UIKit

class menu: UIView {

    @IBOutlet var view: UIView!
    
    required init(coder aDecoder: NSCoder)  {
        super.init(coder: aDecoder)!
        self.setup()
    }
    
    override init(frame: CGRect)   {
        super.init(frame: frame)
        self.setup()
    }
    
    func setup() {
        self.view = Bundle.main.loadNibNamed("menu", owner: self, options: nil)?[0] as? UIView
        self.view?.frame = self.bounds
        
        self.addSubview(self.view!)
    }
        
}
