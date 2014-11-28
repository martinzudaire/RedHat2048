library score_view;

import 'dart:html';
import 'observer.dart';
import 'game.dart';
import 'game_state.dart';

///
/// SCORE VIEW
///
/// Updates HTML with score values.
///

class ScoreView implements Observer {

  ScoreView() {}
  
  void notify() {
    GameState gs = Game.getCurrentGameState();

    querySelector('#score_id').text = 'Score: '+gs.getScore().toString();
    
  }
  
}