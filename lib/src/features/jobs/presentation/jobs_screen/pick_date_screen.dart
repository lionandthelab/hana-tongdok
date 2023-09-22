import 'package:flutter/material.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:starter_architecture_flutter_firebase/src/common_widgets/date_time_picker.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:intl/intl.dart' show DateFormat;


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage=0;
  DateTime _currentDate = DateTime.now();
  DateTime _currentDate2 = DateTime.now();
  String _currentMonth = DateFormat.yMMM().format(DateTime.now());
  DateTime _targetDateTime = DateTime.now();
//  List<DateTime> _markedDate = [DateTime(2018, 9, 20), DateTime(2018, 10, 11)];
  static Widget _eventIcon = new Container(
    decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(1000)),
        border: Border.all(color: Colors.blue, width: 2.0)),
    child: new Icon(
      Icons.person,
      color: Colors.amber,
    ),
  );

  EventList<Event> _markedDateMap = new EventList<Event>(
    events: {
      new DateTime(2019, 2, 10): [
        new Event(
          date: new DateTime(2019, 2, 10),
          title: 'Event 1',
          icon: _eventIcon,
          dot: Container(
            margin: EdgeInsets.symmetric(horizontal: 1.0),
            color: Colors.red,
            height: 5.0,
            width: 5.0,
          ),
        ),
        new Event(
          date: new DateTime(2019, 2, 10),
          title: 'Event 2',
          icon: _eventIcon,
        ),
        new Event(
          date: new DateTime(2019, 2, 10),
          title: 'Event 3',
          icon: _eventIcon,
        ),
      ],
    },
  );

  @override
  void initState() {
    super.initState();
  }
  final PageController controller = PageController(viewportFraction: 1, keepPage: true);


  final idx = 4;
  @override
  Widget build(BuildContext context) {
    final _calendarCarouselNoHeader = CalendarCarousel<Event>(
      todayBorderColor: Colors.green,
      onDayPressed: (date, events) {
        this.setState(() => _currentDate2 = date);
        events.forEach((event) => print(event.title));
        print('pressed date ' + _currentDate2.month.toString());
      },
      daysHaveCircularBorder: true,
      showOnlyCurrentMonthDate: false,
      weekendTextStyle: TextStyle(
        color: Colors.red,
      ),
      thisMonthDayBorderColor: Colors.grey,
      weekFormat: false,
//      firstDayOfWeek: 4,
      markedDatesMap: _markedDateMap,
      height: 420.0,
      selectedDateTime: _currentDate2,
      targetDateTime: _targetDateTime,
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      markedDateCustomShapeBorder:
      CircleBorder(side: BorderSide(color: Colors.yellow)),
      markedDateCustomTextStyle: TextStyle(
        fontSize: 18,
        color: Colors.blue,
      ),
      showHeader: false,
      todayTextStyle: TextStyle(
        color: Colors.blue,
      ),
      // markedDateShowIcon: true,
      // markedDateIconMaxShown: 2,
      // markedDateIconBuilder: (event) {
      //   return event.icon;
      // },
      // markedDateMoreShowTotal:
      //     true,
      todayButtonColor: Colors.yellow,
      selectedDayTextStyle: TextStyle(
        color: Colors.yellow,
      ),
      minSelectedDate: _currentDate.subtract(Duration(days: 36500)),
      maxSelectedDate: _currentDate.add(Duration(days: 36500)),
      prevDaysTextStyle: TextStyle(
        fontSize: 16,
        color: Colors.pinkAccent,
      ),
      inactiveDaysTextStyle: TextStyle(
        color: Colors.tealAccent,
        fontSize: 16,
      ),
      onCalendarChanged: (DateTime date) {
        this.setState(() {
          _targetDateTime = date;
          _currentMonth = DateFormat.yMMM().format(_targetDateTime);
          print(_targetDateTime);
        });
      },
      onDayLongPressed: (DateTime date) {
        print('long pressed date $date');
      },
    );
    final pages = List.generate(
        idx-1,
            (index) => Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.transparent,
              ),
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Container(
                child: Center(
                    child: Text(
                      "Page $index",
                      style: TextStyle(color: Colors.indigo),
                    )),
              ),
        ));
    pages.insert(0,
        Container(

          child: Column(
            children: [
              SizedBox(height:20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: <Widget>[
                        TextButton(
                          child: Text('PREV'),
                          onPressed: () {
                            setState(() {
                              _targetDateTime = DateTime(
                                  _targetDateTime.year, _targetDateTime.month - 1);
                              _currentMonth =
                                  DateFormat.yMMM().format(_targetDateTime);
                            });
                          },
                        ),
                        Expanded(
                            child: Center(
                              child: Text(
                                _currentMonth,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24.0,
                                ),
                              ),
                            )),
                        TextButton(
                          child: Text('NEXT'),
                          onPressed: () {
                            setState(() {
                              _targetDateTime = DateTime(
                                  _targetDateTime.year, _targetDateTime.month + 1);
                              _currentMonth =
                                  DateFormat.yMMM().format(_targetDateTime);
                            });
                          },
                        )
                      ],
                    ),
                  ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                child: _calendarCarouselNoHeader,
              ),
              TextButton(
                child: Text('읽으러 가기'),
                onPressed: () {
                  setState(() {
                    controller.nextPage(
                        duration: Duration(milliseconds: 1000),
                        curve: Curves.easeIn
                    );
                  });
                },
              ), //
          ],
        ),
        )

    );



    /// Example Calendar Carousel without header and custom prev & next button

    return Scaffold(
      body: SafeArea(
        left: false,
        child: PageView.builder(
                  onPageChanged: (page){
                    setState(() {
                      currentPage=page;
                    });
                  },
                  controller: controller,
                  // itemCount: pages.length,
                  itemBuilder: (_, index) {
                    return pages[index % pages.length];
                  },
                ),

      ),
    );
  }
}

final colors = const [
  Colors.red,
  Colors.green,
  Colors.greenAccent,
  Colors.amberAccent,
  Colors.blue,
  Colors.amber,
];