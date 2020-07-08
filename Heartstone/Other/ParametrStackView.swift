//
//  ParametrStackView.swift
//  Heartstone
//
//  Created by Юлия Харламова on 20.05.2020.
//  Copyright © 2020 Юлия Харламова. All rights reserved.
//

import UIKit

class ParametrStackView: UIStackView {
    
    let url = "https://omgvamp-hearthstone-v1.p.rapidapi.com/cards/sets/Classic?collectible=1"
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    let sliderValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    let slider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 1
        return slider
    }()
    
    let switchElement = UISwitch()

    
    init(textHeaderLabelText: String, sliderMaxValue: Float) {
        super.init(frame: .zero)
        
        headerLabel.text = textHeaderLabelText
        slider.maximumValue = sliderMaxValue
        sliderValueLabel.text = ""
        sliderValueLabel.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        switchElement.isOn = false
        sliderValueLabel.isEnabled = false
        slider.isEnabled = false
        
        switchElement.addTarget(self, action: #selector(handleHidden(sender: )), for: .valueChanged)
        
        slider.addTarget(self, action: #selector(handleValue(slider: )), for: .valueChanged)

        let horizontalStackView = UIStackView(arrangedSubviews: [sliderValueLabel, slider, switchElement])
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 10
        
        self.axis = .vertical
        self.spacing = 10
        self.addArrangedSubview(headerLabel)
        self.addArrangedSubview(horizontalStackView)
    }
    
    @objc fileprivate func handleValue(slider: UISlider) {
        sliderValueLabel.text = String(Int(slider.value))
    }
    
    @objc fileprivate func handleHidden(sender: UISwitch) {
        
        if sender.isOn == false {
            slider.isEnabled = false
            sliderValueLabel.isEnabled = false
        } else {
            slider.isEnabled = true
            sliderValueLabel.isEnabled = true
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

