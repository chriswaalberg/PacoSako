//
//  Knight.swift
//  Paco Sako
//
//  Created by Chris Waalberg on 22/12/2019.
//  Copyright © 2019 Chris Waalberg. All rights reserved.
//

import UIKit

class Knight: UIPiece {
	init(frame: CGRect, color: UIColor, vc: ViewController) {
		super.init(frame: frame)
		
//		if color == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) {
			self.text = "♞"
//		} else {
//			self.text = "♘"
//		}
		
		initPiece(pieceColor: color, vc: vc)
	}
	
	func doesMoveSeemFine(fromIndex source: BoardIndex, toIndex dest: BoardIndex) -> Bool {
		let validMoves = [(source.row - 1, source.col + 2), (source.row - 2, source.col + 1), (source.row - 2, source.col - 1), (source.row - 1, source.col - 2), (source.row + 1, source.col - 2), (source.row + 2, source.col - 1), (source.row + 2, source.col + 1), (source.row + 1, source.col + 2)]
		
		for (validRow, validCol) in validMoves {
			if dest.row == validRow && dest.col == validCol {
				return true
			}
		}
		
		return false
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)!
	}
}
