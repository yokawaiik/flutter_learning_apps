#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"

#import <Flutter/Flutter.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

  // [GeneratedPluginRegistrant registerWithRegistry:self];
  // // Override point for customization after application launch.
  // return [super application:application didFinishLaunchingWithOptions:launchOptions];


  FlutterViewController* controller = (FlutterViewController*)self.window.rootViewController;

  FlutterMethodChannel* batteryChannel = [FlutterMethodChannel
                                          methodChannelWithName:@"specific.dev/battery"
                                          binaryMessenger:controller.binaryMessenger];

  [batteryChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {

    - (int)getBatteryLevel {
      UIDevice* device = UIDevice.currentDevice;
      device.batteryMonitoringEnabled = YES;
      if (device.batteryState == UIDeviceBatteryStateUnknown) {
        return -1;
      } else {
        return (int)(device.batteryLevel * 100);
      }
    }
  }];

  [GeneratedPluginRegistrant registerWithRegistry:self];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];

}

__weak typeof(self) weakSelf = self;
[batteryChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
  // Note: this method is invoked on the UI thread.
  if ([@"getBatteryLevel" isEqualToString:call.method]) {
    int batteryLevel = [weakSelf getBatteryLevel];

    if (batteryLevel == -1) {
      result([FlutterError errorWithCode:@"UNAVAILABLE"
                                 message:@"Battery info unavailable"
                                 details:nil]);
    } else {
      result(@(batteryLevel));
    }
  } else {
    result(FlutterMethodNotImplemented);
  }
}];




@end
