//
//  ViewController.swift
//  newsapp
//
//  Created by f4ni on 1.05.2021.
//

import UIKit


class MainViewController: UITableViewController, UISearchResultsUpdating {

    var favNVController: FavoritesViewController!
    
    fileprivate let nTVCellId = "nTVCellId"
    
    var page = 1
    
    var totalNews: Int!
    
    var newsViewModel = [NewsViewModel]() {
        didSet{
          
        }
    }
    
    let search = UISearchController(searchResultsController: nil)
    
    lazy var refreshC: UIRefreshControl = {
        let c = UIRefreshControl()
        
        
        
        return c
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "NewsApp"
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Type here to search news"
        navigationItem.searchController = search
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: nTVCellId)
        tableView.addSubview( self.refreshC )
        refreshC.addTarget(self, action: #selector(refreshHandle), for: .valueChanged)
    }
    
    @objc func refreshHandle() {
        self.page = 1
        refreshC.beginRefreshing()
        updateSearchResults(for: search)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let total = self.totalNews, !(total > self.page * 20) {
            return
        }
        guard let text = searchController.searchBar.text else { return }
        
        if text.count > 2 {
            APIService.instance.fetchNews(word: text, page: self.page) { (res) in
                switch res {
                
                case .success(let model):
                    DispatchQueue.main.async {
                        let nBundle = model as! NBundle
                        let news = nBundle.articles.map({return NewsViewModel(news: $0)})
                        self.page == 1 ? self.newsViewModel = news: self.newsViewModel.append(contentsOf: news)
                        
                        if !self.newsViewModel.isEmpty {
                            self.tableView.reloadData()
                            self.tableView.endUpdates()
                            
                            self.page += 1
                        }
                    }
       
                case .failure(_):
                    print("failure ")
                    break
                }
                self.refreshC.endRefreshing()

            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nTVCellId", for: indexPath) as! NewsTableViewCell
        
        let news = newsViewModel[indexPath.row]
        
        cell.news = news
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if !self.newsViewModel.isEmpty {
            count = self.newsViewModel.count
        }

        return count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let news = newsViewModel[indexPath.row]
            
        let detailVC = DetailViewController()
        detailVC.news = news
        detailVC.mainViewController = self
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == newsViewModel.count - 1 {
            self.updateSearchResults(for: self.search)
        }
    }
    

    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let news = newsViewModel[indexPath.row]
        let action = UIContextualAction(style: .normal,
                                        title: "⭐") { [weak self] (action, view, completionHandler) in
                                            LocalService.instance.addNewstoFavorites(news: news)
                                            completionHandler(true)
        }
        action.backgroundColor = .systemBlue
        return UISwipeActionsConfiguration(actions: [action])
    }
}

private extension UISearchBar {
    private func setBackgroundColorWithImage(color: UIColor) {
        let rect = self.bounds
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect);

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.backgroundImage = image // here!
    }
}
