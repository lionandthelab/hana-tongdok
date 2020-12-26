import React, { memo, useState, useEffect, Component } from "react"
import { Dimensions, Platform, View, Text, StyleSheet, ScrollView, SafeAreaView, Animated, Easing, Button, TouchableOpacity, PixelRatio } from 'react-native';
import Background from "../components/Background"
import Swiper from 'react-native-swiper'
import Modal from 'react-native-modal'
import AsyncStorage from '@react-native-community/async-storage'

import Icon from 'react-native-vector-icons/FontAwesome';
import { logoutUser } from "../api/auth-api";
import { dailyVerse } from '../data/DailyVerse';

import { Calendar, LocaleConfig } from 'react-native-calendars';
import ProgressCircle from 'react-native-progress-circle'

LocaleConfig.locales['kr'] = {
  monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
  monthNamesShort: ['1.', '2.', '3.', '4.', '5.', '6.', '7.', '8.', '9.', '10.', '11.', '12.'],
  dayNames: ['일요일', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일'],
  dayNamesShort: ['일', '월', '화', '수', '목', '금', '토'],
  today: '오늘'
};
LocaleConfig.defaultLocale = 'kr';

const oneDay = (1000 * 60 * 60 * 24)
const firstDay = new Date(new Date().getFullYear(), 0, 1);
const lastDay = new Date(new Date().getFullYear(), 11, 31)

class Dashboard extends Component {
  constructor(props) {
    super(props);
    this.state = {
      curDate: firstDay,
      nextDateToRead: new Date(),
      verseFontSize: 20,
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
      showsPagination: Platform.OS === 'ios' ? false : true,

      // progress
      progress: 0,
    };
  }

  async componentWillMount() {
    this._retrieveData()
  }

  componentDidMount() {
    this.setState({
      curDate: new Date(),
    })

    this.calcProgress();
  }

  componentWillUpdate() {
    this.scaleCheckmark(1)
  }

  async componentWillUnmount() {
    await this._storePlan(this.state.plan)
  }

  //----------------------------------------
  // local db
  //----------------------------------------

  async _storePlan(plan) {
    try {
      await AsyncStorage.setItem('@key_plan', plan);
    } catch (error) {
      // Error saving data
    }
  }

  async _retrieveData() {
    var value = 0

    try {
      value = await AsyncStorage.getItem('@key_plan')

      if (value == '1') {
        this.setPlan1()
      } else if (value == '2') {
        this.setPlan2()
      } else if (value == '3') {
        this.setPlan3()
      } else {
        // first launch
        this.setPlan1()
      }
    } catch (error) {
      // Error retrieving data
      value = 0
    }

    this._retrievecheckedDates()
  }

  async _storecheckedDate(curDate) {
    try {
      var _tmp = this.state.checkedDates
      _tmp.push(this.yyyymmdd(curDate))
      this.setState({
        checkedDates: _tmp
      })
      await AsyncStorage.setItem('@key_checked_dates', JSON.stringify(this.state.checkedDates));
    } catch (error) {
      // Error saving data
    }
  }

  async _retrievecheckedDates() {
    try {
      const _checkedDates = await AsyncStorage.getItem('@key_checked_dates');
      if (_checkedDates !== null) {
        // We have data!!
        this.setState({ checkedDates: JSON.parse(_checkedDates) })
        console.log(this.state.checkedDates);
      }
    } catch (error) {
      // Error retrieving data
      this.state.checkedDates = "err"
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
    var percent = 0.0

    var unique = [...new Set(this.state.checkedDates)];
    var readThisYearDayNum = unique.filter(x => { return parseInt(x.substring(0.4)) == this.state.curDate.getFullYear() });
    var readDayNum = readThisYearDayNum.length
    var totalDayNum = 0

    if (this.state.curDate.getFullYear() % 4 == 0) {
      totalDayNum = 366
    } else {
      totalDayNum = 365
    }

    percent = readDayNum / totalDayNum * 100
    // var percentString = String(percent.toFixed(2).concat("% 완료!\n(").concat(readDayNum)
    // .concat(" / ".concat(totalDayNum).concat(")")))
    var percentString = String(percent.toFixed(2).concat("%"))

    this.setState({ progress: percent })

    return percentString
  }

  renderDate(dateIn) {
    var mm = dateIn.getMonth() < 9 ? "0" + (dateIn.getMonth() + 1) : (dateIn.getMonth() + 1); // getMonth() is zero-based
    var dd = dateIn.getDate() <= 9 ? "0" + (dateIn.getDate()) : (dateIn.getDate());;
    return "".concat(mm).concat("월 ").concat(dd).concat("일")
  }

  yyyymmdd(dateIn) {
    var yyyy = dateIn.getFullYear();
    var mm = dateIn.getMonth() < 9 ? "0" + (dateIn.getMonth() + 1) : (dateIn.getMonth() + 1); // getMonth() is zero-based
    var dd = dateIn.getDate() <= 9 ? "0" + (dateIn.getDate()) : (dateIn.getDate());;
    return "".concat(yyyy).concat("-").concat(mm).concat("-").concat(dd)
  }

  getMarkedDates(checkedDates) {
    var obj = checkedDates.reduce((c, v) => Object.assign(c, { [v]: { selected: true, marked: true } }), {});
    return obj;
  }

  goToDate(dateString) {
    var _curDate = new Date(dateString)
    this.setState({
      curDate: _curDate,
      complete: false,
      showCalendar: false,
    }, function () {
      this.getDailyVerseContents()
      this.state.swiperRef.scrollBy(-(this.state.pageCount + 1), true);
    })
  }

  goMain() {
    this.state.swiperRef.scrollBy(-(this.state.pageCount + 1), true);
    this.nextDate()
    this.setState({
      complete: false,
      showCalendar: false,
    })
    this.getDailyVerseContents()
  }

  setNextDate(dateString) {
    var _curDate = new Date(dateString)
    this.setState({
      nextDateToRead: _curDate
    })
  }

  nextDate() {
    var _curDate = this.state.curDate
    // cannot go after 20xx-12-31
    // if (_curDate + 1 > _lastDay) return

    _curDate.setDate(_curDate.getDate() + 1);
    this.setState({
      curDate: _curDate
    })
    this.getDailyVerseContents()
    this.setState({
      complete: false,
      showCalendar: false,
    })
  }

  previousDate() {
    var _curDate = this.state.curDate
    // cannot go before 2020-01-01
    if (_curDate < firstDay) return

    _curDate.setDate(_curDate.getDate() - 1);
    this.setState({
      curDate: _curDate
    })
    this.getDailyVerseContents()
    this.setState({
      complete: false,
      showCalendar: false,
    })
  }

  increaseFontSize() {
    var newSize = this.state.verseFontSize + 2
    if (newSize > 26)
      newSize = this.state.verseFontSize
    this.setState({
      verseFontSize: newSize
    })
  }

  decreaseFontSize() {
    var newSize = this.state.verseFontSize - 2
    if (newSize < 18)
      newSize = this.state.verseFontSize
    this.setState({
      verseFontSize: newSize
    })
  }

  openSettings() {
    this.setState({
      isSettingsVisible: true
    })
  }

  closeSettings() {
    this.setState({
      isSettingsVisible: false
    })
    this.getDailyVerseContents()
  }

  setPlan1() {
    this.setState({
      plan: 1
    })
    this._storePlan('1')
    this.getDailyVerseContents()
  }

  setPlan2() {
    this.setState({
      plan: 2
    })
    this._storePlan('2')
    this.getDailyVerseContents()
  }

  setPlan3() {
    this.setState({
      plan: 3
    })
    this._storePlan('3')
    this.getDailyVerseContents()
  }

  getDailyVerseContents() {
    this.setState({
      loadingDate: true
    })
    var _curDate = this.state.curDate;
    var _firstDay = new Date(_curDate.getFullYear(), 0, 1);
    var _lastDay = new Date(_curDate.getFullYear(), 11, 31);
    var curDateIdx = (_curDate.getTime() - _firstDay.getTime()) / oneDay
    var _todayVerse = []
    var _todayContents = []
    var _pageCount = 0
    for (let i = 0; i < this.state.plan; i++) {
      // _date.setDate(firstDay.getDate() + (curDateIdx * plan + i + 1))
      var dateToProceed = 0
      if (_curDate.getFullYear() % 4 == 0) {
        dateToProceed = (curDateIdx * this.state.plan + i) % 366
      } else {
        dateToProceed = (curDateIdx * this.state.plan + i) % 365
      }
      var _date = new Date(_firstDay.getTime() + dateToProceed * oneDay)
      var _dateToReadKey = 'm' + (_date.getMonth() + 1) + 'd' + (_date.getDate())
      // alert(_dateToReadKey)

      _todayVerse = [..._todayVerse, dailyVerse[_dateToReadKey]]
      _todayContents = [..._todayContents, dailyVerse[_dateToReadKey].contents]
      _pageCount = _pageCount + dailyVerse[_dateToReadKey].contents.length
    }
    this.setState({
      todayVerse: _todayVerse,
      todayContents: _todayContents,
      pageCount: _pageCount,
      loadingDate: false
    })

    this.calcProgress();
  }

  scaleCheckmark(value) {
    var scaleCheckmarkValue = new Animated.Value(0)
    Animated.timing(
      scaleCheckmarkValue,
      {
        toValue: value,
        duration: 400,
        easing: Easing.easeOutBack,
      },
    ).start();
  }

  render() {
    var renderSettingsModal = [
      <Modal key={11} isVisible={this.state.isSettingsVisible}
        testID={'modal'}
        backdropColor="#777777"
        backdropOpacity={0.2}
        animationIn="zoomInDown"
        animationOut="zoomOutUp"
        animationInTiming={600}
        animationOutTiming={600}
        backdropTransitionInTiming={600}
        backdropTransitionOutTiming={600}>
        <View style={styles.settingsDummyView}></View>
        <View style={styles.settingsModalView}>
          <View style={styles.settingsModalTitle}>
            <Text style={styles.settingsModalClose}></Text>
            <Text style={styles.customBackdropText}>
              설정
            </Text>
            <TouchableOpacity
              style={styles.settingsModalClose}
              onPress={() => { this.closeSettings(); }}>
              <Icon name="times-circle" size={36} color="#00ffcc" />
            </TouchableOpacity>
          </View>

          <View style={styles.settingsModalContents}>

            <View style={styles.settingsModalPlan}>
              <Text style={styles.settingsModalPlanTitle}>
                통독 플랜
              </Text>
              <TouchableOpacity
                style={styles.settingsModalPlanButton}
                onPress={() => { this.setPlan1(); }}>
                <Text style={[styles.settingsModalPlanText, this.state.plan == 1 ? { color: '#00ffcc', borderColor: '#00ffcc' } : null]}>
                  1독
              </Text>
              </TouchableOpacity>

              <TouchableOpacity
                style={styles.settingsModalPlanButton}
                onPress={() => { this.setPlan2(); }}>
                <Text style={[styles.settingsModalPlanText, this.state.plan == 2 ? { color: '#00ffcc', borderColor: '#00ffcc' } : null]}>
                  2독
              </Text>
              </TouchableOpacity>

              <TouchableOpacity
                style={styles.settingsModalPlanButton}
                onPress={() => { this.setPlan3(); }}>
                <Text style={[styles.settingsModalPlanText, this.state.plan == 3 ? { color: '#00ffcc', borderColor: '#00ffcc' } : null]}>
                  3독
              </Text>
              </TouchableOpacity>
            </View>

            <TouchableOpacity
              style={styles.settingsModalLogout}
              onPress={() => { logoutUser(); this.closeSettings(); }}>
              <Icon name="sign-out" size={36} color="#FFFFFF" />
              <Text style={styles.buttonInSettings}>
                로그아웃
              </Text>
            </TouchableOpacity>
          </View>
        </View>
        <View style={styles.settingsDummyView}></View>
      </Modal>
    ]

    // intro page
    var renderPages = []
    renderPages.push([
      <View key={0} style={styles.headerContainer}>
        <View style={styles.dateBox}>
          <View style={styles.settingsView}>
            <Text style={[styles.settingsIconView,
            { padding: 3, fontWeight: 'bold', fontSize: 24, color: "#3CD3AD99" }]}>
              1년{this.state.plan}독
          </Text>
            <TouchableOpacity style={styles.settingsIconView} onPress={() => { this.openSettings() }}>
              <Icon name="cogs" size={40} color="#3CD3AD99" />
            </TouchableOpacity>
          </View>
          <TouchableOpacity style={styles.arrowLeftView} onPress={() => { this.previousDate() }}>
            <Icon name="angle-up" size={100} color="#3CD3AD99" />
          </TouchableOpacity>
          <View style={styles.dateView}>
            <Text style={styles.date}>
              {/* {todayVerse.date} */}
              {this.state.curDate.getMonth() + 1}월 {this.state.curDate.getDate()}일
          </Text>
            {!this.state.loadingDate ?
              this.state.todayVerse.map((verse, i) => (
                <Text key={i} style={styles.chapter}>
                  {verse.chapter}
                </Text>
              )
              )
              : null}
          </View>
          <TouchableOpacity style={styles.arrowRightView} onPress={() => { this.nextDate() }}>
            <Icon name="angle-down" size={100} color="#3CD3AD99" />
          </TouchableOpacity>
          <View style={styles.settingsDummyView}></View>
        </View>
      </View>
    ])

    // content page
    this.state.todayContents.map((contentValues, i) =>
      contentValues.map((contentValue, j) =>
        renderPages.push([
          <View key={1 + i} style={styles.verseContainer}>
            <ScrollView
              showsVerticalScrollIndicator={true} style={styles.oneChaper}>
              <View style={styles.chapterLineBox}>
                <View style={styles.chapterLineWrapper}>
                  <Text style={[styles.chapterLine, { fontSize: this.state.verseFontSize + 3 }]}>
                    {contentValue.chapter_name}
                  </Text>
                </View>
                <View style={styles.fontSizerIconWrapper}>
                  <TouchableOpacity onPress={() => this.increaseFontSize()}>
                    <Icon name="plus" size={25} color="#3CD3AD" />
                  </TouchableOpacity>
                </View>
                <View style={styles.fontSizerIconWrapper}>
                  <TouchableOpacity onPress={() => this.decreaseFontSize()}>
                    <Icon name="minus" size={25} color="#3CD3AD" />
                  </TouchableOpacity>
                </View>
              </View>
              {contentValue.verse.map((verseValue, i) => (
                <View key={i} style={styles.verseContent}>
                  {verseValue.title ?
                    <View style={styles.titleLine} >
                      <Text style={[styles.title, { fontSize: this.state.verseFontSize + 1 }]} >
                        {verseValue.title}
                      </Text>
                    </View> : null}
                  <View style={styles.verseLine} >
                    <Text style={styles.idx}>
                      {verseValue.idx}
                    </Text>
                    <Text style={[styles.verse, { fontSize: this.state.verseFontSize, lineHeight: this.state.verseFontSize + 10 }]}>
                      {verseValue.content}
                    </Text>
                  </View>
                </View>
              ))}
            </ScrollView>
          </View>]
        )
      )
    )

    // complete page
    if (this.state.complete == true) {
      renderCheckButton = [
        <TouchableOpacity key={0} style={styles.checkIcon} onPress={() => {
          this.setState({
            complte: false,
            showCalendar: false,
          })
        }}>
          <Icon name="check" size={120} color="#3CD3AD" />
        </TouchableOpacity>
      ]
    } else {
      renderCheckButton = [
        <TouchableOpacity key={0} style={styles.checkIcon} onPress={() => {
          this.setState({
            complete: true
          })
          this._storecheckedDate(this.state.curDate)
          this.calcProgress();

          _interval = setTimeout(() => {
            this.setState({
              showCalendar: true,
            })
          }, 1000);
        }}>
          <Icon name="check" size={120} color="#777" />
        </TouchableOpacity>
      ]
    }

    renderCalendar = [
      <View>
        <Calendar
          current={this.state.curDate}
          // minDate={'2020-01-01'}
          // maxDate={'2020-12-31'}
          minDate={'2020-01-01'}
          maxDate={'2022-12-31'}
          hideExtraDays={true}
          firstDay={0}
          markedDates={
            this.getMarkedDates(this.state.checkedDates)
          }
          style={{
            width: Dimensions.get('window').width * 0.8,
            alignContent: 'center',
            // height: '100%',
          }}
          theme={{
            // backgroundColor: '#ffffff',
            calendarBackground: '#ffffff',
            textSectionTitleColor: '#3CD3AD',
            selectedDayBackgroundColor: '#3CD3AD',
            selectedDayTextColor: '#ffffff',
            todayTextColor: '#3CD3AD',
            dayTextColor: '#2d4150',
            textDisabledColor: '#777',
            dotColor: '#00adf5',
            selectedDotColor: '#ffffff',
            arrowColor: '#3CD3AD',
            monthTextColor: '#3CD3AD',
            indicatorColor: '#3CD3AD',
            textDayFontWeight: '300',
            textMonthFontWeight: 'bold',
            textDayHeaderFontWeight: 'bold',
            textDayFontSize: 16,
            textMonthFontSize: 16,
            textDayHeaderFontSize: 16
          }}
          // onDayPress={(day) => {this.setNextDate(day.dateString); this.goMain()}}
          onDayPress={(day) => { this.goToDate(day.dateString) }}
        />
      </View>
    ]

    renderPages.push([
      <View key={100} style={styles.lastContainer}>
        <Background>
          <View style={styles.checkIconView}>
            {renderCheckButton}
          </View>
          <View style={styles.calendarView}>
            {renderCalendar}
          </View>
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
              <Text style={{ fontSize: 18 }}>{this.state.progress.toFixed(2)}%</Text>
            </ProgressCircle>
            {/* <Text style={styles.goHomeText}> {this.wholeProgress()} </Text> */}

            <TouchableOpacity style={styles.goHomeText} onPress={() => {
              this.goMain()
            }}>
              {this.state.showCalendar ?
                <Text style={styles.goHomeText}> 계속 읽기 </Text>
                : null}

            </TouchableOpacity>
          </View>
        </Background>
      </View >
    ])

    return (
      <View style={styles.mainContainer}>
        <SafeAreaView style={styles.mainContainer}>
          <Swiper ref={(_swiper) => { this.state.swiperRef = _swiper }}
            loop={false} loadMinimal={true} loadMinimalSize={1}
            bounces={true} showsPagination={this.state.showsPagination}
            paginationStyle={{
              bottom: 10, left: null, right: 10
            }}>
            {renderPages}
          </Swiper>
          {renderSettingsModal}
        </SafeAreaView>
      </View >
    );
  }
};

var styles = StyleSheet.create({
  mainContainer: {
    flex: 1,
    backgroundColor: '#fff',
    padding: 0
  },
  headerContainer: {
    flex: 1,
    padding: 0,
    alignItems: 'center',
    justifyContent: 'center',
    borderWidth: 10,
    borderRadius: 10,
    borderColor: '#3CD3AD',
  },
  dateBox: {
    flexDirection: 'column',
    flex: 1,
    alignContent: 'center',
    justifyContent: 'center',
    width: '100%',
    padding: 10,
  },
  dateView: {
    flex: 4,
    alignContent: 'center',
    justifyContent: 'center',
  },
  arrowLeftView: {
    flex: 6,
    alignItems: 'center',
    justifyContent: 'flex-end',
    // paddingLeft: 10,
  },
  arrowRightView: {
    flex: 6,
    alignItems: 'center',
    justifyContent: 'flex-start',
    // paddingRight: 10,
  },
  date: {
    fontSize: Platform.OS === 'ios' ? 42 : 32,
    color: '#3CD3AD',
    textAlign: 'center',
    textAlignVertical: 'center',
    margin: 12,
    fontWeight: 'bold',
    // fontFamily: 'BMJUA',
  },
  chapter: {
    fontSize: Platform.OS === 'ios' ? 30 : 24,
    color: '#3CD3AD',
    textAlign: 'center',
    margin: 5,
    // fontFamily: 'BMJUA',
  },
  settingsView: {
    flex: 1,
    flexDirection: 'row',
    alignItems: 'flex-start',
    justifyContent: 'flex-end',
  },
  settingsIconView: {
    alignItems: 'center',
    justifyContent: 'center',
  },
  settingsModalView: {
    flex: 1,
    fontSize: Platform.OS === 'ios' ? 24 : 24,
    fontWeight: 'bold',
    color: '#FFFFFF',
    backgroundColor: '#77777777',
    borderRadius: 5,
    borderWidth: 1,
    borderColor: '#FFFFFF',
    alignItems: 'center',
    justifyContent: 'center',
  },
  settingsModalTitle: {
    flex: 2,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    width: '100%',
    borderTopWidth: 1,
    borderBottomWidth: 1,
    borderColor: '#FFFFFF',
  },
  settingsModalContents: {
    flex: 6,
    alignItems: 'center',
    justifyContent: 'center',
    width: '100%',
  },
  settingsModalPlan: {
    flex: 1,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    marginTop: 10,
    marginBottom: 10,
  },
  settingsModalPlanButton: {
    flex: 2,
    alignItems: 'center',
    justifyContent: 'center',
  },
  settingsModalPlanTitle: {
    flex: 3,
    alignItems: 'center',
    justifyContent: 'center',
    textAlign: 'center',
    fontSize: Platform.OS === 'ios' ? 24 : 24,
    fontWeight: 'bold',
    color: '#FFFFFF',
  },
  settingsModalPlanText: {
    fontSize: Platform.OS === 'ios' ? 24 : 24,
    fontWeight: 'bold',
    color: '#FFFFFF',
    borderRadius: 5,
    borderWidth: 2,
    borderColor: '#FFFFFF',
  },
  settingsModalLogout: {
    flex: 1,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
  },
  settingsModalClose: {
    flex: 1,
    alignItems: 'flex-end',
    justifyContent: 'flex-end',
    marginRight: 10,
  },
  buttonInSettings: {
    fontSize: Platform.OS === 'ios' ? 24 : 24,
    fontWeight: 'normal',
    color: '#FFFFFF',
  },
  settingsDummyView: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'flex-end',
  },
  customBackdrop: {
    flex: 1,
    backgroundColor: '#777777',
    alignItems: 'center',
    justifyContent: 'center',
  },
  customBackdropText: {
    fontSize: Platform.OS === 'ios' ? 36 : 36,
    fontWeight: 'bold',
    color: '#FFFFFF',
  },

  // content page
  verseContainer: {
    flex: 1,
    padding: 0,
  },
  chapterLineBox: {
    flex: 1,
    flexDirection: 'row',
  },
  chapterLineWrapper: {
    flex: 8,
    alignContent: 'flex-start',
    justifyContent: 'flex-start',
  },
  fontSizerIconWrapper: {
    flex: 1,
    alignContent: 'space-between',
    justifyContent: 'center',
    padding: 0,
    margin: 0,
  },
  oneChaper: {
    marginBottom: 40,
  },
  chapterLine: {
    fontSize: 23,
    fontWeight: 'bold',
    margin: 10,
    color: '#000'
    // color: '#3CD3AD',
  },
  verseContent: {
    flex: 1,
  },
  titleLine: {
    flex: 1,
    flexDirection: 'column',
  },
  verseLine: {
    flex: 1,
    flexDirection: 'row',
  },
  title: {
    flex: 1,
    fontSize: 20,
    color: '#777',
    fontWeight: 'bold',
    textAlign: 'left',
    margin: 10,
  },
  idx: {
    flex: 2,
    fontSize: 16,
    color: '#777',
    alignItems: 'center',
    justifyContent: 'center',
    textAlign: 'right',
    margin: 5,
  },
  verse: {
    flex: 28,
    fontSize: 20,
    color: '#000',
    padding: 5,
    textAlign: 'left',
    // flexWrap: 'wrap',
    lineHeight: 30,
    fontWeight: 'normal',
    // textAlign: 'justify',
  },

  // closing page
  lastContainer: {
    flex: 1,
    padding: 0,
    alignItems: 'center',
    justifyContent: 'center',
    borderWidth: 10,
    borderRadius: 10,
    borderColor: '#3CD3AD',
  },
  progressView: {
    flex: 3,
    alignItems: 'center',
    justifyContent: 'center',
  },
  checkUpperView: {
    flex: 1,
    alignContent: 'flex-end',
    justifyContent: 'flex-end',
    backgroundColor: '#444',
  },
  checkIconView: {
    flex: 2,
    alignContent: 'center',
    justifyContent: 'center',
  },
  checkIcon: {
    // flex: 1,
    alignContent: 'center',
    justifyContent: 'center',
  },
  calendarView: {
    flex: 4,
    marginTop: 10,
    alignContent: 'flex-start',
    justifyContent: 'flex-start',
  },
  goHomeText: {
    flex: 1,
    textAlign: 'center',
    fontSize: Platform.OS === 'ios' ? 20 : 20,
    fontWeight: 'bold',
    marginTop: 10,
    color: '#3CD3AD',
  },
  logoutButton: {
    flex: 1,
    marginBottom: 50,
    alignContent: 'flex-end',
    justifyContent: 'flex-end',
  },
  logoutText: {
    flex: 1,
    fontSize: Platform.OS === 'ios' ? 16 : 16,
    color: '#3CD3AD',
  },
});

// export default memo(Dashboard);
export default Dashboard;
