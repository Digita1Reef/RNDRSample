#import "AppDelegate.h"
#import <DigitalReefSDK/DigitalReefSDK.h>
#import <Firebase.h>

#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>

@interface AppDelegate() <UNUserNotificationCenterDelegate>
@property (strong, nonatomic) DigitalReef *digitalReef;
@end


@implementation AppDelegate

- (instancetype)init{
    self = [super init];
    if(self){
        self.digitalReef = DigitalReef.shared;
    }
    return self;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    BOOL drAd = [[userInfo objectForKey:@"adAvailable"] boolValue];
    if(drAd){
      NSLog(@"DR SDK PAYLOAD");
      [DigitalReef.shared didReceiveRemoteNotificationWithApplication:application userInfo:userInfo fetchCompletionHandler:completionHandler];
    }else{
      NSLog(@"Other SDK PAYLOAD");
    }
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary *userInfo = notification.request.content.userInfo;
    BOOL drAd = [[userInfo objectForKey:@"adAvailable"] boolValue];
    if(drAd){
      NSLog(@"DR SDK PAYLOAD");
      [self.digitalReef willPresentNotificationWithCenter:center willPresent:notification withCompletionHandler:completionHandler];
    }else{
      NSLog(@"Other SDK PAYLOAD");
    }
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    
    BOOL drAd = [[userInfo objectForKey:@"adAvailable"] boolValue];
    if(drAd){
      NSLog(@"DR SDK PAYLOAD");
      [self.digitalReef didReceiveNotificationResponseWithCenter:center didReceive:response withCompletionHandler:completionHandler];
    }else{
      NSLog(@"Other SDK PAYLOAD");
    }
}
- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken {
    NSLog(@"FCM registration token: %@", fcmToken);
    // Notify about received token.
//    NSDictionary *dataDict = [NSDictionary dictionaryWithObject:fcmToken forKey:@"token"];
//    [[NSNotificationCenter defaultCenter] postNotificationName:
//     @"FCMToken" object:nil userInfo:dataDict];
    // TODO: If necessary send token to application server.
    // Note: This callback is fired at each app startup and whenever a new token is generated.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken : %@", deviceToken);
    [FIRMessaging messaging].APNSToken = deviceToken;
    [self.digitalReef didRegisterForRemoteNotificationsWithDeviceToken:application deviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError RegisterForRemoteNotificationsWithDeviceToken : %@", error.userInfo);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  [FIRApp configure]; // Firebase initialization
  [FIRMessaging messaging].delegate = self;
  [[UNUserNotificationCenter currentNotificationCenter] setDelegate:self]; // Required - if "DigitalReefSwizzlingEnabled" key is disabled in info.plist file
  [DigitalReef requestPushPermission];
  [application registerForRemoteNotifications]; // Required
  
  self.moduleName = @"RNDRSample";
  // You can add your custom initial props in the dictionary below.
  // They will be passed down to the ViewController used by React Native.
  self.initialProps = @{};
  
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge
{
#if DEBUG
  return [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index"];
#else
  return [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
#endif
}

/// This method controls whether the `concurrentRoot`feature of React18 is turned on or off.
///
/// @see: https://reactjs.org/blog/2022/03/29/react-v18.html
/// @note: This requires to be rendering on Fabric (i.e. on the New Architecture).
/// @return: `true` if the `concurrentRoot` feature is enabled. Otherwise, it returns `false`.
- (BOOL)concurrentRootEnabled
{
  return true;
}

@end
