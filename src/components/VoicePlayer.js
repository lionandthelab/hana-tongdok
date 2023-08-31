import React, { memo } from "react";
// import { WebView } from "react-native-webview";
import { Platform, StyleSheet, View } from "react-native";

const VoicePlayer = ({ book, chapter }) => (
  <View style={styles.container}>
    {/* <WebView
      scalesPageToFit={true}
      originWhitelist={["*"]}
      source={{
        html: `<iframe width="100%" height="100%" src="https://www.bskorea.or.kr/bible/listen.php?voiceAnchor=&version=SAENEW&book=${book}&chap=${chapter}&chap2=${chapter}&sex=m" \
            frameborder="0" \
            allow="autoplay; encrypted-media" \
            allowfullscreen \
          ></iframe>`,
      }}
      style={{ marginTop: 10 }}
    /> */}
  </View>
);

const styles = StyleSheet.create({
  container: {
    // height: Platform.OS == "ios" ? 170 : 500,
    height: 170,
    width: "100%",
    margin: 0,
  },
});

export default memo(VoicePlayer);
