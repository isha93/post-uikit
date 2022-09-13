//
//  PostDetailViewController.swift
//  post-kin
//
//  Created by isa nur fajar on 13/09/22.
//

import UIKit

class PostDetailViewController: UIViewController {
    
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var imgContent: UIImageView!
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    var postDetailVM: PostDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpViewModel()
        self.setupCollection()
        print("helo")
        // Do any additional setup after loading the view.
    }
    
    private func setupCollection(){
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName:"TagsViewCell", bundle: nil), forCellWithReuseIdentifier: "TagsViewCell")
        self.postDetailVM.getMatchTags()
    }
    
    private func setUpViewModel(){
        guard let vm = postDetailVM else { return }
        lblFullName.text = vm.fullName
        lblDesc.text = vm.item?.textContent
        lblDate.text = vm.item?.createdDate
        imgProfile.kf.setImage(with: URL(string: vm.user?.profileImagePath ?? ""))
        imgContent.kf.setImage(with: URL(string: vm.item?.mediaContentPath ?? ""))
    }
    
}

extension PostDetailViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.postDetailVM.tagsUser.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagsViewCell", for: indexPath) as! TagsViewCell
        cell.lblTag.text = postDetailVM.tagsUser[indexPath.row]
        return cell
    }
    
    
}


extension PostDetailViewController : UICollectionViewDelegate {
    
}
