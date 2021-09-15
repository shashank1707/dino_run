import 'dart:math' as math;
import 'dart:ui';

import 'package:dino_run/game/game.dart';
import 'package:dino_run/widgets/gameOver.dart';
import 'package:dino_run/widgets/hud.dart';
import 'package:dino_run/widgets/pauseMenu.dart';
import 'package:flame/flame.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.setLandscape();
  Flame.device.fullScreen();
  runApp(
    MyApp()
  );
}

class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(body: MyGameWidget()));
  }
}

class MyGameWidget extends StatefulWidget {
  const MyGameWidget({ Key? key }) : super(key: key);

  @override
  _MyGameWidgetState createState() => _MyGameWidgetState();
}

class _MyGameWidgetState extends State<MyGameWidget> {

  @override
  Widget build(BuildContext context) {
    return GameWidget<DinoGame>(
      game: DinoGame(),
      overlayBuilderMap: {
        Hud.id: (_, DinoGame gameRef) => Hud(gameRef),
        PauseMenu.id: (_, DinoGame gameRef) => PauseMenu(gameRef),
        GameOver.id: (_, DinoGame gameRef) => GameOver(gameRef)
      },
      initialActiveOverlays: const [Hud.id],
    );
  }
}