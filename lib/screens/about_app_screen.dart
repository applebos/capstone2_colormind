import 'package:flutter/material.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'ColorMind란?',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).appBarTheme.titleTextStyle?.color,
          ),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: Theme.of(context).appBarTheme.elevation,
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ColorMind 설명',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: Theme.of(context).cardColor, // 테마의 카드 색상 적용
              elevation: 2.0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSummaryItem(context, '앱 이름', 'ColorMind'),
                    _buildSummaryItem(context, '주요 기능', '그림 감정 분석, 감정 기반 음악 추천, 공감 코멘트 제공'),
                    _buildSummaryItem(context, '개발 목적', '아동의 정서 표현과 정서 케어 지원'),
                    _buildSummaryItem(context, '주요 사용자', '아동, 보호자, 교사'),
                    _buildSummaryItem(context, '활용 예시', '그림 업로드 → 감정 분석 → 음악 & 문장 추천'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              color: Theme.of(context).cardColor, // 테마의 카드 색상 적용
              elevation: 2.0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ExpansionTile(
                title: Text(
                  '자세한 설명',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                shape: const RoundedRectangleBorder(side: BorderSide.none), // 구분선 제거
                collapsedShape: const RoundedRectangleBorder(side: BorderSide.none), // 구분선 제거
                tilePadding: EdgeInsets.zero, // 패딩 제거
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text(
                      'ColorMind는 사용자가 업로드한 그림을 인공지능이 분석하여 감정을 예측하고, 해당 감정에 어울리는 음악과 따뜻한 공감 문장을 추천해주는 감성 케어 앱입니다.\n'
                      '특히 언어로 감정을 표현하기 어려운 아동을 대상으로, 그림이라는 비언어적 수단을 통해 감정을 드러낼 수 있도록 돕습니다. 사용자는 아이가 그린 그림을 앱에 업로드하면, AI가 색상과 시각적 요소를 분석하여 감정 상태를 추정하고, 이를 바탕으로 youtube에서 어울리는 음악을 추천합니다. 또한 감정에 맞는 공감 문장을 함께 제시하여 정서적 지지를 제공합니다.\n\n'
                      '이러한 기능은 아동 스스로의 감정 인지력과 표현력을 향상시킬 뿐만 아니라, 보호자나 교사가 아동의 내면 상태를 보다 쉽게 파악하고 정서적 개입의 실마리를 찾을 수 있도록 돕습니다. 실생활에서는 “오늘 어떤 기분이었는지 그림으로 표현해볼까?”와 같은 자연스러운 활동을 통해 앱을 사용할 수 있으며, 분석된 결과를 기반으로 감정 해소 또는 격려의 기회를 마련할 수 있습니다.\n'
                      'ColorMind는 단순한 분석 도구를 넘어 아동의 감정을 존중하고 보듬는 심리적 다리 역할을 하는 플랫폼입니다.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(BuildContext context, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title: ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
          Expanded(
            child: Text(
              content,
              style: TextStyle(fontSize: 16, color: Theme.of(context).textTheme.bodyMedium?.color),
            ),
          ),
        ],
      ),
    );
  }
}
