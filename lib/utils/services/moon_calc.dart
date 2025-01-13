import 'package:dart_suncalc/suncalc.dart';
import 'package:fishing_calendar/utils/services/city_reader.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz_data;

class MoonTimeCalculator {
  final double latitude;
  final double longitude;

  MoonTimeCalculator(this.latitude, this.longitude) {
    // Initialize timezone data when the class is instantiated
    tz_data.initializeTimeZones();
  }

  /// Calculate moonrise and moonset times for a given UTC time and timezone
  Map<String, DateTime> getMoonTimesForDate(DateTime utcDate, String timeZoneId, Map selectedData) {
    // Get the local timezone location
    final location = tz.getLocation(timeZoneId);

    final utcTime = DateTime(utcDate.year, utcDate.month, utcDate.day);

    // Calculate moonrise and moonset for the previous, current, and next days in UTC
    final moonTimesToday = SunCalc.getMoonTimes(utcTime, lat: latitude, lng: longitude);
    final moonTimesYesterday =
    SunCalc.getMoonTimes(utcTime.subtract(Duration(days: 1)), lat: latitude, lng: longitude);
    final moonTimesTomorrow =
    SunCalc.getMoonTimes(utcTime.add(Duration(days: 1)), lat: latitude, lng: longitude);

    // Collect all moonrise and moonset times
    var allMoonrise = [
      moonTimesYesterday.riseDateTime,
      moonTimesToday.riseDateTime,
      moonTimesTomorrow.riseDateTime
    ].whereType<DateTime>(); // Filter out null values

    var allMoonset = [
      moonTimesYesterday.setDateTime,
      moonTimesToday.setDateTime,
      moonTimesTomorrow.setDateTime
    ].whereType<DateTime>(); // Filter out null values

    // convert times to local for no errors
    var allMoonriseTz = allMoonrise.map((time) => tz.TZDateTime.from(time, location)).toList();
    var allMoonsetTz = allMoonset.map((time) => tz.TZDateTime.from(time, location)).toList();

    // Filter valid moonrise and moonset times that occur on or after the given UTC time
    final nextMoonrise = allMoonriseTz.firstWhere(
          (rise) => rise.day == selectedData["moonPhaseData"].date.day,
      orElse: () => allMoonriseTz.isNotEmpty ? allMoonriseTz.first : tz.TZDateTime.now(location),
    );

    final nextMoonset = allMoonsetTz.firstWhere(
          (set) => set.day == selectedData["moonPhaseData"].date.day,
      orElse: () => allMoonsetTz.isNotEmpty ? allMoonsetTz.first : tz.TZDateTime.now(location),
    );

    // Calculate overhead and underfoot times
    final differenceInMilliseconds = nextMoonset.difference(nextMoonrise).abs().inMilliseconds ~/ 2;
    final difference = Duration(milliseconds: differenceInMilliseconds);

    DateTime moonOverhead;
    DateTime moonUnderfoot;

    if (nextMoonrise.isBefore(nextMoonset)) {
      moonOverhead = nextMoonrise.add(difference);
      moonUnderfoot = moonOverhead.subtract(Duration(hours: 11, minutes: 47));
    } else {
      moonUnderfoot = nextMoonset.add(difference);
      moonOverhead = moonUnderfoot.subtract(Duration(hours: 11, minutes: 47));
    }


    // Return the moonrise and moonset times in local time
    return {
      'moonrise': nextMoonrise,
      'moonset': nextMoonset,
      'moonoverhead': moonOverhead,
      'moonunderfoot': moonUnderfoot
    };
  }

  List<DateTime> getTimeRange(DateTime time, Duration range) {
    final int halfRangeInMilliseconds = range.inMilliseconds ~/ 2;

    final DateTime startTime = time.subtract(Duration(milliseconds: halfRangeInMilliseconds));
    final DateTime endTime = time.add(Duration(milliseconds: halfRangeInMilliseconds));

    return [startTime, endTime];
  }

  Map<String, List<DateTime>> getMajorAndMinorTimeRanges(DateTime utcTime, City city, Map selectedData) {
    final moonTimes = getMoonTimesForDate(utcTime, city.timeZoneId, selectedData);


    final firstMajorTime = getTimeRange(moonTimes['moonoverhead']!, Duration(hours: 2));
    final secondMajorTime = getTimeRange(moonTimes['moonunderfoot']!, Duration(hours: 2));

    final firstMinorTime = getTimeRange(moonTimes['moonrise']!, Duration(hours: 1, minutes: 30));
    final secondMinorTime = getTimeRange(moonTimes['moonset']!, Duration(hours: 1, minutes: 30));

    return {
      "firstMajorTime": firstMajorTime,
      "secondMajorTime": secondMajorTime,
      "firstMinorTime": firstMinorTime,
      "secondMinorTime": secondMinorTime,
    };
  }
}
