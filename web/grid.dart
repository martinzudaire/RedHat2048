library grid;

import 'matrix.dart';

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
  
  int getElement(int x, int y) {
    if (x>=0 && x<4 && y>=0 && y<4) {
      return _grid.getElement(x, y);
    } else {
      return 0;
    }
  }
  
  void setElement(int x, int y, int value) {
    if (x>=0 && x<4 && y>=0 && y<4) {
      _grid.setElement(value, x, y);
    }
  }
  
  Grid clone() {
    return new Grid.fromMatrix(this._grid);
  }
  
  Matrix getMatrix()
  {
    return this._grid;
  }
  
  void simulateMoveLeft()
  {
    for(int i=0; i<4; i++)
    {
      //ponemos todos los numeros juntos
      for(int j=0; j<3; j++)
      {
        if(this.getElement(i,j) == 0)
        {
          bool notZero = false;
          for(int k=j+1; k<4; k++)
          {
            if(this.getElement(i, k) != 0)
            {
              notZero = true;
            }
            this.setElement(i, k-1, this.getElement(i, k));
          }
          this.setElement(i, 3, 0);
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
        if(this.getElement(i, j) == 0)
        {
          j = 4;
        } else
        {
          if(this.getElement(i, j+1) == this.getElement(i, j))
          {
            this.setElement(i, j, this.getElement(i, j)*2);
            for(int k=j+2; k<4; k++)
            {
              this.setElement(i, k-1, this.getElement(i, k));
            }
            this.setElement(i, 3, 0);
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
        if(this.getElement(i,j) == 0)
        {
          bool notZero = false;
          for(int k=j-1; k>=0; k--)
          {
            if(this.getElement(i, k) != 0)
            {
              notZero = true;
            }
            this.setElement(i, k+1, this.getElement(i, k));
          }
          this.setElement(i, 0, 0);
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
        if(this.getElement(i, j) == 0)
        {
          j = 0;
        } else
        {
          if(this.getElement(i, j-1) == this.getElement(i, j))
          {
            this.setElement(i, j, this.getElement(i, j)*2);
            for(int k=j-2; k>=0; k--)
            {
              this.setElement(i, k+1, this.getElement(i, k));
            }
            this.setElement(i, 0, 0);
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
        if(this.getElement(i,j) == 0)
        {
          bool notZero = false;
          for(int k=i+1; k<4; k++)
          {
            if(this.getElement(k, j) != 0)
            {
              notZero = true;
            }
            this.setElement(k-1, j, this.getElement(k, j));
          }
          this.setElement(3, j, 0);
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
        if(this.getElement(i, j) == 0)
        {
          i = 4;
        } else
        {
          if(this.getElement(i+1, j) == this.getElement(i, j))
          {
            this.setElement(i, j, this.getElement(i, j)*2);
            for(int k=i+2; k<4; k++)
            {
              this.setElement(k-1, j, this.getElement(k, j));
            }
            this.setElement(3, j, 0);
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
        if(this.getElement(i,j) == 0)
        {
          bool notZero = false;
          for(int k=i-1; k>=0; k--)
          {
            if(this.getElement(k, j) != 0)
            {
              notZero = true;
            }
            this.setElement(k+1, j, this.getElement(k, j));
          }
          this.setElement(0, j, 0);
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
        if(this.getElement(i, j) == 0)
        {
          i = 0;
        } else
        {
          if(this.getElement(i-1, j) == this.getElement(i, j))
          {
            this.setElement(i, j, this.getElement(i, j)*2);
            for(int k=i-2; k>=0; k--)
            {
              this.setElement(k+1, j, this.getElement(k, j));
            }
            this.setElement(0, j, 0);
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
        if(gridToCompare.getElement(i, j) != this.getElement(i, j))
        {
          return 1;
        }
      }
    }
    return 0;
  }
}