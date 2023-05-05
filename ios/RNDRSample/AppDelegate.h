#import <RCTAppDelegate.h>
#import <UIKit/UIKit.h>
#import <DigitalReefSDK/DigitalReefSDK.h>
#import <UserNotifications/UNUserNotificationCenter.h>
#import <Firebase.h>

@interface AppDelegate : RCTAppDelegate<UNUserNotificationCenterDelegate, FIRMessagingDelegate>
//@property (nonatomic, strong) UIWindow *window;
//@property (nonatomic, strong) DigitalReef *digitalReef;
@end
