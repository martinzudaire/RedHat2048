library matrix;

///
/// MATRIX
/// 
/// 2D array.
///
///

class Matrix {
  List<List<int>> _array;
  int _sizeX;
  int _sizeY;
  
  
  //Constructor
  Matrix(int sizeX, int sizeY)  {
    this._array = new List<List<int>>();
    this._sizeX = sizeX;
    this._sizeY = sizeY;
    
    for (int i=0; i<sizeX; i++) {
      List<int> list = new List<int>();
      for (int j=0; j<sizeY; j++) {
        list.add(0);
      }
      _array.add(list);
    }
  }
  
  
  //getValue()
  int getValue(int x, int y) {
    if (!isOutOfBounds(x,y)) {
      return _array[x][y];
    } else {
      return 0;
    }
  }
  
  
  //setValue()
  void setValue(int x, int y, int value) {
    if (!isOutOfBounds(x,y)) {
      _array[x][y] = value;
    }
  }
  
  
  //parseMatrix()
  //Parses a string and returns a matrix with the values
  static Matrix parseMatrix(String text, int sizeX, int sizeY) {
    Matrix matrix = new Matrix(sizeX, sizeY);
    int start = 1;
    int end;
    
    for (int i=0; i<sizeX; i++) {
      for (int j=0; j<sizeY; j++) {
        
        for(end = start; text[end] != ',' && text[end] != ']'; end++) {}        
        matrix.setValue(i, j, int.parse(text.substring(start,end)));
        start = end+1;
        
      }
      start = end+3;
    }
    return matrix;
  }
  
  
  //isOutOfBounds()
  bool isOutOfBounds(int x, int y) {
    return !(x>=0 && x<_sizeX && y>=0 && y<_sizeY);
  }
  
  
  //clone()
  //Clones a matrix and returns it.
  Matrix clone() {
    Matrix mat = new Matrix(_sizeX, _sizeY);
    for (int i=0; i<_sizeX; i++) {
      for (int j=0; j<_sizeY; j++) {
        mat.setValue(i, j, getValue(i,j));
      }
    }
    return mat;
  }
}