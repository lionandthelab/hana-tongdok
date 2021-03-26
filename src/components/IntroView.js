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
  <LinearGradient
    colors={["#4CE3BDFF", "#3CD3AD11"]}
    start={{ x: 0, y: 0 }}
    end={{ x: 1, y: 1 }}
    style={styles.headerContainer}
  >
    <View style={styles.dateBox}>
      <View style={styles.settingsView}>
        <Text style={styles.settingsTextView}>1년{plan}독</Text>
        <TouchableOpacity
          style={styles.settingsIconView}
          onPress={() => {
            openSettings();
          }}
        >
          <Icon name="cogs" size={40} color="#FFFFFF" />
        </TouchableOpacity>
      </View>
      <View style={styles.dateView}>
        <TouchableOpacity
          style={styles.arrowLeftView}
          onPress={() => {
            previousDate();
          }}
        >
          <Icon name="angle-up" size={100} color="#FFFFFF" />
        </TouchableOpacity>
        <Text style={styles.date}>
          {/* {todayVerse.date} */}
          {curDate.getMonth() + 1}월 {curDate.getDate()}일
        </Text>
        {!loadingDate
          ? todayVerse.map((verse, i) => (
              <Text key={i} style={styles.chapter}>
                {verse.chapter}
              </Text>
            ))
          : null}
        <TouchableOpacity
          style={styles.arrowRightView}
          onPress={() => {
            nextDate();
          }}
        >
          <Icon name="angle-down" size={100} color="#FFFFFF" />
        </TouchableOpacity>

        <GDButton
          style={styles.readButton}
          text={"읽기"}
          onPress={() => {
            setReading(1);
          }}
        />
        <GDButton
          style={styles.readButton}
          text={"나의 말씀"}
          onPress={() => {
            setReading(2);
          }}
        />
      </View>
      <View style={styles.settingsView}></View>
    </View>
  </LinearGradient>
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
    // borderWidth: 10,
    // borderRadius: 10,
    // borderColor: "#3CD3AD",
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
  },
  arrowLeftView: {
    alignItems: "center",
    justifyContent: "flex-end",
    top: 10,
    // paddingLeft: 10,
  },
  arrowRightView: {
    alignItems: "center",
    justifyContent: "flex-start",
    // paddingRight: 10,
  },
  date: {
    fontSize: Platform.OS === "ios" ? 42 : 32,
    color: "#FFFFFF",
    textAlign: "center",
    textAlignVertical: "center",
    margin: 12,
    fontWeight: "bold",
    // fontFamily: 'BMJUA',
  },
  chapter: {
    fontSize: Platform.OS === "ios" ? 30 : 24,
    color: "#FFFFFF",
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
    top: 5 + getStatusBarHeight(),
    right: 20,
  },
  settingsTextView: {
    alignItems: "center",
    justifyContent: "center",
    padding: 3,
    fontWeight: "bold",
    fontSize: 24,
    color: "#FFFFFF",
  },
  settingsIconView: {
    alignItems: "center",
    justifyContent: "center",
  },

  readButton: {
    padding: 10,
  },
});

export default memo(IntroView);
