library game;

import 'web_request.dart';
import 'game_state.dart';
import 'move.dart';
import 'observer.dart';

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
  
  List<Observer> _listObservers;
  
  factory Game() {
    return _instance;
  }
  
  // Private constructor
  Game._internal() {
    this.webRequest = new WebRequest();
    this._currentGameState = new GameState(); 
    this._playersTurn = false;
    this._listObservers = new List<Observer>();
  }
  
  
  // PUBLIC STATIC methods
  static void newGame() => _instance._newGame();
  static void move(Move move) => _instance._move(move);
  static GameState getCurrentGameState() => _instance._getCurrentGameState();
  static void notifyUpdate() => _instance._notifyUpdate();
  
  static void addObserver(Observer o) => _instance._addObserver(o);
  static void removeObserver(Observer o) => _instance._removeObserver(o);
    
  
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
  
  GameState _getCurrentGameState() => _currentGameState;

  
  //WebRequest calls this when it pulls the latest gamestate from the server
  void _notifyUpdate() {
    _updateGameState(this.webRequest.getGameState());
    _notifyObservers();
    _playersTurn = true;
  }
  
  
  void _addObserver(Observer o) {
    if (o!=null) {
      _listObservers.add(o);
    }
  }
  
  void _removeObserver(Observer o) {
    if (o!=null) {
      _listObservers.remove(o);
    }
  }
  
  void _notifyObservers() {
    for (Observer o in _listObservers) {
      o.notify();
    }
  }
  
  
  
  //Helpers
  void _updateGameState(GameState gs) {
    if (gs!=null) {
      _currentGameState = gs;
    }
  }
  
}