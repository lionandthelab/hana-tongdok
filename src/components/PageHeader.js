import React, { memo } from "react";
import { Snackbar } from "react-native-paper";
import { StyleSheet, View, Text, TouchableOpacity } from "react-native";
import Icon from "react-native-vector-icons/FontAwesome";

const PageHeader = ({
  fontColor,
  fontSize,
  chapterName,
  flipDarkMode,
  increaseFontSize,
  decreaseFontSize,
}) => (
  <View style={styles.chapterLineBox}>
    <View style={styles.chapterLineWrapper}>
      <Text
        style={[
          styles.chapterLine,
          {
            color: fontColor,
            fontSize: fontSize,
          },
        ]}
      >
        {chapterName}
      </Text>
    </View>
    <View style={styles.fontSizerIconWrapper}>
      <TouchableOpacity onPress={() => flipDarkMode()}>
        <Icon name="flash" size={25} color="#3CD3AD" />
      </TouchableOpacity>
    </View>
    <View style={styles.fontSizerIconWrapper}>
      <TouchableOpacity onPress={() => increaseFontSize()}>
        <Icon name="plus" size={25} color="#3CD3AD" />
      </TouchableOpacity>
    </View>
    <View style={styles.fontSizerIconWrapper}>
      <TouchableOpacity onPress={() => decreaseFontSize()}>
        <Icon name="minus" size={25} color="#3CD3AD" />
      </TouchableOpacity>
    </View>
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

export default memo(PageHeader);
