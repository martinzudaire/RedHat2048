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
  static Move none = new Move._internal(-1); //TODO CHECK <-- This upsets the balance of the universe, use 'null' instead
  
  int _value;
  
  Move._internal(int value) {
    this._value = value;
  }
  
  toString() => _value.toString();  
  
  int getValue()
  {
    return this._value;
  }
}