//
//  FavoritesTableViewController.swift
//  MoviesAPI
//
//  Created by Kerem on 17.08.2020.
//  Copyright © 2020 Kerem. All rights reserved.
//

import UIKit

class FavoritesTableViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var favTableView: UITableView!{
        didSet{
            favTableView.register(UINib(nibName: "FavoritesTableViewCell", bundle: nil).self, forCellReuseIdentifier: "FavoritesTableViewCell")
            self.favTableView.keyboardDismissMode = .onDrag
            self.favTableView.tableFooterView = UIView(frame: .zero)
        }
    }
    
    var favList:[Movies] = []{
        didSet {
            //favTableView.reloadData()
        }
    }
    var FavStore = DataStore()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        favList = FavStore.getFavMovies() ?? []
        self.favTableView.reloadData()
       
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         favList = FavStore.getFavMovies() ?? [ ]
               self.favTableView.reloadData()
       
    }

    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favList.count
        
    }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favTableView.dequeueReusableCell(withIdentifier: "FavoritesTableViewCell", for: indexPath) as! FavoritesTableViewCell
        cell.configureFavCell(data: favList[indexPath.row])

        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
        print("Deleted")
        
        //favTableView.reloadData()
        
        
        self.favList.remove(at: indexPath.row)
        FavStore.setFavMovies(favList)
        self.favTableView.deleteRows(at: [indexPath], with: .automatic)
      }
    }
    
}
