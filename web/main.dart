
import 'game.dart';
import 'grid_view.dart';
import 'score_view.dart';
import 'points_view.dart';
import 'moves_view.dart';
import 'game_over_view.dart';
import 'game_solver.dart';
import 'button_new_game.dart';

//Add solvers here
import 'solver_player.dart';
import 'solver_gradient.dart';
import 'solver_decrecimiento.dart';
import 'solver_decrecimiento_2.dart';

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
  GameOverView gameOverView = new GameOverView();
  GameSolver solver = new SolverDecrecimiento2(); //Change this to custom game solver
  
  ButtonNewGame buttonNewGame = new ButtonNewGame();
  
  Game.addObserver(gridView);
  Game.addObserver(scoreView);
  Game.addObserver(pointsView);
  Game.addObserver(movesView);
  Game.addObserver(gameOverView);
  Game.addObserver(solver);

  Game.newGame();   
  
}
