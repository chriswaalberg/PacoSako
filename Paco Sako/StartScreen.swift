//
//  StartScreen.swift
//  Paco Sako
//
//  Created by Chris Waalberg on 22/12/2019.
//  Copyright © 2019 Chris Waalberg. All rights reserved.
//

import UIKit

class StartScreen: UIViewController {
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let destVC = segue.destination as! ViewController
		
		if segue.identifier == "singleplayer" {
			destVC.isAgainstAI = true
		}
		
		if segue.identifier == "multiplayer" {
			destVC.isAgainstAI = false
		}
	}
	
	@IBAction func unwind(segue: UIStoryboardSegue) {
		
	}
}
