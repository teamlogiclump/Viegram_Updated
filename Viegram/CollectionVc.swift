//
//  CollectionVc.swift
//  Viegram
//
//  Created by Avatar Singh on 2017-09-04.
//  Copyright © 2017 Relinns. All rights reserved.
//

import UIKit

protocol selectIconDelegates {
    func didSelectCollectionOncell(indexPath:IndexPath)
     func dismissView()
}

class CollectionVc: UIView {
    var delegates :selectIconDelegates?
    @IBOutlet weak var collectionView: UICollectionView!
    let iconsArr = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16"]
    var uiView:UIView?
    required init(coder aDecoder: NSCoder)  {
        super.init(coder: aDecoder)!
        
        
        self.setup()
    }
    override init(frame: CGRect)   {
        super.init(frame: frame)
        self.setup()
    }
    @IBAction func btnCrosstapped(_ sender: Any) {
        self.delegates?.dismissView()
        self.removeFromSuperview()
    }
    @IBAction func cancelTapped(_ sender: Any) {
        //self.removeFromSuperview()
    }
    func setup() {
        
        self.uiView = Bundle.main.loadNibNamed("CollectionView", owner: self, options: nil)?[0] as? UIView
        self.uiView?.frame = self.bounds
         self.collectionView!.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
            self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.addSubview(self.uiView!)
    }

}
extension CollectionVc:UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return iconsArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        
        cell.iconImage.image = UIImage(named:(iconsArr[indexPath.item]))
        
        return cell
        
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.removeFromSuperview()
        self.delegates?.didSelectCollectionOncell(indexPath: indexPath)
    }
}
