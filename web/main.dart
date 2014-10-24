
import 'game.dart';
import 'grid_view.dart';
import 'score_view.dart';
import 'points_view.dart';
import 'moves_view.dart';
import 'game_solver.dart';

//Add solvers here
import 'solver_player.dart';
import 'solver_random.dart';
import 'solver_gradient.dart';

///
/// MAIN
/// 
/// Main. 
///
///

void main() {
  
  GridView gridView = new GridView();
  ScoreView scoreView = new ScoreView();
  PointsView pointsView = new PointsView();
  MovesView movesView = new MovesView();
  GameSolver solver = new SolverGradient(); //Change this to custom game solver
  
  Game.addObserver(gridView);
  Game.addObserver(scoreView);
  Game.addObserver(pointsView);
  Game.addObserver(movesView);
  Game.addObserver(solver);

  Game.newGame();   
  
}
