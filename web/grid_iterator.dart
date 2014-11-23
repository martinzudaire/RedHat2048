library GridIterator;

import 'grid.dart';
import 'move.dart';
import 'grid_coordinates.dart';

class GridIterator {
  
  Grid _grid;
  Move _direction;
  int _row;
  int _cell;
  
  GridIterator(Grid grid, Move direction) {
    this._grid = grid;
    this._direction = direction;

    firstRow();
    firstCell();
  }
  
  void firstRow() {
    _row = 0;
  }
  
  void lastRow() {
    _row = 3;
  }
  
  void previousRow() {
    _row--;
  }
  
  void nextRow() {
    _row++;
  }
  
  bool isFirstRow() => (_row==0);
  bool isLastRow() => (_row==3);
  bool isRowDone() => (_row>3);
  
  void firstCell() {
    _cell = 0;
  }
  
  void lastCell() {
    _cell = 3;
  }
  
  void previousCell() {
    _cell--;
  }
  
  void nextCell() {
    _cell++;
  }
  
  bool isFirstCell() => (_cell==0);
  bool isLastCell() => (_cell==3);
  bool isCellDone() => (_cell>3);
  
  int getCellValue() {
    GridCoordinates c = getGridCoordinates();
    return _grid.getValue(c.x, c.y);
  }
  
  void setCellValue(int value) {    
    GridCoordinates c = getGridCoordinates();
    _grid.setValue(c.x, c.y, value);
  }
  
  //getGridCoordinates()
  //Translates _row and _cell values to GridCoordinates.
  GridCoordinates getGridCoordinates(){    
    if (_direction == Move.left) {
      return new GridCoordinates(_row, _cell);  
    } else if (_direction == Move.right) {
      return new GridCoordinates(_row, 3-_cell);
    } else if (_direction == Move.up) {
      return new GridCoordinates(_cell, _row);
    } else if (_direction == Move.down) {
      return new GridCoordinates(3-_cell, _row);
    }
    
    return new GridCoordinates(-1, -1);
  }
  
}