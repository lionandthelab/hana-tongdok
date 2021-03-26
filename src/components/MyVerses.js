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
} from "react-native-paper";
import Icon from "react-native-vector-icons/FontAwesome";
import GDButton from "../components/GradientFilledButton";
import Button from "../components/Button";
import Toast from "../components/Toast";
import LinearGradient from "react-native-linear-gradient";
import { getStatusBarHeight } from "react-native-status-bar-height";

const MyVerses = ({
  verses,
  setReading,
  removeMyVerse
}) => (
  <LinearGradient
    colors={["#4CE3BDFF", "#3CD3AD11"]}
    start={{ x: 0, y: 0 }}
    end={{ x: 1, y: 1 }}
    style={styles.headerContainer}
  >
    <ScrollView style={styles.dateBox}>
      <View style={styles.header}>
      <Title style={styles.title}>
        나의 말씀
      </Title>
      <Divider/>
      <Text style={styles.titleExplanation}>
        말씀을 길게 누르면 말씀을 간직할 수 있습니다.
      </Text>
      </View>
      <View style={styles.body}>
        {verses.map((verse, i) => (
          <Card key={i} style={styles.card}>
            <Card.Title
              title={`${verse.split('#')[0]} ${verse.split('#')[1]}절`}/>
            <Card.Content>
              <Paragraph>
                {verse.split('#')[2]}
              </Paragraph>
            </Card.Content>
            <Card.Actions>
              <Button onPress={() => removeMyVerse(verse)}>삭제</Button>
            </Card.Actions>
          </Card>
        ))}
      <View style={{padding: 30, marginVertical: 20}}>
        <GDButton
          style={styles.readButton}
          text={"돌아가기"}
          onPress={() => {
            setReading(0);
          }}
        />
      </View>
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
    paddingVertical: 30,
    alignItems: "center",
    justifyContent: "center",
  },
  dateBox: {
    flexDirection: "column",
    flex: 1,
    alignContent: "center",
    // justifyContent: "center",
    width: "100%",
  },
  header: {
    flex: 1,
    padding: 30,
    alignItems: "center",
    justifyContent: "center",
  },
  title: {
    fontSize: 25,
    fontWeight: 'bold',
    color: 'white'
  },
  titleExplanation: {
    fontSize: 15,
    fontWeight: 'bold',
    color: 'white'
  },
  body: {
    flex: 9,
  },
  card: {
    shadowColor: "#470000",
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.2,
    elevation: 3,
    margin: 10,
    borderRadius: 30,
    // borderBottomColor: "#47000033",
    // borderBottomWidth: 1,
  },

  readButton: {
    fontSize: 20,
    padding: 30,
  },
});

export default memo(MyVerses);
