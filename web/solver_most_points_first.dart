library solver_most_points_first;

import 'dart:math';
import 'game_solver.dart';
import 'game.dart';
import 'move.dart';
import 'game_logic.dart';
import 'game_state.dart';

///
/// SOLVER MOST POINTS FIRST
/// 
/// 
///

class SolverMostPointsFirst extends GameSolver {
  
  GameLogic gameLogic;
  
  SolverMostPointsFirst() {
    gameLogic = new GameLogic();
  }
  
  void move() {
    
    GameState gameState = Game.getCurrentGameState();
    GameState gsLeft = gameLogic.simulateMove(gameState, Move.left);
    GameState gsRight = gameLogic.simulateMove(gameState, Move.right);
    GameState gsUp = gameLogic.simulateMove(gameState, Move.up);
    GameState gsDown = gameLogic.simulateMove(gameState, Move.down);
    
    int maxPoints = max(max(max(gsLeft.getPoints(), gsRight.getPoints()), gsUp.getPoints()), gsDown.getPoints());
    
    List<Move> movesMaxPoints = new List<Move>();

    if (gsLeft.getPoints()==maxPoints && gsLeft.hasMoved()) movesMaxPoints.add(Move.left);
    if (gsRight.getPoints()==maxPoints && gsRight.hasMoved()) movesMaxPoints.add(Move.right);
    if (gsUp.getPoints()==maxPoints && gsUp.hasMoved()) movesMaxPoints.add(Move.up);
    if (gsDown.getPoints()==maxPoints && gsDown.hasMoved()) movesMaxPoints.add(Move.down);
    
    Random r = new Random();
    Move randomMove = movesMaxPoints[r.nextInt(movesMaxPoints.length)];
    
    Game.move(randomMove);
    
  }
  
}