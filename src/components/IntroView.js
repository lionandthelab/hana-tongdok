import React, { memo } from "react";
import { Snackbar } from "react-native-paper";
import {
  Platform,
  StyleSheet,
  View,
  Text,
  TouchableOpacity,
} from "react-native";
import Icon from "react-native-vector-icons/FontAwesome";
// import LinearGradient from "react-native-linear-gradient";

const IntroView = ({
  plan,
  openSettings,
  previousDate,
  nextDate,
  curDate,
  loadingDate,
  todayVerse,
}) => (
  // <LinearGradient
  //   colors={["purple", "white"]}
  //   style={styles.container}
  //   start={{ x: 0, y: 0 }}
  //   end={{ x: 1, y: 1 }}
  // >
  <View key={0} style={styles.headerContainer}>
    <View style={styles.dateBox}>
      <View style={styles.settingsView}>
        <Text style={styles.settingsTextView}>1년{plan}독</Text>
        <TouchableOpacity
          style={styles.settingsIconView}
          onPress={() => {
            openSettings();
          }}
        >
          <Icon name="cogs" size={40} color="#3CD3AD99" />
        </TouchableOpacity>
      </View>
      <TouchableOpacity
        style={styles.arrowLeftView}
        onPress={() => {
          previousDate();
        }}
      >
        <Icon name="angle-up" size={100} color="#3CD3AD99" />
      </TouchableOpacity>
      <View style={styles.dateView}>
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
      </View>
      <TouchableOpacity
        style={styles.arrowRightView}
        onPress={() => {
          nextDate();
        }}
      >
        <Icon name="angle-down" size={100} color="#3CD3AD99" />
      </TouchableOpacity>
      <View style={styles.settingsDummyView}></View>
    </View>
  </View>
  // </LinearGradient>
);

const styles = StyleSheet.create({
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
    padding: 10,
  },
  dateView: {
    flex: 4,
    alignContent: "center",
    justifyContent: "center",
  },
  arrowLeftView: {
    flex: 6,
    alignItems: "center",
    justifyContent: "flex-end",
    // paddingLeft: 10,
  },
  arrowRightView: {
    flex: 6,
    alignItems: "center",
    justifyContent: "flex-start",
    // paddingRight: 10,
  },
  date: {
    fontSize: Platform.OS === "ios" ? 42 : 32,
    color: "#3CD3AD",
    textAlign: "center",
    textAlignVertical: "center",
    margin: 12,
    fontWeight: "bold",
    // fontFamily: 'BMJUA',
  },
  chapter: {
    fontSize: Platform.OS === "ios" ? 30 : 24,
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
  },
  settingsTextView: {
    alignItems: "center",
    justifyContent: "center",
    padding: 3,
    fontWeight: "bold",
    fontSize: 24,
    color: "#3CD3AD99",
  },
  settingsIconView: {
    alignItems: "center",
    justifyContent: "center",
  },
});

export default memo(IntroView);
