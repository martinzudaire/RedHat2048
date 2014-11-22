library solver_decrecimiento_2;

import 'game_solver.dart';
import 'game.dart';
import 'move.dart';
import 'grid.dart';
import 'grid_coordinates.dart';
import 'grid_iterator.dart';
import 'game_logic.dart';
import 'game_state.dart';

///
/// SOLVER DECRECIMIENTO 2
///
/// Calculates the moves based on maximazing the amount of decrecimientos. (?)
///

class SolverDecrecimiento2 extends GameSolver {
  
  Move _globalMove = null; //used to be a Move.none, now he's a cool null
  int _globalDirectionX = 0;
  int _globalDirectionY = 0;
  
  SolverDecrecimiento2(){}
  
  void move() {
    GameState gameState = Game.getCurrentGameState();
    int moves = gameState.getMoves();

    GridCoordinates cellHighestValue = this.findCellWithHighestValue(gameState.getGrid().clone()); 
    GridCoordinates auxCell = new GridCoordinates(0,0);
    bool isCornered;
    int depth;
    
    auxCell.x = ((cellHighestValue.x+0.25)/2.0).truncate()*3; //TODO check. Wat is dis?
    auxCell.y = ((cellHighestValue.y+0.25)/2.0).truncate()*3; //TODO check. Wat is dis?
    isCornered = (cellHighestValue.x==auxCell.x && cellHighestValue.y==auxCell.y);
    
    this._globalMove = null;
    
    if (!isCornered) {
      _globalMove = pushToCorner(gameState);
    }
    
    
    if(moves>=300) {
      depth = 3;
    } else if(moves<300) {
      depth = 2;
    } else if(moves<200) {
      depth = 1;
    } else if(moves<100) {
      depth = 0;
    }
    
    
    if(_globalMove==null) {
      List<Move> prevMoves = new List<Move>();
      calculateMove(gameState, cellHighestValue, depth, prevMoves);
    }
    
    Game.move(_globalMove);
  }
  
  
  //pushToCorner()
  //TODO Simulates all moves and returns the move that isCornered() considers worthy  
  Move pushToCorner(GameState gameState) {
    GameLogic gameLogic = new GameLogic();
    GameState gs;
    
    gs = gameLogic.simulateMove(gameState, Move.up);
    if (isCornered(findCellWithHighestValue(gs.getGrid()))) {
      return Move.up;
    }
    
    gs = gameLogic.simulateMove(gameState, Move.down);
    if (isCornered(findCellWithHighestValue(gs.getGrid()))) {
      return Move.down;
    }
    
    gs = gameLogic.simulateMove(gameState, Move.right);
    if (isCornered(findCellWithHighestValue(gs.getGrid()))) {
      return Move.right;
    }
    
    gs = gameLogic.simulateMove(gameState, Move.left);
    if (isCornered(findCellWithHighestValue(gs.getGrid()))) {
      return Move.left;
    }
    
    return null;
  }
  
  
  //calculateMove()
  //Recursive. 
  List<int> calculateMove(GameState gameState, GridCoordinates cellHighestValue, int depth, List<Move> prevMoves) {
    List<int> decrecimientos = new List<int>(); //TODO array that will contain the different amount of decrecimientos from up/down/left/right. let's hope so.
    List<Move> moveList = new List<Move>();
    List<int> depthList = new List<int>();
    List<int> aux = new List<int>();
    List<int> temp;
    List<int> returnList = new List<int>();
    GameLogic gameLogic = new GameLogic();
    GameState gs;
    
    //Up
    gs = gameLogic.simulateMove(gameState, Move.up);
    if (!prevMoves.contains(Move.down) && gs.hasMoved()) {
      aux = calculateMaxDecrecimientos(gs.getGrid(), cellHighestValue, true, false);
      decrecimientos.add(aux[1]);
      moveList.add(Move.up);
      depthList.add(depth);
      
      if (depth != 0 && aux[1] != 0) {
        List<Move> newPrevMoves = cloneListMove(prevMoves);
        newPrevMoves.add(Move.up);
        temp = calculateMove(gs, cellHighestValue, depth-1, newPrevMoves);
        if (temp[0] != -1) {
          decrecimientos.add(temp[0]);
          moveList.add(Move.up);
          depthList.add(temp[1]);
        }
      }
    }
    
    //Down
    gs = gameLogic.simulateMove(gameState, Move.down);
    if (!prevMoves.contains(Move.up) && gs.hasMoved()) {
      aux = calculateMaxDecrecimientos(gs.getGrid(), cellHighestValue, true, false);
      decrecimientos.add(aux[1]);
      moveList.add(Move.down);
      depthList.add(depth);

      if (depth != 0 && aux[1] != 0) {
        List<Move> newPrevMoves = cloneListMove(prevMoves);
        newPrevMoves.add(Move.down);
        temp = calculateMove(gs, cellHighestValue, depth-1, newPrevMoves);
        if (temp[0] != -1) {
          decrecimientos.add(temp[0]);
          moveList.add(Move.down);
          depthList.add(temp[1]);
        }
      }
    }

    //Right
    gs = gameLogic.simulateMove(gameState, Move.right);
    if (!prevMoves.contains(Move.left) && gs.hasMoved()) {
      aux = calculateMaxDecrecimientos(gs.getGrid(), cellHighestValue, true, false);
      decrecimientos.add(aux[1]);
      moveList.add(Move.right);
      depthList.add(depth);

      if (depth != 0 && aux[1] != 0) {
        List<Move> newPrevMoves = cloneListMove(prevMoves);
        newPrevMoves.add(Move.right);
        temp = this.calculateMove(gs, cellHighestValue, depth-1, newPrevMoves);
        if (temp[0] != -1) {
          decrecimientos.add(temp[0]);
          moveList.add(Move.right);
          depthList.add(temp[1]);
        }
      }
    }

    //Left
    gs = gameLogic.simulateMove(gameState, Move.left);
    if (!prevMoves.contains(Move.right) && gs.hasMoved()) {
      aux = calculateMaxDecrecimientos(gs.getGrid(), cellHighestValue, true, false);
      decrecimientos.add(aux[1]);
      moveList.add(Move.left);
      depthList.add(depth);

      if (depth != 0 && aux[1] != 0) {
        List<Move> newPrevMoves = cloneListMove(prevMoves);
        newPrevMoves.add(Move.left);
        temp = this.calculateMove(gs, cellHighestValue, depth-1, newPrevMoves);
        if (temp[0] != -1) {
          decrecimientos.add(temp[0]);
          moveList.add(Move.left);
          depthList.add(temp[1]);
        }
      }
    }
    
    
    //me quedo con el que maximice la cantidad de decrecimientos
    if (decrecimientos.length>0) {
      int max = 0;
      
      for (int i=1; i<decrecimientos.length; i++) {
        if (decrecimientos[i] > decrecimientos[max]) {
          max = i;
        } else if (decrecimientos[i] == decrecimientos[max]) {
          if(depthList[i] > depthList[max]) {
            max = i;
          }
        }
      }
   
      this._globalMove = moveList[max];
      returnList.add(decrecimientos[max]);
      returnList.add(depthList[max]);
      
    } else {
      returnList.add(-1);
      returnList.add(depth);
    }
    
    return returnList;
    
  }
  
  
  /*
   * Really cool algorithm that solves the game.
   * Decrecimientos: Empezamos del punto (x,y) y vemos para que lado se cumple que element(x,y) > element(siguiente punto arriba-abajo-etc)
   * Para ese lado contamos la cantidad de decrecimientos de manera recursiva. Basicamente se buscan todos los caminos donde se cumple
   * que cada elemento es mayor o igual al siguiente. De todos los caminos que existen a partir de un punto nos quedamos con el que tenga
   * la mayor suma de elementos. Por ejemplo si tenemos dos caminos que empiezan de un punto de valor 16 y son 16-16-2 y 16-8-4-2 nos
   * quedamos con el de 16-16-2.
   */
  
  //calculateMaxDecrecimientos()
  //Recursive.
  List<int> calculateMaxDecrecimientos(Grid grid, GridCoordinates cell, bool isFirst, bool breakZigZag) {
    List<int> count = new List<int>();
    List<int> addedcount = new List<int>();
    int cellValue = grid.getValue(cell.x, cell.y);
    int max = 300000; //Just 'cause
    List<int> returnList = new List<int>();
    List<int> auxList;
    bool auxZigZag;
    
    if(cellValue==0) { //stop if we find a zero
      returnList.add(-1);
      returnList.add(0);
      return returnList;
    }
    
    //Down
    if(!grid.isOutOfBounds(cell.x+1,cell.y) && grid.getValue(cell.x, cell.y) >= grid.getValue(cell.x+1, cell.y)) {
      factor(1, 0, cell, isFirst, breakZigZag);
      auxZigZag = (factor(1, 0, cell, false, breakZigZag) == 1);
      grid.setValue(cell.x, cell.y, max);
      
      auxList = calculateMaxDecrecimientos(grid, new GridCoordinates(cell.x+1,cell.y), false, auxZigZag);
      count.add(auxList[0]+1);
      addedcount.add(auxList[1]+cellValue*factor(1, 0, cell, false, breakZigZag));
      grid.setValue(cell.x, cell.y, cellValue);
      if(grid.getValue(cell.x, cell.y) == grid.getValue(cell.x+1, cell.y)) {
        addedcount[addedcount.length-1]--;
      }
    }
    
    //Up
    if(!grid.isOutOfBounds(cell.x-1,cell.y) && grid.getValue(cell.x, cell.y) >= grid.getValue(cell.x-1, cell.y)) {
      factor(-1, 0, cell, isFirst, breakZigZag);
      auxZigZag = (factor(1, 0, cell, false, breakZigZag) == 1);
      grid.setValue(cell.x, cell.y, max);
      
      auxList = calculateMaxDecrecimientos(grid, new GridCoordinates(cell.x-1, cell.y), false, auxZigZag);
      count.add(auxList[0]+1);
      addedcount.add(auxList[1]+cellValue*factor(1, 0, cell, false, breakZigZag));
      grid.setValue(cell.x, cell.y, cellValue);
      if(grid.getValue(cell.x, cell.y) == grid.getValue(cell.x-1, cell.y)) {
        addedcount[addedcount.length-1]--;
      }
    }
    
    //Right
    if (!grid.isOutOfBounds(cell.x,cell.y+1) && grid.getValue(cell.x, cell.y) >= grid.getValue(cell.x, cell.y+1)) {
      factor(0, 1, cell, isFirst, breakZigZag);
      auxZigZag = (factor(0, 1, cell, false, breakZigZag) == 1);
      grid.setValue(cell.x, cell.y, max);
      
      auxList = calculateMaxDecrecimientos(grid, new GridCoordinates(cell.x, cell.y+1), false, auxZigZag);
      count.add(auxList[0]+1);
      addedcount.add(auxList[1]+cellValue*factor(0, 1, cell, false, breakZigZag));
      grid.setValue(cell.x, cell.y, cellValue);
      if(grid.getValue(cell.x, cell.y) == grid.getValue(cell.x, cell.y+1)) {
        addedcount[addedcount.length-1]--;
      }
    }
    
    //Left
    if (!grid.isOutOfBounds(cell.x,cell.y-1) && grid.getValue(cell.x, cell.y) >= grid.getValue(cell.x, cell.y-1)) {
      factor(0, -1, cell, isFirst, breakZigZag);
      auxZigZag = (factor(0, 1, cell, false, breakZigZag) == 1);
      grid.setValue(cell.x, cell.y, max);
      
      auxList = calculateMaxDecrecimientos(grid, new GridCoordinates(cell.x, cell.y-1), false, auxZigZag);
      count.add(auxList[0]+1);
      addedcount.add(auxList[1]+cellValue*factor(0, 1, cell, false, breakZigZag));
      grid.setValue(cell.x, cell.y, cellValue);
      if(grid.getValue(cell.x, cell.y) == grid.getValue(cell.x, cell.y-1)) {
        addedcount[addedcount.length-1]--;
      }
    }
    
    if(addedcount.length != 0) { //si esta vacio es porque no hay camino para ningun lado
      int maxcount = 0;
      
      for(int i=1; i<addedcount.length; i++) {
        if(addedcount[i] > addedcount[maxcount]) { //nos quedamos con el mas grande
          maxcount = i;
        }
      }
      
      returnList.add(count[maxcount]);
      returnList.add(addedcount[maxcount]);
      return returnList;
    }
    
    returnList.add(0);
    returnList.add(0);
    return returnList;
    
  }
  
  
  //findCellWithHighestValue()
  //Finds the cell with the highest cell value, and then returns its GridCoordinates
  GridCoordinates findCellWithHighestValue(Grid grid) {
    
    GridIterator iterator = new GridIterator(grid, Move.right);
    GridCoordinates coordinates;
    int highestValue = 0;
    
    while (!iterator.isRowDone()) {      
      while (!iterator.isCellDone()) {
        
        if (iterator.getCellValue() > highestValue) {
          coordinates = iterator.getGridCoordinates();
          
        } else if (iterator.getCellValue() == highestValue) { //TODO CHECK. Wat is dis? I don't even
          GridCoordinates c = iterator.getGridCoordinates();
          if (c.x == ((c.x+0.25)/2.0).truncate()*3 && c.y == ((c.y+0.25)/2.0).truncate()*3) {
            coordinates = c;
          }          
        }
        
        iterator.nextCell();
      }      
      iterator.nextRow();
      iterator.firstCell();      
    }
    
    return coordinates;
    
  }
  
  
  //isCornered()
  //TODO Returns er... something that is a boolean. Looks important.
  bool isCornered(GridCoordinates coordinates) {
    return (coordinates.x==((coordinates.x+0.25)/2.0).truncate()*3 
        && coordinates.y==((coordinates.y+0.25)/2.0).truncate()*3);
  }

  
  //cloneListMove()
  //Clones and returns a list of Move elements.
  List<Move> cloneListMove(List<Move> moves) {
    List<Move> list = new List<Move>();
    for(int i=0; i<moves.length; i++) {
      list.add(moves[i]);
    }
    return list;
  }
  
  
  //factor()
  //TODO Returns 1 or 2 if conditions are met.
  int factor(int currentx, int currenty, GridCoordinates cell, bool first, bool breakZigZag) {
    if(breakZigZag) {
      return 1;
      
    } else if (first) {
      this._globalDirectionX = currentx.abs(); 
      this._globalDirectionY = currenty.abs();
      return 2;
    
    } else if (isCornered(cell)) {
      return 2;
      
    } else if(currentx.abs() == this._globalDirectionX && currenty.abs() == this._globalDirectionY) {
      return 2;
    
    } else {
      return 1;
    }
  }
  
  
}