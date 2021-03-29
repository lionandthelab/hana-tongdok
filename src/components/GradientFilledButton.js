import React, { memo } from "react";
import { StyleSheet, TouchableOpacity, Text } from "react-native";
import { theme } from "../core/theme";
import LinearGradient from "react-native-linear-gradient";

const GDButton = ({ text, onPress }) => (
  <LinearGradient
    //   start={{ x: 0, y: 0 }}
    //   end={{ x: 1, y: 1 }}
    // colors={["red", "yellow", "green"]}
    start={{ x: 0, y: 0 }}
    end={{ x: 1, y: 1 }}
    // colors={["#5851DB", "#5851DB", "purple"]}
    colors={["#4CD3AD77", "#3CD3AD77", "#3CD3ADAA"]}
    // colors={["#5851DB", "#3CD3AD", "#5851DB", "#3CD3AD", "#5851DB"]}

    // colors={["#5851DB11"]}
    style={styles.linearGradient}
  >
    <TouchableOpacity onPress={onPress} style={styles.outlined}>
      <Text style={styles.buttonText}>{text}</Text>
    </TouchableOpacity>
  </LinearGradient>
);

const styles = StyleSheet.create({
  // gradient filled button
  linearGradient: {
    paddingHorizontal: 1,
    paddingVertical: 1,
    borderRadius: 10,
    marginHorizontal: 100,
    marginVertical: 10,
    // alignItems: "center",
    // justifyContent: "center",
    // borderRadius: 10,
  },
  outlined: {
    margin: 1,
    borderRadius: 10,
    paddingVertical: 10,
    alignItems: "center",
    justifyContent: "center",
    backgroundColor: "#FFFFFF",
  },
  buttonText: {
    fontWeight: "bold",
    fontSize: 20,
    lineHeight: 26,
    fontFamily: "Gill Sans",
    textAlign: "center",
    color: "#3CD3AD",
    // color: "#FFFFFF",
    backgroundColor: "transparent",
  },
});

export default memo(GDButton);
