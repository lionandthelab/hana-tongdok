import React, { memo, useState } from "react";
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
  Text,
  Title,
} from "react-native-paper";

const Verse = ({
  chapterName,
  content,
  index,
  comments,
  bgColor,
  fontColor,
  fontSize,
  storeMyVerse,
  removeMyVerse,
  setVisible,
}) => {
  const [kept, setKept] = useState(false);
  const [bg, setBg] = useState("");

  const toggle = () => {
    setKept(!kept);
    if (kept) {
      setBg("#4CE3BD77");
    } else {
      setBg("#FFFFFF");
    }
  };

  return (
    <View key={`verse-${index}`} style={styles.verseContent}>
      <View style={[styles.verseLine, (backgroundColor = `${bg}`)]}>
        <View style={styles.indexView}>
          <TouchableOpacity
            onLongPress={() => {
              storeMyVerse(chapterName, index, content);
              setVisible(true);
              setBg(!kept ? "#4CE3BD" : fontColor);
              setKept(!kept);
            }}
          >
            <Badge style={[styles.badge]}>{index}</Badge>
          </TouchableOpacity>
        </View>
        <View style={[styles.contentView, (backgroundColor = `${bg}`)]}>
          <Paragraph
            style={[
              styles.verse,
              {
                color: bg == "" ? fontColor : bg,
                fontSize: fontSize,
                lineHeight: fontSize * 1.5,
              },
            ]}
          >
            {content}
            {comments &&
              comments.map((c, i) => (
                <Text
                  style={[
                    styles.verse,
                    {
                      color: fontColor,
                      fontSize: fontSize - 5,
                      lineHeight: fontSize * 1.5,
                    },
                  ]}
                >
                  {` ${c}`}
                </Text>
              ))}
          </Paragraph>
        </View>
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  verseContent: {
    flex: 1,
    marginEnd: 1,
  },
  verseLine: {
    flexGrow: 1,
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

// export default memo(Verse);
export default Verse;
