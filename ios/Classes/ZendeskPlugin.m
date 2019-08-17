#import "ZendeskPlugin.h"

#import <ZDCChat/ZDCChat.h>
@import ZendeskSDK;
@import ZendeskCoreSDK;

@implementation ZendeskPlugin{
    UINavigationController *_viewController;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"com.codeheadlabs.zendesk"
            binaryMessenger:[registrar messenger]];

  UIViewController *viewController =
        [UIApplication sharedApplication].delegate.window.rootViewController;

  ZendeskPlugin* instance = [[ZendeskPlugin alloc] initWithViewController:viewController];
  [registrar addMethodCallDelegate:instance channel:channel];

}

- (instancetype)initWithViewController:(UINavigationController *)viewController {
  self = [super init];
  if (self) {
    _viewController = viewController;
  }
  return self;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"init" isEqualToString:call.method]) {
    [ZDCChat initializeWithAccountKey:call.arguments[@"accountKey"]];
    result(@(true));
  } else if ([@"setVisitorInfo" isEqualToString:call.method]) {
      NSString *email = call.arguments[@"email"];
      NSString *phoneNumber = call.arguments[@"phoneNumber"];
      NSString *name = call.arguments[@"name"];

      [ZDCChat updateVisitor:^(ZDCVisitorInfo *user) {
          if (![phoneNumber isKindOfClass:[NSNull class]]) {
              user.phone = phoneNumber;
          }

          if (![email isKindOfClass:[NSNull class]]) {
              user.email = email;
          }

          if (![name isKindOfClass:[NSNull class]]) {
              user.name = name;
          }
      }];
      result(@(true));
  } else if ([@"startChat" isEqualToString:call.method]) {
      [ZDCChat startChat:nil];
      result(@(true));
  } else if ([@"initSupportSDK" isEqualToString:call.method]) {
    
      NSString *appId = call.arguments[@"appId"];
      NSString *clientId = call.arguments[@"clientId"];
      NSString *url = call.arguments[@"url"];
      
      [ZDKZendesk initializeWithAppId:appId clientId:clientId zendeskUrl:url];
      [ZDKSupport initializeWithZendesk:[ZDKZendesk instance]];
      
      id<ZDKObjCIdentity> userIdentity = [[ZDKObjCAnonymous alloc] initWithName:nil email:nil];
      [[ZDKZendesk instance] setIdentity:userIdentity];
      [ZDKCoreLogger setEnabled:YES];
      [ZDKCoreLogger setLogLevel:ZDKLogLevelDebug];
    result(@(true));
  } else if ([@"startSupportSDK" isEqualToString:call.method]) {
    
    UIViewController *helpCenter = [ZDKHelpCenterUi buildHelpCenterOverviewUiWithConfigs:@[]];
    UINavigationController *myNavigation = [[UINavigationController alloc] initWithRootViewController:helpCenter];
    [_viewController presentViewController:myNavigation animated:YES completion:nil];

  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
