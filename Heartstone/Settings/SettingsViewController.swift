//
//  SettingsControllerViewController.swift
//  Heartstone
//
//  Created by Юлия Харламова on 19.05.2020.
//  Copyright © 2020 Юлия Харламова. All rights reserved.
//

import UIKit
import AloeStackView
import JGProgressHUD

class SettingsViewController: UIViewController {
    
    var settingsModelDataArray: SettingsModel? {
        didSet {
            parametrsButton.isEnabled = true
        }
    }
    
    var delegate: ViewController?
    
    lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        return button
    }()
    
    let backgroundImageView = UIImageView(image: #imageLiteral(resourceName: "settingsBackdroundView1"))
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Выбирай с умом, чтобы параметры подходили под карты, которые ты хочешь найти. (Иначе лови пустоту😁)"
        label.font = .boldSystemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let aloeStackView = AloeStackView()
    let healthStackView = ParametrStackView(textHeaderLabelText: "Health", sliderMaxValue: 15)
    let attackStackView = ParametrStackView(textHeaderLabelText: "Attack", sliderMaxValue: 15)
    let costStackView = ParametrStackView(textHeaderLabelText: "Cost", sliderMaxValue: 10)
        
    let pickerView = UIPickerView()
    
    let parametrsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Choose parametrs", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    let localeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Locale", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleChooseLocale), for: .touchUpInside)
        return button
    }()
    
    let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("List of all cards", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleSearch), for: .touchUpInside)
        return button
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        backgroundImageView.alpha = 0.4
        view.addSubview(backgroundImageView)
        backgroundImageView.fillSuperview()
        
        fetchData()
        title = "Settings"
        view.backgroundColor = .black
        
         let saveBt = UIBarButtonItem(customView: saveButton)
        navigationItem.setRightBarButton(saveBt, animated: false)
        
        aloeStackView.backgroundColor = .clear
        
        view.addSubview(aloeStackView)
        aloeStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        parametrsButton.setTitle("Parametrs", for: .normal)
        parametrsButton.addTarget(self, action: #selector(handleTapAlert), for: .touchUpInside)
        parametrsButton.isEnabled = false
        
        aloeStackView.addRows([headerLabel, healthStackView, attackStackView, costStackView, localeButton, parametrsButton, searchButton])
        
        delegate?.parametrs.components(separatedBy: "&").forEach({ (str) in
            let component = str.components(separatedBy: "=")
            if component[0] == healthStackView.headerLabel.text?.lowercased() {
                healthStackView.slider.value = Float(component[1]) ?? 0
                healthStackView.sliderValueLabel.text = "\(component[1])"
            }
            if component[0] == attackStackView.headerLabel.text?.lowercased() {
                attackStackView.slider.value = Float(component[1]) ?? 0
                attackStackView.sliderValueLabel.text = "\(component[1])"
            }
            if component[0] == costStackView.headerLabel.text?.lowercased() {
                costStackView.slider.value = Float(component[1]) ?? 0
                costStackView.sliderValueLabel.text = "\(component[1])"
            }
        })
        
        if let requairedParametrs = delegate?.requairedParameters.components(separatedBy: "/") {
            parametrsButton.setTitle("\(requairedParametrs[0].capitalized) (\(requairedParametrs[1].replacingOccurrences(of: "%2520", with: " ")))", for: .normal)
        }
        
        if let localeParametr = delegate?.localeParametrs.components(separatedBy: "="), localeParametr != [""] {
            localeButton.setTitle("\(localeParametr[0].capitalized): \(localeParametr[1].dropLast())", for: .normal)
        }
    }
    
    deinit {
        print("Screen deinit")
    }
    
    @objc fileprivate func handleSearch() {
        let searchController = SearchController()
        searchController.delegate = self
        navigationController?.pushViewController(searchController, animated: true)
    }
    
    @objc fileprivate func handleChooseLocale() {
        let localeAlert = UIAlertController(title: "Choose Locale", message: nil, preferredStyle: .actionSheet)
        let alertActions = settingsModelDataArray?.locales
        
        alertActions?.forEach({ (action) in
            let alertAction = UIAlertAction(title: "\(action)", style: .default) { (_) in
                self.localeButton.setTitle("Locale: \(action)", for: .normal)
                self.delegate?.localeParametrs = "locale=\(action)&"
            }
            localeAlert.addAction(alertAction)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            self.localeButton.setTitle("Locale", for: .normal)
            self.delegate?.localeParametrs = ""
        }
        localeAlert.addAction(cancelAction)
        
        present(localeAlert, animated: true, completion: nil)
    }
    
    @objc fileprivate func handleTapAlert() {
        let alertButton = UIAlertController(title: "Choose parametrs", message: nil, preferredStyle: .actionSheet)
        
        let parametrsActions = ["Classes", "Sets", "Standard", "Race", "Types", "Factions", "Qualities"]
        let actions = [settingsModelDataArray?.classes, settingsModelDataArray?.sets, settingsModelDataArray?.standard, settingsModelDataArray?.wild, settingsModelDataArray?.types, settingsModelDataArray?.factions, settingsModelDataArray?.qualities]
        
        parametrsActions.enumerated().forEach { ( index, name) in
            let alertAction = UIAlertAction(title: name, style: .default) { (alertAction) in
                let alert = UIAlertController(title: name, message: nil, preferredStyle: .actionSheet)
                actions[index]?.forEach({ (actionTitle) in
                    let action = UIAlertAction(title: actionTitle, style: .default) { (_) in
                        self.delegate?.requairedParameters = "\(name.lowercased())/\(actionTitle.replacingOccurrences(of: " ", with: "%2520"))"
                        self.parametrsButton.setTitle("\(name) (\(actionTitle))", for: .normal)
                    }
                    alert.addAction(action)
                    
                    
                })
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                    self.parametrsButton.setTitle("Choose parametrs", for: .normal)
                    self.delegate?.requairedParameters = "sets/Classic"
                })
                alert.addAction(cancel)
                
                self.present(alert, animated: true, completion: nil)
            }
            alertButton.addAction(alertAction)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            self.parametrsButton.setTitle("Choose parametrs", for: .normal)
            self.delegate?.requairedParameters = "sets/Classic"
        })
        
        alertButton.addAction(cancel)
        
        present(alertButton, animated: true, completion: nil)
    }
    
    func fetchData() {
        let urlString = "https://omgvamp-hearthstone-v1.p.rapidapi.com/info"

        guard let url = URL(string: urlString) else {return}
        var request = URLRequest(url: url)

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

                guard let code = (response as? HTTPURLResponse)?.statusCode, (200...299).contains(code) else {return}

                guard let data = data else {return}

                print("Succesfully fetch data", code)

                // ловить ошибки для try типов
                do {
                    let decodedData = try JSONDecoder().decode(SettingsModel.self, from: data)
                    self.settingsModelDataArray = decodedData

                } catch let err{
                    print("Failed to fetch JSON data:", err)
                    return
                }
                print("Successfully fetch all data")
                hud.dismiss()
            }
        }.resume()
    }
    
    fileprivate func sendParametrs() {
        var parametrs = ""
        
        
        if healthStackView.switchElement.isOn, let text = healthStackView.sliderValueLabel.text {
            parametrs.append("&health=\(text)")
        }
        if attackStackView.switchElement.isOn, let text = attackStackView.sliderValueLabel.text {
            parametrs.append("&attack=\(text)")
        }
        if costStackView.switchElement.isOn, let text = costStackView.sliderValueLabel.text {
            parametrs.append("&cost=\(text)")
        }
        
        
        delegate?.parametrs = parametrs
    }
    
    @objc fileprivate func handleSave() {
        sendParametrs()
        delegate?.fetchData()
        self.navigationController?.popViewController(animated: true)
    }
    
}
