library game_solver;

import 'observer.dart';

///
/// GAME SOLVER
/// 
/// Abstract class to implement various algorithms to solve the game.
///
///


abstract class GameSolver implements Observer {
  
  void move();

  void notify() {
    move();
  }
  
}