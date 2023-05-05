//
//  NotificationService.m
//  RichNotification
//
//  Created by Shamsundar Shinde on 04/05/23.
//

#import "NotificationService.h"
#import <DigitalReefSDK/DigitalReefSDK.h>
#import <FirebaseMessaging/FirebaseMessaging.h>

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    BOOL drAd = [[request.content.userInfo objectForKey:@"adAvailable"] boolValue];
    if(drAd){
      NSLog(@"DR SDK PAYLOAD");
      [DigitalReef includeMediaAttachmentWithRequest:request mutableContent:self.bestAttemptContent contentHandler:self.contentHandler];
    }else{
      NSLog(@"Other SDK PAYLOAD");
//      self.contentHandler(self.bestAttemptContent);
      [[FIRMessagingExtensionHelper init] populateNotificationContent:self.bestAttemptContent withContentHandler:self.contentHandler];
      //Messaging.serviceExtension().populateNotificationContent(bestAttemptContent!, withContentHandler: contentHandler)
    }
    
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

@end
