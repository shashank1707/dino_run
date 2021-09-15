import 'package:dino_run/game/game.dart';
import 'package:flutter/material.dart';

class GameOver extends StatelessWidget {
  const GameOver(this.gameRef, {Key? key}) : super(key: key);

  static const id = 'GameOver';

  final DinoGame gameRef;

  void resetGame(){
    gameRef.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.black.withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Game Over",
                style: TextStyle(fontSize: 24, color: Colors.white)),
            Text("Your Score: ${gameRef.score.toString()}",
                style: TextStyle(fontSize: 24, color: Colors.white)),
            TextButton.icon(
                onPressed: () {
                  resetGame();
                  gameRef.overlays.remove(GameOver.id);
                  gameRef.resumeEngine();
                },
                icon: Icon(Icons.replay, color: Colors.white, size: 45),
                label: Text(''))
          ],
        ),
      ),
    ));
  }
}
