//
//  FeedViewController.swift
//  L-TECH
//
//  Created by Захар Бабкин on 22/05/2018.
//  Copyright © 2018 Захар Бабкин. All rights reserved.
//


import UIKit

final class FeedViewController: UIViewController {
    
    
    //MARK: Variabels
    
    private var feed = [FeedElement]()
    private var timer = Timer()
    
    
    //MARK: Outlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: View Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFeed()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        settingTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }
    
    
    //MARK: IBAction
    
    @IBAction func refreshBarButtonItemAction(_ sender: Any) {
        getFeed()
    }
    
    
    //MARK: Methods
    
    @objc private func getFeed() {
        activityIndicator.startAnimating()
        
        FeedNetworkManager.shared.getFeed { [weak self] (response, error) in
            if let error = error {
                self?.showAlert("Ошибка", message: error, titleAction: "Повторить", cancelAction: false, handler: { [weak self] (_) in
                    self?.getFeed()
                })
            } else if let feed = response {
                DispatchQueue.main.async {
                    self?.feed = feed
                    self?.tableView.isHidden = false
                    self?.tableView.reloadData()
                }
            }
            
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
            }
        }
    }
    
    private func settingTimer() {
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(getFeed), userInfo: nil, repeats: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "DetailFeedSeque",
            let detailFeedViewController = segue.destination as? DetailFeedViewController,
            let feedElement = sender as? FeedElement else {return}
        
        detailFeedViewController.feedElement = feedElement
    }

}


//MARK: UITableViewDelegate, UITableViewDataSource

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feed.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as? FeedTableViewCell {
            let feedElement = feed[indexPath.row]
            cell.configurate(feedElement)
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let feedElement = feed[indexPath.row]
        self.performSegue(withIdentifier: "DetailFeedSeque", sender: feedElement)
    }
}




