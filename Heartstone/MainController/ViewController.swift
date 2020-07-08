//
//  ViewController.swift
//  Heartstone
//
//  Created by Юлия Харламова on 18.05.2020.
//  Copyright © 2020 Юлия Харламова. All rights reserved.
//

import UIKit
import JGProgressHUD
import AVFoundation

class ViewController: UIViewController {
    
    var player: AVAudioPlayer?
    
    var modelDataArray: [Model]? {
        didSet {
            view.subviews.forEach({ v in
                if v is CardView {
                    v.removeFromSuperview()
                }
            })
            
            var lastCard: CardView?
            
            self.modelDataArray?.filter({ (model) -> Bool in
                return model.img != nil
            }).forEach { (model) in
                
                let card = CardView(cardModel: model)
                lastCard?.alpha = 0
                card.nextCard = lastCard
                lastCard = card
                view.addSubview(lastCard!)
                lastCard?.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
            }
        }
    }
    
    let backgroundView = UIImageView(image: #imageLiteral(resourceName: "backgroundImage"))
    
    var parametrs = ""
    var localeParametrs = ""
        
    let heartstoneLogoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "Hearthstone_logo")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    lazy var refreshButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "refreshButton"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        return button
    }()
    
    lazy var settingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "settingsButton"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MusicHelper.sharedHelper.playBackgroundMusic()
        
        backgroundView.contentMode = .scaleAspectFill
        backgroundView.alpha = 0.4
        view.addSubview(backgroundView)
        backgroundView.fillSuperview()
        
        fetchData()
        
        navigationItem.titleView = heartstoneLogoImageView
        let refreshBt = UIBarButtonItem(customView: refreshButton)
        let settingsBt = UIBarButtonItem(customView: settingsButton)
        navigationItem.setLeftBarButton(refreshBt, animated: false)
        navigationItem.setRightBarButton(settingsBt, animated: false)
    }
    
    var requairedParameters = "sets/Classic"
     func fetchData() {
        let urlString = "https://omgvamp-hearthstone-v1.p.rapidapi.com/cards/\(requairedParameters)?\(localeParametrs)collectible=1\(parametrs)"

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
                    
                    hud.textLabel.text = "Данные отсутствуют"
                    hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    hud.show(in: self.view)
                    self.modelDataArray = []
                    hud.dismiss(afterDelay: 2)
                    
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
                hud.dismiss()
            }
            }.resume()
    }
    
    @objc fileprivate func handleRefresh() {
        fetchData()
    }
    
    @objc fileprivate func handleSettings() {
        let settingsController = SettingsViewController()
        settingsController.delegate = self
        navigationController?.pushViewController(settingsController, animated: true)
    }
}

