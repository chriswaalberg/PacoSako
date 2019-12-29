//
//  ExtensionUIPiece.swift
//  Paco Sako
//
//  Created by Chris Waalberg on 22/12/2019.
//  Copyright © 2019 Chris Waalberg. All rights reserved.
//

import UIKit
typealias UIPiece = UILabel

extension UIPiece: Piece {
	var x: CGFloat {
		get {
			return self.frame.origin.x
		}
		set {
			self.frame.origin.x = newValue
		}
	}
	var y: CGFloat {
		get {
			return self.frame.origin.y
		}
		set {
			self.frame.origin.y = newValue
		}
	}
	
	var color: UIColor {
		get {
			return self.textColor
		}
	}
	
	func initPiece(pieceColor: UIColor, vc: ViewController) {
		self.isOpaque = false
		self.textColor = pieceColor
		self.isUserInteractionEnabled = true
		self.textAlignment = .center
		self.font = self.font.withSize(50)
		
		vc.pieces.append(self)
		vc.view.addSubview(self)
	}
}
