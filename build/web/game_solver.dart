library game_solver;

import 'observer.dart';
import 'game.dart';

///
/// GAME SOLVER
/// 
/// Abstract class to implement various algorithms to solve the game.
///
///


abstract class GameSolver implements Observer {
  
  void move();

  void notify() {
    if (!Game.getCurrentGameState().isOver()) move();
  }
  
}