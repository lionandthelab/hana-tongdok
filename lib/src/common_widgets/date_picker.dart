import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class date_picker extends StatefulWidget {
  const date_picker({super.key});

  @override
  State<date_picker> createState() => _date_pickerState();
}

class _date_pickerState extends State<date_picker> {
  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: DateTime.now(),

    );
  }
}
