library button_new_game;

import 'dart:html';
import 'game.dart';

///
/// BUTTON NEW GAME
///
/// New game button
///

class ButtonNewGame {

  ButtonNewGame() {
    ButtonElement button = querySelector("#new_game_button_id");
    button.onMouseUp.listen((MouseEvent e) {
           
          CheckboxInputElement clientSideCheckbox = querySelector('#client_side_game_id');
          
          if (clientSideCheckbox.checked) {
            Game.setClientGame();
          } else {
            Game.setServerGame();
          }
          
          Game.newGame();
        }); 
  }
  
  void notify() {
    
  }
  
}