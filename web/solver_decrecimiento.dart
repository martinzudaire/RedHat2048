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
    //testGrid = new Grid.fromJSON(("[2, 4, 8, 16],[2, 8, 0, 0],[2, 0, 2, 0],[0, 0, 0, 0]"));
    //testGrid.getMatrix().printMatrix();
    List<int> punto = this.puntoMasGrande(testGrid);
    List<int> auxpunto = new List<int>();
    bool esquinado = false;
    int depth = 0;
    
    auxpunto.add(0);
    auxpunto.add(0);
    //no importa mucho esta parte, solo corro donde comienzan los caminos a las esquinas
    //muy probablemente lo cambie
    auxpunto[0] = ((punto[0]+0.25)/2.0).truncate()*3;
    auxpunto[1] = ((punto[1]+0.25)/2.0).truncate()*3;
    esquinado = (punto[0]==auxpunto[0] && punto[1]==auxpunto[1]);
    //punto[0] = auxpunto[0];
    //punto[1] = auxpunto[1];
    
    this.globalMove = Move.none;
    
    this.volverEsquina(testGrid,esquinado);
    
    if(moves>=300)
    {
      depth = 3;
    }
    if(moves<300)
    {
      depth = 2;
    }
    if(moves<200)
    {
      depth = 1;
    }
    if(moves<100)
    {
      depth = 0;
    }
    
    
    if(this.globalMove == Move.none)
    {
      List<Move> prevMoves = new List<Move>();
      this.getMove(testGrid, punto, depth, prevMoves, 0);
    }
    if(1 == 300)
    {
      print(this.globalMove.getValue());
      print(punto.toString());
      return;
    }
    Game.move(this.globalMove);
  }
  
  int getMove(Grid testGrid, List<int> punto, int depth, List<Move> pMoves, int amountMoves)
  {
    List<int> decrecimientos = new List<int>(); //array that will contain the different amount of decrecimientos from up/down/left/right
    List<Move> prevMoves = this.cloneList(pMoves,amountMoves);
    List<Move> moveList = new List<Move>();
    int count = 0;
    List<int> aux = new List<int>();
    Grid moveGrid = testGrid.clone();
    int temp;
    
    //arriba
    moveGrid.simulateMoveUp();
    if(isInList(prevMoves, amountMoves, Move.down) == false && moveGrid.compareGrid(testGrid) != 0)
    {
      aux = this.maxDecrecimientosList(moveGrid,punto[0],punto[1],true);
      decrecimientos.add(aux[1]);
      moveList.add(Move.up);
      count++;
      if(depth != 0 && aux[1] != 0)
      {
        prevMoves.add(Move.up);
        temp = this.getMove(moveGrid, punto, depth-1, prevMoves, amountMoves+1);
        if(temp != -1)
        {
          decrecimientos.add(temp);
          moveList.add(Move.up);
          count++;
        }
      }
    }
    prevMoves = this.cloneList(pMoves,amountMoves);
    moveGrid = testGrid.clone();
    //abajo
    moveGrid.simulateMoveDown();
    if(isInList(prevMoves, amountMoves, Move.up) == false && moveGrid.compareGrid(testGrid) != 0)
    {
      aux = this.maxDecrecimientosList(moveGrid,punto[0],punto[1],true);
      decrecimientos.add(aux[1]);
      moveList.add(Move.down);
      count++;
      if(depth != 0 && aux[1] != 0)
      {
        prevMoves.add(Move.down);
        temp = this.getMove(moveGrid, punto, depth-1, prevMoves, amountMoves+1);
        if(temp != -1)
        {
          decrecimientos.add(temp);
          moveList.add(Move.down);
          count++;
        }
      }
    }
    prevMoves = this.cloneList(pMoves,amountMoves);
    moveGrid = testGrid.clone();
    //derecha
    moveGrid.simulateMoveRight();
    if(isInList(prevMoves, amountMoves, Move.left) == false && moveGrid.compareGrid(testGrid) != 0)
    {
      aux = this.maxDecrecimientosList(moveGrid,punto[0],punto[1],true);
      decrecimientos.add(aux[1]);
      moveList.add(Move.right);
      count++;
      if(depth != 0 && aux[1] != 0)
      {
        prevMoves.add(Move.right);
        temp = this.getMove(moveGrid, punto, depth-1, prevMoves, amountMoves+1);
        if(temp != -1)
        {
          decrecimientos.add(temp);
          moveList.add(Move.right);
          count++;
        }
      }
    }
    prevMoves = this.cloneList(pMoves,amountMoves);
    moveGrid = testGrid.clone();
    //izquierda
    moveGrid.simulateMoveLeft();
    if(isInList(prevMoves, amountMoves, Move.right) == false && moveGrid.compareGrid(testGrid) != 0)
    {
      aux = this.maxDecrecimientosList(moveGrid,punto[0],punto[1],true);
      decrecimientos.add(aux[1]);
      moveList.add(Move.left);
      count++;
      if(depth != 0 && aux[1] != 0)
      {
        prevMoves.add(Move.left);
        temp = this.getMove(moveGrid, punto, depth-1, prevMoves, amountMoves+1);
        if(temp != -1)
        {
          decrecimientos.add(temp);
          moveList.add(Move.left);
          count++;
        }
      }
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
  
  void volverEsquina(Grid grid, bool esquinado)
  {
    if(esquinado == true)
    {
      return;
    }
    Grid moveGrid = grid.clone();
    
    //arriba
    moveGrid.simulateMoveUp();
    if(this.enEsquina(this.puntoMasGrande(moveGrid)) == true)
    {
      this.globalMove = Move.up;
      return;
    }
    moveGrid = grid.clone();
    
    //abajo
    moveGrid.simulateMoveDown();
    if(this.enEsquina(this.puntoMasGrande(moveGrid)) == true)
    {
      this.globalMove = Move.down;
      return;
    }
    moveGrid = grid.clone();
    
    //derecha
    moveGrid.simulateMoveRight();
    if(this.enEsquina(this.puntoMasGrande(moveGrid)) == true)
    {
      this.globalMove = Move.right;
      return;
    }
    moveGrid = grid.clone();

    //izquierda
    moveGrid.simulateMoveLeft();
    if(this.enEsquina(this.puntoMasGrande(moveGrid)) == true)
    {
      this.globalMove = Move.left;
      return;
    }
  }
  
  /*
   * Really cool algorithm that solves the game.
   * Decrecimientos: Empezamos del punto (x,y) y vemos para que lado se cumple que element(x,y) > element(siguiente punto arriba-abajo-etc)
   * Para ese lado contamos la cantidad de decrecimientos de manera recursiva. Basicamente se buscan todos los caminos donde se cumple
   * que cada elemento es mayor o igual al siguiente. De todos los caminos que existen a partir de un punto nos quedamos con el que tenga
   * la mayor suma de elementos. Por ejemplo si tenemos dos caminos que empiezan de un punto de valor 16 y son 16-16-2 y 16-8-4-2 nos
   * quedamos con el de 16-16-2.
   */
  List<int> maxDecrecimientosList(Grid grid, int x, int y, bool first)
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
      auxList = this.maxDecrecimientosList(grid,x+1,y,false);
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
      auxList = this.maxDecrecimientosList(grid,x-1,y,false);
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
      auxList = this.maxDecrecimientosList(grid,x,y+1,false);
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
      auxList = this.maxDecrecimientosList(grid,x,y-1,false);
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
  
  bool enEsquina(List<int> punto)
  {
    List<int> auxpunto = new List<int>();
    auxpunto.add(0);
    auxpunto.add(0);
    auxpunto[0] = ((punto[0]+0.25)/2.0).truncate()*3;
    auxpunto[1] = ((punto[1]+0.25)/2.0).truncate()*3;
    return (punto[0]==auxpunto[0] && punto[1]==auxpunto[1]);
  }
  
  List<Move> cloneList(List<Move> moves, int amount)
  {
    List<Move> list = new List<Move>();
    for(int i=0; i<amount; i++)
    {
      list.add(moves[i]);
    }
    return list;
  }
  
  bool isInList(List<Move> list, int length, Move element)
  {
    for(int i=0; i<length; i++)
    {
      if(list[i] == element)
      {
        return true;
      }
    }
    return false;
  }
}