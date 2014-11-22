library grid;

import 'matrix.dart';
import 'grid_coordinates.dart';

///
/// GRID
/// 
/// Grid representation. 4x4 matrix.
/// 
///

class Grid {
  
  Matrix _grid;
  
  Grid() {
    _grid = new Matrix.fromZero(4, 4);
  }
  
  Grid.fromJSON(String json) {
    _grid = Matrix.parseMatrix(json, 4, 4);
  }
  
  Grid.fromMatrix(Matrix matrix) {
    this._grid = matrix.clone();
  }
  
  
  //Get & Set methods
  
  int getValue(int x, int y) {
    if (!isOutOfBounds(x,y)) {
      return _grid.getElement(x, y);
    } else {
      return -1;
    }
  }
  
  void setValue(int x, int y, int value) {
    if (!isOutOfBounds(x,y)) {
      _grid.setElement(value, x, y);
    }
  }
  
  bool isOutOfBounds(int x, int y) {
    return !(x>=0 && x<4 && y>=0 && y<4);
  }
  
  Grid clone() {
    return new Grid.fromMatrix(this._grid);
  }
  
  Matrix getMatrix() {
    return this._grid;
  }
  
  
  //TODO check below
  void simulateMoveLeft()
  {
    for(int i=0; i<4; i++)
    {
      //ponemos todos los numeros juntos
      for(int j=0; j<3; j++)
      {
        if(this.getValue(i,j) == 0)
        {
          bool notZero = false;
          for(int k=j+1; k<4; k++)
          {
            if(this.getValue(i, k) != 0)
            {
              notZero = true;
            }
            this.setValue(i, k-1, this.getValue(i, k));
          }
          this.setValue(i, 3, 0);
          if(notZero == true)
          {
            j--;
          }
        }
      }
      //juntamos los que son iguales
      for(int j=0; j<3; j++)
      {
        //si ya llegamos al sector de ceros salir
        if(this.getValue(i, j) == 0)
        {
          j = 4;
        } else
        {
          if(this.getValue(i, j+1) == this.getValue(i, j))
          {
            this.setValue(i, j, this.getValue(i, j)*2);
            for(int k=j+2; k<4; k++)
            {
              this.setValue(i, k-1, this.getValue(i, k));
            }
            this.setValue(i, 3, 0);
          }
        }
      }
    }
  }
  
  void simulateMoveRight()
  {
    for(int i=0; i<4; i++)
    {
      //ponemos todos los numeros juntos
      for(int j=3; j>0; j--)
      {
        if(this.getValue(i,j) == 0)
        {
          bool notZero = false;
          for(int k=j-1; k>=0; k--)
          {
            if(this.getValue(i, k) != 0)
            {
              notZero = true;
            }
            this.setValue(i, k+1, this.getValue(i, k));
          }
          this.setValue(i, 0, 0);
          if(notZero == true)
          {
            j++;
          }
        }
      }
      //juntamos los que son iguales
      for(int j=3; j>0; j--)
      {
        //si ya llegamos al sector de ceros salir
        if(this.getValue(i, j) == 0)
        {
          j = 0;
        } else
        {
          if(this.getValue(i, j-1) == this.getValue(i, j))
          {
            this.setValue(i, j, this.getValue(i, j)*2);
            for(int k=j-2; k>=0; k--)
            {
              this.setValue(i, k+1, this.getValue(i, k));
            }
            this.setValue(i, 0, 0);
          }
        }
      }
    }
  }
  
  void simulateMoveUp()
  {
    for(int j=0; j<4; j++)
    {
      //ponemos todos los numeros juntos
      for(int i=0; i<3; i++)
      {
        if(this.getValue(i,j) == 0)
        {
          bool notZero = false;
          for(int k=i+1; k<4; k++)
          {
            if(this.getValue(k, j) != 0)
            {
              notZero = true;
            }
            this.setValue(k-1, j, this.getValue(k, j));
          }
          this.setValue(3, j, 0);
          if(notZero == true)
          {
            i--;
          }
        }
      }
      //juntamos los que son iguales
      for(int i=0; i<3; i++)
      {
        //si ya llegamos al sector de ceros salir
        if(this.getValue(i, j) == 0)
        {
          i = 4;
        } else
        {
          if(this.getValue(i+1, j) == this.getValue(i, j))
          {
            this.setValue(i, j, this.getValue(i, j)*2);
            for(int k=i+2; k<4; k++)
            {
              this.setValue(k-1, j, this.getValue(k, j));
            }
            this.setValue(3, j, 0);
          }
        }
      }
    }
  }
  
  void simulateMoveDown()
  {
    for(int j=0; j<4; j++)
    {
      //ponemos todos los numeros juntos
      for(int i=3; i>0; i--)
      {
        if(this.getValue(i,j) == 0)
        {
          bool notZero = false;
          for(int k=i-1; k>=0; k--)
          {
            if(this.getValue(k, j) != 0)
            {
              notZero = true;
            }
            this.setValue(k+1, j, this.getValue(k, j));
          }
          this.setValue(0, j, 0);
          if(notZero == true)
          {
            i++;
          }
        }
      }
      //juntamos los que son iguales
      for(int i=3; i>0; i--)
      {
        //si ya llegamos al sector de ceros salir
        if(this.getValue(i, j) == 0)
        {
          i = 0;
        } else
        {
          if(this.getValue(i-1, j) == this.getValue(i, j))
          {
            this.setValue(i, j, this.getValue(i, j)*2);
            for(int k=i-2; k>=0; k--)
            {
              this.setValue(k+1, j, this.getValue(k, j));
            }
            this.setValue(0, j, 0);
          }
        }
      }
    }
  }
  
  //compares a grid to this one. returns 0 if equal, 1 if different
  int compareGrid(Grid gridToCompare)
  {
    for(int i=0; i<4; i++)
    {
      for(int j=0; j<4; j++)
      {
        if(gridToCompare.getValue(i, j) != this.getValue(i, j))
        {
          return 1;
        }
      }
    }
    return 0;
  }
}