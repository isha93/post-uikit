//
//  PostViewController.swift
//  post-kin
//
//  Created by isa nur fajar on 09/09/22.
//

import UIKit
import Combine

class PostViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var postVM : PostViewModel = PostViewModel()
    private var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.setupBinding()
        self.postVM.getPost()
        // Do any additional setup after loading the view.
    }
    
    private func setupTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchBar.delegate = self
        self.tableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "PostTableViewCell")
    }
    
    private func setupBinding() {
        postVM.$postData
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] item in
                print(item)
                self?.tableView.reloadData()
            })
            .store(in: &subscriptions)
        postVM.$usersData
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .store(in: &subscriptions)
        
        postVM.$postUserData
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] item in
                print(item)
                self?.tableView.reloadData()
            })
        .store(in: &subscriptions)    }
    
}

extension PostViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postVM.postUserData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == postVM.postUserData.count - 1 {
            postVM.loadMoreContent(currentItem: postVM.postUserData[indexPath.row].post)
        }
        if let cell : PostTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell") as? PostTableViewCell {
            let row = indexPath.row
            postVM.postItem = postVM.postUserData[row].post
            postVM.userItem = postVM.postUserData[row].user
            cell.postCellVM = PostCellViewModel(user: postVM.postUserData[row].user, item: postVM.postUserData[row].post)
            return cell
        }
        return UITableViewCell()
    }
}

extension PostViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = PostDetailViewController(nibName: "PostDetailViewController", bundle: nil)
        detail.postDetailVM = PostDetailViewModel(user: postVM.postUserData[indexPath.row].user, item: postVM.postUserData[indexPath.row].post)
        self.present(detail, animated: true)
    }
}


extension PostViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        if searchText == "" {
            postVM.getPost()
        }else{
            postVM.searchPost(searchText: searchBar.text ?? "")
        }
    }
}
