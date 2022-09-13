//
//  PostDetailViewModel.swift
//  post-kin
//
//  Created by isa nur fajar on 13/09/22.
//

import Foundation

final class PostDetailViewModel {
    @Published var fullName : String = ""
    @Published var user : UserData?
    @Published var item : PostModelData?
    @Published var tagsUser : [String] = []
    
    var prefs = UserDefaults.standard
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
    
    func getMatchTags(){
        guard let postItem = item else {
            return
        }
        do {
            let allUser : UserModel = try prefs.getObject(forKey: "USER", castTo: UserModel.self)
            for tags in postItem.tagIDS{
                for user in allUser where tags == user.id{
                    self.tagsUser.append(user.firstName)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
