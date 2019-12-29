//
//  BoardIndex.swift
//  Paco Sako
//
//  Created by Chris Waalberg on 22/12/2019.
//  Copyright © 2019 Chris Waalberg. All rights reserved.
//

struct BoardIndex: Equatable {
	var row: Int
	var col: Int
	
	init(row: Int, col: Int) {
		self.row = row
		self.col = col
	}
	
	static func ==(lhs: BoardIndex, rhs: BoardIndex) -> Bool {
		return (lhs.row == rhs.row && lhs.col == rhs.col)
	}
}
