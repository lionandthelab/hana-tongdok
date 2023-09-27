import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starter_architecture_flutter_firebase/src/features/read/data/read_repository.dart';
import 'package:starter_architecture_flutter_firebase/src/routing/app_router.dart';

class ReadScreen extends StatefulWidget {
  const ReadScreen({super.key});

  @override
  State<ReadScreen> createState() => _ReadScreenState();
}

class _ReadScreenState extends State<ReadScreen> {
  late List<dynamic> _verseData = [];
  late DateTime? _selectedDate = null;
  late String _verseKey = "";
  double _fontSize = 24.0; // Initial font size
  final today = DateUtils.dateOnly(DateTime.now());
  late bool _showCalendar = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ReadRepository readRepository = new ReadRepository();
  CollectionReference product = FirebaseFirestore.instance.collection("users");

  EventList<Event> _markedDateMap = new EventList<Event>(
    events: {},
  );

  @override
  void initState() {
    super.initState();

    setState(() => {
          _selectedDate = DateTime.now(),
          _verseKey = "m${DateTime.now().month}d${DateTime.now().day}",
        });

    _loadUserSettings();
    _loadUserDates();
    print("initState: _verseKey: $_verseKey");
    _loadJsonData();
  }

  @override
  void deactivate() async {
    super.deactivate();
    print("deactivate: _verseKey: $_verseKey");

    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setDouble("fontSize", _fontSize);
  }

  void _increaseFontSize() {
    setState(() {
      _fontSize += 2.0;
    });
  }

  void _decreaseFontSize() {
    setState(() {
      _fontSize -= 2.0;
    });
  }

  Future<void> _submitAddDate(DateTime selectedDate) async {
    if (selectedDate != null) {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final path = 'users/${user!.uid}/dates';
        readRepository.addDate(uid: user.uid, date: selectedDate.toString());
        print("selectedDate.toString(): ${selectedDate.toString()}");

        QuerySnapshot querySnapshot = await _firestore.collection(path).get();
        print("after addDate: $querySnapshot");
      }
    }
  }

  // Future<void> _loadDatesData() async {
  //   print('hello');
  //   final user = FirebaseAuth.instance.currentUser;
  //   final path = 'users/${user!.uid}/dates';

  //   if (user != null) {
  //     // readRepository.addDate(uid: user.uid, date: "09/13");
  //     QuerySnapshot querySnapshot = await _firestore.collection(path).get();
  //     print("_loadDatesData: $querySnapshot");
  //     querySnapshot.docs.forEach((doc) {
  //       print(doc["date"]);
  //     });
  //   }
  // }

  Future<void> _loadUserDates() async {
    print('firestore dates read - start');
    final user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('dates')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc["date"]);
        _markedDateMap.add(
            DateTime.parse(doc["date"]),
            new Event(
              date: DateTime.parse(doc["date"]),
              icon: Icon(Icons.check_circle_outline_outlined),
              dot: Container(
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                color: Colors.black,
                height: 12.0,
                width: 12.0,
              ),
            ));
      });
    });
    print('firestore dates read - done ');
  }

  Future<void> _loadUserSettings() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    _fontSize = sharedPreferences.getDouble("fontSize") ?? 24.0;
    print("initState(sharedPreferences): _fontSize: $_fontSize");
  }

  Future<void> _loadJsonData() async {
    final jsonString =
        await rootBundle.loadString('assets/json/bible-RNKSV.json');
    final jsonData = json.decode(jsonString);

    setState(() {
      // String m = _selectedDate!.month.toString();
      // String d = _selectedDate!.day.toString();
      // _verseKey = "m${m}d$d";

      // yourJsonData = jsonData[_verseKey]["contents"] as List<Map<String, dynamic>>;
      _verseData = jsonData[_verseKey]["contents"] as List<dynamic>;
      print("_verseData: $_verseData");
      // yourJsonData = jsonDecode(_bibleList) as List<Map<String, dynamic>>;
    });
  }

  Future<void> _selectDate(BuildContext context, List<DateTime> dates) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2024),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final _calendarCarousel = CalendarCarousel<Event>(
      onDayPressed: (date, events) {
        print("onDayPressed: date: $date");
        setState(() => {
              _selectedDate = date,
              _verseKey = "m${_selectedDate?.month}d${_selectedDate?.day}",
            });

        _loadJsonData();
        setState(() => _showCalendar = !_showCalendar);
      },
      weekdayTextStyle: TextStyle(
        color: Colors.black87,
      ),
      headerTextStyle: TextStyle(
        color: Colors.cyan,
      ),
      weekendTextStyle: TextStyle(
        color: Colors.redAccent,
      ),
      thisMonthDayBorderColor: Colors.grey,
//          weekDays: null, /// for pass null when you do not want to render weekDays
      headerText: '하나통독 캘린더',
      weekFormat: false,
      markedDatesMap: _markedDateMap,
      selectedDateTime: _selectedDate,
      showIconBehindDayText: true,
//          daysHaveCircularBorder: false, /// null for not rendering any border, true for circular border, false for rectangular border
      markedDateShowIcon: true,
      markedDateIconMaxShown: 2,
      selectedDayTextStyle: TextStyle(
        color: Colors.white,
      ),
      selectedDayBorderColor: Colors.cyan,
      selectedDayButtonColor: Colors.cyan,
      markedDateCustomShapeBorder: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      todayTextStyle: TextStyle(
        color: Colors.cyan,
      ),
      markedDateIconBuilder: (event) {
        return event.icon ?? Icon(Icons.help_outline);
      },
      markedDateMoreCustomDecoration: BoxDecoration(
        border: Border.all(
          color: Colors.cyanAccent,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(4.0),
        color: Colors.cyanAccent,
      ),
      // minSelectedDate: _selectedDate.subtract(Duration(days: 360)),
      // maxSelectedDate: _selectedDate.add(Duration(days: 360)),
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      // markedDateCustomShapeBorder:
      //     (side: BorderSide(color: Colors.yellow)),
      markedDateCustomTextStyle: TextStyle(
        fontSize: 18,
        color: Colors.blue,
      ),
      todayButtonColor: Colors.transparent,
      todayBorderColor: Colors.cyanAccent,
      markedDateIconMargin: 5,
      markedDateIconOffset: 1,
    );

    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.book_rounded),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              setState(() => _showCalendar = !_showCalendar);
              // showDialog(
              //     context: context,
              //     barrierDismissible: true, // 바깥 영역 터치시 닫을지 여부
              //     builder: (BuildContext context) {
              //       return AlertDialog(
              //         content: Container(
              //           margin: EdgeInsets.symmetric(horizontal: 16.0),
              //           child: _calendarCarousel,
              //         ), //_calendarCarousel,
              //         insetPadding: const EdgeInsets.fromLTRB(0, 80, 0, 80),
              //         actions: [
              //           TextButton(
              //             child: const Text('확인'),
              //             onPressed: () {
              //               Navigator.of(context).pop();
              //             },
              //           ),
              //         ],
              //       );
              //     });
            },
            // onPressed: () => _selectDate(context, [DateTime(2023, 09, 01)]),
          ),
          FontSizeAdjusterButton(
              increaseFontSize: _increaseFontSize,
              decreaseFontSize: _decreaseFontSize),
          IconButton(
            icon: Icon(Icons.history_edu_rounded),
            onPressed: () => context.goNamed(
              AppRoute.keep.name,
              // pathParameters: {'id': proclaim.id},
            ),
          ),
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              if (_selectedDate != null) _submitAddDate(_selectedDate!);
              print(_selectedDate.toString());
              _loadUserDates();
            },
          ),
        ],
      ),
      body: _showCalendar
          ? Container(
              margin: EdgeInsets.symmetric(horizontal: 160.0),
              child: _calendarCarousel,
            )
          : StreamBuilder(
              stream: product.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasData) {
                  return TextSizeAdjusterWidget(
                      jsonData: _verseData, fontSize: _fontSize);
                }
                return CircularProgressIndicator();
              },
            ), //_cal
      //,
    );
  }
}

class TextSizeAdjusterWidget extends StatefulWidget {
  final List<dynamic> jsonData;
  final double fontSize;

  TextSizeAdjusterWidget({required this.jsonData, required this.fontSize});

  @override
  _TextSizeAdjusterWidgetState createState() => _TextSizeAdjusterWidgetState();
}

class _TextSizeAdjusterWidgetState extends State<TextSizeAdjusterWidget> {
  @override
  void initState() {
    super.initState();
    // print("initState: jsondata: ${widget.jsonData}");
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.jsonData.length,
      itemBuilder: (context, chapterIndex) {
        final chapter = widget.jsonData[chapterIndex];
        final chapterName = chapter['chapter_name'];
        final numOfVerses = chapter['num_of_verses'];
        final paragraphs = List<dynamic>.from(chapter['paragraphs']);

        return Center(
            child: Container(
                margin: EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(
                        '$chapterName - $numOfVerses절',
                        style: TextStyle(
                          fontSize: widget.fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: paragraphs.length,
                      itemBuilder: (context, paragraphIndex) {
                        final paragraph = paragraphs[paragraphIndex];
                        final title = paragraph['title'];
                        final verses = List<Map<String, dynamic>>.from(
                            paragraph['verses']);

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (title != null && title.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  title,
                                  style: TextStyle(
                                    fontSize: widget.fontSize - 2,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            for (var verse in verses)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextButton(
                                  child: Text(
                                    '${verse['index']}. ${verse['content']}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: widget.fontSize - 4),
                                  ),
                                  onPressed: () {
                                    context.goNamed(AppRoute.editKeep.name,
                                        pathParameters: {},
                                        queryParameters: {
                                          'title':
                                              "$chapterName ${verse['index']}절",
                                          'verse': verse['content'],
                                          'note': '',
                                          'id': Random.secure()
                                              .nextInt(1000000)
                                              .toString()
                                        });
                                  },
                                ),
                              ),
                            for (var verse in verses)
                              if (verse['comments'] != null)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '${verse['comments']}',
                                    style: TextStyle(
                                        fontSize: widget.fontSize - 6,
                                        fontStyle: FontStyle.italic),
                                  ),
                                ),
                          ],
                        );
                      },
                    ),
                  ],
                )));
      },
    );
  }
}

class FontSizeAdjusterButton extends StatelessWidget {
  final VoidCallback increaseFontSize; // Define a callback property
  final VoidCallback decreaseFontSize; // Define a callback property

  const FontSizeAdjusterButton(
      {required this.increaseFontSize,
      required this.decreaseFontSize}); // Constructor to receive the callback

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: increaseFontSize,
        ),
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: () {
            // ScaffoldMessenger.of(context).hideCurrentSnackBar();
            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //   content: Text('Decrease Font Size'),
            // ));
            decreaseFontSize();
          },
        ),
      ],
    );
  }
}
