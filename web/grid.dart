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
  
}