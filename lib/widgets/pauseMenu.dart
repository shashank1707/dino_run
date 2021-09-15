import 'package:dino_run/game/game.dart';
import 'package:flutter/material.dart';

class PauseMenu extends StatelessWidget {
  static const id = 'PauseMenu';

  final DinoGame gameRef;

  const PauseMenu(this.gameRef, {Key? key}) : super(key: key);

  void resumeGame() {
    gameRef.overlays.remove(id);
    gameRef.resumeEngine();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
          ),
      color: Colors.black.withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Game Paused",
                style: TextStyle(fontSize: 24, color: Colors.white)),
            
            TextButton.icon(onPressed: () {
                resumeGame();
              }, icon: Icon(Icons.play_arrow, color: Colors.white, size: 60), label: Text(''))

          ],
        ),
      ),
    ));
  }
}
