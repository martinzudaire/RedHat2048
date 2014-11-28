library game_over_view;

import 'dart:html';
import 'observer.dart';
import 'game.dart';
import 'game_state.dart';

///
/// GAME OVER VIEW
///
/// Updates HTML by showing either GAME OVER or YOU WIN messages.
///

class GameOverView implements Observer {

  GameOverView() {}
  
  void notify() {
    GameState gs = Game.getCurrentGameState();

    if (gs.isWon()) {
      querySelector('#you_win_id').style.display = "block";
      querySelector('#game_over_id').style.display = "none";
    } else if (gs.isOver()) {
      querySelector('#you_win_id').style.display = "none";
      querySelector('#game_over_id').style.display = "block";
    } else {
      querySelector('#you_win_id').style.display = "none";
      querySelector('#game_over_id').style.display = "none";      
    }
    
  }
  
}