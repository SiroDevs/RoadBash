import 'package:flutter/material.dart';

class TimePickerUtil {
  static Future<TimeOfDay?> showCustomTimePicker({
    required BuildContext context,
    required TimeOfDay from,
    required TimeOfDay to,
  }) async {
    List<TimeOfDay> timeOptions = [];

    for (int hour = from.hour; hour <= to.hour; hour++) {
      for (int min = 0; min < 60; min += 5) {
        final time = TimeOfDay(hour: hour, minute: min);

        if (hour == from.hour && min < from.minute) continue;
        if (hour == to.hour && min > to.minute) continue;

        timeOptions.add(time);
      }
    }

    return showDialog<TimeOfDay>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select Time'),
          children: timeOptions
              .map(
                (time) => SimpleDialogOption(
                  onPressed: () => Navigator.pop(context, time),
                  child: Text(time.format(context)),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
