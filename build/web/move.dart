library move;

///
/// MOVE
///
/// Move.
///

class Move {
  
  static final Move up = new Move._internal(0,-1,0);
  static final Move right = new Move._internal(1,0,1);
  static final Move down = new Move._internal(2,1,0);
  static final Move left = new Move._internal(3,0,-1);
  
  int _value;
  int _directionX;
  int _directionY;
  
  Move._internal(int value, int directionX, int directionY) {
    this._value = value;
    this._directionX = directionX;
    this._directionY = directionY;
  }
  
  toString() => _value.toString();  
  
  int getDirectionX() => _directionX;
  int getDirectionY() => _directionY;
  
}