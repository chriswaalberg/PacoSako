//
//  ViewController.swift
//  Paco Sako
//
//  Created by Chris Waalberg on 22/12/2019.
//  Copyright © 2019 Chris Waalberg. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	@IBOutlet var lblDisplayTurnOUTLET: UILabel!
	@IBOutlet var lblDisplaySacoOUTLET: UILabel!
	@IBOutlet var panOUTLET: UIPanGestureRecognizer!
	var pieceDragged: UIPiece!
	var sourceOrigin: CGPoint!
	var destOrigin: CGPoint!
	static var SPACE_FROM_LEFT_EDGE: Int = 8
	static var SPACE_FROM_TOP_EDGE: Int = 132
	static var TILE_SIZE: Int = 38
	var myGame: Game!
	var pieces: [UIPiece]!
	var isAgainstAI: Bool!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		pieces = []
		myGame = Game.init(viewController: self)
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		pieceDragged = touches.first!.view as? UIPiece
		
		if pieceDragged != nil {
			sourceOrigin = pieceDragged.frame.origin
		}
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		if pieceDragged != nil {
			drag(piece: pieceDragged, usingGestureRecognizer: panOUTLET)
		}
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		if pieceDragged != nil {
			let touchLocation = touches.first!.location(in: view)
			
			var x = Int(touchLocation.x)
			var y = Int(touchLocation.y)
			
			x -= ViewController.SPACE_FROM_LEFT_EDGE
			y -= ViewController.SPACE_FROM_TOP_EDGE
			
			x = (x / ViewController.TILE_SIZE) * ViewController.TILE_SIZE
			y = (y / ViewController.TILE_SIZE) * ViewController.TILE_SIZE
			
			x += ViewController.SPACE_FROM_LEFT_EDGE
			y += ViewController.SPACE_FROM_TOP_EDGE
			
			destOrigin = CGPoint(x: x, y: y)
			
			let sourceIndex = Board.indexOf(origin: sourceOrigin)
			let destIndex = Board.indexOf(origin: destOrigin)
			
			if myGame.isMoveValid(piece: pieceDragged, fromIndex: sourceIndex, toIndex: destIndex) {
				myGame.move(piece: pieceDragged, fromIndex: sourceIndex, toIndex: destIndex, toOrigin: destOrigin)
				
				//check if game is over
				if myGame.isGameOver() {
					displayWinner()
					return
				}
				
				if shouldPromotePawn() {
					promptForPawnPromotion()
				} else {
					resumeGame()
				}
			} else {
				pieceDragged.frame.origin = sourceOrigin
			}
		}
	}
	
	func resumeGame() {
		//display saco state, if any
		displaySacoState()
		
		//change the turn
		myGame.nextTurn()
		
		//display turn on screen
		updateTurnOnScreen()
		
		//make AI move, if necessary
		if isAgainstAI == true && !myGame.isWhiteTurn {
			myGame.makeAIMove()
			
			if myGame.isGameOver() {
				displayWinner()
				return
			}
			
			if shouldPromotePawn() {
				promote(pawn: myGame.getPawnToBePromoted()!, into: "Queen")
			}
			
			displaySacoState()
			
			myGame.nextTurn()
			
			updateTurnOnScreen()
		}
	}
	
	func promote(pawn pawnToBePromoted: Pawn, into pieceName: String) {
		let pawnColor = pawnToBePromoted.color
		let pawnFrame = pawnToBePromoted.frame
		let pawnIndex = Board.indexOf(origin: pawnToBePromoted.frame.origin)
		
		myGame.theBoard.remove(piece: pawnToBePromoted)
		
		switch pieceName {
		case "Queen":
			myGame.theBoard.board[pawnIndex.row][pawnIndex.col] = Queen(frame: pawnFrame, color: pawnColor, vc: self)
		case "Knight":
			myGame.theBoard.board[pawnIndex.row][pawnIndex.col] = Knight(frame: pawnFrame, color: pawnColor, vc: self)
		case "Rook":
			myGame.theBoard.board[pawnIndex.row][pawnIndex.col] = Rook(frame: pawnFrame, color: pawnColor, vc: self)
		case "Bishop":
			myGame.theBoard.board[pawnIndex.row][pawnIndex.col] = Bishop(frame: pawnFrame, color: pawnColor, vc: self)
		default:
			break
		}
	}
	
	func promptForPawnPromotion() {
		if let pawnToPromote = myGame.getPawnToBePromoted() {
			let box = UIAlertController(title: "Pionpromotie", message: "Kies stuk", preferredStyle: UIAlertController.Style.alert)
			
			box.addAction(UIAlertAction(title: "Koningin", style: UIAlertAction.Style.default, handler: { action in
				self.promote(pawn: pawnToPromote, into: "Queen")
				self.resumeGame()
			}))
			
			box.addAction(UIAlertAction(title: "Paard", style: UIAlertAction.Style.default, handler: { action in
				self.promote(pawn: pawnToPromote, into: "Knight")
				self.resumeGame()
			}))
			
			box.addAction(UIAlertAction(title: "Toren", style: UIAlertAction.Style.default, handler: { action in
				self.promote(pawn: pawnToPromote, into: "Rook")
				self.resumeGame()
			}))
			
			box.addAction(UIAlertAction(title: "Loper", style: UIAlertAction.Style.default, handler: { action in
				self.promote(pawn: pawnToPromote, into: "Bishop")
				self.resumeGame()
			}))
			
			self.present(box, animated: true, completion: nil)
		}
	}
	
	func shouldPromotePawn() -> Bool {
		return (myGame.getPawnToBePromoted() != nil)
	}
	
	func displaySacoState() {
		let playerSacoState = myGame.getPlayerSacoState()
		
		if playerSacoState != nil {
			lblDisplaySacoOUTLET.text = playerSacoState! + " staat Saco!"
		} else {
			lblDisplaySacoOUTLET.text = nil
		}
	}
	
	func displayWinner() {
		let box = UIAlertController(title: "Game over", message: "\(myGame.winner!) wint", preferredStyle: UIAlertController.Style.alert)

		box.addAction(UIAlertAction(title: "Terug naar menu", style: UIAlertAction.Style.default, handler: {
			action in self.performSegue(withIdentifier: "backToMainMenu", sender: self)
		}))
		
		box.addAction(UIAlertAction(title: "Opnieuw", style: UIAlertAction.Style.default, handler: {
			action in
			
			//clear screen, pieces array, and board matrix
			for piece in self.pieces {
				self.myGame.theBoard.remove(piece: piece)
			}
			
			//create new game
			self.myGame = Game(viewController: self)
			
			//update labels with game status
			self.updateTurnOnScreen()
			self.lblDisplaySacoOUTLET.text = nil
		}))
		
		self.present(box, animated: true, completion: nil)
	}
	
	func updateTurnOnScreen() {
		lblDisplayTurnOUTLET.text = myGame.isWhiteTurn ? "Beurt wit" : "Beurt zwart"
		lblDisplayTurnOUTLET.textColor = myGame.isWhiteTurn ? #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
	}
	
	func drag(piece: UIPiece, usingGestureRecognizer gestureRecognizer: UIPanGestureRecognizer) {
		let translation = gestureRecognizer.translation(in: view)
		
		piece.center = CGPoint(x: translation.x + piece.center.x, y: translation.y + piece.center.y)
		
		gestureRecognizer.setTranslation(CGPoint.zero, in: view)
	}
}
