import 'dart:math';
import 'dart:ui';

import 'package:dino_run/game/enemy.dart';
import 'package:dino_run/game/game.dart';
import 'package:flame/components.dart';

class EnemyManager extends Component with HasGameRef<DinoGame> {
  late Random _random;
  late Timer _timer;
  late int spawnLevel = 0;

  // EnemyManager(){
  //   _random = Random();
  //   _timer = Timer(4, repeat: true, callback: (){});
  //   spawnRandomEnemy();
  // }

  void spawnRandomEnemy() {
    final randomNumber = _random.nextInt(EnemyType.values.length);
    final randomEnemyType = EnemyType.values.elementAt(randomNumber);
    final newEnemy = Enemy(randomEnemyType);
    gameRef.add(newEnemy);
  }

  @override
  Future<void>? onLoad() {
    spawnLevel = 0;
    _random = Random();
    _timer = Timer(4, repeat: true, callback: () {
      spawnRandomEnemy();
    });
  }

  @override
  void onMount() {
    super.onMount();
    _timer.start();
  }

  // @override
  // void render(Canvas c){

  // }

  @override
  void update(double dt) {
    super.update(dt);
    _timer.update(dt);

    var newSpawnLevel = (gameRef.score ~/ 500);
    if (spawnLevel < newSpawnLevel) {
      spawnLevel = newSpawnLevel;

      var newWaitTime = (4 / (1 + (0.2 * spawnLevel)));

      _timer.stop();

      _timer = Timer(newWaitTime, repeat: true, callback: () {
        spawnRandomEnemy();
      });

      _timer.start();
    }
  }

  void reset(){
    spawnLevel = 0;
    _timer = Timer(4, repeat: true, callback: () {
        spawnRandomEnemy();
      });
    _timer.start();
  }
}
