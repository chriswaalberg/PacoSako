//
//  Board.swift
//  Paco Sako
//
//  Created by Chris Waalberg on 22/12/2019.
//  Copyright © 2019 Chris Waalberg. All rights reserved.
//

import UIKit

class Board: NSObject {
	var board: [[Piece]]!
	var vc: ViewController!
	let ROWS = 8
	let COLS = 8
	var whiteKing: King!
	var blackKing: King!
	
	func getIndex(forPiece pieceToFind: UIPiece) -> BoardIndex? {
		for row in 0..<ROWS {
			for col in 0..<COLS {
				let aPiece = board[row][col] as? UIPiece
				if pieceToFind == aPiece {
					return BoardIndex(row: row, col: col)
				}
			}
		}
		
		return nil
	}
	
	func remove(piece: Piece) {
		if let pieceToBeRemoved = piece as? UIPiece {
			//remove from board matrix
			let indexOnBoard = Board.indexOf(origin: pieceToBeRemoved.frame.origin)
			board[indexOnBoard.row][indexOnBoard.col] = Dummy(frame: pieceToBeRemoved.frame)
			
			//remove from array of pieces
			if let indexInPiecesArray = vc.pieces.firstIndex(of: pieceToBeRemoved) {
				vc.pieces.remove(at: indexInPiecesArray)
			}
			
			//remove from screen
			pieceToBeRemoved.removeFromSuperview()
		}
	}
	
	func place(piece: UIPiece, toIndex destIndex: BoardIndex, toOrigin destOrigin: CGPoint) {
		piece.frame.origin = destOrigin
		board[destIndex.row][destIndex.col] = piece
	}
	
	static func indexOf(origin: CGPoint) -> BoardIndex {
		let row = (Int(origin.y) - ViewController.SPACE_FROM_TOP_EDGE) / ViewController.TILE_SIZE
		let col = (Int(origin.x) - ViewController.SPACE_FROM_LEFT_EDGE) / ViewController.TILE_SIZE
		
		return BoardIndex(row: row, col: col)
	}
	
	static func getFrame(forRow row: Int, forCol col: Int) -> CGRect {
		let x = CGFloat(ViewController.SPACE_FROM_LEFT_EDGE + col * ViewController.TILE_SIZE)
		let y = CGFloat(ViewController.SPACE_FROM_TOP_EDGE + row * ViewController.TILE_SIZE)
		
		return CGRect(origin: CGPoint(x: x, y: y), size: CGSize(width: ViewController.TILE_SIZE, height: ViewController.TILE_SIZE))
	}
	
	init(viewController: ViewController) {
		vc = viewController
		
		//initialize the board matrix with dummies
		let oneRowOfBoard = Array(repeating: Dummy(), count: COLS)
		board = Array(repeating: oneRowOfBoard, count: ROWS)
		
		for row in 0..<ROWS {
			for col in 0..<COLS	{
				switch row {
				case 0:
					switch col {
					case 0:
						board[row][col] = Rook(frame: Board.getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), vc: vc)
					case 1:
						board[row][col] = Knight(frame: Board.getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), vc: vc)
					case 2:
						board[row][col] = Bishop(frame: Board.getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), vc: vc)
					case 3:
						board[row][col] = Queen(frame: Board.getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), vc: vc)
					case 4:
						blackKing = King(frame: Board.getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), vc: vc)
						board[row][col] = blackKing
					case 5:
						board[row][col] = Bishop(frame: Board.getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), vc: vc)
					case 6:
						board[row][col] = Knight(frame: Board.getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), vc: vc)
					default:
						board[row][col] = Rook(frame: Board.getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), vc: vc)
					}
				case 1:
					board[row][col] = Pawn(frame: Board.getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), vc: vc)
				case 6:
					board[row][col] = Pawn(frame: Board.getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), vc: vc)
				case 7:
					switch col {
					case 0:
						board[row][col] = Rook(frame: Board.getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), vc: vc)
					case 1:
						board[row][col] = Knight(frame: Board.getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), vc: vc)
					case 2:
						board[row][col] = Bishop(frame: Board.getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), vc: vc)
					case 3:
						board[row][col] = Queen(frame: Board.getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), vc: vc)
					case 4:
						whiteKing = King(frame: Board.getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), vc: vc)
						board[row][col] = whiteKing
					case 5:
						board[row][col] = Bishop(frame: Board.getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), vc: vc)
					case 6:
						board[row][col] = Knight(frame: Board.getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), vc: vc)
					default:
						board[row][col] = Rook(frame: Board.getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), vc: vc)
					}
				default:
						board[row][col] = Dummy(frame: Board.getFrame(forRow: row, forCol: col))
				}
			}
		}
	}
}
