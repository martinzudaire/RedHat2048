library game_player;

import 'game_solver.dart';
import 'game.dart';
import 'move.dart';
import 'dart:html';

///
/// GAME PLAYER
/// 
/// Play 2048 ^^
///
///

class SolverPlayer extends GameSolver {
  
  SolverPlayer() {
    window.onKeyDown.listen((KeyboardEvent e) {
      if (e.keyCode == KeyCode.LEFT) {
        Game.move(Move.left);
      } else if (e.keyCode == KeyCode.RIGHT) {
        Game.move(Move.right);
      } else if (e.keyCode == KeyCode.UP) {
        Game.move(Move.up);
      } else if (e.keyCode == KeyCode.DOWN) {
        Game.move(Move.down);
      }
    });    
  }
  
  void getNextMove() {
    //No AI, so do nothing.
  }
  
  void notify() {
    //Do nothing
  }
}