import 'package:dino_run/game/game.dart';
import 'package:dino_run/widgets/pauseMenu.dart';
import 'package:flutter/material.dart';

class Hud extends StatelessWidget {
  static const id = 'Hud';

  final DinoGame gameRef;

  const Hud(this.gameRef, {Key? key}) : super(key: key);

  void pauseGame() {
    gameRef.pauseEngine();
    gameRef.overlays.add(PauseMenu.id);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton.icon(
            onPressed: () {
              pauseGame();
            },
            icon: Icon(Icons.pause, color: Colors.white, size: 30),
            label: Text('')),

        ValueListenableBuilder(
          valueListenable: gameRef.life,
          builder: (_,int value, __) {

            final list = <Widget>[];

            for(int i=0; i<3; i++){
              list.add(
                Icon((i<value) ? Icons.favorite : Icons.favorite_border_outlined, color: Colors.red, size: 30,)
                );
            }

            return Row(
              children: list,
            );
          },
        )
      ],
    );
  }
}
