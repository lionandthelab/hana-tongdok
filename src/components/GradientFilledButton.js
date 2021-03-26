import React, { memo } from "react";
import { StyleSheet, TouchableOpacity, Text } from "react-native";
import { theme } from "../core/theme";
import LinearGradient from "react-native-linear-gradient";

const GDButton = ({ text, onPress }) => (
  <LinearGradient
    //   start={{ x: 0, y: 0 }}
    //   end={{ x: 1, y: 1 }}
    //   colors={["red", "yellow", "green"]}
    start={{ x: 0, y: 0 }}
    end={{ x: 1, y: 1 }}
    // colors={["#5851DB", "#C13584", "#E1306C", "#FD1D1D", "#F77737"]}
    colors={["#5851DB", "#3CD3AD", "#5851DB", "#3CD3AD", "#5851DB"]}
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
    paddingHorizontal: 5,
    paddingVertical: 5,
    borderRadius: 10,
    marginHorizontal: 30,
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
    backgroundColor: "white",
  },
  buttonText: {
    fontWeight: "bold",
    fontSize: 20,
    lineHeight: 26,
    fontFamily: "Gill Sans",
    textAlign: "center",
    color: "#3CD3AD",
    backgroundColor: "transparent",
  },
});

export default memo(GDButton);
