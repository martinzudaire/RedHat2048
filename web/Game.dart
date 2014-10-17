library Game;
import 'WebRequest.dart';
import 'Matrix.dart';

class Game
{
  WebRequest webRequest;
  Matrix grid;
  int score,points,moves;
  bool moved,over,won;
  String sessionId;
  static int UP = 0;
  static int RIGHT = 1;
  static int DOWN = 2;
  static int LEFT = 3;
  
  Game()
  {
    this.webRequest = new WebRequest(this);
  }
  
  void start()
  {
    this.webRequest.getFirstState();
  }
  
  void solve()
  {
    this.grid.printMatrix();
    
    if(this.won == false && this.over == false)
    {
      //we always begin with (0,0) occupied by something, we make sure with this
      if(this.moves < 2 && this.grid.getElement(0, 0) == 0)
      {
        if(this.moves == 0)
        {
          this.webRequest.postMove(UP);
        } else
        {
          this.webRequest.postMove(LEFT);
        }
        return;
      }
        
    } else
    {
      if(this.over == true) print("GAME OVER :(");
      if(this.won == true) print("We win :D");
    }
  }
}