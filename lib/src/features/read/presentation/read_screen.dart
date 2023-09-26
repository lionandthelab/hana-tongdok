import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_architecture_flutter_firebase/src/constants/strings.dart';
import 'package:starter_architecture_flutter_firebase/src/features/keeps/domain/keep.dart';
import 'package:starter_architecture_flutter_firebase/src/routing/app_router.dart';

class ReadScreen extends StatefulWidget {
  const ReadScreen({super.key});

  @override
  State<ReadScreen> createState() => _ReadScreenState();
}

class _ReadScreenState extends State<ReadScreen> {
  late List<dynamic> yourJsonData = [];
  late DateTime? _selectedDate = null;
  late String _verseKey = "";
  double _fontSize = 24.0; // Initial font size

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    String m = _selectedDate!.month.toString();
    String d = _selectedDate!.day.toString();
    _verseKey = "m${m}d$d";
    //_fontSize = 24.0;
    _loadJsonData();
    _loadUsetSettings();
  }

  final userSettings = rootBundle.loadString('assets/json/userdata.json');
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
  Future<void> _loadUsetSettings() async{
    final jsonString =
    await rootBundle.loadString('assets/json/userdata.json');
    final jsonData = json.decode(jsonString);
    _fontSize = jsonData.read_number;
  }
  Future<void> _loadJsonData() async {
    final jsonString =
        await rootBundle.loadString('assets/json/bible-RNKSV.json');
    final jsonData = json.decode(jsonString);

    // print("@@@jsonData[_verseKey]: $jsonData[_verseKey]");

    setState(() {
      String m = _selectedDate!.month.toString();
      String d = _selectedDate!.day.toString();
      _verseKey = "m${m}d$d";

      // yourJsonData = jsonData[_verseKey]["contents"] as List<Map<String, dynamic>>;
      yourJsonData = jsonData[_verseKey]["contents"] as List<dynamic>;
      // print("@@@_bibleList: $_bibleList");
      // yourJsonData = jsonDecode(_bibleList) as List<Map<String, dynamic>>;
      print("yourJsonData: $yourJsonData");
      print("your read number: $userSettings");
      // _bibleText = "";
      // for (int i = 0; i < _bibleList.length; i++) {
      //   List<dynamic> book = _bibleList[i]["paragraphs"][0];
      //   for (int j = 0; i < book.length; j++) {
      //     String verse = book[i]["content"];
      //     _bibleText += '$verse\n';
      //   }
      // }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2024),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _loadJsonData();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.book_rounded),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
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
            onPressed: (){
              print(DateFormat('MM/dd').format(_selectedDate!));
            },
          ),
        ],
      ),
      body: TextSizeAdjusterWidget(jsonData: yourJsonData, fontSize: _fontSize),
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
    print("initState: jsondata: ${widget.jsonData}");
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
                                        queryParameters: {'title': "$chapterName ${verse['index']}절", 'verse': verse['content'], 'note':'', 'id': Random.secure().nextInt(1000000).toString()}
                                    );
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




// class ReadScreen extends ConsumerWidget {
//   const ReadScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(Strings.read),
//       ),
//       body: SizedBox(
//       width: 200.0,
//       height: 300.0,
//       child: Scaffold(
//           body:Column(
//               children: [
//                 //Text('asdafs')
//                 Text(context.watch<DatePickup>().curDate.toString()),
//                 Text(context.watch<DatePickup>().strDate.toString()),
//                 CarouselSlider(
//                   options: CarouselOptions(
//                       height: 100.0,
//                       enableInfiniteScroll: false,
//                   ),
//                   items: context.watch<DatePickup>().bibleList.map((script) {
//                     return Builder(
//                       builder: (BuildContext context) {
//                         return Container(
//                             width: MediaQuery.of(context).size.width,
//                             margin: EdgeInsets.symmetric(horizontal: 5.0),
//                             decoration: BoxDecoration(
//                                 color: Colors.amber
//                             ),
//                             child: Column(
//                                 children: [
//                                   //Text(context.watch<DatePickup>().verses)
//                                 ]
//                             )
//                         );
//                       },
//                     );
//                   }).toList(),
//                 )
//               ],
//             ),

//         ),
//     )
//       // body: Swiper(
//       //   itemBuilder: (BuildContext context, int index){
//       //     // return Image.network("https://via.placeholder.com/350x150", fit: BoxFit.fill,);
//       //     return Text(index.toString(), style: TextStyle(_fontSize: 50.0),);
//       //   },
//       //   itemCount: 100,
//       //   pagination: SwiperPagination(),
//       //   control: SwiperControl(),
//       // ),
//     );
//   }
// }
