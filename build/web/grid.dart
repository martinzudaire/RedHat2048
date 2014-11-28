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
    
  
  //getValueXY()
  int getValueXY(int x, int y) {
    if (!isOutOfBoundsXY(x,y)) {
      return _grid.getValue(x, y);
    } else {
      return -1;
    }
  }
  

  //getValue()
  int getValue(GridCoordinates coordinates) {
    return getValueXY(coordinates.x, coordinates.y);
  }
  
  
  //setValueXY()
  void setValueXY(int x, int y, int value) {
    if (!isOutOfBoundsXY(x,y)) {
      _grid.setValue(x, y, value);
    }
  }
  
  
  //setValue()
  void setValue(GridCoordinates coordinates, int value) {
    setValueXY(coordinates.x, coordinates.y, value);
  }
  
  
  //isOutOfBounds()
  bool isOutOfBoundsXY(int x, int y) {
    return !(x>=0 && x<4 && y>=0 && y<4);
  }
  
  
  //isOutOfBounds()
  bool isOutOfBounds(GridCoordinates coordinates) {
    return isOutOfBoundsXY(coordinates.x, coordinates.y);
  }
  
  
  //clone()
  //Clones grid and returns it.
  Grid clone() {
    return new Grid.fromMatrix(this._grid);
  }
  
}