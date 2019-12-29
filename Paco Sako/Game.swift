//
//  Game.swift
//  Paco Sako
//
//  Created by Chris Waalberg on 22/12/2019.
//  Copyright © 2019 Chris Waalberg. All rights reserved.
//

import UIKit

class Game: NSObject {
	var theBoard: Board!
	var isWhiteTurn = true
	var winner: String?
	
	init(viewController: ViewController) {
		theBoard = Board.init(viewController: viewController)
	}
	
	func makeAIMove() {
		
	}
	
	func getPawnToBePromoted() -> Pawn? {
		for piece in theBoard.vc.pieces {
			if let pawn = piece as? Pawn {
				let pawnIndex = Board.indexOf(origin: pawn.frame.origin)
				if pawnIndex.row == 0 || pawnIndex.row == 7 {
					return pawn
				}
			}
		}
		
		return nil
	}
	
	func getPlayerSacoState() -> String? {
		guard let whiteKingIndex = theBoard.getIndex(forPiece: theBoard.whiteKing) else {
			return nil
		}
		
		guard let blackKingIndex = theBoard.getIndex(forPiece: theBoard.blackKing) else {
			return nil
		}
		
		for row in 0..<theBoard.ROWS {
			for col in 0..<theBoard.COLS {
				if let piece = theBoard.board[row][col] as? UIPiece {
					let pieceIndex = BoardIndex(row: row, col: col)
					if piece.color == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) {
						if isNormalMoveValid(forPiece: piece, fromIndex: pieceIndex, toIndex: whiteKingIndex) {
							return "Wit"
						}
					} else {
						if isNormalMoveValid(forPiece: piece, fromIndex: pieceIndex, toIndex: blackKingIndex) {
							return "Zwart"
						}
					}
				}
			}
		}
		
		return nil
	}
	
	func isGameOver() -> Bool {
		if didSomebodyWin() {
			return true
		}
		return false
	}
	
	func didSomebodyWin() -> Bool {
		if !theBoard.vc.pieces.contains(theBoard.whiteKing) {
			winner = "Zwart"
			return true
		}
		
		if !theBoard.vc.pieces.contains(theBoard.blackKing) {
			winner = "Wit"
			return true
		}
		
		return false
	}
	
	func move (piece pieceToMove: UIPiece, fromIndex sourceIndex: BoardIndex, toIndex destIndex: BoardIndex, toOrigin destOrigin: CGPoint) {
		//get initial piece frame
		let initialPieceFrame = pieceToMove.frame
		
		//remove piece at destination
		let pieceToRemove = theBoard.board[destIndex.row][destIndex.col]
		theBoard.remove(piece: pieceToRemove)
		
		//place piece at destination
		theBoard.place(piece: pieceToMove, toIndex: destIndex, toOrigin: destOrigin)
		
		//put dummy piece in vacant source tile
		theBoard.board[sourceIndex.row][sourceIndex.col] = Dummy(frame: initialPieceFrame)
	}
	
	func isMoveValid(piece: UIPiece, fromIndex sourceIndex: BoardIndex, toIndex destIndex: BoardIndex) -> Bool {
		guard isMoveOnBoard(forPieceFrom: sourceIndex, thatGoesTo: destIndex) else {
			print("MOVE IS NOT ON BOARD")
			return false
		}
		
		guard isTurnColor(sameAsPiece: piece) else {
			print("WRONG TURN")
			return false
		}
		
		return isNormalMoveValid(forPiece: piece, fromIndex: sourceIndex, toIndex: destIndex)
	}
	
	func isNormalMoveValid(forPiece piece: UIPiece, fromIndex source: BoardIndex, toIndex dest: BoardIndex) -> Bool {
		guard source != dest else {
			print("MOVING PIECE ON ITS CURRENT POSITION")
			return false
		}
		
		guard !isAttackingAlliedPiece(theSourcePiece: piece, destIndex: dest) else {
			print("ATTACKING ALLIED PIECE")
			return false
		}
		
		switch piece {
		case is Pawn:
			return isMoveValid(forPawn: piece as! Pawn, fromIndex: source, toIndex: dest)
		case is Rook, is Bishop, is Queen:
			return isMoveValid(forRookOrBishopOrQueen: piece, fromIndex: source, toIndex: dest)
		case is Knight:
			if !(piece as! Knight).doesMoveSeemFine(fromIndex: source, toIndex: dest) {
				return false
			}
		case is King:
			return isMoveValid(forKing: piece as! King, fromIndex: source, toIndex: dest)
		default:
			break
		}
		
		return true
	}
	
	func isMoveValid(forPawn pawn: Pawn, fromIndex source: BoardIndex, toIndex dest: BoardIndex) -> Bool {
		if !pawn.doesMoveSeemFine(fromIndex: source, toIndex: dest) {
			return false
		}
		
		//no attack
		if source.col == dest.col {
			//advance by 2
			if pawn.triesToAdvanceBy2 {
				var moveForward = 0
				
				if pawn.color == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) {
					moveForward = 1
				} else {
					moveForward = -1
				}
				
				if theBoard.board[dest.row][dest.col] is Dummy && theBoard.board[dest.row - moveForward][dest.col] is Dummy {
					return true
				}
			}
			//advance by 1
			else {
				if theBoard.board[dest.row][dest.col] is Dummy {
					return true
				}
			}
		}
		//attack some piece
		else {
			if !(theBoard.board[dest.row][dest.col] is Dummy) {
				return true
			}
		}
		
		return false
	}
	
	func isMoveValid(forRookOrBishopOrQueen piece: UIPiece, fromIndex source: BoardIndex, toIndex dest: BoardIndex) -> Bool {
		switch piece {
		case is Rook:
			if !(piece as! Rook).doesMoveSeemFine(fromIndex: source, toIndex: dest) {
				return false
			}
		case is Bishop:
			if !(piece as! Bishop).doesMoveSeemFine(fromIndex: source, toIndex: dest) {
				return false
			}
		default:
			if !(piece as! Queen).doesMoveSeemFine(fromIndex: source, toIndex: dest) {
				return false
			}
		}
		
		var increaseRow = 0
		
		if dest.row - source.row != 0 {
			increaseRow = (dest.row - source.row) / abs(dest.row - source.row)
		}
		
		var increaseCol = 0
		
		if dest.col - source.col != 0 {
			increaseCol = (dest.col - source.col) / abs(dest.col - source.col)
		}
		
		var nextRow = source.row + increaseRow
		var nextCol = source.col + increaseCol
		
		while nextRow != dest.row || nextCol != dest.col {
			if !(theBoard.board[nextRow][nextCol] is Dummy) {
				return false
			}
			
			nextRow += increaseRow
			nextCol += increaseCol
		}
		
		return true
	}
	
	func isMoveValid(forKing king: King, fromIndex source: BoardIndex, toIndex dest: BoardIndex) -> Bool {
		if !king.doesMoveSeemFine(fromIndex: source, toIndex: dest) {
			return false
		}
		
		if isOpponentKing(nearKing: king, thatGoesTo: dest) {
			return false
		}
		
		return true
	}
	
	func isOpponentKing(nearKing movingKing: King, thatGoesTo destIndexOfMovingKing: BoardIndex) -> Bool {
		// find out which one is the opponent king
		var theOpponentKing: King
		
		if movingKing == theBoard.whiteKing {
			theOpponentKing = theBoard.blackKing
		} else {
			theOpponentKing = theBoard.whiteKing
		}
		
		//get index of opponent king
		var indexOfOpponentKing: BoardIndex!
		
		for row in 0..<theBoard.ROWS {
			for col in 0..<theBoard.COLS {
				if let aKing = theBoard.board[row][col] as? King, aKing == theOpponentKing {
					indexOfOpponentKing = BoardIndex(row: row, col: col)
				}
			}
		}
		
		//compute absolute difference between kings
		let differenceInRows = abs(indexOfOpponentKing.row - destIndexOfMovingKing.row)
		let differenceInCols = abs(indexOfOpponentKing.col - destIndexOfMovingKing.col)
		
		//if they're too close, move is invalid
		if case 0...1 = differenceInRows {
			if case 0...1 = differenceInCols {
				return true
			}
		}
		
		return false
	}
	
	func isAttackingAlliedPiece(theSourcePiece: UIPiece, destIndex: BoardIndex) -> Bool {
		let destPiece: Piece = theBoard.board[destIndex.row][destIndex.col]
		
		guard !(destPiece is Dummy) else {
			return false
		}
		
		let theDestPiece = destPiece as! UIPiece
		
		return theSourcePiece.color == theDestPiece.color
	}
	
	func nextTurn() {
		isWhiteTurn = !isWhiteTurn
	}
	
	func isTurnColor(sameAsPiece piece: UIPiece) -> Bool {
		if piece.color == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) {
			if !isWhiteTurn {
				return true
			}
		} else {
			if isWhiteTurn {
				return true
			}
		}
		return false
	}
	
	func isMoveOnBoard(forPieceFrom sourceIndex: BoardIndex, thatGoesTo destIndex: BoardIndex) -> Bool {
		if case 0..<theBoard.ROWS = sourceIndex.row {
			if case 0..<theBoard.COLS = sourceIndex.col {
				if case 0..<theBoard.ROWS = destIndex.row {
					if case 0..<theBoard.COLS = destIndex.col {
						return true;
					}
				}
			}
		}
		return false;
	}
}
