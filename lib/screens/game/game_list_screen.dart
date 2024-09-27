import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:math_game/configs/configs.dart';
import 'package:math_game/controller/controllers.dart';
import 'package:math_game/model/game_model.dart';
import 'package:math_game/screens/game/game_leaderboard_screen.dart';
import 'package:math_game/widget/common/custom_app_bar.dart';
import 'package:math_game/widget/common/progress_widgets.dart';

class GameListScreen extends GetView<GameController> {
  const GameListScreen({super.key});
  static const String routeName = '/game_list';

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    final RxString searchQuery = ''.obs;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.shouldReset.value) {
        controller.selectedGame.value = null;
        controller.shouldReset.value = false;
      }
    });

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: Container(
          decoration: BoxDecoration(gradient: mainGradient(context)),
          child: Obx(() {
            return CustomAppBar(
              title: controller.selectedGame.value != null
                  ? controller.games.firstWhere((game) =>
                      game['id'] == controller.selectedGame.value)['name']
                  : 'Thư viện trò chơi',
              leading: controller.selectedGame.value != null
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        controller.selectedGame.value = null;
                      },
                    )
                  : null,
              showAudioButton: true,
            );
          }),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: LoadingWidgets());
          }
          if (controller.selectedGame.value != null) {
            return controller.buildGameWidget(controller.selectedGame.value!);
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 12),
                width: MediaQuery.of(context).size.width * 0.3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm trò chơi',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    onChanged: (value) {
                      searchQuery.value = value;
                    },
                  ),
                ),
              ),
              Expanded(
                child: Obx(() {
                  final filteredGames = controller.games.where((game) {
                    final gameName = game['name']?.toLowerCase() ?? '';
                    final query = searchQuery.value.toLowerCase();
                    return gameName.contains(query);
                  }).toList();
                  return _buildGameGrid(filteredGames);
                }),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildGameGrid(List<dynamic> games) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.4,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: games.length,
      itemBuilder: (context, index) {
        final game = games[index];
        return GestureDetector(
          onTap: () {
            controller.isLoading.value = true;
            controller.selectedGame.value = game['id'];
            Future.delayed(Duration.zero, () {
              controller.isLoading.value = false;
            });
          },
          child: Card(
            margin: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
              side: BorderSide(
                color: Colors.grey.shade400,
                width: 1.3,
              ),
            ),
            elevation: 5,
            shadowColor: Colors.grey.withOpacity(0.5),
            child: LayoutBuilder(
              builder: (context, constraints) {
                double imageHeight = constraints.maxHeight *
                    0.5; // 50% of the card height for the image
                return Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Image.network(
                            game['image'] ?? '',
                            width: double.infinity,
                            height: imageHeight,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        game['name'] ?? '',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        game['description'] ?? '',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.deepPurple,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              elevation: 5,
                            ),
                            onPressed: () {
                              Get.toNamed(
                                GameLeaderboardScreen.routeName,
                                arguments: GameModel(
                                  id: game['id']!,
                                  title: game['name']!,
                                  imageUrl: game['image'] ?? '',
                                  description: game['description'] ?? '',
                                ),
                              );
                            },
                            child: const Row(
                              children: [
                                Icon(AppIcons.trophyoutline),
                                SizedBox(width: 5),
                                Text('Bảng xếp hạng'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }


}
