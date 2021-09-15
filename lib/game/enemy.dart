import 'dart:math';

import 'package:dino_run/game/constants.dart';
import 'package:flame/components.dart';

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


enum EnemyType {AngryPig, Bat, Rino}

class EnemyData {
  final imageName;
  final height;
  final width;
  final nColumns;
  final canFly;

  EnemyData({
    @required this.height,
    @required this.imageName,
    @required this.width,
    @required this.nColumns,
    @required this.canFly
  });
}

class Enemy extends SpriteAnimationComponent{
  late SpriteAnimation runAnimation;
  late SpriteAnimation hitAnimation;

  static Random _random = Random();

  double speed = 200;
  Vector2 s = Vector2(0,0);
  late EnemyData enemyData;
  // late double textureHeight;
  // late double textureWidth;

  static Map<EnemyType, EnemyData> _enemyDetails = {
    EnemyType.AngryPig: EnemyData(
      imageName: 'AngryPig/Run (36x30).png',
      height: 30.0,
      width: 36.0,
      nColumns: 12,
      canFly: false
    ),
    EnemyType.Bat: EnemyData(
      imageName: 'Bat/Flying (46x30).png',
      height: 30.0,
      width: 46.0,
      nColumns: 7,
      canFly: true
    ),
    EnemyType.Rino: EnemyData(
      imageName: 'Rino/Run (52x34).png',
      height: 34.0,
      width: 52.0,
      nColumns: 6,
      canFly: false
    )
  };

  Enemy(EnemyType enemyType){
    enemyData = _enemyDetails[enemyType] ?? EnemyData(
      imageName: 'Rino/Run (52x34).png',
      height: 34.0,
      width: 52.0,
      nColumns: 6,
      canFly: false
    );

    // textureHeight = enemyData.height;
    // textureWidth = enemyData.width;
  }

  @override
  Future<void>? onLoad() async {

    final image = await Flame.images.load(enemyData.imageName);

    final spriteSheet = SpriteSheet(image: image, srcSize: Vector2(enemyData.width, enemyData.height));

    runAnimation = spriteSheet.createAnimation(row: 0, stepTime: 0.1, from: 0, to: enemyData.nColumns-1);

    this.animation = runAnimation;
    this.anchor = Anchor.center;
  }

  @override
  void onGameResize(Vector2 gameSize) {

    double scaleFactor = (gameSize.x / numTiles) / enemyData.width;

    this.height = enemyData.height * scaleFactor;
    this.width = enemyData.width * scaleFactor;
    this.x = gameSize.x + this.width;
    this.y = gameSize.y - groundHeight - this.height/2;
    // this.s = gameSize;

    if(enemyData.canFly && _random.nextBool()){
      this.y -= this.height + 10;
    }

    // this.height = this.width = gameSize.x/numTiles;
    // this.x = gameSize.x/numTiles;
    // this.y = gameSize.y - groundHeight - this.height + dinoSpacing;
    super.onGameResize(gameSize);
  }

  @override
  void update(double dt) {
    super.update(dt);
    this.x -= speed * dt;
  }

  @override
  bool get shouldRemove => this.x < (-this.width);


}