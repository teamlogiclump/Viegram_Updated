//
//  hello.swift
//  Viegram
//
//  Created by Relinns on 01/06/17.
//  Copyright © 2017 Relinns. All rights reserved.
//

import UIKit
protocol del: class {
    func alert()
}


class hello: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setscreen()
    }
    
    
    weak var delegate: del?
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func setscreen(){
        
    }

    @IBAction func fgt(_ sender: UIButton) {
        
        self.delegate?.alert()
        
    }
}
