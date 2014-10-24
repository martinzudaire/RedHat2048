library matrix;

///
/// MATRIX
/// 
/// Wut is dis?
///
///

class Matrix {
  List<List<int>> array;
  int nx;
  int ny;
  
  Matrix.fromZero(int nx,int ny)
  {
    this.array = new List<List<int>>();
    this.nx = nx;
    this.ny = ny;
    for(int i=0; i<nx; i++)
    {
      List<int> list = new List<int>();
      for(int j=0; j<ny; j++)
      {
        list.add(0);
      }
      array.add(list);
    }
  }
  
  Matrix.fromList(List<List<int>> array,int nx,int ny)
  {
    this.array = array;
    this.nx = nx;
    this.ny = ny;
  }
  
  int getElement(int x, int y)
  {
    return array[x][y];
  }
  
  void setElement(int element, int x, int y)
  {
    array[x][y] = element;
  }
  
  static Matrix parseMatrix(String text,int nx,int ny)
  {
    Matrix matrix = new Matrix.fromZero(nx, ny);
    int start = 1;
    int end;
    for(int i=0; i<nx; i++)
    {
      for(int j=0; j<ny; j++)
      {
        for(end = start; text[end] != ',' && text[end] != ']'; end++) {}
        matrix.setElement(int.parse(text.substring(start,end)), i, j);
        start = end+1;
      }
      start = end+3;
    }
    return matrix;
  }
  
  void printMatrix()
  {
    print(this.array.toString());
  }
  
  Matrix clone() 
  {
    Matrix mat = new Matrix.fromZero(this.nx, this.ny);
    for(int i=0; i<this.nx; i++)
    {
      for(int j=0; j<this.ny; j++)
      {
        mat.setElement(this.getElement(i,j), i, j);
      }
    }
    return mat;
  }
}