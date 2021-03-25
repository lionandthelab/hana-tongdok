import React, { memo } from "react";
import { Snackbar } from "react-native-paper";
import { StyleSheet, View, Text, TouchableOpacity } from "react-native";
import Icon from "react-native-vector-icons/FontAwesome";

const Verse = ({ title, content, index, fontColor, fontSize }) => (
  <View key={index} style={styles.verseContent}>
    {title ? (
      <View style={styles.titleLine}>
        <Text
          style={[
            styles.title,
            {
              color: fontColor,
              fontSize: fontSize,
            },
          ]}
        >
          {title}
        </Text>
      </View>
    ) : null}
    <View style={styles.verseLine}>
      <Text style={styles.idx}>{index}</Text>
      <Text
        style={[
          styles.verse,
          {
            color: fontColor,
            fontSize: fontSize,
            lineHeight: fontSize + 10,
          },
        ]}
      >
        {content}
      </Text>
    </View>
  </View>
);

const styles = StyleSheet.create({
  verseContent: {
    flex: 1,
  },
  titleLine: {
    flex: 1,
    flexDirection: "column",
  },
  verseLine: {
    flex: 1,
    flexDirection: "row",
  },
  title: {
    flex: 1,
    fontSize: 20,
    color: "#777",
    fontWeight: "bold",
    textAlign: "left",
    margin: 10,
  },
  idx: {
    flex: 2,
    fontSize: 16,
    color: "#777",
    alignItems: "center",
    justifyContent: "center",
    textAlign: "right",
    margin: 5,
  },
  verse: {
    flex: 28,
    fontSize: 20,
    color: "#000",
    padding: 5,
    textAlign: "left",
    lineHeight: 30,
    fontWeight: "normal",
  },
});

export default memo(Verse);
