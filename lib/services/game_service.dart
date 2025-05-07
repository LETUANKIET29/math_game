import 'package:get/get.dart';

class GameService extends GetxService {
  static GameService get to => Get.find();

  Future<GameService> init() async {
    return this;
  }

  List<dynamic> getGameList() {
    return [
      {
        'id': '49299e7c-fa16-45fd-84e4-1a725c118a9f',
        'name': 'Happy Farm Level 1',
        'image':
            'https://firebasestorage.googleapis.com/v0/b/beanmind-2911.appspot.com/o/thumbnail_game_images%2Fhappy_farm.png?alt=media&token=ed307113-421f-4d74-bea2-e4d45fd18b8f',
        'description': 'Trò chơi nông trại vui vẻ cấp độ 1'
      },
      {
        'id': 'a65534d6-b34c-43d1-e2f6-08dcb0b903bd',
        'name': 'Happy Farm Level 2',
        'image':
            'https://firebasestorage.googleapis.com/v0/b/beanmind-2911.appspot.com/o/thumbnail_game_images%2Fhappy_farm.png?alt=media&token=ed307113-421f-4d74-bea2-e4d45fd18b8f',
        'description': 'Trò chơi nông trại vui vẻ cấp độ 2'
      },
      {
        'id': '9400fa00-e27d-40a1-e2f7-08dcb0b903bd',
        'name': 'Happy Farm Level 3',
        'image':
            'https://firebasestorage.googleapis.com/v0/b/beanmind-2911.appspot.com/o/thumbnail_game_images%2Fhappy_farm.png?alt=media&token=ed307113-421f-4d74-bea2-e4d45fd18b8f',
        'description': 'Trò chơi nông trại vui vẻ cấp độ 3'
      },
      {
        'id': '3ae42c10-7dbe-4e71-a52c-c19c44e3c4a0',
        'name': 'Ocean Adventure Level 1',
        'image':
            'https://firebasestorage.googleapis.com/v0/b/beanmind-2911.appspot.com/o/thumbnail_game_images%2Focean_adventure.png?alt=media&token=d9ada505-0862-4a8b-afe6-6a11358561bc',
        'description': 'Cuộc phiêu lưu đại dương cấp độ 1'
      },
      {
        'id': 'd9db0faa-49e7-488e-e2f8-08dcb0b903bd',
        'name': 'Ocean Adventure Level 2',
        'image':
            'https://firebasestorage.googleapis.com/v0/b/beanmind-2911.appspot.com/o/thumbnail_game_images%2Focean_adventure.png?alt=media&token=d9ada505-0862-4a8b-afe6-6a11358561bc',
        'description': 'Cuộc phiêu lưu đại dương cấp độ 2'
      },
      {
        'id': '6d69ec97-28c8-4c34-e2f9-08dcb0b903bd',
        'name': 'Ocean Adventure Level 3',
        'image':
            'https://firebasestorage.googleapis.com/v0/b/beanmind-2911.appspot.com/o/thumbnail_game_images%2Focean_adventure.png?alt=media&token=d9ada505-0862-4a8b-afe6-6a11358561bc',
        'description': 'Cuộc phiêu lưu đại dương cấp độ 3'
      },
      {
        'id': 'ead13199-827d-4c48-5d08-08dcafad932c',
        'name': 'Sắp xếp số Level 1',
        'image':
            'https://firebasestorage.googleapis.com/v0/b/beanmind-2911.appspot.com/o/thumbnail_game_images%2Fnumber_sort.png?alt=media&token=6124bb15-ff34-47fc-a0ad-143463324dd1',
        'description': 'Trò chơi sắp xếp số cấp độ 1'
      },
      {
        'id': '3e2e9eee-07bb-4548-e2fa-08dcb0b903bd',
        'name': 'Sắp xếp số Level 2',
        'image':
            'https://firebasestorage.googleapis.com/v0/b/beanmind-2911.appspot.com/o/thumbnail_game_images%2Fnumber_sort.png?alt=media&token=6124bb15-ff34-47fc-a0ad-143463324dd1',
        'description': 'Trò chơi sắp xếp số cấp độ 2'
      },
      {
        'id': '6011f3e5-d1fd-439c-e2fb-08dcb0b903bd',
        'name': 'Sắp xếp số Level 3',
        'image':
            'https://firebasestorage.googleapis.com/v0/b/beanmind-2911.appspot.com/o/thumbnail_game_images%2Fnumber_sort.png?alt=media&token=6124bb15-ff34-47fc-a0ad-143463324dd1',
        'description': 'Trò chơi sắp xếp số cấp độ 3'
      },
      {
        'id': '59141c9e-7dd3-4c76-5d0a-08dcafad932c',
        'name': 'Chẵn lẻ Level 1',
        'image':
            'https://firebasestorage.googleapis.com/v0/b/beanmind-2911.appspot.com/o/thumbnail_game_images%2Fodd_and_even.png?alt=media&token=30686705-4ae5-433a-8af7-16a30938461c',
        'description': 'Trò chơi chẵn lẻ cấp độ 1'
      },
      {
        'id': 'b2b05dc0-d4d4-4dfb-e2fc-08dcb0b903bd',
        'name': 'Chẵn lẻ Level 2',
        'image':
            'https://firebasestorage.googleapis.com/v0/b/beanmind-2911.appspot.com/o/thumbnail_game_images%2Fodd_and_even.png?alt=media&token=30686705-4ae5-433a-8af7-16a30938461c',
        'description': 'Trò chơi chẵn lẻ cấp độ 2'
      },
      {
        'id': 'c296495f-342e-4fd6-5d09-08dcafad932c',
        'name': 'Đi chợ',
        'image':
            'https://firebasestorage.googleapis.com/v0/b/beanmind-2911.appspot.com/o/thumbnail_game_images%2Fshopping.png?alt=media&token=6ba50614-1253-4b02-8906-e19979d9f614',
        'description': 'Trò chơi đi chợ'
      },
      {
        'id': '134a1896-37a0-481c-76b8-08dcb1f69dd7',
        'name': 'Toán học Level 1',
        'image':
            'https://firebasestorage.googleapis.com/v0/b/beanmind-2911.appspot.com/o/thumbnail_game_images%2Fmath_game_level_1.png?alt=media&token=5ec9aabf-a503-426c-b7db-73b5f6641ed0',
        'description': 'Trò chơi toán học cấp độ 1'
      },
      {
        'id': 'd9ebd726-6f2b-4609-76b9-08dcb1f69dd7',
        'name': 'Toán học Level 2',
        'image':
            'https://firebasestorage.googleapis.com/v0/b/beanmind-2911.appspot.com/o/thumbnail_game_images%2Fmath_game_level_2.png?alt=media&token=524e8506-7eb7-4bd0-935b-01e1e67b78a8',
        'description': 'Trò chơi toán học cấp độ 2'
      },
      {
        'id': '2395575f-74e2-4809-76ba-08dcb1f69dd7',
        'name': 'Toán học Level 3',
        'image':
            'https://firebasestorage.googleapis.com/v0/b/beanmind-2911.appspot.com/o/thumbnail_game_images%2Fmath_game_level_3.png?alt=media&token=d541325d-4c80-493b-8728-363ab0d4437e',
        'description': 'Trò chơi toán học cấp độ 3'
      },
    ];
  }
}
