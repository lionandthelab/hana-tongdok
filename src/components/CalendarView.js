import React, { memo } from "react";
import { Snackbar } from "react-native-paper";
import {
  Dimensions,
  StyleSheet,
  View,
  Text,
  TouchableOpacity,
} from "react-native";
import Icon from "react-native-vector-icons/FontAwesome";
import { Calendar, LocaleConfig } from "react-native-calendars";

LocaleConfig.locales["kr"] = {
  monthNames: [
    "1월",
    "2월",
    "3월",
    "4월",
    "5월",
    "6월",
    "7월",
    "8월",
    "9월",
    "10월",
    "11월",
    "12월",
  ],
  monthNamesShort: [
    "1.",
    "2.",
    "3.",
    "4.",
    "5.",
    "6.",
    "7.",
    "8.",
    "9.",
    "10.",
    "11.",
    "12.",
  ],
  dayNames: [
    "일요일",
    "월요일",
    "화요일",
    "수요일",
    "목요일",
    "금요일",
    "토요일",
  ],
  dayNamesShort: ["일", "월", "화", "수", "목", "금", "토"],
  today: "오늘",
};
LocaleConfig.defaultLocale = "kr";

const CalendarView = ({ current, markedDates, onDayPress }) => (
  <View>
    <Calendar
      current={current}
      minDate={"2020-01-01"}
      maxDate={"2022-12-31"}
      hideExtraDays={true}
      firstDay={0}
      markedDates={markedDates}
      style={{
        width: Dimensions.get("window").width * 0.8,
        alignContent: "center",
        height: "100%",
      }}
      theme={{
        calendarBackground: "#ffffff00",
        textSectionTitleColor: "#3CD3AD",
        selectedDayBackgroundColor: "#3CD3AD",
        selectedDayTextColor: "#ffffff",
        todayTextColor: "#3CD3AD",
        dayTextColor: "#2d4150",
        textDisabledColor: "#777",
        dotColor: "#00adf5",
        selectedDotColor: "#ffffff",
        arrowColor: "#3CD3AD",
        monthTextColor: "#3CD3AD",
        indicatorColor: "#3CD3AD",
        textDayFontWeight: "300",
        textMonthFontWeight: "bold",
        textDayHeaderFontWeight: "bold",
        textDayFontSize: 16,
        textMonthFontSize: 16,
        textDayHeaderFontSize: 16,
      }}
      onDayPress={onDayPress}
    />
  </View>
);

const styles = StyleSheet.create({
  chapterLineBox: {
    flex: 1,
    flexDirection: "row",
  },
  chapterLineWrapper: {
    flex: 8,
    alignContent: "flex-start",
    justifyContent: "flex-start",
  },
  chapterLine: {
    fontSize: 23,
    fontWeight: "bold",
    margin: 10,
  },
  fontSizerIconWrapper: {
    flex: 1,
    alignContent: "space-between",
    justifyContent: "center",
    padding: 0,
    margin: 0,
  },
});

export default memo(CalendarView);
