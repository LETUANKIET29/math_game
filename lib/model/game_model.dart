import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flame/components.dart';

class GameModel {
  final String id;
  final String title;
  final String imageUrl;
  final String description;

  GameModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.description,
  });

  factory GameModel.fromJson(Map<String, dynamic> json) {
    return GameModel(
      id: json['id'],
      title: json['name'],
      imageUrl: json['image'],
      description: json['description'],
    );
  }
}


class GameAnimalModel {
  final String id;
  String? imageurl;
  final double vectorX;
  final double vectorY;
  final double scaleFactor;
  final int sprite;
  final double steptime;
  final String type;

  GameAnimalModel({
    required this.id,
    this.imageurl,
    required this.vectorX,
    required this.vectorY,
    required this.scaleFactor,
    required this.sprite,
    required this.steptime,
    required this.type,
  });

  factory GameAnimalModel.fromString(String jsonString) =>
      GameAnimalModel.fromJson(json.decode(jsonString));

  factory GameAnimalModel.fromJson(Map<String, dynamic> json) =>
      GameAnimalModel(
        id: json['id'] as String,
        imageurl: json['imageurl'] as String?,
        vectorX: json['VectorX'] as double,
        vectorY: json['VectorY'] as double,
        scaleFactor: json['scaleFactor'] as double,
        sprite: json['sprite'] as int,
        steptime: json['steptime'] as double,
        type: json['type'] as String,
      );

  factory GameAnimalModel.fromSnapshot(
          DocumentSnapshot<Map<String, dynamic>> snapshot) =>
      GameAnimalModel(
        id: snapshot.id,
        imageurl: snapshot.data()?['imageurl'] as String?,
        vectorX: snapshot.data()?['VectorX'] as double,
        vectorY: snapshot.data()?['VectorY'] as double,
        scaleFactor: snapshot.data()?['scaleFactor'] as double,
        sprite: snapshot.data()?['sprite'] as int,
        steptime: snapshot.data()?['steptime'] as double,
        type: snapshot.data()?['type'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'imageurl': imageurl,
        'VectorX': vectorX,
        'VectorY': vectorY,
        'scaleFactor': scaleFactor,
        'sprite': sprite,
        'steptime': steptime,
        'type': type,
      };
}

List<GameAnimalModel> animalslist = [];

//random number 1-5
int randomNum() {
  return Random().nextInt(5) + 1;
}

//reset animal count

int globalChickenCount = 0;
int globalDuckCount = 0;
int globalBlueFishCount = 0;
int globalRedFishCount = 0;
int globalVioletFishCount = 0;
int globalOctopusCount = 0;
int globalMoonFishCount = 0;
int globalBlueBirdCount = 0;
int globalRedBirdCount = 0;

void resetAnimalFarm() {
  globalDuckCount = 0;
  globalChickenCount = 0;
}

void resetAnimalOcean() {
  globalBlueFishCount = 0;
  globalRedFishCount = 0;
  globalVioletFishCount = 0;
  globalOctopusCount = 0;
  globalMoonFishCount = 0;
}

void resetAnimalSky() {
  globalBlueBirdCount = 0;
  globalRedBirdCount = 0;
}

class Animal {
  final double scaleFactor;
  final SpriteAnimation animation;
  final Vector2 position;
  final Vector2 textureSize;
  final bool flipped;
  final String type;

  Animal({
    required this.scaleFactor,
    required this.animation,
    required this.position,
    required this.textureSize,
    required this.flipped,
    required this.type,
  });

  SpriteAnimationComponent createComponent() {
    SpriteAnimationComponent component = SpriteAnimationComponent()
      ..animation = animation
      ..size = textureSize * scaleFactor
      ..position = position;

    if (flipped) {
      component.flipHorizontally();
    }
    return component;
  }
}

class ItemModel {
  final String id;
  String? imageurl;
  final int price;

  ItemModel({required this.id, this.imageurl, required this.price});

  factory ItemModel.fromString(String jsonString) =>
      ItemModel.fromJson(json.decode(jsonString));

  ItemModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        imageurl = json['imageurl'] as String?,
        price = json['price'] as int;

  ItemModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : id = snapshot.id,
        imageurl = snapshot.data()?['imageurl'] as String?,
        price = snapshot.data()?['price'] as int;

  Map<String, dynamic> toJson() => {
        'id': id,
        'imageurl': imageurl,
        'price': price,
      };
}

// Game Shopping
List<ItemModel> upperItemModel = [];
List<ItemModel> lowerItemModel = [];
List<ItemModel> startLowerItemModel = [];
int balance = 100;
int lastbalance = 20;
