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
import 'package:hntd/src/features/read/data/read_repository.dart';
import 'package:hntd/src/routing/app_router.dart';

class ReadScreen extends StatefulWidget {
  const ReadScreen({super.key});

  @override
  State<ReadScreen> createState() => _ReadScreenState();
}

class _ReadScreenState extends State<ReadScreen> {
  bool _isDarkMode = false;
  int _annualGoal = 1;
  bool _showCheckButton = false;
  bool _isButtonClicked = false;
  late DateTime? _selectedDate = null;
  // late String _verseKey = "";
  // late String _chapter = "";
  late List<dynamic> _verseData = [];
  late List<String> _verseKeys = [];
  late List<String> _chapters = [];
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

    setState(() => _selectedDate = DateTime.now());

    _loadUserSettings();
    _loadUserDates();
    _loadJsonData();
  }

  @override
  void deactivate() async {
    super.deactivate();
    // print("deactivate: _verseKey: $_verseKey");

    _saveUserSettings();
  }

  void _increaseFontSize() {
    setState(() {
      _fontSize += 2.0;
    });
    _saveUserSettings();
  }

  void _decreaseFontSize() {
    setState(() {
      _fontSize -= 2.0;
    });
    _saveUserSettings();
  }

  void _toggleThemeMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
      print("_isDarkMode: $_isDarkMode");
    });
    _saveUserSettings();
  }

  void _setAnnualGoal(int selectedValue) {
    setState(() {
      _annualGoal = selectedValue;
    });
    _saveUserSettings();
    _loadJsonData();
  }

  void _showCheckButtonOn() {
    setState(() {
      _showCheckButton = true;
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

    setState(() {
      _fontSize = sharedPreferences.getDouble("fontSize") ?? 24.0;
      _isDarkMode = sharedPreferences.getBool('isDarkMode') ?? false;
      _annualGoal = sharedPreferences.getInt('annualGoal') ?? 1;
    });

    print("initState(sharedPreferences): _fontSize: $_fontSize");

    _isButtonClicked = false;
  }

  Future<void> _saveUserSettings() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setDouble('fontSize', _fontSize);
    sharedPreferences.setBool('isDarkMode', _isDarkMode);
    sharedPreferences.setInt('annualGoal', _annualGoal);
  }

  Future<void> _loadJsonData() async {
    final jsonString =
        await rootBundle.loadString('assets/json/bible-RNKSV.json');
    final jsonData = json.decode(jsonString);

    setState(() {
      final dayPassedFromFirstDayOfYear =
          _selectedDate?.difference(DateTime(DateTime.now().year, 1, 1)).inDays;
      print("dayPassedFromFirstDayOfYear: $dayPassedFromFirstDayOfYear");

      List<String> _verseKeys = List.generate(_annualGoal, (index) {
        int day = (dayPassedFromFirstDayOfYear! * _annualGoal + index) % 365 +
            1; // 연도의 총 일수로 나눈 나머지를 사용하여 12월 31일을 넘어가면 다시 1월 1일로 돌아갑니다.
        DateTime date = DateTime(DateTime.now().year, 1, 1)
            .add(Duration(days: day - 1)); // 올해 첫날에 일수를 더하여 날짜를 계산합니다.
        return "m${date.month}d${date.day}";
      });

      print("_verseKeys: $_verseKeys");

      // _verseKey = "m${_selectedDate?.month}d${_selectedDate?.day}";
      // _chapter = jsonData[_verseKey]["chapter"];
      // _verseData = jsonData[_verseKey]["contents"] as List<dynamic>;
      _chapters =
          _verseKeys.map((key) => jsonData[key]["chapter"] as String).toList();
      final List<List<dynamic>> _verseDatas = _verseKeys
          .map((key) => jsonData[key]["contents"] as List<dynamic>)
          .toList();
      _verseData = _verseDatas.expand((data) => data).toList();
      // print("_verseKey: $_verseKey");
      // print("_verseData: $_verseData");
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
    final _calendarCarousel = AspectRatio(
      aspectRatio: 1.0, // Adjust this value as needed
      child: CalendarCarousel<Event>(
        showHeader: false,
        onDayPressed: (date, events) {
          print("onDayPressed: date: $date");
          setState(() {
            _selectedDate = date;
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
          color: _isDarkMode
              ? Theme.of(context).primaryColorLight
              : Theme.of(context)
                  .primaryColorDark, // Set the arrow color to cyan
        ),
        weekdayTextStyle: TextStyle(
            color: _isDarkMode
                ? Theme.of(context).primaryColorLight
                : Theme.of(context).primaryColorDark,
            fontSize: 20,
            fontWeight: FontWeight.bold),
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
        showIconBehindDayText: false,
        //          daysHaveCircularBorder: false, /// null for not rendering any border, true for circular border, false for rectangular border
        markedDateShowIcon: true,
        markedDateIconMaxShown: 1,
        selectedDayTextStyle: TextStyle(
          color: Colors.indigo,
        ),
        selectedDayBorderColor: Colors.grey,
        selectedDayButtonColor: Colors.white,
        markedDateCustomShapeBorder: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        todayTextStyle: TextStyle(
          color: Colors.indigo,
        ),
        markedDateIconBuilder: (event) {
          return Icon(
            Icons.check,
            size: 30,
            color: Colors.indigo,
          );
        },
        markedDateMoreCustomDecoration: BoxDecoration(
          border: Border.all(
            color: Colors.indigo,
            width: 3.0,
          ),
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.indigo,
        ),
        // minSelectedDate: _selectedDate.subtract(Duration(days: 360)),
        // maxSelectedDate: _selectedDate.add(Duration(days: 360)),
        customGridViewPhysics: ScrollPhysics(),
        // markedDateCustomShapeBorder:
        //     (side: BorderSide(color: Colors.yellow)),
        markedDateCustomTextStyle: TextStyle(
          fontSize: 16,
          color: Colors.indigo,
        ),
        todayButtonColor: Colors.transparent,
        todayBorderColor: Colors.indigo,
        markedDateIconMargin: 0,
        markedDateIconOffset: 0,
      ),
    );

    return Theme(
        data: _isDarkMode
            ? ThemeData(
                colorScheme: ColorScheme.dark(),
                secondaryHeaderColor: Colors.white,
                primarySwatch: Colors.indigo)
            : ThemeData(
                secondaryHeaderColor: Colors.black87,
                primarySwatch: Colors.indigo),
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              leading: Icon(Icons.book_rounded, color: Colors.black87),
              title: Text('하나통독', style: TextStyle(color: Colors.black87)),
              actions: <Widget>[
                PopupMenuButton<int>(
                  icon: Icon(Icons.more_vert, color: Colors.black87),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      child: ListTile(
                        leading: Icon(Icons.calendar_today),
                        title: Text("달력"),
                      ),
                    ),
                    PopupMenuItem(
                      value: 2,
                      child: ListTile(
                        leading: Icon(Icons.text_increase),
                        title: Text("글씨 크게"),
                      ),
                    ),
                    PopupMenuItem(
                      value: 3,
                      child: ListTile(
                        leading: Icon(Icons.text_decrease),
                        title: Text("글씨 작게"),
                      ),
                    ),
                    PopupMenuItem(
                      value: 4,
                      child: ListTile(
                        leading: Icon(
                          _isDarkMode ? Icons.brightness_7 : Icons.brightness_2,
                        ),
                        title: Text(_isDarkMode ? "다크 모드 OFF" : "다크 모드 ON"),
                      ),
                    ),
                    PopupMenuItem(
                      value: 5,
                      child: ListTile(
                        leading: Icon(Icons.numbers),
                        title: Text("통독 횟수"),
                      ),
                    ),
                    PopupMenuItem(
                      value: 6,
                      child: ListTile(
                        leading: Icon(Icons.list),
                        title: Text("말씀 노트"),
                      ),
                    ),
                  ],
                  onSelected: (value) async {
                    switch (value) {
                      case 1:
                        setState(() => _showCalendar = !_showCalendar);
                        setState(() => _showCheckButton = false);
                        break;
                      case 2:
                        _increaseFontSize();
                        break;
                      case 3:
                        _decreaseFontSize();
                        break;
                      case 4:
                        _toggleThemeMode();
                        break;
                      case 5:
                        int? selectedValue = await showDialog<int>(
                          context: context,
                          builder: (BuildContext context) {
                            return SimpleDialog(
                              title: const Text('🚩 통독 목표'),
                              children: <Widget>[
                                SimpleDialogOption(
                                  onPressed: () {
                                    Navigator.pop(context, 1);
                                  },
                                  child: const Text('😄 1년 1독'),
                                ),
                                SimpleDialogOption(
                                  onPressed: () {
                                    Navigator.pop(context, 2);
                                  },
                                  child: const Text('😁 1년 2독'),
                                ),
                                SimpleDialogOption(
                                  onPressed: () {
                                    Navigator.pop(context, 3);
                                  },
                                  child: const Text('😍 1년 3독'),
                                ),
                              ],
                            );
                          },
                        );
                        if (selectedValue != null) {
                          _setAnnualGoal(selectedValue);
                        }
                        break;
                      case 6:
                        context.goNamed(
                          AppRoute.keep.name,
                        );
                        break;
                    }
                  },
                ),
              ],
            ),
            body: _showCalendar
                ? Container(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          _selectedDate == null
                              ? '날짜를 선택하세요'
                              : DateFormat('yyyy년 MM월 dd일')
                                  .format(_selectedDate!),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16.0),

                        Text(
                          _selectedDate == null ? '말씀을 선택하세요' : '$_chapters',
                          style: TextStyle(
                            fontSize: 18,
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
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  backgroundColor:
                                      Colors.grey[50], // background
                                ),
                                child: Text(
                                  '읽으러 가기',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87),
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
                                  color: Theme.of(context).primaryColor,
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
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).primaryColor),
                            ),
                            SizedBox(height: 16.0),
                          ],
                        ),
                        // _calendarCarousel
                      ],
                    ),
                  )
                : StreamBuilder(
                    stream: product.snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                      if (streamSnapshot.hasData) {
                        return Column(
                          children: [
                            Expanded(
                              child: TextSizeAdjusterWidget(
                                  jsonData: _verseData,
                                  fontSize: _fontSize,
                                  showCheckButtonOn: _showCheckButtonOn),
                            ),
                          ],
                        );
                      }
                      return CircularProgressIndicator();
                    },
                  ), //_cal
            //,
            floatingActionButton: _showCheckButton
                ? FloatingActionButton(
                    onPressed: () async {
                      setState(() {
                        _isButtonClicked = true;
                      });

                      if (_selectedDate != null) {
                        await _submitAddDate(_selectedDate!);
                      }

                      print(_selectedDate.toString());
                      await _loadUserDates();

                      setState(() {
                        _showCalendar = true;
                        _showCheckButton = false;
                      });
                    },
                    child: Icon(
                      Icons.check,
                      size: 50,
                      color: _isButtonClicked ? Colors.black87 : Colors.white,
                    ),
                  )
                : null));
  }
}

class TextSizeAdjusterWidget extends StatefulWidget {
  final List<dynamic> jsonData;
  final double fontSize;
  final Function showCheckButtonOn;

  TextSizeAdjusterWidget(
      {required this.jsonData,
      required this.fontSize,
      required this.showCheckButtonOn});

  @override
  _TextSizeAdjusterWidgetState createState() => _TextSizeAdjusterWidgetState();
}

class _TextSizeAdjusterWidgetState extends State<TextSizeAdjusterWidget> {
  @override
  void initState() {
    super.initState();
    // print("initState: jsondata: ${widget.jsonData}");
  }

  final _pageController = PageController();

  Widget _buildChapter(dynamic chapter, bool isLastChapter) {
    final chapterName = chapter['chapter_name'];
    final numOfVerses = chapter['num_of_verses'];
    final paragraphs = List<dynamic>.from(chapter['paragraphs']);
    final comments = paragraphs
        .map((paragraph) => paragraph['verses']
            .map((verse) => verse['comments'])
            .where((comment) => comment != null))
        .expand((i) => i)
        .toSet();

    final scrollView = Center(
        child: Container(
            margin: EdgeInsets.all(4.0),
            decoration: BoxDecoration(
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
            child: SingleChildScrollView(
                child: Column(
              children: [
                ListTile(
                  title: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '$chapterName',
                          style: TextStyle(
                            fontSize:
                                widget.fontSize, // Font size for chapterName
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).secondaryHeaderColor,
                          ),
                        ),
                        TextSpan(
                          text: ' - $numOfVerses절',
                          style: TextStyle(
                            fontSize: widget.fontSize -
                                6, // Font size for numOfVerses
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).secondaryHeaderColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: paragraphs.length,
                  itemBuilder: (context, paragraphIndex) {
                    final paragraph = paragraphs[paragraphIndex];
                    final title = paragraph['title'];
                    final verses =
                        List<Map<String, dynamic>>.from(paragraph['verses']);

                    return Column(
                      children: [
                        if (title != null && title.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              title,
                              style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor,
                                fontSize: widget.fontSize - 2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        for (var verse in verses)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2.0,
                                horizontal:
                                    8.0), // Adjust the vertical padding value
                            child: TextButton(
                              child: Text(
                                '${verse['index']}. ${verse['content']}',
                                style: TextStyle(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  fontSize: widget.fontSize - 4,
                                ),
                                textAlign: TextAlign.justify,
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
                )
                // for (var comment in comments)
                //   Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: Text(
                //       '${comment}',
                //       style: TextStyle(
                //         fontSize: widget.fontSize - 8,
                //         fontFamily: 'NotoSansKR',
                //         fontStyle: FontStyle.italic,
                //         fontWeight: FontWeight.w300,
                //       ),
                //     ),
                //   ),
              ],
            ))));

    if (isLastChapter == true) {
      print('LAST! isLastChapter: $isLastChapter');
      return NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollEndNotification) {
              final metrics = notification.metrics;
              if (metrics.atEdge && metrics.pixels == metrics.maxScrollExtent) {
                print('End of scroll');
                setState(() {
                  widget.showCheckButtonOn();
                });
              }
            }
            return true;
          },
          child: scrollView);
    } else {
      return scrollView;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ...
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.jsonData.length,
        itemBuilder: (context, chapterIndex) {
          final chapter = widget.jsonData[chapterIndex];
          print("object: $chapterIndex, len: ${widget.jsonData.length}");
          return _buildChapter(
              chapter, chapterIndex == widget.jsonData.length - 1);
        },
      ),
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
          icon: Icon(Icons.text_increase),
          onPressed: increaseFontSize,
        ),
        IconButton(
          icon: Icon(Icons.text_decrease),
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
