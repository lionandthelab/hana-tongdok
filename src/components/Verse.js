import React, { memo } from "react";
import { Snackbar } from "react-native-paper";
import { StyleSheet, View, TouchableOpacity } from "react-native";
import Icon from "react-native-vector-icons/FontAwesome";
import {
  Badge,
  Divider,
  Paragraph,
  Avatar,
  Card,
  IconButton,
  List,
  Text, Title,
} from "react-native-paper";

const Verse = ({ chapterName, content, index, comments, bgColor, fontColor, fontSize, storeMyVerse, removeMyVerse, setVisible }) => (
  <View key={`verse-${index}`} style={styles.verseContent}>
    <TouchableOpacity onLongPress={() => {
      storeMyVerse(chapterName, index, content)
      setVisible(true)
      }}>
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
                lineHeight: fontSize * 1.5,
              },
            ]}
          >
            {content}
            {comments && comments.map((c, i) => <Text style={[
              styles.verse,
              {
                color: fontColor,
                fontSize: fontSize - 5,
                lineHeight: fontSize * 1.5,
              },
            ]}>
              {c }
            </Text> )}
            {/* {comments && 
            <Text style={[
              styles.verse,
              {
                color: fontColor,
                fontSize: fontSize - 5,
                lineHeight: fontSize * 1.5,
              },
            ]}>
              {comments.map((c, i) => {c })}
            </Text> */}
          </Paragraph>
        </View>
      </View>
    </TouchableOpacity>
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
