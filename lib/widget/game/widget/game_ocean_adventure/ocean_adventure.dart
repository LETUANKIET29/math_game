import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/image_composition.dart';
import 'package:flame_network_assets/flame_network_assets.dart';
import 'package:math_game/model/game_model.dart';
import 'package:math_game/widget/game/class/ocean_adventure/ocean_adventure_level.dart';
import 'package:math_game/widget/game/class/ocean_adventure/ocean_adventure_user.dart';

class GameOceanAdventure extends FlameGame {
  final int level;
  GameOceanAdventure({required this.level});

  late SpriteComponent background;
  final networkImages = FlameNetworkImages();

  late SpriteAnimation blueFishAnimation;
  late SpriteAnimation moonFishAnimation;
  late SpriteAnimation octopusAnimation;
  late SpriteAnimation redFishAnimation;
  late SpriteAnimation violetFishAnimation;

  bool flipped = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    question = 'Đang tải câu hỏi...';
    resetAnimalOcean();
    await loadBackground();
    await loadAnimals();
    generateQuestion(level);
  }

  Future<void> loadBackground() async {
    background = SpriteComponent()
      ..sprite = await loadSprite('background/background_ocean.png')
      ..size = size;
    add(background);
  }

  Future<void> loadAnimals() async {
    for (var animal in animalslist) {
      if (animal.type == 'bluefish') {
        Image blueFishImage = await networkImages.load(
          animal.imageurl.toString().isEmpty
              ? 'animal/blue_fish/blue_fish_idle.png'
              : animal.imageurl.toString(),
        );
        blueFishAnimation = SpriteAnimation.fromFrameData(
          blueFishImage,
          SpriteAnimationData.sequenced(
            amount: animal.sprite,
            textureSize: Vector2(animal.vectorX, animal.vectorY),
            stepTime: animal.steptime,
          ),
        );
        createAnimals(
          count: randomNum(),
          scaleFactor: animal.scaleFactor,
          animation: blueFishAnimation,
          xRange: Range(0.1, 0.95),
          yRange: Range(0.1, 0.95),
          textureSize: Vector2(animal.vectorX, animal.vectorY),
          type: animal.type,
        );
      } else if (animal.type == 'moonfish') {
        Image moonFishImage = await networkImages.load(
          animal.imageurl.toString().isEmpty
              ? 'animal/moon_fish/moon_fish_idle.png'
              : animal.imageurl.toString(),
        );
        moonFishAnimation = SpriteAnimation.fromFrameData(
          moonFishImage,
          SpriteAnimationData.sequenced(
            amount: animal.sprite,
            textureSize: Vector2(animal.vectorX, animal.vectorY),
            stepTime: animal.steptime,
          ),
        );
        createAnimals(
          count: randomNum(),
          scaleFactor: animal.scaleFactor,
          animation: moonFishAnimation,
          xRange: Range(0.1, 0.95),
          yRange: Range(0.1, 0.95),
          textureSize: Vector2(animal.vectorX, animal.vectorY),
          type: animal.type,
        );
      } else if (animal.type == 'octopus') {
        Image octopusImage = await networkImages.load(
          animal.imageurl.toString().isEmpty
              ? 'animal/octopus/octopus_idle.png'
              : animal.imageurl.toString(),
        );
        octopusAnimation = SpriteAnimation.fromFrameData(
          octopusImage,
          SpriteAnimationData.sequenced(
            amount: animal.sprite,
            textureSize: Vector2(animal.vectorX, animal.vectorY),
            stepTime: animal.steptime,
          ),
        );
        createAnimals(
          count: randomNum(),
          scaleFactor: animal.scaleFactor,
          animation: octopusAnimation,
          xRange: Range(0.1, 0.95),
          yRange: Range(0.1, 0.95),
          textureSize: Vector2(animal.vectorX, animal.vectorY),
          type: animal.type,
        );
      } else if (animal.type == 'redfish') {
        Image redFishImage = await networkImages.load(
          animal.imageurl.toString().isEmpty
              ? 'animal/red_fish/red_fish_idle.png'
              : animal.imageurl.toString(),
        );
        redFishAnimation = SpriteAnimation.fromFrameData(
          redFishImage,
          SpriteAnimationData.sequenced(
            amount: animal.sprite,
            textureSize: Vector2(animal.vectorX, animal.vectorY),
            stepTime: animal.steptime,
          ),
        );
        createAnimals(
          count: randomNum(),
          scaleFactor: animal.scaleFactor,
          animation: redFishAnimation,
          xRange: Range(0.1, 0.95),
          yRange: Range(0.1, 0.95),
          textureSize: Vector2(animal.vectorX, animal.vectorY),
          type: animal.type,
        );
      } else if (animal.type == 'violetfish') {
        Image violetFishImage = await networkImages.load(
          animal.imageurl.toString().isEmpty
              ? 'animal/violet_fish/violet_fish_idle.png'
              : animal.imageurl.toString(),
        );
        violetFishAnimation = SpriteAnimation.fromFrameData(
          violetFishImage,
          SpriteAnimationData.sequenced(
            amount: animal.sprite,
            textureSize: Vector2(animal.vectorX, animal.vectorY),
            stepTime: animal.steptime,
          ),
        );
        createAnimals(
          count: randomNum(),
          scaleFactor: animal.scaleFactor,
          animation: violetFishAnimation,
          xRange: Range(0.1, 0.95),
          yRange: Range(0.1, 0.95),
          textureSize: Vector2(animal.vectorX, animal.vectorY),
          type: animal.type,
        );
      }
    }
  }

  void createAnimals({
    required int count,
    required double scaleFactor,
    required SpriteAnimation animation,
    required Range xRange,
    required Range yRange,
    required Vector2 textureSize,
    required String type,
  }) {
    double screenWidth = size.x;
    double screenHeight = size.y;
    double minGap = 60.0; // Minimum gap between animals

    List<Vector2> positions = [];

    for (int i = 0; i < count; i++) {
      Vector2 position;
      bool validPosition;

      // Find a valid random position for the current animal
      do {
        validPosition = true;

        // Generate random position within the specified ranges
        double x =
            Random().nextDouble() * (xRange.end - xRange.start) + xRange.start;
        double y =
            Random().nextDouble() * (yRange.end - yRange.start) + yRange.start;

        // Adjust position to screen dimensions and scale
        double xPosition = screenWidth * x;
        double yPosition = screenHeight * y;

        position = Vector2(xPosition, yPosition);

        // Check if the new position is at least minGap away from existing positions
        for (Vector2 existingPosition in positions) {
          if ((position - existingPosition).length < minGap) {
            validPosition = false;
            break;
          }
        }
      } while (!validPosition);

      positions.add(position);

      // Check if the animal exceeds the screen boundaries
      if (position.x >= 0 &&
          position.x + textureSize.x * scaleFactor <= screenWidth &&
          position.y >= 0 &&
          position.y + textureSize.y * scaleFactor <= screenHeight) {
        bool flip = Random().nextBool();
        Animal animal = Animal(
          scaleFactor: scaleFactor,
          animation: animation,
          textureSize: textureSize,
          position: position,
          flipped: flip,
          type: type,
        );
        switch (type) {
          case 'bluefish':
            globalBlueFishCount++;
            break;
          case 'moonfish':
            globalMoonFishCount++;
            break;
          case 'octopus':
            globalOctopusCount++;
            break;
          case 'redfish':
            globalRedFishCount++;
            break;
          case 'violetfish':
            globalVioletFishCount++;
            break;
          default:
            break;
        }
        add(animal.createComponent());
      }
    }
    // print all animals count
    print('globalBlueFishCount: $globalBlueFishCount');
    print('globalMoonFishCount: $globalMoonFishCount');
    print('globalOctopusCount: $globalOctopusCount');
    print('globalRedFishCount: $globalRedFishCount');
    print('globalVioletFishCount: $globalVioletFishCount');
  }

}

class Range {
  final double start;
  final double end;

  Range(this.start, this.end);
}
