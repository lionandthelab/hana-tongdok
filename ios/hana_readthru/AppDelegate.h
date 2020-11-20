/**
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <UIKit/UIKit.h>
#import <UMReactNativeAdapter/UMModuleRegistryAdapter.h>
#import <React/RCTBridgeDelegate.h>
#import <UMCore/UMAppDelegateWrapper.h>
//@import UserNotifications;

@interface AppDelegate : UMAppDelegateWrapper <RCTBridgeDelegate>
// change this with extra parameter
//@interface AppDelegate : UIResponder <UIApplicationDelegate,UNUserNotificationCenterDelegate>

@property (nonatomic, strong) UMModuleRegistryAdapter *moduleRegistryAdapter;
@property (nonatomic, strong) UIWindow *window;

@end
