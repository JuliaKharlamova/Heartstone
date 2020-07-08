//
//  SearchControllerTableViewController.swift
//  Heartstone
//
//  Created by Юлия Харламова on 26.05.2020.
//  Copyright © 2020 Юлия Харламова. All rights reserved.
//

import UIKit
import SDWebImage
import JGProgressHUD

class SearchController: UITableViewController {
    
    let cellId = "cellId"
    var requairedParameters = "sets/Classic"
    var parametrs = ""
    var localeParametrs = ""
    
    var modelDataArray: [Model]?

    var delegate: SettingsViewController?
    
    let img: UIImage = {
        let image = #imageLiteral(resourceName: "place")
        image.resizableImage(withCapInsets: .init(top: 10, left: 5, bottom: 10, right: 5), resizingMode: .stretch)
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        title = "Search"
        
        tableView.register(SearchCardCell.self, forCellReuseIdentifier: cellId)
        tableView.dataSource = self
        tableView.delegate = self
        searchController.searchResultsUpdater = self
        fetchData()
    }
    
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(modelDataArray?.count ?? 0)
        return modelDataArray?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SearchCardCell
        let model = modelDataArray?[indexPath.row]
        cell.cardLabel.text = model?.name
        if let urlString = URL(string: model?.img ?? "") {
            cell.cardImageView.sd_setImage(with: urlString, placeholderImage: #imageLiteral(resourceName: "place"))
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailCardController = DetailCardController()
//        navController.modalPresentationStyle = .fullScreen
        
        detailCardController.model = modelDataArray?[indexPath.row]
        
        navigationController?.pushViewController(detailCardController, animated: true)
    }
    
    func fetchData(searchText: String? = nil) {
        
        var urlString = ""
        
        if let text = searchText  {
             urlString = "https://omgvamp-hearthstone-v1.p.rapidapi.com/cards/search/\(text)"
           
        } else if searchText == "" || searchText == nil {
            urlString = "https://omgvamp-hearthstone-v1.p.rapidapi.com/cards/\(requairedParameters)?\(localeParametrs)collectible=1\(parametrs)"
        }

        guard let url = URL(string: urlString) else {return}
        var request = URLRequest(url: url)
        print("URL-------------", urlString)
        
        let hud = JGProgressHUD(style: .dark)
        hud.show(in: view)
        
        request.addValue("omgvamp-hearthstone-v1.p.rapidapi.com", forHTTPHeaderField: "X-RapidAPI-Host")
        request.addValue("48f94c2caemsh61e42ba73e1a9c2p16f913jsnbc83cb0bf1f2", forHTTPHeaderField: "x-rapidapi-key")
        
        URLSession.shared.dataTask(with: request) { (data, response, err) in
            DispatchQueue.main.async {
                
                if let err = err {
                    print("Failed to fetch data:", err)
                    return
                }
                
                guard let code = (response as? HTTPURLResponse)?.statusCode, (200...299).contains(code) else {
                    
                    hud.textLabel.text = "Wrong Name"
                    hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    hud.show(in: self.view)
                    hud.dismiss(afterDelay: 2)
                    self.modelDataArray = []
                    self.tableView.reloadData()
                    return}
                
                guard let data = data else {return}
                
                print("Succesfully fetch data", code)
                
                // ловить ошибки для try типов
                do {
                    let decodedData = try JSONDecoder().decode([Model].self, from: data)
                    self.modelDataArray = decodedData
                    
                } catch let err{
                    print("Failed to fetch JSON data:", err)
                    return
                }
                print("Successfully fetch all data")
                self.tableView.reloadData()
                hud.dismiss()
            }
            }.resume()
        
    }
    var dispatchItem: DispatchWorkItem?
}

extension SearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        dispatchItem?.cancel()
        dispatchItem = DispatchWorkItem(block: {
            if searchController.searchBar.text == "" || searchController.searchBar.text == nil {
                self.fetchData(searchText: nil)
            } else {
                self.fetchData(searchText: searchController.searchBar.text)
            }
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: dispatchItem!)
//        fetchData(searchText: searchController.searchBar.text)
    }
}
