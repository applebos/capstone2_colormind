# ColorMind: AI 기반 예술 작품 감정 분석

ColorMind는 그림과 사진에 담긴 감정을 분석하는 Flutter 애플리케이션입니다. 정교한 AI 모델을 사용하여 주요 감정을 식별하고 기분에 맞는 음악과 비디오 추천을 제공합니다.

## 주요 기능

*   **AI 기반 감정 분석**: TensorFlow Lite 모델을 활용하여 행복, 슬픔, 분노 등 이미지에서 다양한 감정을 예측합니다.
*   **개인화된 콘텐츠**: 작품에서 감지된 상위 3가지 감정을 기반으로 음악과 YouTube 비디오를 추천합니다.
*   **감정 캘린더**: 감정 분석 기록을 저장하여 시간 경과에 따른 기분 패턴을 캘린더 뷰에서 추적할 수 있습니다.
*   **인앱 뮤직 플레이어**: 결과 화면에서 제어할 수 있는 플레이어로 앱 내에서 직접 선별된 음악을 즐길 수 있습니다.
*   **세련되고 사용자 친화적인 인터페이스**: 이미지를 쉽게 업로드하고 결과를 볼 수 있는 현대적이고 직관적인 UI입니다.

## 작동 방식

1.  **이미지 선택**: 갤러리에서 사진을 선택하거나 카메라로 새 사진을 찍습니다.
2.  **AI 분석**: 앱의 `EmotionPredictor`가 이미지를 전처리하고 TensorFlow Lite 모델(`emotion_model_bs1.tflite`)에 입력합니다.
3.  **결과 보기**: `ResultScreen`은 감지된 상위 감정과 확률을 표시합니다. 또한 전반적인 감정에 대한 요약을 제공합니다.
4.  **콘텐츠 발견**: 감정 프로필을 기반으로 앱이 탐색할 노래와 YouTube 비디오를 제안합니다.
5.  **기분 추적**: 결과는 `emotions.db` SQLite 데이터베이스에 자동으로 저장되며 `CalendarScreen`에서 볼 수 있습니다.

## 핵심 구성 요소

*   **`home_screen.dart`**: 사용자가 분석할 이미지를 선택할 수 있는 앱의 기본 진입점입니다.
*   **`emotion_predictor.dart`**: TFLite 모델 로딩 및 감정 예측 로직을 처리합니다.
*   **`result_screen.dart`**: 상위 감정, 음악 추천, YouTube 비디오 제안 등 분석 결과를 표시합니다.
*   **`calendar_screen.dart`**: 감정 분석의 과거 기록을 보여줍니다.
*   **`music_service.dart`**: 인앱 오디오 플레이어를 관리합니다.
*   **`youtube_service.dart`**: YouTube 비디오 추천을 가져와 표시합니다.
*   **`database_helper.dart`**: 감정 데이터 저장을 위한 SQLite 데이터베이스를 관리합니다.

## 시작하기

이 프로젝트는 Flutter 애플리케이션의 시작점입니다.

이것이 첫 번째 Flutter 프로젝트인 경우 시작하는 데 도움이 되는 몇 가지 리소스는 다음과 같습니다.

*   [실습: 첫 번째 Flutter 앱 작성](https://docs.flutter.dev/get-started/codelab)
*   [쿡북: 유용한 Flutter 샘플](https://docs.flutter.dev/cookbook)

Flutter 개발 시작에 대한 도움말은 튜토리얼, 샘플, 모바일 개발 지침 및 전체 API 참조를 제공하는 [온라인 설명서](https://docs.flutter.dev/)를 참조하십시오.
