library moves_view;

import 'dart:html';
import 'observer.dart';
import 'game.dart';
import 'game_state.dart';

///
/// MOVES VIEW
///
/// Updates HTML with moves.
///

class MovesView implements Observer {

  MovesView() {}
  
  void notify() {
    GameState gs = Game.getCurrentGameState();

    querySelector('#moves_id').text = 'Moves: '+gs.getMoves().toString();
    
  }
  
}