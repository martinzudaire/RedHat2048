library game;

import 'web_request.dart';
import 'game_state.dart';
import 'move.dart';

///
/// GAME
/// 
/// Singleton.
///
///

class Game {
  
  static final Game _instance = new Game._internal();
  
  WebRequest webRequest;
  GameState _currentGameState;
  bool _playersTurn;
  
  factory Game() {
    return _instance;
  }
  
  // Private constructor
  Game._internal() {
    this.webRequest = new WebRequest();
    this._currentGameState = new GameState(); 
    this._playersTurn = false;
  }
  
  
  // PUBLIC STATIC methods
  static void newGame() => _instance._newGame();
  static void move(Move move) => _instance._move(move);
  static void notifyUpdate() => _instance._notifyUpdate();
  static GameState getCurrentGameState() => _instance._getCurrentGameState();
    
  
  //
  // PRIVATE
  //
  
  void _newGame() {
    this.webRequest.getFirstState();    
  }
  
  void _move(Move move) {
    this.webRequest.postMove(move);
    _playersTurn = false;
  }
  
  void _notifyUpdate() {
    _updateGameState(this.webRequest.getGameState());
    _playersTurn = true;
  }
  
  GameState _getCurrentGameState() => _currentGameState;
  
  //Helpers
  void _updateGameState(GameState gs) {
    if (gs!=null) {
      _currentGameState = gs;
    }
  }
  
}