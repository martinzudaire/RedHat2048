library solver_decrecimiento;

import 'game_solver.dart';
import 'game.dart';
import 'move.dart';
import 'grid.dart';

///
/// SOLVER DECRECIMIENTO
///
/// Calculates the moves based on maximazing the amount of decrecimientos.
///

class SolverDecrecimiento extends GameSolver {
  
  SolverDecrecimiento() 
  {
    
  }
  
  void move() 
  {
    Grid testGrid = Game.getCurrentGameState().getGrid().clone(); //this is the current grid getting it from currentGameState
    Grid moveGrid = testGrid.clone(); //we use this to simulate the moves and not lose the current grid
    int moves = Game.getCurrentGameState().getMoves();
    List<int> decrecimientos = new List<int>(); //array that will contain the different amount of decrecimientos from up/down/left/right
    List<Move> moveList = new List<Move>();
    int count = 0;
    List<int> punto = this.puntoMasGrande(testGrid);
    
    //no importa mucho esta parte, solo corro donde comienzan los caminos a las esquinas
    //muy probablemente lo cambie
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
    //me quedo con el que maximice la cantidad de decrecimientos
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
  
  //useless method, just kept here because reasons
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
  
  /*
   * Really cool algorithm that solves the game.
   * Decrecimientos: Empezamos del punto (x,y) y vemos para que lado se cumple que element(x,y) > element(siguiente punto arriba-abajo-etc)
   * Para ese lado contamos la cantidad de decrecimientos de manera recursiva. Basicamente se buscan todos los caminos donde se cumple
   * que cada elemento es mayor o igual al siguiente. De todos los caminos que existen a partir de un punto nos quedamos con el que tenga
   * la mayor suma de elementos. Por ejemplo si tenemos dos caminos que empiezan de un punto de valor 16 y son 16-16-2 y 16-8-4-2 nos
   * quedamos con el de 16-16-2.
   */
  List<int> maxDecrecimientosList(Grid grid, int x, int y)
  {
    List<int> count = new List<int>();
    List<int> addedcount = new List<int>();
    int max = 300000; //es medio bestia pero reemplazo el valor actual (x,y) para que cuando entremos en la recursion no vuelva por el camino que vino
    int aux = grid.getElement(x, y);
    int elements = 0;
    List<int> returnList = new List<int>();
    List<int> auxList;
    
    if(aux == 0) //dejar de contar si nos encontramos un cero
    {
      returnList.add(-1);
      returnList.add(0);
      return returnList;
    }
    
    if(this.outOfBounds(x+1,y) == false && grid.getElement(x, y) >= grid.getElement(x+1, y)) //derecha
    {
      grid.setElement(x, y, max);
      auxList = this.maxDecrecimientosList(grid,x+1,y);
      count.add(auxList[0]+1);
      addedcount.add(auxList[1]+aux);
      grid.setElement(x, y, aux);
      elements++;
    }
    if(this.outOfBounds(x-1,y) == false && grid.getElement(x, y) >= grid.getElement(x-1, y)) //izquierda
    {
      grid.setElement(x, y, max);
      auxList = this.maxDecrecimientosList(grid,x-1,y);
      count.add(auxList[0]+1);
      addedcount.add(auxList[1]+aux);
      grid.setElement(x, y, aux);
      elements++;
    }
    if(this.outOfBounds(x,y+1) == false && grid.getElement(x, y) >= grid.getElement(x, y+1)) //arriba
    {
      grid.setElement(x, y, max);
      auxList = this.maxDecrecimientosList(grid,x,y+1);
      count.add(auxList[0]+1);
      addedcount.add(auxList[1]+aux);
      grid.setElement(x, y, aux);
      elements++;
    }
    if(this.outOfBounds(x,y-1) == false && grid.getElement(x, y) >= grid.getElement(x, y-1)) //abajo
    {
      grid.setElement(x, y, max);
      auxList = this.maxDecrecimientosList(grid,x,y-1);
      count.add(auxList[0]+1);
      addedcount.add(auxList[1]+aux);
      grid.setElement(x, y, aux);
      elements++;
    }
    
    if(elements != 0) //si esta vacio es porque no hay camino para ningun lado
    {
      int maxcount = 0;
      for(int i=1; i<elements; i++)
      {
        if(addedcount[i] > addedcount[maxcount]) //nos quedamos con el mas grande
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