import React, { memo } from "react";
import { Snackbar } from "react-native-paper";
import {
  Platform,
  StyleSheet,
  View,
  Text,
  TouchableOpacity,
} from "react-native";
import Icon from "react-native-vector-icons/FontAwesome";
import Modal from "react-native-modal";

const Settings = ({
  isVisible,
  plan,
  setPlan1,
  setPlan2,
  setPlan3,
  logout,
  closeSettings,
}) => (
  <Modal
    key={11}
    isVisible={isVisible}
    testID={"modal"}
    backdropColor="#777777"
    backdropOpacity={0.2}
    animationIn="fadeIn"
    animationOut="fadeOut"
    animationInTiming={400}
    animationOutTiming={400}
    backdropTransitionInTiming={400}
    backdropTransitionOutTiming={400}
  >
    <View style={styles.settingsDummyView}></View>
    <View style={styles.settingsModalView}>
      <View style={styles.settingsModalTitle}>
        <Text style={styles.settingsModalClose}></Text>
        <Text style={styles.customBackdropText}>설정</Text>
        <TouchableOpacity
          style={styles.settingsModalClose}
          onPress={() => {
            closeSettings();
          }}
        >
          <Icon name="times-circle" size={36} color="#00ffcc" />
        </TouchableOpacity>
      </View>

      <View style={styles.settingsModalContents}>
        <View style={styles.settingsModalPlan}>
          <Text style={styles.settingsModalPlanTitle}>통독 플랜</Text>
          <TouchableOpacity
            style={styles.settingsModalPlanButton}
            onPress={() => {
              setPlan1();
            }}
          >
            <Text
              style={[
                styles.settingsModalPlanText,
                plan == 1 ? { color: "#00ffcc", borderColor: "#00ffcc" } : null,
              ]}
            >
              1독
            </Text>
          </TouchableOpacity>

          <TouchableOpacity
            style={styles.settingsModalPlanButton}
            onPress={() => {
              setPlan2();
            }}
          >
            <Text
              style={[
                styles.settingsModalPlanText,
                plan == 2 ? { color: "#00ffcc", borderColor: "#00ffcc" } : null,
              ]}
            >
              2독
            </Text>
          </TouchableOpacity>

          <TouchableOpacity
            style={styles.settingsModalPlanButton}
            onPress={() => {
              setPlan3();
            }}
          >
            <Text
              style={[
                styles.settingsModalPlanText,
                plan == 3 ? { color: "#00ffcc", borderColor: "#00ffcc" } : null,
              ]}
            >
              3독
            </Text>
          </TouchableOpacity>
        </View>

        <TouchableOpacity
          style={styles.settingsModalLogout}
          onPress={() => {
            logout();
            closeSettings();
          }}
        >
          <Icon name="sign-out" size={36} color="#FFFFFF" />
          <Text style={styles.buttonInSettings}>로그아웃</Text>
        </TouchableOpacity>
      </View>
    </View>
    <View style={styles.settingsDummyView}></View>
  </Modal>
);

const styles = StyleSheet.create({
  settingsModalView: {
    flex: 1,
    fontSize: Platform.OS === "ios" ? 24 : 24,
    fontWeight: "bold",
    color: "#FFFFFF",
    backgroundColor: "#77777777",
    borderRadius: 5,
    borderWidth: 1,
    borderColor: "#FFFFFF",
    alignItems: "center",
    justifyContent: "center",
  },
  settingsModalTitle: {
    flex: 2,
    flexDirection: "row",
    alignItems: "center",
    justifyContent: "center",
    width: "100%",
    borderTopWidth: 1,
    borderBottomWidth: 1,
    borderColor: "#FFFFFF",
  },
  settingsModalContents: {
    flex: 6,
    alignItems: "center",
    justifyContent: "center",
    width: "100%",
  },
  settingsModalPlan: {
    flex: 1,
    flexDirection: "row",
    alignItems: "center",
    justifyContent: "center",
    marginTop: 10,
    marginBottom: 10,
  },
  settingsModalPlanButton: {
    flex: 2,
    alignItems: "center",
    justifyContent: "center",
  },
  settingsModalPlanTitle: {
    flex: 3,
    alignItems: "center",
    justifyContent: "center",
    textAlign: "center",
    fontSize: Platform.OS === "ios" ? 24 : 24,
    fontWeight: "bold",
    color: "#FFFFFF",
  },
  settingsModalPlanText: {
    fontSize: Platform.OS === "ios" ? 24 : 24,
    fontWeight: "bold",
    color: "#FFFFFF",
    borderRadius: 5,
    borderWidth: 2,
    borderColor: "#FFFFFF",
  },
  settingsModalLogout: {
    flex: 1,
    flexDirection: "row",
    alignItems: "center",
    justifyContent: "center",
  },
  settingsModalClose: {
    flex: 1,
    alignItems: "flex-end",
    justifyContent: "flex-end",
    marginRight: 10,
  },
  buttonInSettings: {
    fontSize: Platform.OS === "ios" ? 24 : 24,
    fontWeight: "normal",
    color: "#FFFFFF",
  },
  settingsDummyView: {
    flex: 1,
    alignItems: "center",
    justifyContent: "flex-end",
  },

  customBackdrop: {
    flex: 1,
    backgroundColor: "#777777",
    alignItems: "center",
    justifyContent: "center",
  },
  customBackdropText: {
    fontSize: Platform.OS === "ios" ? 36 : 36,
    fontWeight: "bold",
    color: "#FFFFFF",
  },
});

export default memo(Settings);
