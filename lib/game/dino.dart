import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/flame.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/palette.dart';
import 'package:flame/parallax.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

class Dino extends SpriteAnimationComponent {
  late SpriteAnimation runAnimation;
  late SpriteAnimation hitAnimation;

  double speedY = 0;
  double yMax = 0;
  late Timer _timer;
  late bool isHit;

  ValueNotifier<int> life = ValueNotifier(3);

  @override
  Future<void>? onLoad() async {
    final image = await Flame.images.load('DinoSprites-tard.png');

    final spriteSheet = SpriteSheet(image: image, srcSize: Vector2(24, 24));

    runAnimation =
        spriteSheet.createAnimation(row: 0, stepTime: 0.1, from: 4, to: 10);

    hitAnimation =
        spriteSheet.createAnimation(row: 0, stepTime: 0.1, from: 14, to: 16);

    this.animation = runAnimation;

    _timer = Timer(1.5, callback: () {
      run();
    });

    isHit = false;
    this.anchor = Anchor.center;
    life.value = 3;
  }

  @override
  void onGameResize(Vector2 gameSize) {
    this.height = this.width = gameSize.x / numTiles;
    this.x = gameSize.x / numTiles;
    this.y = gameSize.y - groundHeight - this.height/2 + dinoSpacing;
    this.yMax = this.y;
    super.onGameResize(gameSize);
  }

  @override
  void update(double dt) {
    super.update(dt);
    // v = u + at;
    this.speedY += GRAVITY * dt;

    // d = si + s * t
    this.y += this.speedY * dt;

    if (isOnGround()) {
      this.y = this.yMax;
      this.speedY = 0;
    }

    _timer.update(dt);
  }

  bool isOnGround() {
    return this.y >= this.yMax;
  }

  void run() {
    isHit = false;
    this.animation = runAnimation;
  }

  void hit() {
    if (!isHit) {
      this.animation = hitAnimation;
      _timer.start();
      isHit = true;
      life.value -= 1;
    }
  }

  void jump() {
    if (isOnGround()) {
      this.speedY = -500;
    }
  }
}
