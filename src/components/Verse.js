import React, { memo } from "react";
import { Snackbar } from "react-native-paper";
import { StyleSheet, View, Text, TouchableOpacity } from "react-native";
import Icon from "react-native-vector-icons/FontAwesome";
import {
  Badge,
  Divider,
  Paragraph,
  Avatar,
  Card,
  IconButton,
  List,
  Title,
} from "react-native-paper";

const Verse = ({ content, index, comments, bgColor, fontColor, fontSize }) => (
  <View key={`verse-${index}`} style={styles.verseContent}>
    <View style={styles.verseLine}>
      <View style={styles.indexView}>
        <Badge style={styles.badge}>{index}</Badge>
      </View>
      <View style={styles.contentView}>
        <Paragraph
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
        </Paragraph>
        {comments && comments.map((c, i) => <Paragraph>{c}</Paragraph>)}
      </View>
    </View>
  </View>
);

const styles = StyleSheet.create({
  verseContent: {
    flex: 1,
    marginEnd: 1,
  },
  verseLine: {
    flex: 1,
    flexDirection: "row",
    borderRightColor: "#4CE3BD77",
    borderRightWidth: 2,
    margin: 1,
  },
  indexView: {
    flex: 1,
    flexDirection: "row",
    alignSelf: "center",
    justifyContent: "center",
  },
  contentView: {
    flex: 10,
  },
  badge: {
    fontSize: 15,
    backgroundColor: "#4CE3BD",
    color: "white",
  },
  card: {
    marginStart: 2,
    marginEnd: 20,
    borderBottomColor: "#4CE3BD33",
  },
  title: {
    fontSize: 20,
    color: "#777",
    fontWeight: "bold",
    textAlign: "left",
    margin: 1,
  },
  idx: {
    fontSize: 16,
    color: "#777",
    alignItems: "center",
    justifyContent: "center",
    textAlign: "right",
    margin: 5,
  },
  verse: {
    fontSize: 20,
    color: "#000",
    padding: 3,
    textAlign: "left",
    lineHeight: 30,
    fontWeight: "normal",
  },
});

export default memo(Verse);
