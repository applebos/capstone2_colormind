import 'package:flutter/material.dart';

class AboutAIScreen extends StatelessWidget {
  const AboutAIScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          '감정 분석 AI 모델',
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
              'AI 설명',
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
                    _buildSummaryItem(context, '모델 기반', 'EfficientNet-B0 기반 CNN 모델'),
                    _buildSummaryItem(context, '데이터셋', 'WikiArt Emotions + 자체 라벨링 감정 데이터'),
                    _buildSummaryItem(context, '감정 라벨', '총 19개 감정, 다중 이진 분류 방식'),
                    _buildSummaryItem(context, '학습 방식', 'Weighted Binary Crossentropy 사용'),
                    _buildSummaryItem(context, '성능 지표', '정확도 92.11%, 해밍 거리 0.0789, MSE 0.0866'),
                    _buildSummaryItem(context, '결과 활용', '감정 예측 결과를 음악 추천 및 문장 생성에 활용'),
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
                      'ColorMind의 감정 예측 기능은 EfficientNet-B0를 기반으로 한 다중 이진 분류 딥러닝 모델에 의해 작동합니다.\n'
                      'EfficientNet-B0는 Google이 제안한 경량화된 합성곱 신경망(CNN)으로, 적은 연산량 대비 높은 정확도를 제공하는 것이 특징입니다. 본 프로젝트에서는 이 모델을 백본으로 사용하여 감정 예측 시스템을 구축하였습니다.\n\n'
                      '모델은 WikiArt Emotions Dataset과 자체 구축한 감정 라벨링 데이터셋을 활용하여 학습하였습니다. 이 데이터셋은 미술 작품이나 그림에 대해 사람들이 느낀 감정을 기준으로 구성되며, 각 감정은 다중 이진 라벨 형식으로 제공됩니다. 모델은 ‘anger’, ‘happiness’, ‘sadness’, ‘calmness’, ‘hope’ 등 총 19가지 감정을 동시에 예측할 수 있으며, 하나의 이미지에 여러 감정이 함께 나타나는 경우도 고려합니다.\n\n'
                      '학습 시 감정 간의 빈도 불균형 문제를 해결하기 위해 가중 이진 크로스엔트로피(Weighted Binary Crossentropy) 손실 함수를 사용하였습니다. 또한 감정마다 독립적인 이진 노드를 두어 예측의 유연성을 확보하였습니다.\n\n'
                      '성능 평가 결과, 정확도는 92.11%, 해밍 거리(Hamming Distance)는 0.0789, 평균 제곱 오차(MSE)는 0.0866으로 우수한 성능을 보였습니다. 감정별 Precision, Recall, F1-score 등의 지표도 함께 분석하여 모델의 신뢰성을 확보하였습니다.\n\n'
                      '이 모델은 예측된 감정 값을 바탕으로 youtube를 통해 음악을 추천하고, 감정에 맞는 공감 문장을 제공하는 데 활용됩니다. 감정 예측은 단순한 분류 작업을 넘어, 사용자에게 맞춤형 정서 콘텐츠를 연결해주는 핵심 기술로 기능합니다.',
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
