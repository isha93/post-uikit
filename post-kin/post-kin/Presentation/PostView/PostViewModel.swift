//
//  PostViewModel.swift
//  post-kin
//
//  Created by isa nur fajar on 12/09/22.
//

import Foundation
import Combine

class PostViewModel {
    @Published var postData : PostModel = []
    @Published var usersData : UserModel = []
    @Published var isLoadMore : Bool = false
    @Published var loading : Bool = false
    @Published var userItem : UserData?
    @Published var isLoaded : Bool = false
    @Published var postUserData : PostUserModel = []
    
    let validationResult = PassthroughSubject<PostModel, Error>()

    var postItem : PostModelData?
    
    private var cancellable: AnyCancellable?
    
    private var postServices : PostClient
    
    var totalPages = 0
    var page : Int = 0
    
    var prefs = UserDefaults.standard
    
    init(postServices: PostClient = PostClient()) {
        self.postServices = postServices
    }
    
    func getPost() {
        self.loading = true
        
        cancellable = postServices.getFeed(.getPost(page: page))
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    self.getUsers()
                case .failure(_):
                    break
                }
            }, receiveValue: { item in
                self.postData.append(contentsOf: item)
                self.loading = false
                do {
                    try self.prefs.setObject(self.postData, forKey: "POST")
                }catch{
                    print(error)
                }
            })
    }
    
    func getUsers() {
        self.loading = true
        cancellable = postServices.getUser(.getUser)
            .sink(receiveCompletion: { _ in
                
            }, receiveValue: { users in
                self.usersData = users
                self.getMatchUser()
                self.matchingData()
                do {
                    try self.prefs.setObject(self.usersData, forKey: "USER")
                }catch{
                    print(error)
                }
                self.loading = false
            })
    }
    
    func loadMoreContent(currentItem item: PostModelData){
        let thresholdIndex = self.postData.last
        if thresholdIndex?.position == item.position {
            self.isLoadMore = true
            self.page += 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.getPost()
            }
        }
    }
    
    func getMatchUser(){
        guard let postItem = postItem else {
            return
        }
        for user in usersData where user.id == postItem.ownerID {
            let fullName = [user.firstName, user.lastName].joined(separator: " ")
            self.userItem = user
            self.postUserData.append(PostUserData(post: postItem, user: user, fullName: fullName))
            print(postUserData)
        }
    }
    
    
    func matchingData(){
        for user in usersData {
            for post in postData {
                if post.ownerID == user.id {
                    let fullName = [user.firstName, user.lastName].joined(separator: " ")
                    postUserData.append(PostUserData(post: post, user: user, fullName: fullName))
                }
            }
        }
    }
    
    func searchPost(searchText: String){
        let result = self.postUserData.filter({$0.fullName.contains(searchText) || $0.post.textContent.contains(searchText) })
        self.postUserData = result
    }
    
    func getMatchTags(){
        guard let postItem = postItem else {
            return
        }
        for (index, element)  in postItem.tagIDS.enumerated() where postItem.tagIDS[index] == usersData[index].id {
            print(element)
        }
    }
    
    func setupOfflineData(){
        do{
            self.usersData = try prefs.getObject(forKey: "USER", castTo: UserModel.self)
            self.postData = try prefs.getObject(forKey: "POST", castTo: PostModel.self)
            self.getMatchUser()
        }catch{
            print(error)
        }
    }
}
