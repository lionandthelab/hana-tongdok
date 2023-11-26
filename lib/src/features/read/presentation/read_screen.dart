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
  bool _showCheckButton = false;
  bool _isButtonClicked = false;
  late String _chapter = "";
  late String _date = "";
  late List<dynamic> _verseData = [];
  late DateTime? _selectedDate = null;
  late String _verseKey = "";
  double _fontSize = 24.0; // Initial font size
  final today = DateUtils.dateOnly(DateTime.now());
  late bool _showCalendar = false;
  late double _progress = 0.0;

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
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('dates')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print("Marked ${DateTime.parse(doc["date"])}");
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

    DateTime now = _selectedDate ?? DateTime.now();
    DateTime startOfYear = DateTime(now.year, 1, 1);
    DateTime endOfYear = DateTime(now.year + 1, 1, 1);
    int totalDays = endOfYear.difference(startOfYear).inDays;

    int progressDays = _markedDateMap.events.length;

    _progress = progressDays / totalDays;
    print('progress calculated: $_progress ($progressDays/$totalDays))');

    _isButtonClicked = false;
  }

  Future<void> _loadUserSettings() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    _fontSize = sharedPreferences.getDouble("fontSize") ?? 24.0;
    print("initState(sharedPreferences): _fontSize: $_fontSize");

    _isButtonClicked = false;
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
      _date = jsonData[_verseKey]["date"];
      _chapter = jsonData[_verseKey]["chapter"];
      _verseData = jsonData[_verseKey]["contents"] as List<dynamic>;
      print("_verseKey: $_verseKey");
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
    final _calendarCarousel = Theme(
        data: ThemeData(
            primarySwatch: Colors.blue,
            splashColor: Colors.red,
            primaryColor: Colors.red),
        child: CalendarCarousel<Event>(
          showHeader: false,
          onDayPressed: (date, events) {
            print("onDayPressed: date: $date");
            setState(() => {
                  _selectedDate = date,
                  _verseKey = "m${_selectedDate?.month}d${_selectedDate?.day}",
                });
            _loadJsonData();
            _loadUserDates();
            // setState(() => _showCalendar = !_showCalendar);
          },
          locale: 'ko',
          prevDaysTextStyle: TextStyle(
            color: Colors.grey, // Set the arrow color to cyan
          ),
          nextDaysTextStyle: TextStyle(
            color: Colors.grey, // Set the arrow color to cyan
          ),
          daysTextStyle: TextStyle(
            color: Colors.black87, // Set the arrow color to cyan
          ),
          weekdayTextStyle: TextStyle(
            color: Colors.black87,
          ),
          headerTextStyle: TextStyle(
            color: Colors.black87,
            fontSize: 24,
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
          markedDateIconMaxShown: 1,
          selectedDayTextStyle: TextStyle(
            color: Colors.white,
          ),
          selectedDayBorderColor: Colors.grey,
          selectedDayButtonColor: Colors.blue,
          markedDateCustomShapeBorder: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          todayTextStyle: TextStyle(
            color: Colors.cyan,
          ),
          markedDateIconBuilder: (event) {
            return Icon(Icons.check_circle, size: 30);
          },
          markedDateMoreCustomDecoration: BoxDecoration(
            border: Border.all(
              color: Colors.cyan,
              width: 3.0,
            ),
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.cyan,
          ),
          // minSelectedDate: _selectedDate.subtract(Duration(days: 360)),
          // maxSelectedDate: _selectedDate.add(Duration(days: 360)),
          customGridViewPhysics: NeverScrollableScrollPhysics(),
          // markedDateCustomShapeBorder:
          //     (side: BorderSide(color: Colors.yellow)),
          markedDateCustomTextStyle: TextStyle(
            fontSize: 16,
            color: Colors.cyan,
          ),
          todayButtonColor: Colors.transparent,
          todayBorderColor: Colors.cyan,
          markedDateIconMargin: 10,
          markedDateIconOffset: 10,
        ));

    return Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.book_rounded),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: () {
                setState(() => _showCalendar = !_showCalendar);
                setState(() => _showCheckButton = false);
              },
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
          ],
        ),
        body: _showCalendar
            ? Container(
                color: Colors.white,
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      _selectedDate == null
                          ? '날짜를 선택하세요'
                          : DateFormat('yyyy년 MM월 dd일').format(_selectedDate!),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.0),

                    Text(
                      _selectedDate == null ? '말씀을 선택하세요' : '$_chapter장',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 32.0),
                    Expanded(
                      child: _calendarCarousel,
                    ),
                    SizedBox(height: 16.0),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              onPrimary: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                            ),
                            child: Text(
                              '읽으러 가기',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            onPressed: () async {
                              setState(() {
                                _showCalendar = false;
                              });
                            },
                          )
                        ]),
                    SizedBox(height: 48.0),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(children: [
                          Expanded(
                              child: Text(
                            '${DateTime.now().year}년 목표',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.left,
                          )),
                          Expanded(
                              child: Text(
                            '${(_progress * 100).toStringAsFixed(2)}%',
                            style: TextStyle(
                              color: Colors.cyan,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.right,
                          )),
                        ]),
                        SizedBox(height: 16.0),
                        LinearProgressIndicator(
                          value: _progress,
                          backgroundColor: Colors.grey[300],
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.cyan),
                        ),
                        SizedBox(height: 16.0),
                      ],
                    ),
                    // _calendarCarousel
                  ],
                ),
              )
            : NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollEndNotification) {
                    final metrics = notification.metrics;
                    if (metrics.atEdge &&
                        metrics.pixels == metrics.maxScrollExtent) {
                      setState(() {
                        _showCheckButton = true;
                      });
                    } else {
                      setState(() {
                        _showCheckButton = false;
                      });
                    }
                  }
                  return true;
                },
                child: StreamBuilder(
                  stream: product.snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                    if (streamSnapshot.hasData) {
                      // return TextSizeAdjusterWidget(
                      //     jsonData: _verseData, fontSize: _fontSize);
                      return Column(
                        children: [
                          Expanded(
                            child: TextSizeAdjusterWidget(
                                jsonData: _verseData, fontSize: _fontSize),
                          ),
                          if (_showCheckButton)
                            AnimatedOpacity(
                              opacity: _showCheckButton ? 1.0 : 0.0,
                              duration: Duration(milliseconds: 1000),
                              child: Container(
                                  padding: EdgeInsets.all(16.0),
                                  color: Colors.white,
                                  child: Center(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: IconButton(
                                            icon: Icon(Icons.check, size: 50),
                                            color: _isButtonClicked
                                                ? Colors.cyan
                                                : Colors.black87,
                                            onPressed: () async {
                                              setState(() {
                                                _isButtonClicked = true;
                                              });

                                              if (_selectedDate != null) {
                                                await _submitAddDate(
                                                    _selectedDate!);
                                              }

                                              print(_selectedDate.toString());
                                              await _loadUserDates();

                                              setState(() {
                                                _showCalendar = true;
                                                _showCheckButton = false;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                        ],
                      );
                    }
                    return CircularProgressIndicator();
                  },
                ), //_cal
                //,
              ));
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
        final comments = paragraphs
            .map((paragraph) => paragraph['verses']
                .map((verse) => verse['comments'])
                .where((comment) => comment != null)
                .toList())
            .expand((i) => i)
            .toSet();

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
                      title: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '$chapterName',
                              style: TextStyle(
                                fontSize: widget
                                    .fontSize, // Font size for chapterName
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: ' - $numOfVerses절',
                              style: TextStyle(
                                fontSize: widget.fontSize -
                                    6, // Font size for numOfVerses
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                          ],
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
                                padding: const EdgeInsets.symmetric(
                                    vertical:
                                        2.0), // Adjust the vertical padding value
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
                          ],
                        );
                      },
                    ),
                    for (var comment in comments)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${comment}',
                          style: TextStyle(
                            fontSize: widget.fontSize - 8,
                            fontFamily: 'NotoSansKR',
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
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
