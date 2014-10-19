library solver_random;

import 'game_solver.dart';
import 'game.dart';
import 'move.dart';
import 'dart:math';

///
/// SOLVER RANDOM
/// 
/// Play 2048 ^^
///

class SolverRandom extends GameSolver {
  
  SolverRandom() {}
  
  void move() {
    
    Random r = new Random();
    
    switch (r.nextInt(4)) {
      case 0:
        Game.move(Move.up);
        break;
        
      case 1:
        Game.move(Move.down);
        break;
        
      case 2:
        Game.move(Move.left);
        break;
        
      case 3:
        Game.move(Move.right);
        break;
    }
    
    
  }
  
}