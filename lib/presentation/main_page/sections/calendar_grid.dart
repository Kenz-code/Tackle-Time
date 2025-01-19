import 'package:tackle_time/logic/main_page/daily_fish_activity.dart';
import 'package:tackle_time/logic/main_page/moon_phase.dart';
import 'package:tackle_time/logic/main_page/selected_data_manager.dart';
import 'package:tackle_time/utils/constants/border_radius.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CalendarGrid extends StatefulWidget {

  const CalendarGrid(this.data, {super.key});

  final Map data;

  @override
  State<CalendarGrid> createState() => _CalendarGridState();
}

class _CalendarGridState extends State<CalendarGrid> {
  int startDayOfWeek = 6;
 // Example: 0 = Sunday, 1 = Monday, ..., 6 = Saturday (e.g., starts on Wednesday)
  List<Widget> calendarWidgets = [];

  int currentMonth = 12;

  int currentYear = 2024;

  @override
  void initState() {
    super.initState();

    // set current date
    currentMonth = DateTime.now().month;
    currentYear = DateTime.now().year;
  }

  void makeCalendarWidgets(context) {
    calendarWidgets = [];
    startDayOfWeek = getAdjustedWeekday(DateTime.utc(currentYear, currentMonth, 1)) - 1;

    // Add days of the week headers
    final List<String> daysOfWeek = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    for (var day in daysOfWeek) {
      calendarWidgets.add(
        Center(
          child: Text(
            day,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ),
      );
    }

    // Add empty cells for days before the start of the month
    for (int i = 0; i < startDayOfWeek; i++) {
      calendarWidgets.add(Container());
    }

    for (int day = 0; day < DateUtils.getDaysInMonth(currentYear, currentMonth); day++) {
      calendarWidgets.add(CalendarGridDay(data: widget.data, date: DateTime.utc(currentYear, currentMonth, day + 1)));
    }
  }

  int getAdjustedWeekday(DateTime date) {
    return date.weekday == 7 ? 1 : date.weekday + 1;
  }

  void addMonth() {
    setState(() {
      currentMonth += 1;

      if (currentMonth == 13) {
        currentMonth = 1;
        currentYear += 1;
      }
    });
  }

  void subtractMonth() {
    setState(() {
      currentMonth -= 1;

      if (currentMonth == 0) {
        currentMonth = 12;
        currentYear -= 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    makeCalendarWidgets(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(onPressed: subtractMonth, icon: Icon(Icons.arrow_back_ios_rounded)),

              Text("${DateFormat('MMMM').format(DateTime(0, currentMonth))} - $currentYear", style: Theme.of(context).textTheme.titleMedium,),

              IconButton(onPressed: addMonth, icon: Icon(Icons.arrow_forward_ios_rounded)),
            ],
          ), // update this to match

          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 7, // 7 columns for the days of the week
            children: calendarWidgets,
          ),
        ],
      ),
    );
  }
}

class CalendarGridDay extends StatefulWidget {
  const CalendarGridDay({super.key, required this.data, required this.date});

  final Map data;
  final DateTime date;

  @override
  State<CalendarGridDay> createState() => _CalendarGridDayState();
}

class _CalendarGridDayState extends State<CalendarGridDay> {
  final DailyFishActivityLogic logic = DailyFishActivityLogic();
  int index = 0;
  bool hasData = false;

  Color getContainerColor(bool hasData, selectedData, int index) {
    if (hasData) {
      return selectedData["moonPhaseData"].date == widget.data["moonPhaseData"][index].date ? Theme.of(context).colorScheme.surfaceContainer : Colors.transparent;
    } else {
      return Colors.transparent;
    }
  }

  Color getPercentIndicatorBackgroundColor(bool hasData, selectedData, int index, BuildContext context) {
    if (hasData) {
      return selectedData["moonPhaseData"].date == widget.data["moonPhaseData"][index].date ? Theme.of(context).colorScheme.surfaceContainerHighest : Theme.of(context).colorScheme.surfaceContainerHigh;
    } else {
      return Theme.of(context).colorScheme.surfaceContainerHigh;
    }
  }

  void setCurrentDay() {
    SelectedDataManager().updateSelectedDay(
        {
          'moonPhaseData': widget.data['moonPhaseData'][index],
          "weatherData": widget.data["weatherData"][index]
        }
    );
  }

  @override
  void initState() {
    super.initState();

    if (isDateToday()) {
      WidgetsBinding.instance.addPostFrameCallback((_) => setCurrentDay());
    }
  }

  bool isDateToday() => DateTime.now().year == widget.date.year &&
      DateTime.now().month == widget.date.month &&
      DateTime.now().day == widget.date.day;

  void setHasDataAndIndex() {
    hasData = false;
    index = 0;
    for (final MoonPhase i in widget.data['moonPhaseData']) {
      if (i.date.year == widget.date.year && i.date.month == widget.date.month && i.date.day == widget.date.day) {
        hasData = true;
        break;
      } else {
        index += 1;
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    setHasDataAndIndex();
    int fishingScore = 0;
    if (hasData) {
      final double moonPhase = widget.data['moonPhaseData'][index].phase.toDouble();
      final int weatherCode = widget.data["weatherData"][index].code;

      // Calculate the fishing score for the day
      fishingScore = logic.getFishingScore(moonPhase, weatherCode);
    }

    // Determine if the day is today
    final bool isToday = isDateToday();

    return GestureDetector(
      onTap: hasData ? () {
        setCurrentDay();

        HapticFeedback.lightImpact();
      } : () {},
      child: ValueListenableBuilder(
        valueListenable: SelectedDataManager().selectedDataNotifier,
        builder: (context, selectedData, _) {
          if (selectedData != null) {
            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: AppBorderRadius.defaultBorderRadius,
                      color: getContainerColor(hasData, selectedData, index)
                  ),
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          '${widget.date.day}',
                          style: Theme.of(context).textTheme.labelLarge!.copyWith(color: hasData ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.onSurfaceVariant),
                        ),
                      ),
                      SizedBox(height: 4),
                      hasData ? LinearProgressIndicator(
                        value: fishingScore / 100,
                        backgroundColor: getPercentIndicatorBackgroundColor(hasData, selectedData, index, context),
                        valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.secondary),
                      ) : SizedBox.shrink(),
                    ],
                  ),
                ),
                if (isToday)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            );
          }
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(borderRadius: AppBorderRadius.defaultBorderRadius,
                  color: Colors.transparent
                ),
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        '${widget.date.day}',
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(color: hasData ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                    ),
                    SizedBox(height: 4),
                    hasData ? LinearProgressIndicator(
                      value: fishingScore / 100,
                      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.secondary),
                    ) : SizedBox.shrink()
                  ],
                ),
              ),
              if (isToday)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
