import 'dart:async';
import 'dart:ui' as ui;
import 'package:tackle_time/logic/main_page/daily_fish_activity.dart';
import 'package:tackle_time/logic/main_page/selected_data_manager.dart';
import 'package:tackle_time/utils/services/city_reader.dart';
import 'package:tackle_time/utils/services/moon_calc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:timezone/timezone.dart' as tz;

class DailyActivitySection extends StatelessWidget {
  DailyActivitySection({super.key, required this.selectedCity});

  final City selectedCity;

  final DateFormat formatter = DateFormat.jm();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double screenWidth = size.width;

    return ValueListenableBuilder<Map?>(
        valueListenable: SelectedDataManager().selectedDataNotifier,
        builder: (context, selectedData, _) {
          if (selectedData != null) {
            final MoonTimeCalculator moonCalculator = MoonTimeCalculator(selectedCity.latitude, selectedCity.longitude);
            final timeRanges = moonCalculator.getMajorAndMinorTimeRanges(selectedData["moonPhaseData"].date.toUtc(), selectedCity, selectedData);

            int score = DailyFishActivityLogic().getFishingScore(selectedData["moonPhaseData"].phase.toDouble(), selectedData["weatherData"].code);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  // title
                  Align(alignment: Alignment.centerLeft, child: Text("Fish Activity", style: Theme.of(context).textTheme.titleSmall),),

                  SizedBox(height: 16,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // times
                      Column(
                        children: [
                          Text("Major times",),
                          Text("${formatter.format(timeRanges['firstMajorTime']![0])} - ${formatter.format(timeRanges['firstMajorTime']![1])}", style: Theme.of(context).textTheme.labelMedium,),
                          Text("${formatter.format(timeRanges['secondMajorTime']![0])} - ${formatter.format(timeRanges['secondMajorTime']![1])}", style: Theme.of(context).textTheme.labelMedium,),

                          SizedBox(height: 4,),

                          Text("Minor times",),
                          Text("${formatter.format(timeRanges['firstMinorTime']![0])} - ${formatter.format(timeRanges['firstMinorTime']![1])}", style: Theme.of(context).textTheme.labelMedium,),
                          Text("${formatter.format(timeRanges['secondMinorTime']![0])} - ${formatter.format(timeRanges['secondMinorTime']![1])}", style: Theme.of(context).textTheme.labelMedium,),
                        ],
                      ),

                      // daily score
                      CircularPercentIndicator(
                        radius: 60,
                        lineWidth: 15,
                        percent: score / 100,
                        animation: true,
                        curve: Curves.easeInOutExpo,
                        center: Text(
                          "${score.toInt()}",
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        progressColor: Theme.of(context).colorScheme.primary,
                        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
                      ),
                    ],
                  ),

                  // timeline
                  TimelineBar(
                    selectedCity: selectedCity,
                    highlightedSections: [
                      TimeSection(
                        startDateTime: timeRanges['firstMajorTime']![0],
                        endDateTime: timeRanges['firstMajorTime']![1],
                        color: Theme.of(context).colorScheme.secondary,
                      ),

                      TimeSection(
                        startDateTime: timeRanges['secondMajorTime']![0],
                        endDateTime: timeRanges['secondMajorTime']![1],
                        color: Theme.of(context).colorScheme.secondary,
                      ),

                      TimeSection(
                        startDateTime: timeRanges['firstMinorTime']![0],
                        endDateTime: timeRanges['firstMinorTime']![1],
                        color: Theme.of(context).colorScheme.secondaryFixed,
                      ),

                      TimeSection(
                        startDateTime: timeRanges['secondMinorTime']![0],
                        endDateTime: timeRanges['secondMinorTime']![1],
                        color: Theme.of(context).colorScheme.secondaryFixed,
                      ),
                    ],
                  )
                ],
              ),
            );

          }
          return Center(child: CircularProgressIndicator());
        }
    );
  }
}

class TimelineBar extends StatefulWidget {
  final List<TimeSection> highlightedSections;
  final City selectedCity;

  const TimelineBar({Key? key, required this.highlightedSections, required this.selectedCity}) : super(key: key);

  @override
  _TimelineBarState createState() => _TimelineBarState();
}

class _TimelineBarState extends State<TimelineBar> {
  late Timer _timer;
  late DateTime _currentTime;

  @override
  void initState() {
    super.initState();
    _currentTime = tz.TZDateTime.from(DateTime.now().toUtc(), tz.getLocation(widget.selectedCity.timeZoneId));
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        _currentTime = tz.TZDateTime.from(DateTime.now().toUtc(), tz.getLocation(widget.selectedCity.timeZoneId));
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(double.infinity, 100),
      painter: TimelineBarPainter(_currentTime, widget.highlightedSections, context),
    );
  }
}

class TimelineBarPainter extends CustomPainter {
  final DateTime currentTime;
  final List<TimeSection> highlightedSections;
  final BuildContext context;

  TimelineBarPainter(this.currentTime, this.highlightedSections, this.context);

  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width;
    double height = size.height;
    double hourWidth = width / 24;

    Paint barPaint = Paint()
      ..color = Theme.of(context).colorScheme.surfaceContainerHigh
      ..style = PaintingStyle.fill;

    Paint currentTimePaint = Paint()
      ..color = Theme.of(context).colorScheme.primary;

    // Draw the solid bar
    canvas.drawRect(Rect.fromLTWH(0, height / 2 - 10, width, 20), barPaint);

    // Highlight time sections
    for (var section in highlightedSections) {
      if (section.startDateTime.add(Duration(milliseconds: section.startDateTime.difference(section.endDateTime).inMilliseconds.abs())).day == section.startDateTime.day) {
        // Normal section
        _drawHighlight(
          canvas,
          section.startDateTime,
          section.endDateTime,
          hourWidth,
          size,
          section.color,
        );
      } else {
        // Spanning midnight: split into two parts
        _drawHighlight(
          canvas,
          section.startDateTime,
          DateTime(section.startDateTime.year, section.startDateTime.month,
              section.startDateTime.day, 23, 59, 59),
          hourWidth,
          size,
          section.color,
        );
        _drawHighlight(
          canvas,
          DateTime(section.endDateTime.year, section.endDateTime.month,
              section.endDateTime.day, 0, 0),
          section.endDateTime,
          hourWidth,
          size,
          section.color,
        );
      }
    }

    // Draw hour labels (every 3rd hour) in 12-hour format
    for (int i = 0; i <= 24; i += 3) {
      double x = i * hourWidth;

      int hour12 = i % 12;
      String period = (i < 12 || i == 24) ? 'a' : 'p';
      if (hour12 == 0) hour12 = 12;  // Adjust for 12 AM/PM

      TextSpan span = TextSpan(
        style: Theme.of(context).textTheme.bodyMedium,
        text: '$hour12',
      );
      TextPainter textPainter = TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: ui.TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
          canvas, Offset(x - textPainter.width / 2, height / 2 + 15));
    }

    // Draw the current time marker
    double currentX = currentTime.hour * hourWidth +
        (currentTime.minute / 60) * hourWidth;
    canvas.drawRect(
      Rect.fromLTWH(currentX - 2, height / 2 - 15, 4, 30),
      currentTimePaint,
    );

    // Draw the current time label in 12-hour format
    int currentHour12 = currentTime.hour % 12;
    String currentPeriod = (currentTime.hour < 12 || currentTime.hour == 24) ? 'AM' : 'PM';
    if (currentHour12 == 0) currentHour12 = 12;  // Adjust for 12 AM/PM

    TextSpan currentTimeSpan = TextSpan(
      style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Theme.of(context).colorScheme.primary),
      text: '$currentHour12:${currentTime.minute.toString().padLeft(2, '0')} $currentPeriod',
    );
    TextPainter currentTimePainter = TextPainter(
      text: currentTimeSpan,
      textAlign: TextAlign.center,
      textDirection: ui.TextDirection.ltr,
    );
    currentTimePainter.layout();
    currentTimePainter.paint(
        canvas, Offset(currentX - currentTimePainter.width / 2, height / 2 - 35));
  }

  void _drawHighlight(Canvas canvas, DateTime start, DateTime end, double hourWidth,
      Size size, Color color) {
    double startX = start.hour * hourWidth +
        (start.minute / 60) * hourWidth;
    double endX = end.hour * hourWidth +
        (end.minute / 60) * hourWidth;

    Paint sectionPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawRect(Rect.fromLTWH(startX, size.height / 2 - 10, endX - startX, 20),
        sectionPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class TimeSection {
  final DateTime startDateTime; // Start of the section
  final DateTime endDateTime;   // End of the section
  final Color color;            // Highlight color

  TimeSection({required this.startDateTime, required this.endDateTime, required this.color});
}