import React, { memo } from "react";
import { Snackbar } from "react-native-paper";
import {
  SafeAreaView,
  Platform,
  StyleSheet,
  View,
  Text,
  TouchableOpacity,
  StatusBar,
} from "react-native";
import Icon from "react-native-vector-icons/FontAwesome";
import GDButton from "../components/GradientFilledButton";
import LinearGradient from "react-native-linear-gradient";
import { getStatusBarHeight } from "react-native-status-bar-height";

const IntroView = ({
  plan,
  openSettings,
  previousDate,
  nextDate,
  curDate,
  loadingDate,
  todayVerse,
  setReading,
}) => (
  <View style={styles.headerContainer}>
    <View style={styles.dateBox}>
      <View style={styles.settingsView}>
        {/* <Text style={styles.settingsTextView}>1년{plan}독</Text> */}
        <TouchableOpacity
          style={styles.settingsIconView}
          onPress={() => {
            setReading(1);
          }}
        >
          <Icon name="book" size={40} color="#3CD3AD" />
        </TouchableOpacity>
        <TouchableOpacity
          style={styles.settingsIconView}
          onPress={() => {
            openSettings();
          }}
        >
          <Icon name="cogs" size={40} color="#3CD3AD" />
        </TouchableOpacity>
      </View>
      <View style={styles.dateView}>
        <TouchableOpacity
          style={styles.arrowLeftView}
          onPress={() => {
            previousDate();
          }}
        >
          <Icon name="angle-up" size={100} color="#3CD3AD" />
        </TouchableOpacity>
        <Text style={styles.date}>
          {/* {todayVerse.date} */}
          {curDate.getYear() + 1900}년 {curDate.getMonth() + 1}월{" "}
          {curDate.getDate()}일
        </Text>
        {!loadingDate && todayVerse ? (
          todayVerse.map((verse, i) => (
            <Text key={i} style={styles.chapter}>
              {verse.chapter}
            </Text>
          ))
        ) : (
          <Text style={styles.chapter}>로딩중...</Text>
        )}
        <TouchableOpacity
          style={styles.arrowRightView}
          onPress={() => {
            nextDate();
          }}
        >
          <Icon name="angle-down" size={100} color="#3CD3AD" />
        </TouchableOpacity>
      </View>
      <View style={styles.settingsView}></View>
    </View>
  </View>
);

const styles = StyleSheet.create({
  mainContainer: {
    flex: 1,
    backgroundColor: "#fff",
    padding: 0,
  },
  headerContainer: {
    flex: 1,
    padding: 0,
    alignItems: "center",
    justifyContent: "center",
    borderWidth: 10,
    borderRadius: 10,
    borderColor: "#3CD3AD",
  },
  dateBox: {
    flexDirection: "column",
    flex: 1,
    alignContent: "center",
    justifyContent: "center",
    width: "100%",
  },
  dateView: {
    flex: 3,
    alignContent: "center",
    justifyContent: "center",
    // borderWidth: 3,
    // borderRadius: 0,
    // borderColor: "#3CD3AD",
    margin: 40,
    paddingBottom: 40,
  },
  arrowLeftView: {
    alignItems: "center",
    justifyContent: "flex-end",
    padding: 10,
    // paddingLeft: 10,
  },
  arrowRightView: {
    alignItems: "center",
    justifyContent: "flex-start",
    padding: 10,
    // paddingRight: 10,
  },
  date: {
    fontSize: Platform.OS === "ios" ? 26 : 24,
    color: "#3CD3AD",
    textAlign: "center",
    textAlignVertical: "center",
    padding: 10,
    // fontWeight: "bold",
    // fontFamily: 'BMJUA',
  },
  chapter: {
    fontSize: Platform.OS === "ios" ? 26 : 24,
    fontWeight: "bold",
    color: "#3CD3AD",
    textAlign: "center",
    margin: 5,
    // fontFamily: 'BMJUA',
  },

  // Settings
  settingsView: {
    flex: 1,
    flexDirection: "row",
    alignItems: "flex-start",
    justifyContent: "flex-end",
    // top: 5 + getStatusBarHeight(),
    top: 10,
    right: 10,
  },
  settingsTextView: {
    alignItems: "center",
    justifyContent: "center",
    padding: 3,
    fontWeight: "bold",
    fontSize: 24,
    color: "#3CD3AD",
  },
  settingsIconView: {
    alignItems: "center",
    justifyContent: "center",
    padding: 5,
  },

  readButton: {
    padding: 5,
  },
});

export default memo(IntroView);
