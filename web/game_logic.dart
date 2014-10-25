library game_logic;

import 'game_state.dart';
import 'grid.dart';
import 'move.dart';
import 'web_request.dart';
import 'dart:math';
import 'observer.dart';
import 'grid_iterator.dart';


///
/// GAME LOGIC
/// 
/// Client-based version of web request. Can also be used for simulations.
/// Calculates the next GameState, and adds a random number.
///


class GameLogic implements WebRequest {
  
  Random _random;
  GameState _lastGameState;
  
  List<Observer> _listObservers;
  
  GameLogic() {
    this._random = new Random();
    this._lastGameState = new GameState();
    
    this._listObservers = new List<Observer>();
  }
  
  
  void getFirstState() {
    _lastGameState = _processNewGame();
    notifyObservers();
  }
  
  void getState() {
    //Do nothing
    notifyObservers();
  }
  
  void postMove(Move move) {
    _lastGameState = _processGameState(_lastGameState, move);
    _addRandomNumberToGrid(_lastGameState.getGrid());
    notifyObservers();
  }
  
  GameState getGameState() => _lastGameState;
  
  
  GameState simulateMove(GameState gameState, Move move) {
    return _processGameState(gameState.clone(), move);
  }
  
  
  //Observable methods
  void addObserver(Observer o) {
    if (o!=null) {
      _listObservers.add(o);
    }
  }
  
  void removeObserver(Observer o) {
    if (o!=null) {
      _listObservers.remove(o);
    }
  }
  
  void notifyObservers() {
    for (Observer o in _listObservers) {
      o.notify();
    }
  }
  
  
  
  //PRIVATE
  
  //_processNewGame()
  GameState _processNewGame() {
    GameState gameState = new GameState();
    _addRandomNumberToGrid(gameState.getGrid());
    _addRandomNumberToGrid(gameState.getGrid());
    return gameState;
  }
  
  //_processNewRandomNumber()
  void _processNewRandomNumber(GameState gameState) {
    _addRandomNumberToGrid(gameState.getGrid());
  }
  
  
  //_processGameState()
  GameState _processGameState(GameState gameState, Move move) {

    GridIterator iterator = new GridIterator(gameState.getGrid(), move);
    GridIterator iteratorHelper = new GridIterator(gameState.getGrid(), move);
    bool moved = false;
    bool won = false;
    bool over = false;
    int points = 0; 
    
    while (!iterator.isRowDone()) {
      
      //Advance one cell (we don't want to compare the same cell)
      iterator.nextCell();
      
      while (!iterator.isCellDone()) {
        
        if (iterator.getCellValue() == 0) { //Found a zero, advance to next cell
          iterator.nextCell();
          
        } else if (iterator.getCellValue() == iteratorHelper.getCellValue()) { //Numbers are equal => MERGE!
          moved = true;
          if (iteratorHelper.getCellValue()*2 == 2048) won = true;
          points += iteratorHelper.getCellValue()*2;
          iteratorHelper.setCellValue(iteratorHelper.getCellValue()*2);
          iteratorHelper.nextCell(); //We can't have multiple merges with one cell
          iterator.setCellValue(0);
          iterator.nextCell();
          
        } else { //Numbers are not equal => MOVE!
          
          if (iteratorHelper.getCellValue() != 0) { //Not a zero, check next position
            iteratorHelper.nextCell();
            
            if (iteratorHelper.getCellValue() != 0) { //There is no zero, can't move!
              iterator.nextCell();
              
            } else { //There is a zero, move here!
              moved = true;
              iteratorHelper.setCellValue(iterator.getCellValue());
              iterator.setCellValue(0);
              iterator.nextCell();
            }
            
          } else { //This is a zero, move here!
            moved = true;
            iteratorHelper.setCellValue(iterator.getCellValue());
            iterator.setCellValue(0);
            iterator.nextCell();            
          } 
        }
        
      }
      
      iterator.nextRow();
      iterator.firstCell();
      iteratorHelper.nextRow();
      iteratorHelper.firstCell();
    }    

    over = (won || _getNumberOfEmptyCells(gameState.getGrid()) <= 1);
    
    return new GameState.fromJSON(gameState.getGrid(), gameState.getScore()+points, points, gameState.getMoves()+1, moved, over, won);
     
  }
  
  
  //_addRandomNumberToGrid()
  void _addRandomNumberToGrid(Grid grid) {
    
    int numberOfEmptyCells = _getNumberOfEmptyCells(grid);
    if (numberOfEmptyCells<=0) return; //No empty spaces, can't add a random number

    GridIterator iterator = new GridIterator(grid, Move.left); //Direction is irrelevant here
    int randomCell = _random.nextInt(numberOfEmptyCells)+1;    
    int emptyCell = 0;
   
    while (!iterator.isRowDone() && emptyCell!=randomCell) {
      while (!iterator.isCellDone() && emptyCell!=randomCell) {
        
        if (iterator.getCellValue()==0) emptyCell++;
        if (emptyCell==randomCell) iterator.setCellValue((_random.nextDouble()<0.9 ? 2 : 4));
        
        iterator.nextCell();        
      }
      iterator.nextRow();
      iterator.firstCell();
    }
    
  }
  
  
  //getNumberOfEmptySpaces()
  int _getNumberOfEmptyCells(Grid grid) {
    GridIterator iterator = new GridIterator(grid, Move.left); //Direction is irrelevant here
    int emptyCells = 0;
    
    while (!iterator.isRowDone()) {
      while (!iterator.isCellDone()) {
        
        if (iterator.getCellValue()==0) emptyCells++;
        
        iterator.nextCell();
      }
      iterator.nextRow();
      iterator.firstCell();
    }
    
    return emptyCells;
  }
  
}