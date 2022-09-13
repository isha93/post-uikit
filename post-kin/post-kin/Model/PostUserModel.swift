//
//  PostUserModel.swift
//  post-kin
//
//  Created by isa nur fajar on 12/09/22.
//

import Foundation
struct PostUserData: Identifiable {
    var id = UUID()
    let post : PostModelData
    let user : UserData
    let fullName : String
}

typealias PostUserModel = [PostUserData]
