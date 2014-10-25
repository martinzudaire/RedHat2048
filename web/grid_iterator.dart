library GridIterator;

import 'grid.dart';
import 'move.dart';

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
    if (!(_row>=0 && _row<=3 && _cell>=0 && _cell<=3)) {
      return -1;
    }
    
    if (_direction == Move.left) {
      return _grid.getElement(_row, _cell);      
    } else if (_direction == Move.right) {
      return _grid.getElement(_row, 3-_cell);
    } else if (_direction == Move.up) {
      return _grid.getElement(_cell, _row);
    } else if (_direction == Move.down) {
      return _grid.getElement(3-_cell, _row);
    }
    
    return -1;
  }
  
  void setCellValue(int value) {
    if (!(_row>=0 && _row<=3 && _cell>=0 && _cell<=3)) {
      return;
    }
    
    if (_direction == Move.left) {
      _grid.setElement(_row, _cell, value);      
    } else if (_direction == Move.right) {
      _grid.setElement(_row, 3-_cell, value);
    } else if (_direction == Move.up) {
      _grid.setElement(_cell, _row, value);
    } else if (_direction == Move.down) {
      _grid.setElement(3-_cell, _row, value);
    }
  }
  
}