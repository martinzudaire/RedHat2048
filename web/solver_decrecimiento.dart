library solver_decrecimiento;

import 'game_solver.dart';
import 'game.dart';
import 'move.dart';
import 'grid.dart';

class SolverDecrecimiento extends GameSolver {
  
  SolverDecrecimiento() 
  {
    
  }
  
  void move() 
  {
    Grid testGrid = Game.getCurrentGameState().getGrid().clone();
    Grid moveGrid = testGrid.clone();
    int moves = Game.getCurrentGameState().getMoves();
    List<int> decrecimientos = new List<int>();
    List<Move> moveList = new List<Move>();
    int count = 0;
    
    if(testGrid.getElement(0, 0) == 0 && moves > 10)
    {
      return;
    }
    //arriba
    moveGrid.simulateMoveUp();
    if(moveGrid.compareGrid(testGrid) != 0)
    {
      decrecimientos.add(this.maxDecrecimientos(moveGrid,0,0));
      moveList.add(Move.up);
      count++;
    }
    moveGrid = testGrid.clone();
    //abajo
    moveGrid.simulateMoveDown();
    if(moveGrid.compareGrid(testGrid) != 0)
    {
      decrecimientos.add(this.maxDecrecimientos(moveGrid,0,0));
      moveList.add(Move.down);
      count++;
    }
    moveGrid = testGrid.clone();
    //derecha
    moveGrid.simulateMoveRight();
    if(moveGrid.compareGrid(testGrid) != 0)
    {
      decrecimientos.add(this.maxDecrecimientos(moveGrid,0,0));
      moveList.add(Move.right);
      count++;
    }
    moveGrid = testGrid.clone();
    //izquierda
    moveGrid.simulateMoveLeft();
    if(moveGrid.compareGrid(testGrid) != 0)
    {
      decrecimientos.add(this.maxDecrecimientos(moveGrid,0,0));
      moveList.add(Move.left);
      count++;
    }
    
    if(count>0)
    {
      int max = decrecimientos[0];
      Move movimiento = moveList[0];
      for(int i=1; i<count; i++)
      {
        if(decrecimientos[i] > max)
        {
          movimiento = moveList[i];
          max = decrecimientos[i];
        }
      }
      Game.move(movimiento);
    } else
    {
      print("perdio");
    }
  }
  
  int maxDecrecimientos(Grid grid, int x, int y)
  {
    List<int> count = new List<int>();
    int max = 300000;
    int aux = grid.getElement(x, y);
    int elements = 0;
    
    if(aux == 0)
    {
      return -1;
    }
    
    if(this.outOfBounds(x+1,y) == false && grid.getElement(x, y) >= grid.getElement(x+1, y))
    {
      grid.setElement(x, y, max);
      count.add(this.maxDecrecimientos(grid, x+1, y)+1);
      grid.setElement(x, y, aux);
      elements++;
    }
    if(this.outOfBounds(x-1,y) == false && grid.getElement(x, y) >= grid.getElement(x-1, y))
    {
      grid.setElement(x, y, max);
      count.add(this.maxDecrecimientos(grid, x-1, y)+1);
      grid.setElement(x, y, aux);
      elements++;
    }
    if(this.outOfBounds(x,y+1) == false && grid.getElement(x, y) >= grid.getElement(x, y+1))
    {
      grid.setElement(x, y, max);
      count.add(this.maxDecrecimientos(grid, x, y+1)+1);
      grid.setElement(x, y, aux);
      elements++;
    }
    if(this.outOfBounds(x,y-1) == false && grid.getElement(x, y) >= grid.getElement(x, y-1))
    {
      grid.setElement(x, y, max);
      count.add(this.maxDecrecimientos(grid, x, y-1)+1);
      grid.setElement(x, y, aux);
      elements++;
    }
    if(elements != 0)
    {
      int maxcount = count[0];
      for(int i=1; i<elements; i++)
      {
        if(count[i] > maxcount)
        {
          maxcount = count[i];
        }
      }
      return maxcount;
    }
    return 0;
  }
  
  bool outOfBounds(int x, int y)
  {
    if(x>=0 && x<4 && y>=0 && y<4)
    {
      return false;
    }
    return true;
  }
}