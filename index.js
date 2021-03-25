import { AppRegistry, Platform } from "react-native";
import App from "./App";

AppRegistry.registerComponent("hana_readthru", () => App);

if (Platform.OS === "web") {
  const rootTag =
    document.getElementById("root") || document.getElementById("main");
  AppRegistry.runApplication("hana_readthru", { rootTag });
}

// New task registration
AppRegistry.registerHeadlessTask(
  "RNFirebaseBackgroundMessage",
  () => bgMessaging
); // <-- Add this line
