//
//  DetailViewController.swift
//  newsapp
//
//  Created by f4ni on 3.05.2021.
//

import UIKit
import Kingfisher
import SafariServices

class DetailViewController: UIViewController {
    
    var mainViewController: MainViewController!
    
    var news: NewsViewModel!
    {
        didSet{
     
            let placeholder =  #imageLiteral(resourceName: "ph.png")
            self.posterIV.kf.setImage(with: news.urlToImage, placeholder: placeholder, options: [.transition(.flipFromLeft(0.3))])
            self.titleLbl.text = news.description
            self.newsContTV.text = news.content
            self.authorLbl.text = news.author
            self.dateLbl.text = news.publishedAt

        }
    }
    
    
    
    let posterIV: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFill
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.masksToBounds = true
        return v
    }()
    
    
    var titleLbl: UILabel = {
      let l = UILabel()
        l.font = UIFont.boldSystemFont(ofSize: 20)
        l.translatesAutoresizingMaskIntoConstraints = false
        l.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        l.lineBreakMode = .byWordWrapping
        l.numberOfLines = 2
        
        return l
    }()
    

    var authorLbl: UILabel = {
      let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 16)
        l.translatesAutoresizingMaskIntoConstraints = false
        l.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        l.textAlignment = .left
        return l
    }()

    var dateLbl: UILabel = {
      let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 16)
        l.translatesAutoresizingMaskIntoConstraints = false
        l.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        l.textAlignment = .left
        return l
    }()


    var newsContTV: UITextView = {
       let v = UITextView()
        v.font = UIFont.systemFont(ofSize: 18)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var mainStackView: UIStackView = {
       let v = UIStackView()
        v.axis = .vertical
        v.translatesAutoresizingMaskIntoConstraints = false
        v.spacing = .pi
        return v
    }()
    
    var innerStackV: UIStackView = {
       let v = UIStackView()
        v.axis = .horizontal
        v.spacing = 10
        v.translatesAutoresizingMaskIntoConstraints = false
        v.alignment = .leading
        v.distribution = .fill
        return v
    }()
    
    lazy var goSourceBtn: UIButton = {
        let b = UIButton()
        b.setTitle("News Source", for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitleColor(.black, for: .normal)
        b.layer.borderWidth = 1
        b.layer.borderColor = UIColor.darkGray.cgColor
        return b
    }()
    
    override func viewDidLoad() {
        setupViews()

    }

    @objc func shareNews(){

        let actVC = UIActivityViewController(activityItems: [news.title, news.url, news.urlToImage ], applicationActivities: nil)
        actVC.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if !completed {
                // User canceled
                return
            }
         
        }

        self.present(actVC, animated: true, completion: nil)
    }
   
    @objc func likeNews(){
        
        LocalService.instance.addNewstoFavorites(news: news)
        self.mainViewController.favNVController.getFavNews()

    }
    
    func setupViews() {
        
        goSourceBtn.addTarget(self, action: #selector(openUrl), for: .touchUpInside)
        let shareBtn = UIBarButtonItem.init(barButtonSystemItem: .action, target: self, action: #selector(shareNews))
        let likeBtn = UIBarButtonItem(image: "🖤".image()?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(likeNews))
        self.navigationItem.rightBarButtonItems = [likeBtn, shareBtn]
                
        view.backgroundColor = .white
        
        self.view.addSubview(mainStackView)
        
        
        mainStackView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
               
        mainStackView.addArrangedSubview(posterIV)
        mainStackView.addArrangedSubview(titleLbl)
        mainStackView.addArrangedSubview(innerStackV)
        mainStackView.addArrangedSubview(newsContTV)
        mainStackView.addArrangedSubview(goSourceBtn)
        
        innerStackV.addArrangedSubview(authorLbl)
        let separator = UIView()
        separator.widthAnchor.constraint(equalToConstant: 1).isActive = true
        separator.backgroundColor = .black
        innerStackV.addArrangedSubview(separator)
        separator.heightAnchor.constraint(equalTo: innerStackV.heightAnchor, multiplier: 0.8).isActive = true
        innerStackV.addArrangedSubview(dateLbl)
        authorLbl.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        
        posterIV.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        posterIV.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        posterIV.heightAnchor.constraint(equalToConstant: 350).isActive = true
        
        
        titleLbl.topAnchor.constraint(equalTo: self.posterIV.bottomAnchor, constant: 16).isActive = true
        titleLbl.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        titleLbl.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        titleLbl.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        innerStackV.topAnchor.constraint(equalTo: self.titleLbl.bottomAnchor, constant: 16).isActive = true
        innerStackV.heightAnchor.constraint(equalToConstant: 18).isActive = true
        innerStackV.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        innerStackV.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true

        newsContTV.topAnchor.constraint(equalTo: self.innerStackV.bottomAnchor, constant: 16).isActive = true
        newsContTV.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        newsContTV.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true

        authorLbl.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 16).isActive = true
        
        goSourceBtn.leadingAnchor.constraint(equalTo: self.mainStackView.leadingAnchor, constant: 36).isActive = true
        goSourceBtn.trailingAnchor.constraint(equalTo: self.mainStackView.trailingAnchor, constant: -36).isActive = true
        goSourceBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        goSourceBtn.widthAnchor.constraint(equalToConstant: 100).isActive = true
        goSourceBtn.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -24).isActive = true
    }
    
    @objc func openUrl() {
        
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true

        let vc = SFSafariViewController(url: self.news.url!, configuration: config)
        self.present(vc, animated: true)
            
        
    }
    
}

