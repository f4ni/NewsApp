//
//  FavoritesViewController.swift
//  newsapp
//
//  Created by f4ni on 4.05.2021.
//

import UIKit

class FavoritesViewController: UITableViewController {

    var mainVController: MainViewController!
    
    fileprivate let nTVCellId = "nTVCellId"
    
    var newsViewModel = [NewsViewModel]() {
        didSet{
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad() 

        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: nTVCellId)
        getFavNews()
    }
    
    func getFavNews() {
        if let data = LocalService.instance.getFavoriteNews(){
            newsViewModel = data
            self.tableView.reloadData()
            self.tableView.endUpdates()
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
        self.navigationController?.pushViewController(detailVC, animated: true)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let news = self.newsViewModel[indexPath.row]
            LocalService.instance.removeNewsFromFavorites(news: news)
            self.newsViewModel.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
}

