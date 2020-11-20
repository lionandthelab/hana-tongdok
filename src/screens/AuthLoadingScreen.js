import React, { memo, useState } from "react";
import { ActivityIndicator } from "react-native";
import firebase from "firebase/app";
import "firebase/auth";
import Background from "../components/Background";
import Logo from "../components/Logo";
import { theme } from "../core/theme";
import { FIREBASE_CONFIG } from "../core/config";
// import * as firebase from 'firebase';
// import '@firebase/messaging';

// Initialize Firebase
firebase.initializeApp(FIREBASE_CONFIG);

useEffect = () => {
  checkPermission()
  messageListener()
}

checkPermission = async () => {
  const enabled = await firebase.messaging().hasPermission();
  if (enabled) {
      getFcmToken();
  } else {
      requestPermission();
  }
}

getFcmToken = async () => {
  const fcmToken = await firebase.messaging().getToken();
  if (fcmToken) {
    console.log(fcmToken);
    showAlert('Your Firebase Token is:', fcmToken);
  } else {
    showAlert('Failed', 'No token received');
  }
}

requestPermission = async () => {
  try {
    await firebase.messaging().requestPermission();
    // User has authorised
  } catch (error) {
    // User has rejected permissions
  }
}

messageListener = async () => {

  notificationListener = firebase.notifications().onNotification((notification) => {
      const { title, body } = notification;

      console.log("notificationListener - title", title, "body: ", body);
      notification.localNotification(title, body)
      // this.notification.scheduleNotification()
      console.log("notificationListener");
      this.showAlert(title, body);
  });

  notificationOpenedListener = firebase.notifications().onNotificationOpened((notificationOpen) => {
      const { title, body } = notificationOpen.notification;
      // this.notification.localNotification()
      console.log("notificationOpenedListener");
      this.showAlert(title, body);
  });

  const notificationOpen = await firebase.notifications().getInitialNotification();
  if (notificationOpen) {
      // const { title, body } = notificationOpen.notification;
      
      console.log("notificationOpen");
      this.showAlert(title, body);
  }

  messageListener = firebase.messaging().onMessage((message) => {
    console.log(JSON.stringify(message));
  });
}

showAlert = (title, message) => {
  Alert.alert(
    title,
    message,
    [
      {text: 'OK', onPress: () => console.log('OK Pressed')},
    ],
    {cancelable: false},
  );
}

const AuthLoadingScreen = ({ navigation }) => {
  const [loading, setLoading] = useState(true); 

  if (loading == false) {
    return (
    <Background>
      <Logo />
    </Background>
    );
  }
  this.useEffect()
    
  
  firebase.auth().onAuthStateChanged(user => {
    if (user) {
      setLoading(false);
      // User is logged in
      navigation.navigate("Dashboard");
    } else {
      // User is not logged in
      navigation.navigate("HomeScreen");
    }
  });

  return (
    <Background>
      {/* <ActivityIndicator size="large" color={theme.colors.primary} /> */}
      <Logo />

    </Background>
  );
};

export default memo(AuthLoadingScreen);
