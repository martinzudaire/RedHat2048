library WebRequest;
import 'dart:html';
import 'Game.dart';
import 'Matrix.dart';

class WebRequest
{
  Game game;
  
  static String url = "http://nodejs2048-universidades.rhcloud.com/hi/start/OMEGA/json";
  
  
  WebRequest(Game game)
  {
    this.game = game;
  }
  
  void getFirstState()
  {
    HttpRequest.getString(url).then((String fileContents) 
      {
        processData(fileContents);
      }).catchError((Error error) 
      {
        print(error.toString());
      });
  }
  
  void getState()
  {
    String url = "http://nodejs2048-universidades.rhcloud.com/hi/state/" + this.game.sessionId + "/json";
    HttpRequest.getString(url).then((String fileContents) 
      {
        processData(fileContents);
      }).catchError((Error error) 
      {
        print(error.toString());
      });
  }
  
  void postMove(int move)
  {
    String url = "http://nodejs2048-universidades.rhcloud.com/hi/state/" + this.game.sessionId + "/move/" + move.toString() + "/json";
    HttpRequest.getString(url).then((String fileContents) 
      {
        processData(fileContents);
      }).catchError((Error error) 
      {
        print(error.toString());
      });
  }
  
  void processData(String data)
  {
    int start = 9;
    int end;
    String text;
    
    //grid
    for(end=start; data[end]!='\"'; end++){}
    text = data.substring(start,end-2) + ',';
    this.game.grid = Matrix.parseMatrix(text, 4, 4);
    //score
    for(start=end; data[start]!=':'; start++){}
    for(end=start; data[end]!=','; end++){}
    this.game.score = int.parse(data.substring(start+1,end));
    //points
    for(start=end; data[start]!=':'; start++){}
    for(end=start; data[end]!=','; end++){}
    this.game.points = int.parse(data.substring(start+1,end));
    //moved
    for(start=end; data[start]!=':'; start++){}
    for(end=start; data[end]!=','; end++){}
    this.game.moved = (data.substring(start+1,end) == 'true');
    //over
    for(start=end; data[start]!=':'; start++){}
    for(end=start; data[end]!=','; end++){}
    this.game.over = (data.substring(start+1,end) == 'true');
    //won
    for(start=end; data[start]!=':'; start++){}
    for(end=start; data[end]!=','; end++){}
    this.game.won = (data.substring(start+1,end) == 'true');
    //moves
    for(start=end; data[start]!=':'; start++){}
    for(end=start; data[end]!=','; end++){}
    this.game.moves = int.parse(data.substring(start+1,end));
    //skip group
    for(start=end; data[start]!=':'; start++){}
    for(end=start; data[end]!=','; end++){}
    //session id
    for(start=end; data[start]!=':'; start++){}
    for(end=start; data[end]!='}'; end++){}
    this.game.sessionId = data.substring(start+2,end-1);
    
    
    //return from this async state to the program to continue solving the game
    this.game.solve();
  }
  
}