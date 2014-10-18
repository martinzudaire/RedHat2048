library move;

///
/// MOVE
///
///

class Move {
  
  static Move up = new Move._internal(0);
  static Move right = new Move._internal(1);
  static Move down = new Move._internal(2);
  static Move left = new Move._internal(3);
  
  int _value;
  
  Move._internal(int value) {
    this._value = value;
  }
  
  toString() => _value.toString();  
   
}