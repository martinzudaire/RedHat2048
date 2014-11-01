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
    List<int> punto = this.puntoMasGrande(testGrid);
    
    punto[0] = ((punto[0]+0.25)/2.0).truncate()*3;
    punto[1] = ((punto[1]+0.25)/2.0).truncate()*3;
    
    //arriba
    moveGrid.simulateMoveUp();
    if(moveGrid.compareGrid(testGrid) != 0)
    {
      decrecimientos.add(this.maxDecrecimientosList(moveGrid,punto[0],punto[1])[1]);
      moveList.add(Move.up);
      count++;
    }
    moveGrid = testGrid.clone();
    //abajo
    moveGrid.simulateMoveDown();
    if(moveGrid.compareGrid(testGrid) != 0)
    {
      decrecimientos.add(this.maxDecrecimientosList(moveGrid,punto[0],punto[1])[1]);
      moveList.add(Move.down);
      count++;
    }
    moveGrid = testGrid.clone();
    //derecha
    moveGrid.simulateMoveRight();
    if(moveGrid.compareGrid(testGrid) != 0)
    {
      decrecimientos.add(this.maxDecrecimientosList(moveGrid,punto[0],punto[1])[1]);
      moveList.add(Move.right);
      count++;
    }
    moveGrid = testGrid.clone();
    //izquierda
    moveGrid.simulateMoveLeft();
    if(moveGrid.compareGrid(testGrid) != 0)
    {
      decrecimientos.add(this.maxDecrecimientosList(moveGrid,punto[0],punto[1])[1]);
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
  
  
  List<int> maxDecrecimientosList(Grid grid, int x, int y)
  {
    List<int> count = new List<int>();
    List<int> addedcount = new List<int>();
    int max = 300000;
    int aux = grid.getElement(x, y);
    int elements = 0;
    List<int> returnList = new List<int>();
    List<int> auxList;
    
    if(aux == 0)
    {
      returnList.add(-1);
      returnList.add(0);
      return returnList;
    }
    
    if(this.outOfBounds(x+1,y) == false && grid.getElement(x, y) >= grid.getElement(x+1, y))
    {
      grid.setElement(x, y, max);
      auxList = this.maxDecrecimientosList(grid,x+1,y);
      count.add(auxList[0]+1);
      addedcount.add(auxList[1]+aux);
      grid.setElement(x, y, aux);
      elements++;
    }
    if(this.outOfBounds(x-1,y) == false && grid.getElement(x, y) >= grid.getElement(x-1, y))
    {
      grid.setElement(x, y, max);
      auxList = this.maxDecrecimientosList(grid,x-1,y);
      count.add(auxList[0]+1);
      addedcount.add(auxList[1]+aux);
      grid.setElement(x, y, aux);
      elements++;
    }
    if(this.outOfBounds(x,y+1) == false && grid.getElement(x, y) >= grid.getElement(x, y+1))
    {
      grid.setElement(x, y, max);
      auxList = this.maxDecrecimientosList(grid,x,y+1);
      count.add(auxList[0]+1);
      addedcount.add(auxList[1]+aux);
      grid.setElement(x, y, aux);
      elements++;
    }
    if(this.outOfBounds(x,y-1) == false && grid.getElement(x, y) >= grid.getElement(x, y-1))
    {
      grid.setElement(x, y, max);
      auxList = this.maxDecrecimientosList(grid,x,y-1);
      count.add(auxList[0]+1);
      addedcount.add(auxList[1]+aux);
      grid.setElement(x, y, aux);
      elements++;
    }
    if(elements != 0)
    {
      int maxcount = 0;
      for(int i=1; i<elements; i++)
      {
        if(addedcount[i] > addedcount[maxcount])
        {
          maxcount = i;
        }
      }
      returnList.add(count[maxcount]);
      returnList.add(addedcount[maxcount]);
      return returnList;
    }
    returnList.add(-1);
    returnList.add(0);
    return returnList;
  }
  
  bool outOfBounds(int x, int y)
  {
    if(x>=0 && x<4 && y>=0 && y<4)
    {
      return false;
    }
    return true;
  }

  int logaritmo(int element)
  {
    int x=0;
    int current = element;
    if(element == 0)
    {
      return 0;
    }
    while(element%2 == 0)
    {
      x++;
      element = (element/2).round();
    }
    return x;
  }
  
  List<int> puntoMasGrande(Grid grid)
  {
    List<int> punto = new List<int>();
    punto.add(0);
    punto.add(0);
    int valor = 0;
    
    for(int i=0; i<4; i++)
    {
      for(int j=0; j<4; j++)
      {
        if(grid.getElement(i, j) > valor)
        {
          punto[0] = i;
          punto[1] = j;
          valor = grid.getElement(i, j);
        }
      }
    }
    
    return punto;
  }
}