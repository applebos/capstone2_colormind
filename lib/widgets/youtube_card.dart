// lib/widgets/youtube_card.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../youtube_service.dart';

class YouTubeCard extends StatefulWidget {
  final List<String> emotionNames;

  const YouTubeCard({super.key, required this.emotionNames});

  @override
  State<YouTubeCard> createState() => _YouTubeCardState();
}

class _YouTubeCardState extends State<YouTubeCard>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.emotionNames.length,
      vsync: this,
    );

    // 위젯이 화면에 그려진 직후, 첫 번째 탭의 데이터를 불러옵니다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget.emotionNames.isNotEmpty) {
        _fetchInitialData();
      }
    });

    _tabController.addListener(_handleTabSelection);
  }

  void _fetchInitialData() {
    // 서비스의 데이터가 비어있을 때만 첫 감정 데이터를 가져옵니다.
    final youtubeService = context.read<YouTubeService>();
    final initialEmotion = widget.emotionNames.first;
    if (youtubeService.recommendationsByEmotion[initialEmotion] == null) {
      youtubeService.fetchVideosForEmotion(initialEmotion);
    }
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      final selectedEmotion = widget.emotionNames[_tabController.index];
      final youtubeService = context.read<YouTubeService>();
      // 해당 탭의 데이터가 아직 로드되지 않았다면 API를 호출합니다.
      if (youtubeService.recommendationsByEmotion[selectedEmotion] == null) {
        youtubeService.fetchVideosForEmotion(selectedEmotion);
      }
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.emotionNames.isEmpty) {
      return const SizedBox.shrink(); // 표시할 감정이 없으면 위젯을 숨깁니다.
    }

    // 서비스의 변경사항을 실시간으로 감지하여 UI를 다시 그립니다.
    return Consumer<YouTubeService>(
      builder: (context, youtubeService, child) {
        return Card(
          elevation: 2.0,
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: const Color(0xFFFFF9C4),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '감정별 음악 추천',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    // 이미지가 없다면 Icon(Icons.play_circle_fill, color: Colors.red) 등으로 대체하세요.
                    Icon(Icons.play_circle_fill, color: Colors.red, size: 28),
                  ],
                ),
                const SizedBox(height: 12),
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabs: widget.emotionNames
                      .map((name) => Tab(text: name))
                      .toList(),
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey[700],
                  indicatorColor: Colors.red,
                ),
                SizedBox(
                  height: 150, // 추천 영상 목록의 높이를 고정합니다.
                  child: TabBarView(
                    controller: _tabController,
                    children: widget.emotionNames.map((emotion) {
                      final recommendations =
                          youtubeService.recommendationsByEmotion[emotion];

                      // 현재 탭의 데이터를 로딩 중일 때 로딩 아이콘을 표시합니다.
                      if (youtubeService.isLoading && recommendations == null) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      // 로딩이 끝났지만 영상이 없을 때 메시지를 표시합니다.
                      if (recommendations == null || recommendations.isEmpty) {
                        return const Center(child: Text("추천 영상을 찾지 못했어요."));
                      }

                      // 영상 목록을 가로로 스크롤되게 표시합니다.
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: recommendations.length,
                        itemBuilder: (context, index) {
                          final video = recommendations[index];
                          return GestureDetector(
                            onTap: () =>
                                youtubeService.selectVideo(video),
                            child: SizedBox(
                              width: 150,
                              child: Card(
                                clipBehavior: Clip.antiAlias,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Image.network(
                                      video.thumbnailUrl,
                                      height: 80,
                                      fit: BoxFit.cover,
                                      // 썸네일 로딩 실패 시 에러 아이콘 표시
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Center(
                                                child: Icon(
                                                  Icons.broken_image,
                                                  size: 40,
                                                ),
                                              ),
                                      // 썸네일 로딩 중일 때 로딩 아이콘 표시
                                      loadingBuilder:
                                          (
                                            context,
                                            child,
                                            progress,
                                          ) => progress == null
                                          ? child
                                          : const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          video.title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}