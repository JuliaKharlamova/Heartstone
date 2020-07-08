//
//  DetailCardController.swift
//  Heartstone
//
//  Created by Юлия Харламова on 29.05.2020.
//  Copyright © 2020 Юлия Харламова. All rights reserved.
//

import UIKit
import AloeStackView

class DetailCardController: UIViewController {
    
    var model: Model? {
        didSet {
            if let urlStr = URL(string: model?.img ?? "") {
                cardImageView.sd_setImage(with: urlStr, placeholderImage: #imageLiteral(resourceName: "placeholderCard"), completed: nil)
            }
            
        }
    }
    
    let backgroundImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "searchBackgroundView"))
        iv.contentMode = .scaleAspectFill
        iv.alpha = 0.4
        iv.clipsToBounds = true
        return iv
    }()
    
    let cardImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
//        iv.heightAnchor.constraint(equalToConstant: 400).isActive = true
        return iv
    }()
    
    let aloeStack = AloeStackView()
    
    lazy var name = attributedLabel(parametrText: "Name", value: model?.name ?? "🤫")
    lazy var typeLabel = attributedLabel(parametrText: "Type", value: model?.type ?? "🥺 потеряли")
    lazy var cardSet = attributedLabel(parametrText: "Card Set", value: model?.cardSet ?? "🥺 потеряли")
    lazy var playerClass = attributedLabel(parametrText: "Player Class", value: model?.playerClass ?? "🥺 потеряли")
    lazy var faction = attributedLabel(parametrText: "Faction", value: model?.faction ?? "🥺 потеряли")
    lazy var rarity = attributedLabel(parametrText: "Rarity", value: model?.rarity ?? "🥺 потеряли")


    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        view.addSubview(backgroundImageView)
        backgroundImageView.fillSuperview()
        
        view.addSubview(cardImageView)
        
        cardImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: nil)
        cardImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(aloeStack)
        aloeStack.backgroundColor = .clear
        
        aloeStack.anchor(top: cardImageView.bottomAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 20, bottom: 0, right: 20))
        
        aloeStack.addRows([name, playerClass, typeLabel, cardSet, faction])
    }
    
    func attributedLabel(parametrText: String, value: String) -> UILabel {
        let label = UILabel()
        
        let attributedTitle = NSMutableAttributedString(string: "\(parametrText): ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .heavy), NSAttributedString.Key.foregroundColor: UIColor.white])
        
        
        attributedTitle.append(NSMutableAttributedString(string: " \(value)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: UIColor.white]))
        
        label.attributedText = attributedTitle
        label.numberOfLines = 0
        
        return label
    }

}
