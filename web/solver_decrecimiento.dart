library solver_decrecimiento;

import 'game_solver.dart';
import 'game.dart';
import 'move.dart';
import 'grid.dart';
import 'grid_coordinates.dart';
import 'grid_iterator.dart';
import 'game_logic.dart';
import 'game_state.dart';

///
/// SOLVER DECRECIMIENTO
///
/// Solver based on a Zig-Zag stategy, prioritizing having the highest
/// number in a corner.
/// 
/// The Zig-Zag is achieved by maximazing an amount called "decrecimientos"
/// which basicly adds the numbers in a chain of previousElement>thisElement
/// looking for the chain which has the highest value of added sum.
/// 
/// For each move it checks the evolution of the "decrecimientos" amount,
/// searching for the move which maximizes this value.
/// This move-checking is done upto "depth" times into the future (assuming
/// no random numbers are added after each move) in a recursive fashion.
///

class SolverDecrecimiento extends GameSolver {
  
  Move _globalMove = null; //variable holding the move that will be done this round
  
  //set of variables used to encourage the Zig-Zag
  int _globalDirectionX = 0; 
  int _globalDirectionY = 0;
  
  //Constructor
  SolverDecrecimiento(){}
  
  
  //move()
  //Entry point in the solver algorithm.
  //Decision making (choose one option):
  //-Put highest value in corner.
  //-Calculate the best move.
  void move() {
    GameState gameState = Game.getCurrentGameState();
    int moves = gameState.getMoves();
    int depth;

    //Get cell with highest value in the grid.
    GridCoordinates cellHighestValue = findCellWithHighestValue(gameState.getGrid().clone()); 
    
    _globalMove = null;
    
    //Check if the highest valued cell is in a corner.
    //If not try to move it there.
    if (!isCornered(cellHighestValue)) {
      _globalMove = pushToCorner(gameState);
    }    
    
    depth = 3;
    
    //If there is no move to push to corner or it is already in a corner.
    //Run the algorithm to find the best move.
    if(_globalMove==null) {
      List<Move> prevMoves = new List<Move>();
      calculateMove(gameState, cellHighestValue, depth, prevMoves);
    }
    
    //make the move
    Game.move(_globalMove);
  }
  
  
  //pushToCorner()
  //Simulates all possible moves until we find one where the highest value is 
  //in a corner. Returns that move.  
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
    
    return null; //Couldn't put the highest value in the corner.
  }
  
  
  //calculateMove()
  //Recursive. 
  //Calculates move based on which move or combination of moves (depending on the
  //value of depth) reaches the highest value of "decrecimientos".
  //Since we explore movements until a combination of depth+1 moves we do this in
  //a recursive way.
  //
  List<int> calculateMove(GameState gameState, GridCoordinates cellHighestValue, int depth, List<Move> prevMoves) {
    List<int> decrecimientos = new List<int>(); //array that will contain the different amount of decrecimientos from up/down/left/right.
    List<Move> moveList = new List<Move>(); //array to contain the different moves involved
    List<int> depthList = new List<int>(); //array to associate each move and decrecimientos to a certain depth in moves in the future
    List<int> aux = new List<int>();
    List<int> temp;
    List<int> returnList = new List<int>();
    GameLogic gameLogic = new GameLogic();
    GameState gs;
    
    //Up
    //We first simulate the up move in an auxiliary grid.
    //Then we check if this the opposite move (in this case down) hasn't been done
    //in the previous moves (thinking about previous move in the context of depth).
    //Example: We first simulate move down, when we try to simulate then the up
    //move it will skip tis move.
    //This is done to avoid chains like down-up (which may be the same as nothing)
    //and down-left-up. Better decision making with this option on.
    //We finally check if the move in question actually changed something in the grid.
    //This means it is a valid move.
    gs = gameLogic.simulateMove(gameState, Move.up);
    if (!prevMoves.contains(Move.down) && gs.hasMoved()) {
      //Get the values corresponding to the up move.
      aux = calculateMaxDecrecimientos(gs.getGrid(), cellHighestValue, true, false);
      decrecimientos.add(aux[1]);
      moveList.add(Move.up);
      depthList.add(depth);
      
      //If we haven't reached depth=0, we continue simulating moves in the future.
      //We also make sure that by moving in this direction we don't end up with a zero 
      //in the spot where the highest number was.
      if (depth != 0 && aux[1] != 0) {
        List<Move> newPrevMoves = cloneListMove(prevMoves);
        newPrevMoves.add(Move.up);
        temp = calculateMove(gs, cellHighestValue, depth-1, newPrevMoves);
        //If the return is -1 in the first element means no moves are good
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
        temp = calculateMove(gs, cellHighestValue, depth-1, newPrevMoves);
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
        temp = calculateMove(gs, cellHighestValue, depth-1, newPrevMoves);
        if (temp[0] != -1) {
          decrecimientos.add(temp[0]);
          moveList.add(Move.left);
          depthList.add(temp[1]);
        }
      }
    }
    
    
    //From all the decrecimientos that have been calculated we select the move
    //or chain of moves which gives the highest value.
    //If there are 2 chains of moves which have the same decrecimientos value
    //which is the maximum, we select the one which has the highest value of 
    //depth (which means it has the shorter chain).
    //We use this to prioritize the smaller chain of moves over long ones which
    //give the same results.
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
      //set the nextMove
      _globalMove = moveList[max];
      returnList.add(decrecimientos[max]);
      returnList.add(depthList[max]);
      
    } else {
      //case when no moves are good or possible
      returnList.add(-1);
      returnList.add(depth);
    }
    
    return returnList;
    
  }

  //calculateMaxDecrecimientos()
  //Recursive.
  //Function which calculates for any set grid which is the highest chain of 
  //thisCell>=nextCell in added values.
  //Parameters:
  //-grid: Grid of the game.
  //-cell: Position of the cell from which to start all the chains to test for highest decrecimientos.
  //-isFirst: Boolean used to define if this is the first pass of the function, given that it's recursive.
  //-breakZigZag: Boolean used to know whether the zig-zag condition has been broken.
  List<int> calculateMaxDecrecimientos(Grid grid, GridCoordinates cell, bool isFirst, bool breakZigZag) {
    List<int> count = new List<int>(); //List which contains the length of the chain. Not actually used in any way, kept for historical/debugging reasons.
    List<int> addedcount = new List<int>(); //List which contains the added values of all the elements in the chain
    int cellValue = grid.getValue(cell.x, cell.y); //Value of the primary cell where all chains start
    int max = 300000; //An exagerated big number, higher than the possible values in the grid. Used to mark where the chain has already passed (not to count one same element twice).
    List<int> returnList = new List<int>(); //The first element will contain the amount of elements in the chain. The second value in the array will have the value of decrecimientos.
    List<int> auxList;
    bool auxZigZag;
    
    if(cellValue==0) { //Stop the chain if we find a zero.
      returnList.add(-1);
      returnList.add(0); //Currently added value is zero logically.
      return returnList;
    }
    
    //Down
    //We first check if the cell immediately below this cell (the candidate to
    //next element of the chain) is inside the grid.
    //Then we check if the value of the candidate cell is <= this cell.
    if(!grid.isOutOfBounds(cell.x+1,cell.y) && grid.getValue(cell.x, cell.y) >= grid.getValue(cell.x+1, cell.y)) {
      factor(1, 0, cell, isFirst, breakZigZag); //The function is called to set the direction of the zig-zag.
      auxZigZag = (factor(1, 0, cell, false, breakZigZag) == 1); //We check if moving in the x axis means breaking the zig-zag.
      grid.setValue(cell.x, cell.y, max); //This cell value is set to the max value to avoid chain looping.
      
      auxList = calculateMaxDecrecimientos(grid, new GridCoordinates(cell.x+1,cell.y), false, auxZigZag); //recursive call in said direction.
      count.add(auxList[0]+1); //We set the current length of the chain.
      
      //We add to the added value of the elements of the chain (decrecimientos)
      //the current value of the cell multiplied by a factor which is 1 or 2.
      //More is explained of this factor in the corresponding function.
      addedcount.add(auxList[1]+cellValue*factor(1, 0, cell, false, breakZigZag));
      
      grid.setValue(cell.x, cell.y, cellValue); //We restore the value of this cell to its original value
      if(grid.getValue(cell.x, cell.y) == grid.getValue(cell.x+1, cell.y)) {
        //If we advance in the direction of a cell which has the same value as this one
        //we discount 1 from the added count. This is used to favor having 128-64-2 rather
        //than 128-32-32-2.
        //Discounting one is not enough to make 8-4-2 preferable over 8-4-4.
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
    
    if(addedcount.length != 0) { //If the list is empty there is no way to continue the chain.
      int maxcount = 0;
      
      for(int i=1; i<addedcount.length; i++) {
        if(addedcount[i] > addedcount[maxcount]) { //We keep the highest value of decrecimientos.
          maxcount = i;
        }
      }
      
      returnList.add(count[maxcount]);
      returnList.add(addedcount[maxcount]);
      return returnList;
    }
    //This is the list to return in case no continuing the chain is possible.
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
        
        if (iterator.getCellValue() > highestValue) { //If it's the highest value save coordinates
          coordinates = iterator.getGridCoordinates();
          
        } else if (iterator.getCellValue() == highestValue) { 
          //If value is equal, check if corner. If so, save.
          //This is used to prioritize the highest value to be in the corner rather than in
          //another place if its the same value.
          GridCoordinates c = iterator.getGridCoordinates();
          if (isCornered(c)) {
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
  //Returns true if coordinates are that of a corner of a grid
  bool isCornered(GridCoordinates coordinates) {
    return ((coordinates.x==0 || coordinates.x==3) && (coordinates.y==0 || coordinates.y==3));
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
  //This function has its use to favor the zig-zag form of the grid rather than chains
  //that have a random path in the grid.
  //Basicaly we define the mayor orientation of the zig-zag by the orientation of the
  //lines it contains.
  //If we are moving in the direction of the zig-zag and we haven't broken the zig-zag
  //(moved in a different direction), then we return a factor of 2.
  //In the other case we return a factor of 1 (no preference).
  //If the chain in of the form 128-64 and there are 2 possible ways, on in zig-zag with
  //a value of 32 and another way with the value 64, we will chose the way in zig-zag.
  //The added sum in zig-zag will be 128*2+64*2+32*2=448
  //The added sum in not zig-zag will be 128*2+64*2+64-1=447
  //So we will preffer the zig-zag way over the other one.
  int factor(int currentx, int currenty, GridCoordinates cell, bool first, bool breakZigZag) {
    if(breakZigZag) {
      return 1;
      
    } else if (first) { //Set the current direction of the zig-zag.
      _globalDirectionX = currentx; 
      _globalDirectionY = currenty;
      return 2;
    
    } else if (isCornered(cell)) {
      //This is used to keep the zig-zag after the first corner, 
      //if we go further it will not work. Good aproximation to
      //get 2048 as we only have one turn in the zig-zag to reach
      //it.
      return 2;
      
    } else if(currentx == _globalDirectionX && currenty == _globalDirectionY) {
      return 2;
    
    } else {
      return 1;
    }
  }
  
  
}