import 'package:flutter/material.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final PageController controller = PageController(viewportFraction: 0.8, keepPage: true);
  void initState() {
    super.initState();

    controller.addListener(() {
      // 페이지 컨트롤러의 상태가 변경될 때 실행할 코드 작성
      print('현재 페이지: ${controller.page}');
    });
  }
  @override
  void dispose() {
    controller.dispose(); // 페이지 컨트롤러를 해제해야 합니다.
    super.dispose();
  }

  final idx = 4;
  @override
  Widget build(BuildContext context) {
    final pages = List.generate(
        idx-1,
            (index) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.transparent,
          ),
          // margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Center(
                child: Text(
                  "Page $index",
                  style: TextStyle(color: Colors.indigo),
                )),
          ),
        ));
    pages.insert(0, Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.transparent,
      ),
      // margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Center(
            child: Text(
              "HOMEHOME",
              style: TextStyle(color: Colors.indigo),
            )),
        )
      )
    );
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 16),
              SizedBox(

                height: MediaQuery.of(context).size.height - 250,
                child: PageView.builder(
                  controller: controller,
                  // itemCount: pages.length,
                  itemBuilder: (_, index) {
                    return pages[index % pages.length];
                  },
                ),
              ),
              SizedBox(height: 16),
              SmoothPageIndicator(
                controller: controller,
                count: pages.length,
                effect: controller.page ==0? const WormEffect(
                  dotHeight: 0,
                  dotWidth: 0,
                  type: WormType.thinUnderground,
                ):const WormEffect(
                  dotHeight: 5,
                  dotWidth: 5,
                  type: WormType.thinUnderground,
                ),

              ),
            ],
          ),
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