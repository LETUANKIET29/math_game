import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/image_composition.dart';
import 'package:flame_network_assets/flame_network_assets.dart';
import 'package:flutter/foundation.dart';
import 'package:math_game/model/game_model.dart';

class GameOddAndEven extends FlameGame {
  late SpriteComponent background;
  final networkImages = FlameNetworkImages();
  late SpriteAnimation blueBirdAnimation;
  late SpriteAnimation redBirdAnimation;

  bool flipped = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Background
    background = SpriteComponent()
      ..sprite = await loadSprite('background/background_odd_and_even.png')
      ..size = size;
    add(background);

    for (var animal in animalslist) {
      if (animal.type == 'bluebird') {
        Image blueBirdImage = await networkImages.load(
          animal.imageurl.toString().isEmpty
              ? 'animal/blue_bird/blue_bird_ilde.png'
              : animal.imageurl.toString(),
        );
        blueBirdAnimation = SpriteAnimation.fromFrameData(
          blueBirdImage,
          SpriteAnimationData.sequenced(
            amount: animal.sprite,
            textureSize: Vector2(animal.vectorX, animal.vectorY),
            stepTime: animal.steptime,
          ),
        );
        createAnimals(
          count: randomNum(),
          scaleFactor: animal.scaleFactor,
          animation: blueBirdAnimation,
          xRange: Range(0.1, 0.95),
          yRange: Range(0.1, 0.95),
          textureSize: Vector2(animal.vectorX, animal.vectorY),
          type: animal.type,
        );
      } else if (animal.type == 'redbird') {
        Image redBirdImage = await networkImages.load(
          animal.imageurl.toString().isEmpty
              ? 'animal/red_bird/red_bird_idle.png'
              : animal.imageurl.toString(),
        );
        redBirdAnimation = SpriteAnimation.fromFrameData(
          redBirdImage,
          SpriteAnimationData.sequenced(
            amount: animal.sprite,
            textureSize: Vector2(animal.vectorX, animal.vectorY),
            stepTime: animal.steptime,
          ),
        );
        createAnimals(
          count: randomNum(),
          scaleFactor: animal.scaleFactor,
          animation: redBirdAnimation,
          xRange: Range(0.1, 0.95),
          yRange: Range(0.1, 0.95),
          textureSize: Vector2(animal.vectorX, animal.vectorY),
          type: animal.type,
        );
      }
    }
  }

  int randomNum() {
    return Random().nextInt(5) + 1;
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

        // Ensure the animal stays within screen boundaries by clamping its position
        position.x =
            position.x.clamp(0, screenWidth - textureSize.x * scaleFactor);
        position.y =
            position.y.clamp(0, screenHeight - textureSize.y * scaleFactor);

        // Check if the new position is at least minGap away from existing positions
        for (Vector2 existingPosition in positions) {
          if ((position - existingPosition).length < minGap) {
            validPosition = false;
            break;
          }
        }
      } while (!validPosition);

      positions.add(position);

      // Create and add the animal if the position is valid
      bool flip = Random().nextBool();
      Animal animal = Animal(
        scaleFactor: scaleFactor,
        animation: animation,
        textureSize: textureSize,
        position: position,
        flipped: flip,
        type: type,
      );

      if (type == 'bluebird') {
        globalBlueBirdCount++;
      } else if (type == 'redbird') {
        globalRedBirdCount++;
      }

      add(animal.createComponent());
    }

    // Print animal counts for debugging
    print('BlueBird: $globalBlueBirdCount');
    print('RedBird: $globalRedBirdCount');
  }

}

class Range {
  final double start;
  final double end;

  Range(this.start, this.end);
}
