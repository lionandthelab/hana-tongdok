import React, { memo } from "react";
import { Snackbar } from "react-native-paper";
import {
  SafeAreaView,
  Platform,
  StyleSheet,
  ScrollView,
  View,
  Text,
  TouchableOpacity,
  StatusBar,
} from "react-native";
import {
  Divider,
  Paragraph,
  Card,
  IconButton,
  Title,
  Button,
  Colors,
} from "react-native-paper";
import Icon from "react-native-vector-icons/FontAwesome";
import GDButton from "../components/GradientFilledButton";
import Toast from "../components/Toast";
import LinearGradient from "react-native-linear-gradient";
import { getStatusBarHeight } from "react-native-status-bar-height";
import Swiper from "react-native-swiper";

const MyVerses = ({ verses, setReading, removeMyVerse }) => (
  <LinearGradient
    colors={["#4CE3BDFF", "#3CD3AD11"]}
    start={{ x: 0, y: 0 }}
    end={{ x: 1, y: 1 }}
    style={styles.headerContainer}
  >
    <ScrollView style={styles.dateBox}>
      <View style={styles.header}>
        <Title style={styles.title}>나의 말씀</Title>
        <Divider />
        <Text style={styles.titleExplanation}>
          각 구절의 숫자를 길게 누르면 말씀을 간직할 수 있습니다.
        </Text>
      </View>
      <View style={styles.body}>
        {verses.map((verse, i) => (
          <Card key={i} style={styles.card}>
            <Card.Content>
              <View style={{ flexDirection: "row" }}>
                <View style={{ flex: 9 }}>
                  <Paragraph style={styles.texts}>
                    {verse.split("#")[2]}
                  </Paragraph>
                  <Paragraph style={styles.versetexts}>
                    {`${verse.split("#")[0]} ${verse.split("#")[1]}절`}
                  </Paragraph>
                </View>
                <View style={{ flex: 1, alignSelf: "center" }}>
                  <IconButton
                    icon="close-circle"
                    color={"#4CE3BDFF"}
                    size={20}
                    onPress={() => removeMyVerse(verse)}
                  />
                </View>
              </View>
            </Card.Content>
          </Card>
        ))}
      </View>
      <View style={styles.backButton}>
        <GDButton
          style={styles.readButton}
          text={"돌아가기"}
          onPress={() => {
            setReading(0);
          }}
        />
      </View>
    </ScrollView>
  </LinearGradient>
);

const styles = StyleSheet.create({
  mainContainer: {
    flex: 1,
    backgroundColor: "#fff",
    padding: 0,
  },
  headerContainer: {
    flex: 1,
    paddingTop: 30,
    paddingBottom: 50,
    alignItems: "center",
    justifyContent: "center",
  },
  dateBox: {
    flexDirection: "column",
    flex: 1,
    alignContent: "center",
    // justifyContent: "center",
    width: "100%",
    height: "100%",
  },
  texts: {
    fontSize: 15,
    lineHeight: 25,
  },
  versetexts: {
    fontSize: 16,
    lineHeight: 25,
    fontWeight: "bold",
  },
  header: {
    flex: 1,
    padding: 30,
    alignItems: "center",
    justifyContent: "center",
  },
  title: {
    fontSize: 25,
    fontWeight: "bold",
    color: "white",
  },
  titleExplanation: {
    fontSize: 15,
    fontWeight: "bold",
    color: "white",
    alignItems: "center",
    justifyContent: "center",
  },
  body: {},
  card: {
    shadowColor: "#470000",
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.2,
    elevation: 5,
    marginBottom: 15,
    marginHorizontal: 15,
    // flex: 1,
    flexDirection: "row",
    alignItems: "center",
    justifyContent: "center",
    // borderRadius: 30,
    // borderBottomColor: "#47000033",
    // borderBottomWidth: 1,
  },
  removeButton: {},

  readButton: {
    fontSize: 20,
    padding: 30,
  },
  backButton: {
    flex: 1,
    padding: 30,
    marginVertical: 20,
  },
});

export default memo(MyVerses);
