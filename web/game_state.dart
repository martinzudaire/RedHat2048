library game_state;

import 'grid.dart';

///
/// GAMESTATE
///
/// Just a data struct
///

class GameState {
  
  Grid _grid;
  int _score;
  int _points;
  int _moves;
  bool _moved;
  bool _over;
  bool _won;
  
  GameState() {
    this._grid = new Grid();
    this._score = 0;
    this._points = 0;
    this._moves = 0;
    this._moved = false;
    this._over = false;
    this._won = false;
  }
  
  GameState.fromJSON(Grid grid,
      int score,
      int points,
      int moves,
      bool moved,
      bool over,
      bool won) {
    
    this._grid = grid;
    this._score = score;
    this._points = points;
    this._moves = moves;
    this._moved = moved;
    this._over = over;
    this._won = won;
  }
  
  // Get methods
  
  Grid getGrid() => _grid;
  int getScore() => _score;
  int getPoints() => _points;
  int getMoves() => _moves;
  bool hasMoved() => _moved;
  bool isOver() => _over;
  bool isWon() => _won;
 
}