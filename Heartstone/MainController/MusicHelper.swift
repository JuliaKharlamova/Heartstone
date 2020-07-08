//
//  MusicHelper.swift
//  Heartstone
//
//  Created by Юлия Харламова on 29.05.2020.
//  Copyright © 2020 Юлия Харламова. All rights reserved.
//

import AVFoundation

class MusicHelper {
    static let sharedHelper = MusicHelper()
    var audioPlayer: AVAudioPlayer?
    
    func playBackgroundMusic() {
        let aSound = NSURL(fileURLWithPath:
            Bundle.main.path(forResource: "Hearthstone — Main Title", ofType: "mp3")!) //change the file name as your file
        do {
            audioPlayer = try AVAudioPlayer(contentsOf:aSound as URL)
            audioPlayer!.numberOfLoops = -1
            audioPlayer!.prepareToPlay()
            audioPlayer!.play()
        }
        catch {
            print("Cannot play the file")
        }
    }
}
