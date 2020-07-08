//
//  SettingsModel.swift
//  Heartstone
//
//  Created by Юлия Харламова on 19.05.2020.
//  Copyright © 2020 Юлия Харламова. All rights reserved.
//

import UIKit

struct SettingsModel: Codable {
    let classes, sets, standard, wild: [String]?
    let types, factions, qualities, races: [String]?
    let locales: [String]?
}
