//
//  PostCellViewModel.swift
//  post-kin
//
//  Created by isa nur fajar on 12/09/22.
//

import Foundation

final class PostCellViewModel {
    @Published var fullName : String = ""
    @Published var user : UserData?
    @Published var item : PostModelData?
    
    init(user: UserData, item: PostModelData) {
        self.user = user
        self.item = item
        self.setUpBindings()
    }
    
    private func setUpBindings() {
        if let user = user {
            fullName = [user.firstName, user.lastName].joined(separator: " ")
        }
    }
}
