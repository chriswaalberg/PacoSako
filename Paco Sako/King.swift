//
//  King.swift
//  Paco Sako
//
//  Created by Chris Waalberg on 22/12/2019.
//  Copyright © 2019 Chris Waalberg. All rights reserved.
//

import UIKit

class King: UIPiece {
	init(frame: CGRect, color: UIColor, vc: ViewController) {
		super.init(frame: frame)
		
//		if color == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) {
			self.text = "♚"
//		} else {
//			self.text = "♔"
//		}
		
		initPiece(pieceColor: color, vc: vc)
	}
	
	func doesMoveSeemFine(fromIndex source: BoardIndex, toIndex dest: BoardIndex) -> Bool {
		let differenceInRows = abs(dest.row - source.row)
		let differenceInCols = abs(dest.col - source.col)
		
		if case 0...1 = differenceInRows {
			if case 0...1 = differenceInCols {
				return true
			}
		}
		
		return false
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)!
	}
}
