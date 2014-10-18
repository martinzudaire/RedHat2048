
import 'game.dart';
import 'grid_view.dart';
import 'game_solver.dart';

//Add solvers here
import 'solver_player.dart';

///
/// MAIN
/// 
/// Main. 
///
///

void main() {
  
  GridView gridView = new GridView();
  GameSolver solver = new SolverPlayer(); //Change this to custom game solver
  
  Game.addObserver(gridView);
  Game.addObserver(solver);

  Game.newGame();   
  
}
