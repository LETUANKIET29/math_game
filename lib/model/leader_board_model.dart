import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderBoardData {
  final String? correctCount;
  final String? userId;
  final int? time;
  final String? paperId;
  final double? points;
  late UserData user;

  LeaderBoardData({
    this.correctCount,
    this.userId,
    this.time,
    this.paperId,
    this.points,
  });

  LeaderBoardData.fromJson(Map<String, dynamic> json)
    : correctCount = json['correct_count'] as String?,
      userId = json['user_id'] as String?,
      time = json['time'] as int?,
      paperId = json['paper_id'] as String?,
      points = json['points'] as double?;

  LeaderBoardData.fromSnapShot(DocumentSnapshot<Map<String, dynamic>> snapshot)
    : correctCount = snapshot['correct_count'] as String?,
      userId = snapshot['user_id'] as String?,
      time = snapshot['time'] as int,
      paperId = snapshot['paper_id'] as String?,
      points = snapshot['points'] as double?;    

  Map<String, dynamic> toJson() => {
    'correct_count' : correctCount,
    'user_id' : userId,
    'time' : time,
    'paper_id' : paperId,
    'points' : points
  };
}

class LeaderBoardGameData {
  final String gameId;
  final String gameName;
  final String userName;
  final int point;
  final int duration;

  LeaderBoardGameData({
    required this.gameId,
    required this.gameName,
    required this.userName,
    required this.point,
    required this.duration,
  });

  factory LeaderBoardGameData.fromJson(Map<String, dynamic> json) {
    return LeaderBoardGameData(
      gameId: json['gameId'],
      gameName: json['game']['name'],
      userName: json['applicationUser']['userName'],
      point: json['point'],
      duration: json['duration'],
    );
  }
}

class GameData {
  final String title;
  final String imageUrl;
  final String description;
  final String courseId;
  final String id;
  final bool isDeleted;

  GameData({
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.courseId,
    required this.id,
    required this.isDeleted,
  });

  factory GameData.fromJson(Map<String, dynamic> json) {
    return GameData(
      title: json['title'],
      imageUrl: json['imageUrl'],
      description: json['description'],
      courseId: json['courseId'],
      id: json['id'],
      isDeleted: json['isDeleted'],
    );
  }
}

class UserData {
  final String id;
  final String userName;
  final String email;
  final String? image;

  UserData({
    required this.id,
    required this.userName,
    required this.email,
    this.image,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      userName: json['userName'],
      email: json['email'],
      image: json['imageUrl'], // Assuming `imageUrl` is the correct field for image
    );
  }

  factory UserData.fromSnapShot(DocumentSnapshot snap) {
    return UserData(
      id: snap.id,
      userName: snap['userName'],
      email: snap['email'],
      image: snap['imageUrl'],
    );
  }
}
