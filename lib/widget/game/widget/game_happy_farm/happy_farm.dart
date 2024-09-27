import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/image_composition.dart';
import 'package:flame_network_assets/flame_network_assets.dart';
import 'package:math_game/model/game_model.dart';
import 'package:math_game/widget/game/class/happy_farm/happy_farm_level.dart';
import 'package:math_game/widget/game/class/happy_farm/happy_farm_user.dart';

class HappyFarm extends FlameGame {
  final int level;
  HappyFarm({required this.level});

  late SpriteComponent background;
  final networkImages = FlameNetworkImages();
  late SpriteAnimation chickenIdleAnimation;
  late SpriteAnimation duckIdleAnimation;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    question = 'Đang tải câu hỏi...';
    resetAnimalFarm();
    await loadBackground();
    await loadAnimals();
    await generateQuestion(level);
  }

  Future<void> loadBackground() async {
    background = SpriteComponent()
      ..sprite = await loadSprite('background/background_farm.png')
      ..size = size;
    add(background);
  }

  Future<void> loadAnimals() async {
    for (var animal in animalslist) {
      if (animal.type == 'chicken') {
        chickenIdleAnimation = await loadAnimalAnimation(animal);
        createAnimals(
          count: randomNum(),
          scaleFactor: animal.scaleFactor,
          animation: chickenIdleAnimation,
          xRange: Range(0.05, 0.45),
          yPosition: size.y * 0.65,
          textureSize: Vector2(animal.vectorX, animal.vectorY),
          type: animal.type,
        );
      } else if (animal.type == 'duck') {
        duckIdleAnimation = await loadAnimalAnimation(animal);
        createAnimals(
          count: randomNum(),
          scaleFactor: animal.scaleFactor,
          animation: duckIdleAnimation,
          xRange: Range(0.55, 0.95),
          yPosition: size.y * 0.65,
          textureSize: Vector2(animal.vectorX, animal.vectorY),
          type: animal.type,
        );
      }
    }
  }

  Future<SpriteAnimation> loadAnimalAnimation(GameAnimalModel animal) async {
    Image animalImage = await networkImages.load(
      animal.imageurl.toString().isEmpty
          ? 'animal/${animal.type}/${animal.type}_stand.png'
          : animal.imageurl.toString(),
    );
    return SpriteAnimation.fromFrameData(
      animalImage,
      SpriteAnimationData.sequenced(
        amount: animal.sprite,
        textureSize: Vector2(animal.vectorX, animal.vectorY),
        stepTime: animal.steptime,
      ),
    );
  }

  void createAnimals({
    required int count,
    required double scaleFactor,
    required SpriteAnimation animation,
    required Range xRange,
    required double yPosition,
    required Vector2 textureSize,
    required String type,
  }) {
    double screenWidth = size.x;
    double xStart = screenWidth *
        (xRange.start + 0.05); // Starting x position with 5% border
    double xEnd =
        screenWidth * (xRange.end - 0.05); // Ending x position with 5% border

    // Ensure the gap accounts for the size of the animals and scaleFactor
    double gap = (xEnd - xStart) / (count - 1);
    double minGap = textureSize.x * scaleFactor;

    if (gap < minGap) {
      gap = minGap;
    }

    for (int i = 0; i < count; i++) {
      // Check if the animal exceeds the screen boundaries
      if (xStart >= 0 && xStart + textureSize.x * scaleFactor <= screenWidth) {
        bool flip = Random().nextBool();
        Animal animal = Animal(
          scaleFactor: scaleFactor,
          animation: animation,
          textureSize: textureSize,
          position: Vector2(xStart, yPosition),
          flipped: flip,
          type: type,
        );
        if (type == 'chicken') {
          globalChickenCount++;
        } else if (type == 'duck') {
          globalDuckCount++;
        }

        add(animal.createComponent());
      }
      xStart += gap;
      // Ensure xStart is within bounds
      if (xStart > xEnd) {
        break; // Exit the loop if the animals exceed the specified x-range
      }
    }
  }
}

class Range {
  final double start;
  final double end;

  Range(this.start, this.end);
}
