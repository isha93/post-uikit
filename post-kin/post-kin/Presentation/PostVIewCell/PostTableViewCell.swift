//
//  PostTableViewCell.swift
//  post-kin
//
//  Created by isa nur fajar on 09/09/22.
//

import UIKit
import Kingfisher

class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    
    var postCellVM: PostCellViewModel! {
        didSet { setUpViewModel() }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setUpViewModel(){
        lblName.text = postCellVM.fullName
        lblDesc.text = postCellVM.item?.textContent
        lblDate.text = postCellVM.item?.createdDate
        imgProfile.kf.setImage(with: URL(string: postCellVM.item?.mediaContentPath ?? ""))
    }
    
}
