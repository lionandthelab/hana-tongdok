import React, { memo, useState, useEffect, Component } from "react";
import {
  Platform,
  View,
  Text,
  StyleSheet,
  ScrollView,
  SafeAreaView,
  Animated,
  Easing,
  TouchableOpacity,
  StatusBar,
} from "react-native";
import Background from "../components/Background";
import PageHeader from "../components/PageHeader";
import CalendarView from "../components/CalendarView";
import Settings from "../components/Settings";

import Swiper from "react-native-swiper";
import AsyncStorage from "@react-native-community/async-storage";
import ProgressCircle from "react-native-progress-circle";
import Icon from "react-native-vector-icons/FontAwesome";

import { logoutUser } from "../api/auth-api";
import { dailyVerse } from "../data/SAE_data";
import IntroView from "../components/IntroView";
import VerseParagraph from "../components/VerseParagraph";

const oneDay = 1000 * 60 * 60 * 24;
const firstDay = new Date(new Date().getFullYear(), 0, 1);
const lastDay = new Date(new Date().getFullYear(), 11, 31);

class Dashboard extends Component {
  constructor(props) {
    super(props);
    this.state = {
      curDate: firstDay,
      nextDateToRead: new Date(),
      verseFontSize: 20,
      darkMode: 0,
      fontColor: "#000000",
      bgColor: "#FFFFFF",
      // fontColor: this.state.darkMode ? '#FFFFFF' : '#000000',
      // bgColor: this.state.darkMode ? '#000000' : '#25282d',

      pageCount: 0,
      plan: 0,
      todayVerse: [],
      todayContents: [],
      checkedDates: [],
      complete: false,
      showCalendar: false,
      isSettingsVisible: false,
      needRefresh: false,
      loadingDate: false,
      swiperRef: null,
      showsPagination: Platform.OS === "ios" ? false : true,

      progress: 0,

      reading: false,
    };

    var increaseFontSize = this.increaseFontSize.bind(this);
    var decreaseFontSize = this.decreaseFontSize.bind(this);
    var flipDarkMode = this.flipDarkMode.bind(this);
    var goToDate = this.goToDate.bind(this);
    var setPlan1 = this.setPlan1.bind(this);
    var setPlan2 = this.setPlan2.bind(this);
    var setPlan3 = this.setPlan3.bind(this);
    var openSettings = this.openSettings.bind(this);
    var closeSettings = this.closeSettings.bind(this);
    var previousDate = this.previousDate.bind(this);
    var nextDate = this.nextDate.bind(this);
  }

  async componentWillMount() {
    this._retrieveData();
  }

  componentDidMount() {
    var _fontColor = this.state.darkMode == 0 ? "#000000" : "#FFFFFF";
    var _bgColor = this.state.darkMode == 0 ? "#FFFFFF" : "#25282d";
    this.setState({
      curDate: new Date(),
      fontColor: _fontColor,
      bgColor: _bgColor,
    });

    StatusBar.setHidden(true);
    StatusBar.setBackgroundColor(_bgColor);

    this.calcProgress();
  }

  componentWillUpdate() {
    this.scaleCheckmark(1);
  }

  async componentWillUnmount() {
    await this._storePlan(this.state.plan);
    await this._storeFontSize(this.state.verseFontSize);
    // await this._storeDarkMode(this.state.darkMode)
  }

  //----------------------------------------
  // local db
  //----------------------------------------

  async _storePlan(plan) {
    try {
      await AsyncStorage.setItem("@key_plan", plan);
    } catch (error) {
      // Error saving data
    }
  }

  async _storeFontSize(fontSize) {
    try {
      await AsyncStorage.setItem("@key_fontsize", String(fontSize));
    } catch (error) {
      // Error saving data
    }
  }

  async _storeDarkMode(mode) {
    try {
      if (mode == 1) {
        await AsyncStorage.setItem("@key_dark", "1");
      } else {
        await AsyncStorage.setItem("@key_dark", "0");
      }
    } catch (error) {
      // Error saving data
    }
  }

  async _retrieveData() {
    var value = 0;

    // try {
    //   value = parseInt(await AsyncStorage.getItem('@key_dark'))
    // } catch (error) {
    //   // Error retrieving data
    //   alert('error darkmode')
    // }
    // this.setState({ darkMode: value })

    try {
      value = await AsyncStorage.getItem("@key_plan");

      if (value == "1") {
        this.setPlan1();
      } else if (value == "2") {
        this.setPlan2();
      } else if (value == "3") {
        this.setPlan3();
      } else {
        // first launch
        this.setPlan1();
      }
    } catch (error) {
      // Error retrieving data
      value = 0;
    }

    try {
      value = parseInt(await AsyncStorage.getItem("@key_fontsize"));
      // alert(`fontsize: ${value}`)

      if (parseInt(value) > 10 && parseInt(value) < 100) {
        this.setState({ verseFontSize: parseInt(value) });
      } else {
        this.setState({ verseFontSize: 20 });
      }
    } catch (error) {
      // Error retrieving data
    }

    this._retrievecheckedDates();
  }

  async _storecheckedDate(curDate) {
    try {
      var _tmp = this.state.checkedDates;
      _tmp.push(this.yyyymmdd(curDate));
      this.setState({
        checkedDates: _tmp,
      });
      await AsyncStorage.setItem(
        "@key_checked_dates",
        JSON.stringify(this.state.checkedDates)
      );
    } catch (error) {
      // Error saving data
    }
  }

  async _retrievecheckedDates() {
    try {
      const _checkedDates = await AsyncStorage.getItem("@key_checked_dates");
      if (_checkedDates !== null) {
        // We have data!!
        this.setState({ checkedDates: JSON.parse(_checkedDates) });
        console.log(this.state.checkedDates);
      }
    } catch (error) {
      // Error retrieving data
      this.state.checkedDates = "err";
    }
    this.calcProgress();
  }

  //----------------------------------------
  // utils
  //----------------------------------------

  isThisYear(date) {
    if (parseInt(date.substring(0, 4)) === this.state.curDate.getFullYear()) {
      return true;
    }
  }

  animate() {
    let progress = 0;
    this.setState({ progress });
    setTimeout(() => {
      this.setState({ indeterminate: false });
      setInterval(() => {
        progress += Math.random() / 5;
        if (progress > 1) {
          progress = 1;
        }
        this.setState({ progress });
      }, 500);
    }, 1500);
  }

  calcProgress() {
    var percent = 0.0;

    var unique = [...new Set(this.state.checkedDates)];
    var readThisYearDayNum = unique.filter((x) => {
      return parseInt(x.substring(0.4)) == this.state.curDate.getFullYear();
    });
    var readDayNum = readThisYearDayNum.length;
    var totalDayNum = 0;

    if (this.state.curDate.getFullYear() % 4 == 0) {
      totalDayNum = 366;
    } else {
      totalDayNum = 365;
    }

    percent = (readDayNum / totalDayNum) * 100;
    // var percentString = String(percent.toFixed(2).concat("% 완료!\n(").concat(readDayNum)
    // .concat(" / ".concat(totalDayNum).concat(")")))
    var percentString = String(percent.toFixed(2).concat("%"));

    this.setState({ progress: percent });

    return percentString;
  }

  renderDate(dateIn) {
    var mm =
      dateIn.getMonth() < 9
        ? "0" + (dateIn.getMonth() + 1)
        : dateIn.getMonth() + 1; // getMonth() is zero-based
    var dd = dateIn.getDate() <= 9 ? "0" + dateIn.getDate() : dateIn.getDate();
    return ""
      .concat(mm)
      .concat("월 ")
      .concat(dd)
      .concat("일");
  }

  yyyymmdd(dateIn) {
    var yyyy = dateIn.getFullYear();
    var mm =
      dateIn.getMonth() < 9
        ? "0" + (dateIn.getMonth() + 1)
        : dateIn.getMonth() + 1; // getMonth() is zero-based
    var dd = dateIn.getDate() <= 9 ? "0" + dateIn.getDate() : dateIn.getDate();
    return ""
      .concat(yyyy)
      .concat("-")
      .concat(mm)
      .concat("-")
      .concat(dd);
  }

  getMarkedDates(checkedDates) {
    var obj = checkedDates.reduce(
      (c, v) => Object.assign(c, { [v]: { selected: true, marked: true } }),
      {}
    );
    return obj;
  }

  goToDate(dateString) {
    var _curDate = new Date(dateString);
    this.setState(
      {
        curDate: _curDate,
        complete: false,
        showCalendar: false,
      },
      function() {
        this.getDailyVerseContents();
        this.state.swiperRef.scrollBy(-(this.state.pageCount + 1), true);
      }
    );
  }

  goMain() {
    this.state.swiperRef.scrollBy(-(this.state.pageCount + 1), true);
    this.nextDate();
    this.setState({
      complete: false,
      showCalendar: false,
    });
    this.getDailyVerseContents();
  }

  setReading(state) {
    this.setState({ reading: state });
  }

  setNextDate(dateString) {
    var _curDate = new Date(dateString);
    this.setState({
      nextDateToRead: _curDate,
    });
  }

  nextDate() {
    var _curDate = this.state.curDate;
    // cannot go after 20xx-12-31
    // if (_curDate + 1 > _lastDay) return

    _curDate.setDate(_curDate.getDate() + 1);
    this.setState({
      curDate: _curDate,
    });
    this.getDailyVerseContents();
    this.setState({
      complete: false,
      showCalendar: false,
    });
  }

  previousDate() {
    var _curDate = this.state.curDate;
    // cannot go before 2020-01-01
    if (_curDate < firstDay) return;

    _curDate.setDate(_curDate.getDate() - 1);
    this.setState({
      curDate: _curDate,
    });
    this.getDailyVerseContents();
    this.setState({
      complete: false,
      showCalendar: false,
    });
  }

  increaseFontSize() {
    var newSize = this.state.verseFontSize + 2;
    if (newSize > 30) newSize = this.state.verseFontSize;
    this.setState({
      verseFontSize: newSize,
    });
    this._storeFontSize(this.state.verseFontSize);
  }

  decreaseFontSize() {
    var newSize = this.state.verseFontSize - 2;
    if (newSize < 6) newSize = this.state.verseFontSize;
    this.setState({
      verseFontSize: newSize,
    });
    this._storeFontSize(this.state.verseFontSize);
  }

  openSettings() {
    this.setState({
      isSettingsVisible: true,
    });
  }

  closeSettings() {
    this.setState({
      isSettingsVisible: false,
    });
    this.getDailyVerseContents();
  }

  setPlan1() {
    this.setState({
      plan: 1,
    });
    this._storePlan("1");
    this.getDailyVerseContents();
  }

  setPlan2() {
    this.setState({
      plan: 2,
    });
    this._storePlan("2");
    this.getDailyVerseContents();
  }

  setPlan3() {
    this.setState({
      plan: 3,
    });
    this._storePlan("3");
    this.getDailyVerseContents();
  }

  flipDarkMode() {
    var _new = this.state.darkMode == 0 ? 1 : 0;
    var _fontColor = _new == 0 ? "#000000" : "#FFFFFF";
    var _bgColor = _new == 0 ? "#FFFFFF" : "#25282d";
    this.setState({
      darkMode: _new,
      fontColor: _fontColor,
      bgColor: _bgColor,
    });
    // this._storeDarkMode(_new)
    StatusBar.setBackgroundColor(_bgColor);
  }

  getDailyVerseContents() {
    this.setState({
      loadingDate: true,
    });
    var _curDate = this.state.curDate;
    var _firstDay = new Date(_curDate.getFullYear(), 0, 1);
    var _lastDay = new Date(_curDate.getFullYear(), 11, 31);
    var curDateIdx = (_curDate.getTime() - _firstDay.getTime()) / oneDay;
    var _todayVerse = [];
    var _todayContents = [];
    var _pageCount = 0;
    for (let i = 0; i < this.state.plan; i++) {
      // _date.setDate(firstDay.getDate() + (curDateIdx * plan + i + 1))
      var dateToProceed = 0;
      if (_curDate.getFullYear() % 4 == 0) {
        dateToProceed = (curDateIdx * this.state.plan + i) % 366;
      } else {
        dateToProceed = (curDateIdx * this.state.plan + i) % 365;
      }
      var _date = new Date(_firstDay.getTime() + dateToProceed * oneDay);
      var _dateToReadKey = "m" + (_date.getMonth() + 1) + "d" + _date.getDate();
      // alert(_dateToReadKey)

      _todayVerse = [..._todayVerse, dailyVerse[_dateToReadKey]];
      _todayContents = [..._todayContents, dailyVerse[_dateToReadKey].contents];
      _pageCount = _pageCount + dailyVerse[_dateToReadKey].contents.length;
    }
    this.setState({
      todayVerse: _todayVerse,
      todayContents: _todayContents,
      pageCount: _pageCount,
      loadingDate: false,
    });

    this.calcProgress();
  }

  scaleCheckmark(value) {
    var scaleCheckmarkValue = new Animated.Value(0);
    Animated.timing(scaleCheckmarkValue, {
      toValue: value,
      duration: 400,
      easing: Easing.easeOutBack,
    }).start();
  }

  render() {
    var renderSettingsModal = [
      <Settings
        isVisible={this.state.isSettingsVisible}
        plan={this.state.plan}
        setPlan1={this.setPlan1.bind(this)}
        setPlan2={this.setPlan2.bind(this)}
        setPlan3={this.setPlan3.bind(this)}
        logout={logoutUser}
        closeSettings={this.closeSettings.bind(this)}
      />,
    ];

    var renderPages = [];

    // content page
    this.state.todayContents.map((contentValues, i) =>
      contentValues.map((contentValue, j) =>
        renderPages.push([
          <View key={1 + i} style={styles.verseContainer}>
            <ScrollView
              key={`scroll-${i}`}
              showsVerticalScrollIndicator={true}
              style={styles.oneChaper}
            >
              <PageHeader
                fontColor={this.state.fontColor}
                fontSize={this.state.verseFontSize + 3}
                chapterName={contentValue.chapter_name}
                verseNum={contentValue.num_of_verses}
                flipDarkMode={this.flipDarkMode.bind(this)}
                increaseFontSize={this.increaseFontSize.bind(this)}
                decreaseFontSize={this.decreaseFontSize.bind(this)}
              />

              {contentValue.paragraphs.map((paragraphData, i) => (
                <VerseParagraph
                  index={i}
                  paragraphData={paragraphData}
                  bgColor={this.state.bgColor}
                  fontColor={this.state.fontColor}
                  fontSize={this.state.verseFontSize + 1}
                />
                // <Verse
                //   title={verseValue.title}
                //   content={verseValue.content}
                //   index={verseValue.idx}
                //   bgColor={this.state.bgColor}
                //   fontColor={this.state.fontColor}
                //   fontSize={this.state.verseFontSize + 1}
                // />
              ))}
            </ScrollView>
          </View>,
        ])
      )
    );

    // complete page
    if (this.state.complete == true) {
      renderCheckButton = [
        <TouchableOpacity
          key={0}
          style={styles.checkIcon}
          onPress={() => {
            this.setState({
              complete: false,
              showCalendar: false,
            });
          }}
        >
          <Icon name="check" size={120} color="#3CD3AD" />
        </TouchableOpacity>,
      ];
    } else {
      renderCheckButton = [
        <TouchableOpacity
          key={0}
          style={styles.checkIcon}
          onPress={() => {
            this.setState({
              complete: true,
            });
            this._storecheckedDate(this.state.curDate);
            this.calcProgress();

            _interval = setTimeout(() => {
              this.setState({
                showCalendar: true,
              });
            }, 1000);
          }}
        >
          <Icon name="check" size={120} color="#777" />
        </TouchableOpacity>,
      ];
    }

    renderCalendar = [
      <CalendarView
        key={0}
        current={this.state.curDate}
        markedDates={this.getMarkedDates(this.state.checkedDates)}
        onDayPress={(day) => {
          this.goToDate(day.dateString);
        }}
      />,
    ];

    renderPages.push([
      <View key={100} style={styles.lastContainer}>
        <Background>
          <View style={styles.checkIconView}>{renderCheckButton}</View>
          <View style={styles.calendarView}>{renderCalendar}</View>
          {/* <View style={styles.checkUpperView}> */}
          {/* </View> */}
          <View style={styles.progressView}>
            <ProgressCircle
              percent={parseInt(this.state.progress)}
              radius={50}
              borderWidth={8}
              color="#3CD3AD"
              shadowColor="#ddd"
              bgColor="#fff"
            >
              <Text style={{ fontSize: 18 }}>
                {this.state.progress.toFixed(2)}%
              </Text>
            </ProgressCircle>
            <Text style={{ fontSize: 14 }}>
              {this.state.curDate.getFullYear()}년
            </Text>

            {/* <Text style={styles.goHomeText}> {this.wholeProgress()} </Text> */}

            <TouchableOpacity
              style={styles.goHomeText}
              onPress={() => {
                this.goMain();
                this.setReading(false);
              }}
            >
              {this.state.showCalendar ? (
                <Text style={styles.goHomeText}> 계속 읽기 </Text>
              ) : null}
            </TouchableOpacity>
          </View>
        </Background>
      </View>,
    ]);

    return (
      <View style={styles.mainContainer}>
        {!this.state.reading ? (
          <IntroView
            plan={this.state.plan}
            openSettings={this.openSettings.bind(this)}
            previousDate={this.previousDate.bind(this)}
            nextDate={this.nextDate.bind(this)}
            curDate={this.state.curDate}
            loadingDate={this.state.loadingDate}
            todayVerse={this.state.todayVerse}
            setReading={this.setReading.bind(this)}
          />
        ) : (
          <SafeAreaView
            style={[
              styles.mainContainer,
              { backgroundColor: this.state.bgColor },
            ]}
          >
            <Swiper
              ref={(_swiper) => {
                this.state.swiperRef = _swiper;
              }}
              loop={false}
              loadMinimal={true}
              loadMinimalSize={1}
              bounces={true}
              showsPagination={this.state.showsPagination}
              paginationStyle={{
                bottom: 10,
                left: null,
                right: 10,
              }}
            >
              {renderPages}
            </Swiper>
            {renderSettingsModal}
          </SafeAreaView>
        )}
      </View>
    );
  }
}

var styles = StyleSheet.create({
  mainContainer: {
    flex: 1,
    padding: 0,
  },

  // content page
  verseContainer: {
    flex: 1,
    padding: 0,
  },
  oneChaper: {
    marginBottom: 0,
  },

  // closing page
  lastContainer: {
    flex: 1,
    padding: 0,
    alignItems: "center",
    justifyContent: "center",
    borderWidth: 10,
    borderRadius: 10,
    borderColor: "#3CD3AD",
  },
  progressView: {
    flex: 2,
    alignItems: "center",
    justifyContent: "center",
  },
  checkUpperView: {
    flex: 1,
    alignContent: "flex-end",
    justifyContent: "flex-end",
    backgroundColor: "#444",
  },
  checkIconView: {
    flex: 2,
    alignContent: "center",
    justifyContent: "center",
  },
  checkIcon: {
    // flex: 1,
    alignContent: "center",
    justifyContent: "center",
  },
  calendarView: {
    flex: 4,
    marginTop: 10,
    marginBottom: 20,
    alignContent: "flex-start",
    justifyContent: "flex-start",
  },
  goHomeText: {
    flex: 1,
    textAlign: "center",
    fontSize: Platform.OS === "ios" ? 20 : 20,
    fontWeight: "bold",
    marginTop: 10,
    color: "#3CD3AD",
  },
  logoutButton: {
    flex: 1,
    marginBottom: 50,
    alignContent: "flex-end",
    justifyContent: "flex-end",
  },
  logoutText: {
    flex: 1,
    fontSize: Platform.OS === "ios" ? 16 : 16,
    color: "#3CD3AD",
  },
});

// export default memo(Dashboard);
export default Dashboard;
