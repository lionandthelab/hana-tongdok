import React, { memo } from "react";
import Background from "../components/Background";
import Logo from "../components/Logo";
import Header from "../components/Header";
import Button from "../components/Button";
import Paragraph from "../components/Paragraph";

const HomeScreen = ({ navigation }) => (
  <Background>
    <Logo />
    <Header>하나통독</Header>

    <Paragraph>
      하나님 말씀 안에서의 시간을 누리세요!
    </Paragraph>
    <Button mode="contained" onPress={() => navigation.navigate("LoginScreen")}>
      로그인
    </Button>
    <Button
      mode="outlined"
      onPress={() => navigation.navigate("RegisterScreen")}
    >
      가입하기
    </Button>
  </Background>
);

export default memo(HomeScreen);
