library solver_gradient;

import 'game_solver.dart';
import 'game.dart';
import 'move.dart';
import 'grid.dart';

class SolverGradient extends GameSolver {
  
  SolverGradient() 
  {
    
  }
  
  void move() 
  {
    Grid testGrid = Game.getCurrentGameState().getGrid().clone();
    Grid moveGrid = testGrid.clone();
    int moves = Game.getCurrentGameState().getMoves();
    List<double> gradientes = new List<double>();
    List<Move> moveList = new List<Move>();
    int count = 0;
    
    //arriba
    moveGrid.simulateMoveUp();
    if(moveGrid.compareGrid(testGrid) != 0)
    {
      gradientes.add(this.calculateGradient2(moveGrid));
      moveList.add(Move.up);
      count++;
    }
    moveGrid = testGrid.clone();
    //abajo
    moveGrid.simulateMoveDown();
    if(moveGrid.compareGrid(testGrid) != 0)
    {
      gradientes.add(this.calculateGradient2(moveGrid));
      moveList.add(Move.down);
      count++;
    }
    moveGrid = testGrid.clone();
    //derecha
    moveGrid.simulateMoveRight();
    if(moveGrid.compareGrid(testGrid) != 0)
    {
      gradientes.add(this.calculateGradient2(moveGrid));
      moveList.add(Move.right);
      count++;
    }
    moveGrid = testGrid.clone();
    //izquierda
    moveGrid.simulateMoveLeft();
    if(moveGrid.compareGrid(testGrid) != 0)
    {
      gradientes.add(this.calculateGradient2(moveGrid));
      moveList.add(Move.left);
      count++;
    }
    
    if(count>0)
    {
      double max = gradientes[0];
      Move movimiento = moveList[0];
      for(int i=1; i<count; i++)
      {
        if(gradientes[i] > max)
        {
          movimiento = moveList[i];
          max = gradientes[i];
        }
      }
      Game.move(movimiento);
    } else
    {
      print("perdio");
    }
  }
  
  double calculateGradient1(Grid grid)
  {
    double gradient = 0.0;
    int count = 0;
    for(int i=0; i<4; i++)
    {
      if(i%2 == 0)
      {
        for(int j=0; j<4; j++)
        {
          count++;
          if(j<3)
          {
            gradient += (logaritmo(grid.getValue(i, j)) - logaritmo(grid.getValue(i,j+1)))/count;
          } else
          {
            gradient += (logaritmo(grid.getValue(i, j)) - logaritmo(grid.getValue(i+1,j)))/count;
          }
        }
      } else
      {
        for(int j=3; j>=0; j--)
        {
          count++;
          if(j>0)
          {
            gradient += (logaritmo(grid.getValue(i, j)) - logaritmo(grid.getValue(i,j-1)))/count;
          } else
          {
            gradient += (logaritmo(grid.getValue(i, j)) - logaritmo(grid.getValue(i+1,j)))/count;
          }
        }
      }
    }
    return gradient;
  }

  
  double calculateGradient2(Grid grid)
  {
    double gradient = 0.0;
    int count = 0;
    for(int i=0; i<4; i++)
    {
      if(i%2 == 0)
      {
        for(int j=0; j<3; j++)
        {
          count++;
          if(grid.getValue(i, j) == 0)
          {
            return gradient;
          }
          if(j<3)
          {
            if(grid.getValue(i, j) >= grid.getValue(i, j+1))
            {
              gradient = gradient + 1.0;
            } else
            {
              return gradient;
            }
          } else
          {
            if(grid.getValue(i, j) >= grid.getValue(i+1, j))
            {
              gradient = gradient + 1.0;
            } else
            {
              return gradient;
            }
          }
        }
      } else
      {
        for(int j=0; j<3; j++)
        {
          if(grid.getValue(i, j) == 0)
          {
            return gradient;
          }
          count++;
          if(j<3)
          {
            if(grid.getValue(i, j) >= grid.getValue(i, j-1))
            {
              gradient = gradient + 1.0;
            } else
            {
              return gradient;
            }
          } else
          {
            if(grid.getValue(i, j) >= grid.getValue(i+1, j))
            {
              gradient = gradient + 1.0;
            } else
            {
              return gradient;
            }
          }
        }
      }
    }
    return gradient;
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
}