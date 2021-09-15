import 'dart:math' as math;
import 'dart:ui';

import 'package:dino_run/game/dino.dart';
import 'package:dino_run/game/enemy.dart';
import 'package:dino_run/game/enemyManager.dart';
import 'package:dino_run/widgets/gameOver.dart';
import 'package:dino_run/widgets/pauseMenu.dart';
import 'package:flame/flame.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/palette.dart';
import 'package:flame/parallax.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

const double groundHeight = 32;

class DinoGame extends BaseGame with TapDetector {
  late Dino dinoComponent;
  late ParallaxComponent parallaxComponent;
  late int score = 0;
  late TextComponent scoreText = TextComponent(score.toString());
  late EnemyManager _enemyManager;
  late ValueNotifier<int> life = dinoComponent.life;
  late int spawnLevel;
  @override
  Future<void> onLoad() async {
    _enemyManager = EnemyManager();
    spawnLevel = _enemyManager.spawnLevel;

    parallaxComponent = await loadParallaxComponent([
      ParallaxImageData('parallax/plx-1.png'),
      ParallaxImageData('parallax/plx-2.png'),
      ParallaxImageData('parallax/plx-3.png'),
      ParallaxImageData('parallax/plx-4.png'),
      ParallaxImageData('parallax/plx-5.png'),
      ParallaxImageData('parallax/plx-6.png'),
    ], baseVelocity: Vector2(15, 0), velocityMultiplierDelta: Vector2(1.5, 0));

    add(parallaxComponent);

    dinoComponent = Dino();
    add(dinoComponent);

    add(_enemyManager);

    score = 0;
    scoreText = TextComponent(score.toString(),
        textRenderer: TextPaint(config: TextPaintConfig(color: Colors.white)));
    scoreText.x = canvasSize.x / 2 - scoreText.width / 2;
    scoreText.y = 10;
    add(scoreText);

    life = dinoComponent.life;
  }

  @override
  void onTapDown(TapDownInfo info) {
    super.onTapDown(info);
    dinoComponent.jump();
  }

  @override
  void update(double dt) {
    super.update(dt);
    score += (60 * dt).toInt();
    scoreText.text = score.toString();

    components.whereType<Enemy>().forEach((enemy) {
      if (dinoComponent.distance(enemy) < 30) {
        dinoComponent.hit();
      }
    });

    if (dinoComponent.life.value <= 0) {
      gameOver();
    }

    var newSpawnLevel = (score ~/ 500);
    if (spawnLevel < newSpawnLevel) {
      spawnLevel = newSpawnLevel;
      var parallax = parallaxComponent.parallax;
      if (parallax != null) {
        parallax.baseVelocity.x += spawnLevel * 0.5;
      }
    }
  }

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    super.lifecycleStateChange(state);
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        pauseGame();
        break;
      case AppLifecycleState.paused:
        pauseGame();
        break;
      case AppLifecycleState.detached:
        pauseGame();
        break;
    }
  }

  void pauseGame() {
    overlays.add(PauseMenu.id);
    pauseEngine();
  }

  void gameOver() {
    pauseEngine();
    overlays.add(GameOver.id);
  }

  void reset() {
    this.score = 0;
    dinoComponent.life.value = 3;
    this.life.value = 3;
    _enemyManager.reset();
    components.whereType<Enemy>().forEach((element) {
      element.remove();
    });
    _enemyManager.remove();

    dinoComponent.run();
  }
}
