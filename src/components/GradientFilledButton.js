import React, { memo } from "react";
import { StyleSheet, TouchableOpacity, Text } from "react-native";
import { theme } from "../core/theme";
import LinearGradient from "react-native-linear-gradient";

const GDButton = ({ text, onPress }) => (
  <TouchableOpacity onPress={onPress} style={styles.linearGradient}>
    <LinearGradient
      //   start={{ x: 0, y: 0 }}
      //   end={{ x: 1, y: 1 }}
      //   colors={["red", "yellow", "green"]}
      start={{ x: 0, y: 0 }}
      end={{ x: 1, y: 1 }}
      colors={["#5851DB", "#C13584", "#E1306C", "#FD1D1D", "#F77737"]}
      style={{
        alignItems: "center",
        justifyContent: "center",
        borderRadius: 10,
      }}
    >
      <Text style={styles.buttonText}>{text}</Text>
    </LinearGradient>
  </TouchableOpacity>
);

const styles = StyleSheet.create({
  // gradient filled button
  linearGradient: {
    paddingHorizontal: 40,
    paddingVertical: 10,
    borderRadius: 10,
    margin: 20,
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
    margin: 10,
    color: "#ffffff",
    backgroundColor: "transparent",
  },
});

export default memo(GDButton);
