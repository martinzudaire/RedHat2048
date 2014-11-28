library grid_view;

import 'dart:html';
import 'observer.dart';
import 'game.dart';
import 'grid.dart';

///
/// GRID VIEW
///
/// Updates HTML with grid values.
///

class GridView implements Observer {
  
  GridView() {}
  
  void notify() {
    Grid g = Game.getCurrentGameState().getGrid();

    for (int i=0; i<4; i++) {
      for (int j=0; j<4; j++) {
        querySelector('#gridcell_'+i.toString()+'_'+j.toString()+'_id').text = g.getValueXY(i, j).toString();
      }
    }
    
  }
  
}