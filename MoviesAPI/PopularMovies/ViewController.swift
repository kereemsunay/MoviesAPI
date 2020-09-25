//
//  ViewController.swift
//  MoviesAPI
//
//  Created by Kerem on 10.08.2020.
//  Copyright © 2020 Kerem. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!{
        didSet{
            searchBar.delegate = self
            
        }
    }
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.register(UINib(nibName: Identifier.MoviesTableViewCell.rawValue, bundle: nil).self, forCellReuseIdentifier: Identifier.MoviesTableViewCell.rawValue)
            tableView.dataSource = self
            tableView.delegate = self
            self.tableView.keyboardDismissMode = .onDrag
        }
    }
    var movies : [Movies] = []{
        didSet {
            tableView.reloadData()
        }
    }
   
    private var currentPage = 1
    let network = Network()
    var fetchingMore = false
    var filteredMovies : [Movies]? = []
    var searchingFlag = false
    var favListArray:[Movies] = []
    var FavStore = DataStore()
    var selectedMovieID: Int = 0
    var indicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        favListArray =  FavStore.getFavMovies() ?? []
        self.tableView.reloadData()
        
    }
    

    func activityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        indicator.style = UIActivityIndicatorView.Style.large
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }
    
    func fetchMovies(){
        
        network.getPopularMovies(page: currentPage) { (result) in
            self.activityIndicator()
            self.indicator.startAnimating()
            self.indicator.backgroundColor = .clear
            switch result{
            case .success(let movies):
                self.indicator.stopAnimating()
                self.indicator.hidesWhenStopped = true
                    if let movie = movies.results{
                        self.movies.append(contentsOf: movie)
                    }
                    self.currentPage = self.currentPage + 1
                    print("currentPage",self.currentPage)
                
            case .failure(let error):
                self.indicator.stopAnimating()
                self.indicator.hidesWhenStopped = true
                self.alert(message: error.statusMessage, title: "Ooops!")
                    print("error",error)
                
            }
        }
        
    }
   func alert(message: String, title: String = "") {
     let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
     let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
     alertController.addAction(OKAction)
    let AgainAction = UIAlertAction(title: "Try Again", style: .cancel) { (UIAlertAction) in
        self.fetchMovies()
    }
    alertController.addAction(AgainAction)
     self.present(alertController, animated: true, completion: nil)
   }
    
    
}

extension ViewController:UITableViewDataSource, UISearchBarDelegate, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchingFlag{
            return filteredMovies?.count ?? 0
        }else{
            return movies.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.MoviesTableViewCell.rawValue, for: indexPath) as! MoviesTableViewCell
        
        cell.layer.borderWidth = 0.4
        cell.layer.borderColor = UIColor.red.cgColor
        if searchingFlag{
            cell.configure(data: filteredMovies?[indexPath.row])
        }else{
            cell.configure(data: movies[indexPath.row])
        }
        let data = movies[indexPath.row]
        
        if favListArray.contains(data) {
            cell.movieFavButton.setImage(UIImage(named: "like"), for: .normal)
        }else{
            cell.movieFavButton.setImage(UIImage(named: "dislike"), for: .normal)
        }
        
        cell.movieFavButton.tag = indexPath.row
        
        cell.movieFavButton.addTarget(self, action:#selector(favTapped(_:)) , for: .touchUpInside)
        
        return cell
    }
    
    @objc func favTapped(_ sender: UIButton){
        
        let data = movies[sender.tag]
        print("sender",sender.tag)
        
        if let index = favListArray.firstIndex(of: data){
            favListArray.remove(at: index)
            
        }else{
            
            favListArray.append(data)
        }
        
        tableView.reloadData()
        
        FavStore.setFavMovies(favListArray)
        
        
    }
    
    
  
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if !searchingFlag{
            let lastSectionIndex = tableView.numberOfSections - 1
            let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
            if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
                let spinner = UIActivityIndicatorView(style: .medium)
                spinner.startAnimating()
                spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
                
                self.tableView.tableFooterView = spinner
                self.tableView.tableFooterView?.isHidden = false
                fetchMovies()
            }
        }else{
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = searchingFlag ? filteredMovies?[indexPath.row].id : movies[indexPath.row].id
        print("index",index)
        let detailsVC = UIStoryboard(name: "Movies", bundle: nil).instantiateViewController(withIdentifier: Identifier.DetailVC.rawValue) as! DetailViewController
        detailsVC.chosenID = selectedItem ?? 0
        detailsVC.detailMovie = movies
        detailsVC.modalPresentationStyle = .automatic
        //navigationController?.showDetailViewController(detailsVC, sender: nil)
        self.present(detailsVC, animated: true, completion: nil)
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
          
          if searchText.isEmpty{
              searchingFlag = false
          }else{
              searchingFlag = true
              filteredMovies = movies.filter({ $0.title?.range(of: searchText, options: .caseInsensitive, locale: Locale.current) != nil })
          }
          tableView.reloadData()
          
      }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Stop doing the search stuff
        // and clear the text in the search bar
        searchBar.text = ""
        // Hide the cancel button
        self.view.endEditing(true)
        // You could also change the position, frame etc of the searchBar
    }
    
    
}

