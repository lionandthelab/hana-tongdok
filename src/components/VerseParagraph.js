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
import Verse from "../components/Verse";

const VerseParagraph = ({
  index,
  paragraphData,
  bgColor,
  fontColor,
  fontSize,
}) => (
  <View key={`para-${index}`} style={styles.verseContent}>
    <Card
      key={`card-${index}`}
      style={[styles.card, { backgroundColor: bgColor }]}
    >
      {paragraphData.title ? (
        <Card.Title
          title={paragraphData.title}
          titleStyle={[
            styles.title,
            {
              color: fontColor,
              fontSize: fontSize + 2,
              lineHeight: fontSize + 5,
            },
          ]}
        />
      ) : null}
      <Card.Content>
        {paragraphData.verses.map((verse, i) => (
          <Verse
            content={verse.content}
            index={verse.index}
            comments={verse.comments}
            bgColor={bgColor}
            fontColor={fontColor}
            fontSize={fontSize}
          />
        ))}
      </Card.Content>
    </Card>
  </View>
);

const styles = StyleSheet.create({
  verseContent: {
    flex: 1,
    marginEnd: 5,
  },
  verseLine: {
    flex: 1,
    flexDirection: "row",
    borderRightColor: "#4CE3BD77",
    borderRightWidth: 2,
    margin: 4,
  },
  indexView: {
    flex: 1,
    flexDirection: "row",
    alignSelf: "center",
    justifyContent: "center",
  },
  contentView: {
    flex: 9,
  },
  badge: {
    fontSize: 15,
    backgroundColor: "#4CE3BD11",
    color: "white",
  },
  card: {
    shadowColor: "#470000",
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.2,
    elevation: 1,
    paddingBottom: 1,
    borderBottomColor: "#47000033",
    borderBottomWidth: 1,
  },
  title: {
    fontSize: 20,
    fontWeight: "bold",
    textAlign: "left",
    margin: 1,
  },
  idx: {
    fontSize: 16,
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

export default memo(VerseParagraph);
