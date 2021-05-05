//
//  NewsTableViewCell.swift
//  newsapp
//
//  Created by f4ni on 2.05.2021.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    var news: NewsViewModel?{
        didSet{
            guard let news = news else { return  }
            let placeholder = #imageLiteral(resourceName: "ph.png")
            self.textL.text = news.title
            self.detailTextL.text = news.description
            self.newsIV.kf.setImage(with: news.urlToImage, placeholder: placeholder, options: [.transition(.flipFromLeft(0.3))])
            self.newsIV.contentMode = .scaleAspectFit
            
          
        }
    }
    
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    func setupView(){
        
        setupIV()
        setupTL()
        setupDTL()
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }

    func setupTL() {
        self.addSubview(textL)
        textL.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        textL.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        textL.trailingAnchor.constraint(equalTo: self.newsIV.leadingAnchor, constant: -10).isActive = true
        //textL.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func setupDTL() {
        self.addSubview(detailTextL)
        detailTextL.topAnchor.constraint(equalTo: self.textL.bottomAnchor, constant: 10).isActive = true
        detailTextL.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        detailTextL.trailingAnchor.constraint(equalTo: self.newsIV.leadingAnchor, constant: -10).isActive = true
        detailTextL.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16).isActive = true
    }

    func setupIV() {
        self.addSubview(newsIV)
        newsIV.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        newsIV.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        newsIV.widthAnchor.constraint(equalToConstant: 100).isActive = true
        newsIV.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }

    let newsIV: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFit
        v.layer.cornerRadius = 5
        v.layer.masksToBounds = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    let textL: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.lineBreakMode = .byWordWrapping
        l.numberOfLines = 2
        l.font = UIFont.boldSystemFont(ofSize: 16)

        return l
    }()
    let detailTextL: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = l.font.withSize(14)
        l.lineBreakMode = .byWordWrapping
        l.numberOfLines = 2
        
        return l
    }()
}
