
import 'package:math_game/model/game_model.dart';

class GameHistory {
  final String gameId;
  final GameModel game;
  final String applicationUserId;
  final int point;
  final int duration;
  final String id;
  final bool isDeleted;
  final String playDate;

  GameHistory({
    required this.gameId,
    required this.game,
    required this.applicationUserId,
    required this.point,
    required this.duration,
    required this.id,
    required this.isDeleted,
    required this.playDate,
  });

  factory GameHistory.fromJson(Map<String, dynamic> json) {
    return GameHistory(
      gameId: json['gameId'],
      game: GameModel.fromJson(json['game']),
      applicationUserId: json['applicationUserId'],
      point: json['point'],
      duration: json['duration'],
      id: json['id'],
      isDeleted: json['isDeleted'],
      playDate: json['created'],
    );
  }
}

class GameHistoryResponse {
  final List<GameHistory> items;
  final int pageIndex;
  final int pageSize;
  final int totalPage;

  GameHistoryResponse({
    required this.items,
    required this.pageIndex,
    required this.pageSize,
    required this.totalPage,
  });

  factory GameHistoryResponse.fromJson(Map<String, dynamic> json) {
    return GameHistoryResponse(
      items: (json['items'] as List)
          .map((item) => GameHistory.fromJson(item))
          .toList(),
      pageIndex: json['pageIndex'],
      pageSize: json['pageSize'],
      totalPage: json['totalPage'],
    );
  }
}