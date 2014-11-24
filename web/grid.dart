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
  
  //Constructor
  Grid() {
    _grid = new Matrix(4, 4);
  }
  
  
  //Constructor fromJSON()
  Grid.fromJSON(String json) {
    _grid = Matrix.parseMatrix(json, 4, 4);
  }
  
  
  //Constructor fromMatrix()
  Grid.fromMatrix(Matrix matrix) {
    this._grid = matrix.clone();
  }
    
  
  //getValue()
  int getValue(int x, int y) {
    if (!isOutOfBounds(x,y)) {
      return _grid.getValue(x, y);
    } else {
      return -1;
    }
  }
  
  
  //setValue()
  void setValue(int x, int y, int value) {
    if (!isOutOfBounds(x,y)) {
      _grid.setValue(x, y, value);
    }
  }
  
  
  //isOutOfBounds()
  bool isOutOfBounds(int x, int y) {
    return !(x>=0 && x<4 && y>=0 && y<4);
  }
  
  
  //clone()
  //Clones grid and returns it.
  Grid clone() {
    return new Grid.fromMatrix(this._grid);
  }
  
}