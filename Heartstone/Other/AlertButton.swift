//
//  AlertButton.swift
//  Heartstone
//
//  Created by Юлия Харламова on 20.05.2020.
//  Copyright © 2020 Юлия Харламова. All rights reserved.
//

import UIKit

class AlertButton: UIButton {

    let title: String
    let actions: [String]
    var delegate: ViewController?
    
    var vc: SettingsViewController?
    
    init(title: String, actions: [String]) {
        self.title = title
        self.actions = actions
        super.init(frame: .zero)
        
        self.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = .boldSystemFont(ofSize: 20)
        
        self.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
    }
    
    @objc fileprivate func handleTap() {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        
        actions.forEach { (name) in
            let alertAction = UIAlertAction(title: name, style: .default, handler: { _ in
                self.delegate?.requairedParameters = "\(self.title.lowercased())/\(name)"
                self.setTitle(name, for: .normal)
            })
            alertController.addAction(alertAction)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            self.setTitle(self.title, for: .normal)
            self.delegate?.requairedParameters = "sets/Classic"
        })
        alertController.addAction(cancel)
        
        vc?.present(alertController, animated: true, completion: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
