library move;

///
/// MOVE
///
/// Move.
///

class Move {
  
  static final Move up = new Move._internal(0);
  static final Move right = new Move._internal(1);
  static final Move down = new Move._internal(2);
  static final Move left = new Move._internal(3);
  
  int _value;
  
  Move._internal(int value) {
    this._value = value;
  }
  
  toString() => _value.toString();  
  
}