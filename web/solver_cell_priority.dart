library solver_cell_priority;

import 'dart:math';
import 'game_solver.dart';
import 'game.dart';
import 'move.dart';
import 'game_logic.dart';
import 'game_state.dart';
import 'grid_iterator.dart';

///
/// SOLVER CELL PRIORITY
/// 
/// 
///

class SolverCellPriority extends GameSolver {
  
  GameLogic gameLogic;
  
  SolverCellPriority() {
    gameLogic = new GameLogic();
  }
  
  void move() {
    
    GameState gameState = Game.getCurrentGameState();
    GameState gsLeft = gameLogic.simulateMove(gameState, Move.left);
    GameState gsRight = gameLogic.simulateMove(gameState, Move.right);
    GameState gsUp = gameLogic.simulateMove(gameState, Move.up);
    GameState gsDown = gameLogic.simulateMove(gameState, Move.down);

    int pointsLeft = calculatePoints(gsLeft);
    int pointsRight = calculatePoints(gsRight);
    int pointsUp = calculatePoints(gsUp);
    int pointsDown = calculatePoints(gsDown);
    
    int maxPoints = max(max(max(pointsLeft, pointsRight), pointsUp), pointsDown);
    
    List<Move> movesPoints = new List<Move>();

    if (pointsLeft==maxPoints && gsLeft.hasMoved()) movesPoints.add(Move.left);
    if (pointsRight==maxPoints && gsRight.hasMoved()) movesPoints.add(Move.right);
    if (pointsUp==maxPoints && gsUp.hasMoved()) movesPoints.add(Move.up);
    if (pointsDown==maxPoints && gsDown.hasMoved()) movesPoints.add(Move.down);
    
    Random r = new Random();
    Move randomMove = movesPoints[r.nextInt(movesPoints.length)];
    
    Game.move(randomMove);
    
  }
  
  int calculatePoints(GameState gs) {
    //Assign more points to middle cells
    
    if (!gs.hasMoved()) return 0;
    
    GridIterator iterator = new GridIterator(gs.getGrid(), Move.left);
    int points = 0;
    
    while (iterator.isRowDone()) {
      while (iterator.isCellDone()) {        
        
        if (iterator.isFirstRow() || iterator.isLastRow()) {
          if (iterator.isFirstCell() || iterator.isLastCell()) {
            points += (11-sqrt(iterator.getCellValue()));
          } else {
            points += (11-sqrt(iterator.getCellValue()))*2;
          }
        } else if (iterator.isFirstCell() || iterator.isLastCell()) {
          points += (11-sqrt(iterator.getCellValue()))*2;
        } else {
          points += (11-sqrt(iterator.getCellValue()))*4;
        }
        
      }
      iterator.nextRow();
      iterator.firstCell();
    }
    
    return points;
  }
  
}