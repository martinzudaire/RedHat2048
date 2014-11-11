library solver_decrecimiento;

import 'game_solver.dart';
import 'game.dart';
import 'move.dart';
import 'grid.dart';
import 'matrix.dart';

///
/// SOLVER DECRECIMIENTO
///
/// Calculates the moves based on maximazing the amount of decrecimientos.
///

class SolverDecrecimiento extends GameSolver {
  
  Move globalMove = Move.none;
  
  SolverDecrecimiento() 
  {
    
  }
  
  void move() 
  {
    Grid testGrid = Game.getCurrentGameState().getGrid().clone(); //this is the current grid getting it from currentGameState
    int moves = Game.getCurrentGameState().getMoves();
    //testGrid = new Grid.fromJSON(("[2, 0, 0, 4],[0, 0, 0, 0],[0, 0, 0, 4],[0, 0, 8, 8]"));
    //testGrid.getMatrix().printMatrix();
    List<int> punto = this.puntoMasGrande(testGrid);
    List<int> auxpunto = new List<int>();
    
    auxpunto.add(0);
    auxpunto.add(0);
    //no importa mucho esta parte, solo corro donde comienzan los caminos a las esquinas
    //muy probablemente lo cambie
    auxpunto[0] = ((punto[0]+0.25)/2.0).truncate()*3;
    auxpunto[1] = ((punto[1]+0.25)/2.0).truncate()*3; 
    
    if(moves >= 0)
    {
      punto[0] = auxpunto[0];
      punto[1] = auxpunto[1];
    }
    this.getMove(testGrid, punto, false, Move.none);
    if(1 == 200)
    {
      print(this.globalMove.getValue());
      print(punto.toString());
      return;
    }
    Game.move(this.globalMove);
  }
  
  int getMove(Grid testGrid, List<int> punto, bool limit, Move prevMove)
  {
    List<int> decrecimientos = new List<int>(); //array that will contain the different amount of decrecimientos from up/down/left/right
    List<Move> moveList = new List<Move>();
    int count = 0;
    List<int> aux = new List<int>();
    Grid moveGrid = testGrid.clone();
    int temp;
    
    //arriba
    moveGrid.simulateMoveUp();
    if(prevMove != Move.down && moveGrid.compareGrid(testGrid) != 0)
    {
      if(limit == false)
      {
        temp = this.getMove(moveGrid, punto, true, Move.up);
        if(temp != -1)
        {
          decrecimientos.add(temp);
          moveList.add(Move.up);
          count++;
        }
      }
      aux = this.maxDecrecimientosList(moveGrid,punto[0],punto[1]);
      decrecimientos.add(aux[1]);
      moveList.add(Move.up);
      count++;
    }
    moveGrid = testGrid.clone();
    //abajo
    moveGrid.simulateMoveDown();
    if(prevMove != Move.up && moveGrid.compareGrid(testGrid) != 0)
    {
      if(limit == false)
      {
        temp = this.getMove(moveGrid, punto, true, Move.down);
        if(temp != -1)
        {
          decrecimientos.add(temp);
          moveList.add(Move.down);
          count++;
        }
      }
      aux = this.maxDecrecimientosList(moveGrid,punto[0],punto[1]);
      decrecimientos.add(aux[1]);
      moveList.add(Move.down);
      count++;
    }
    moveGrid = testGrid.clone();
    //derecha
    moveGrid.simulateMoveRight();
    if(prevMove != Move.left && moveGrid.compareGrid(testGrid) != 0)
    {
      if(limit == false)
      {
        temp = this.getMove(moveGrid, punto, true, Move.right);
        if(temp != -1)
        {
          decrecimientos.add(temp);
          moveList.add(Move.right);
          count++;
        }
      }
      aux = this.maxDecrecimientosList(moveGrid,punto[0],punto[1]);
      decrecimientos.add(aux[1]);
      moveList.add(Move.right);
      count++;
    }
    moveGrid = testGrid.clone();
    //izquierda
    moveGrid.simulateMoveLeft();
    if(prevMove != Move.right && moveGrid.compareGrid(testGrid) != 0)
    {
      if(limit == false)
      {
        temp = this.getMove(moveGrid, punto, true, Move.left);
        if(temp != -1)
        {
          decrecimientos.add(temp);
          moveList.add(Move.left);
          count++;
        }
      }
      aux = this.maxDecrecimientosList(moveGrid,punto[0],punto[1]);
      decrecimientos.add(aux[1]);
      moveList.add(Move.left);
      count++;
    }
    //me quedo con el que maximice la cantidad de decrecimientos
    if(count>0)
    {
      int max = 0;
      for(int i=1; i<count; i++)
      {
        if(decrecimientos[i] > decrecimientos[max])
        {
          max = i;
        }
      }
      this.globalMove = moveList[max];
      return decrecimientos[max];
    }
    return -1;
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
      if(grid.getElement(x, y) == grid.getElement(x+1, y))
      {
        addedcount[elements]--;
      }
      elements++;
    }
    if(this.outOfBounds(x-1,y) == false && grid.getElement(x, y) >= grid.getElement(x-1, y)) //izquierda
    {
      grid.setElement(x, y, max);
      auxList = this.maxDecrecimientosList(grid,x-1,y);
      count.add(auxList[0]+1);
      addedcount.add(auxList[1]+aux);
      grid.setElement(x, y, aux);
      if(grid.getElement(x, y) == grid.getElement(x-1, y))
      {
        addedcount[elements]--;
      }
      elements++;
    }
    if(this.outOfBounds(x,y+1) == false && grid.getElement(x, y) >= grid.getElement(x, y+1)) //arriba
    {
      grid.setElement(x, y, max);
      auxList = this.maxDecrecimientosList(grid,x,y+1);
      count.add(auxList[0]+1);
      addedcount.add(auxList[1]+aux);
      grid.setElement(x, y, aux);
      if(grid.getElement(x, y) == grid.getElement(x, y+1))
      {
        addedcount[elements]--;
      }
      elements++;
    }
    if(this.outOfBounds(x,y-1) == false && grid.getElement(x, y) >= grid.getElement(x, y-1)) //abajo
    {
      grid.setElement(x, y, max);
      auxList = this.maxDecrecimientosList(grid,x,y-1);
      count.add(auxList[0]+1);
      addedcount.add(auxList[1]+aux);
      grid.setElement(x, y, aux);
      if(grid.getElement(x, y) == grid.getElement(x, y-1))
      {
        addedcount[elements]--;
      }
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
    int aux1,aux2;
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
        } else if(grid.getElement(i, j) == valor)
        {
          aux1 = ((i+0.25)/2.0).truncate()*3;
          aux2 = ((j+0.25)/2.0).truncate()*3; 
          if(i==aux1 && j==aux2)
          {
            punto[0] = i;
            punto[1] = j;
            valor = grid.getElement(i, j);
          }
        }
      }
    }
    
    return punto;
  }
}