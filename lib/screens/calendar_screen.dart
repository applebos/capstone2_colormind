import 'package:flutter/material.dart';
import 'package:colormind/widgets/glass_container.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:colormind/database_helper.dart';
import 'dart:convert';
import 'dart:io';
import 'package:colormind/models/emotion_model.dart';
import 'package:colormind/widgets/circular_emotion_indicator.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late final DatabaseHelper _dbHelper;
  Map<DateTime, List<Map<String, dynamic>>> _emotionData = {};
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<Map<String, dynamic>> _currentDayEntries = [];

  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadEmotionData();
  }

  Future<void> _loadEmotionData() async {
    final data = await _dbHelper.queryAllEmotionData();
    setState(() {
      _emotionData = {};
      for (var row in data) {
        final date = DateTime.parse(row['date']).toUtc();
        final day = DateTime.utc(date.year, date.month, date.day);
        if (_emotionData[day] == null) {
          _emotionData[day] = [];
        }
        _emotionData[day]!.add(row);
      }
      // Sort entries for each day by time
      _emotionData.forEach((key, value) {
        value.sort((a, b) => DateTime.parse(a['date']).compareTo(DateTime.parse(b['date'])));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          '감정 캘린더',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                _currentDayEntries = _emotionData[DateTime.utc(selectedDay.year, selectedDay.month, selectedDay.day)] ?? [];
              });
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            calendarStyle: CalendarStyle(
              defaultTextStyle: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
              weekendTextStyle: const TextStyle(color: Color(0xFFFF8A80)),
              outsideTextStyle: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.5)),
              todayDecoration: const BoxDecoration(
                color: Color(0xFFE91E63),
                shape: BoxShape.circle,
              ),
              selectedDecoration: const BoxDecoration(
                color: Color(0xFF00B8A9),
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              leftChevronIcon: Icon(Icons.chevron_left, color: Theme.of(context).iconTheme.color),
              rightChevronIcon: Icon(Icons.chevron_right, color: Theme.of(context).iconTheme.color),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
              weekendStyle: const TextStyle(color: Color(0xFFFF8A80)),
            ),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                final dayData =
                    _emotionData[DateTime.utc(date.year, date.month, date.day)];
                if (dayData != null && dayData.isNotEmpty) {
                  final emotions =
                      jsonDecode(dayData.first['emotions']) as Map<String, dynamic>;
                  final sortedEmotions = emotions.entries.toList()
                    ..sort((a, b) => b.value.compareTo(a.value));
                  final top3Emotions = sortedEmotions.take(3).toList();

                  if (top3Emotions.length >= 3) {
                    return Positioned(
                      bottom: 1,
                      child: Container(
                        width: 30,
                        height: 5,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              allEmotions
                                  .firstWhere((e) => e.name == top3Emotions[0].key)
                                  .backgroundColor,
                              allEmotions
                                  .firstWhere((e) => e.name == top3Emotions[1].key)
                                  .backgroundColor,
                              allEmotions
                                  .firstWhere((e) => e.name == top3Emotions[2].key)
                                  .backgroundColor,
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(2.5),
                        ),
                      ),
                    );
                  }
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 16),
          // Display list of entries for the selected day
          if (_currentDayEntries.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: _currentDayEntries.length,
                itemBuilder: (context, index) {
                  final entry = _currentDayEntries[index];
                  final entryTime = DateTime.parse(entry['date']).toLocal();
                  final emotions = jsonDecode(entry['emotions']) as Map<String, dynamic>;
                  final sortedEmotions = emotions.entries.toList()
                    ..sort((a, b) => b.value.compareTo(a.value));
                  final top3Emotions = sortedEmotions.take(3).toList();

                  final List<Color> barColors = top3Emotions.map((e) => allEmotions.firstWhere((em) => em.name == e.key).backgroundColor).toList();

                  return GestureDetector(
                    onTap: () {
                      _showEntryDetailsDialog(context, entry);
                    },
                    child: GlassContainer(
                      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      padding: const EdgeInsets.all(16.0),
                      color: Colors.white,
                      blur: 15,
                      opacity: 0.2,
                      borderRadius: 20,
                      border: Border.all(color: Colors.white.withOpacity(0.6), width: 1),
                      child: Row(
                        children: [
                          Text(
                            '${entryTime.hour.toString().padLeft(2, '0')}:${entryTime.minute.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Container(
                              height: 10,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: barColors,
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  void _showEntryDetailsDialog(BuildContext context, Map<String, dynamic> entry) {
    final emotions = jsonDecode(entry['emotions']) as Map<String, dynamic>;
    final sortedEmotions = emotions.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top3EmotionEntries = sortedEmotions.take(3).toList();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          title: Text('${DateTime.parse(entry['date']).toLocal().hour.toString().padLeft(2, '0')}:${DateTime.parse(entry['date']).toLocal().minute.toString().padLeft(2, '0')}의 감정'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.file(File(entry['imagePath'])),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: top3EmotionEntries.map((e) {
                    final emotion = allEmotions.firstWhere((em) => em.name == e.key);
                    final probability = e.value.toDouble();
                    return CircularEmotionIndicator(
                      context: context,
                      emotion: emotion,
                      probability: probability,
                      isHighlighted: true,
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showAllEmotionPercentages(context, sortedEmotions);
              },
              child: const Text('상세보기', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showMetadata(context, entry['metadata']);
              },
              child: const Text('메타데이터', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('닫기', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  void _showAllEmotionPercentages(
    BuildContext context,
    List<MapEntry<String, dynamic>> sortedEmotions,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          title: const Text('감정별 분석 확률'),
          content: SingleChildScrollView(
            child: Column(
              children: sortedEmotions.map((entry) {
                final emotion = allEmotions.firstWhere((e) => e.name == entry.key);
                final probability = entry.value.toDouble();
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(emotion.name, style: const TextStyle(color: Colors.black)),
                      ),
                      Expanded(
                        flex: 7,
                        child: LinearProgressIndicator(
                          value: probability,
                          backgroundColor: Colors.grey[300],
                          color: emotion.backgroundColor,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text('${(probability * 100).toStringAsFixed(2)}%', style: const TextStyle(color: Colors.black)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('닫기', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  void _showMetadata(BuildContext context, String? metadata) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          title: const Text('이미지 메타데이터'),
          content: SingleChildScrollView(
            child: Text(metadata ?? '메타데이터가 없습니다.', style: const TextStyle(color: Colors.black)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('닫기', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }
}