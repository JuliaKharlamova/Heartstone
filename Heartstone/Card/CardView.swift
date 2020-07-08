//
//  CardsView.swift
//  Heartstone
//
//  Created by Юлия Харламова on 18.05.2020.
//  Copyright © 2020 Юлия Харламова. All rights reserved.
//

import UIKit
import SDWebImage

class CardView: UIView {
    
    fileprivate let distance: CGFloat = 80
    
    fileprivate let flavorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    var nextCard: CardView?
    
    init(cardModel: Model) {
        super.init(frame: .zero)
        backgroundColor = .clear
        
        
        let imageView = UIImageView()
        if let url = URL(string: cardModel.img ?? "") {
            imageView.contentMode = .scaleAspectFit
            imageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholderCard"), options: .delayPlaceholder, completed: nil)
            
            
            flavorLabel.text = cardModel.flavor ?? ""

        }
        addSubview(imageView)
//        imageView.backgroundColor = .red
        imageView.heightAnchor.constraint(equalToConstant: 500).isActive = true
        imageView.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 20, left: 0, bottom: 0, right: 0))
        imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true

        addSubview(flavorLabel)
        flavorLabel.anchor(top: imageView.bottomAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: nil, padding: .init(top: 10, left: 20, bottom: 0, right: 20))
        flavorLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true

        
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
        
        
    }
    
    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            superview?.subviews.forEach({ (subview) in
                subview.layer.removeAllAnimations()
            })
        case .changed:
            handleChanged(gesture)
        case .ended:
            print()
            handleEnded(gesture)
        default:
            print()
        }
    }
    
    fileprivate func handleChanged(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: nil)
        
        let degrees: CGFloat = translation.x / 20
        let angle = degrees * .pi / 180
        
        self.transform = CGAffineTransform(translationX: translation.x, y: translation.y).rotated(by: angle)
    }
    
    fileprivate func handleEnded(_ gesture: UIPanGestureRecognizer) {
        let translationDirection: CGFloat = gesture.translation(in: nil).x > 0 ? 1 : -1
        let shouldDismissCard = abs(gesture.translation(in: nil).x) > distance
        let endPositionX = self.frame.width * 1.5 * translationDirection
        
        if shouldDismissCard {
            UIView.animate(withDuration: 0.3, animations: {
                    self.transform = .init(translationX: endPositionX, y: 0)
                self.nextCard?.alpha = 1
                }) { (_) in
                    self.removeFromSuperview()
                }
            } else {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                self.transform = .identity
                
            })
            
        }
    }


    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
