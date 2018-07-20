

//
//  AvatorVC.swift
//  smack
//
//  Created by HeinHtet on 7/15/18.
//  Copyright © 2018 HeinHtet. All rights reserved.
//

import UIKit

class AvatorVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    var avatarType = AvatarType.dark
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 16, left: 5, bottom: 16, right: 5)
//        layout.minimumInteritemSpacing = 0
//        layout.minimumLineSpacing = 10
//        collectionView!.collectionViewLayout = layout
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if avatarType == .dark{
            UserDataServices.instance.setAvatarName(name: "dark\(indexPath.item)")
        }else{
            UserDataServices.instance.setAvatarName(name: "light\(indexPath.item)")
        }
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 28
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "avatarCell", for: indexPath) as? AvatarCell{
            cell.updateCell(type: avatarType, index: indexPath.item)
            return cell
        }else{
            return AvatarCell()
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var numOfColmuns : CGFloat = 3
        if view.frame.size.width > 320{
            numOfColmuns = 4
        }
        let spaceBetweenCells : CGFloat = 10
        let padding : CGFloat = 40
        let cellDimension = ((collectionView.bounds.width - padding) - (numOfColmuns - 1 ) * spaceBetweenCells) / numOfColmuns 
        return CGSize(width: cellDimension, height: cellDimension)
//        return CGSize(width: CGFloat((collectionView.frame.size.width / 3) - 20), height: CGFloat(100))
    }

    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var controll: UISegmentedControl!
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        if controll.selectedSegmentIndex == 0 {
            self.avatarType = AvatarType.dark
        }else{
            self.avatarType = AvatarType.light
        }
        collectionView.reloadData()
    }
    
    
    
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
