library web_request;

import 'dart:html';
import 'game_state.dart';
import 'grid.dart';
import 'move.dart';
import 'observer.dart';


///
/// WEBREQUEST
/// 
/// Async. Handles all the JSON. 
/// Notifies Game when it obtains and parses the JSON from the server.
///


class WebRequest {

  static String start_url = "http://nodejs2048-universidades.rhcloud.com/hi/start/OMEGA/json";
  static String state_url = "http://nodejs2048-universidades.rhcloud.com/hi/state/";
  
  String _sessionId;
  GameState _lastGameState;  
  List<Observer> _listObservers;
  
  //Constructor
  WebRequest() {
    this._sessionId = null;
    this._lastGameState = null;
    this._listObservers = new List<Observer>();
  }
  
  
  //getFirstState()
  void getFirstState() {    
    HttpRequest.getString(start_url).then((String fileContents) {
      _processData(fileContents);
    }).catchError((Error error) {
      print(error.toString());
    });
  }
  
  
  //getState()
  void getState() {
    String url = state_url + _sessionId + "/json";
    HttpRequest.getString(url).then((String fileContents) {
      _processData(fileContents);
    }).catchError((Error error) {
      print(error.toString());
    });
  }
  
  
  //postMove()
  void postMove(Move move) {
    String url = state_url + _sessionId + "/move/" + move.toString() + "/json";
    HttpRequest.getString(url).then((String fileContents) {
      _processData(fileContents);
    }).catchError((Error error) {
        print(error.toString());
    });
  }
  
  
  GameState getGameState() => _lastGameState;
  
  
  //addObserver()
  void addObserver(Observer o) {
    if (o!=null) {
      _listObservers.add(o);
    }
  }
  
  //removeObserver()
  void removeObserver(Observer o) {
    if (o!=null) {
      _listObservers.remove(o);
    }
  }
  
  //notifyObservers()
  void notifyObservers() {
    for (Observer o in _listObservers) {
      o.notify();
    }
  }
  
  
  //_processData()
  //Private. 
  void _processData(String data) {    
    int start = 9;
    int end;
    String text;
    
    Grid grid;
    int score;
    int points;
    int moves;
    bool moved;
    bool over;
    bool won;
    
    
    //grid
    for(end=start; data[end]!='\"'; end++){}
    text = data.substring(start,end-2) + ',';
    grid = new Grid.fromJSON(text); 
    
    //score
    for(start=end; data[start]!=':'; start++){}
    for(end=start; data[end]!=','; end++){}
    score = int.parse(data.substring(start+1,end));
    
    //points
    for(start=end; data[start]!=':'; start++){}
    for(end=start; data[end]!=','; end++){}
    points = int.parse(data.substring(start+1,end));
    
    //moved
    for(start=end; data[start]!=':'; start++){}
    for(end=start; data[end]!=','; end++){}
    moved = (data.substring(start+1,end) == 'true');
    
    //over
    for(start=end; data[start]!=':'; start++){}
    for(end=start; data[end]!=','; end++){}
    over = (data.substring(start+1,end) == 'true');
    
    //won
    for(start=end; data[start]!=':'; start++){}
    for(end=start; data[end]!=','; end++){}
    won = (data.substring(start+1,end) == 'true');
    
    //moves
    for(start=end; data[start]!=':'; start++){}
    for(end=start; data[end]!=','; end++){}
    moves = int.parse(data.substring(start+1,end));
    
    //skip group
    for(start=end; data[start]!=':'; start++){}
    for(end=start; data[end]!=','; end++){}
    
    //session id
    for(start=end; data[start]!=':'; start++){}
    for(end=start; data[end]!='}'; end++){}
    _sessionId = data.substring(start+2,end-1);
    
    
    _lastGameState = new GameState.fromJSON(grid, score, points, moves, moved, over, won);
    
    notifyObservers();
  }
  
}