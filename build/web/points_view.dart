library points_view;

import 'dart:html';
import 'observer.dart';
import 'game.dart';
import 'game_state.dart';

///
/// POINTS VIEW
///
/// Updates HTML with points.
///

class PointsView implements Observer {

  PointsView() {}
  
  void notify() {
    GameState gs = Game.getCurrentGameState();

    querySelector('#points_id').text = 'Points: '+gs.getPoints().toString();
    
  }
  
}