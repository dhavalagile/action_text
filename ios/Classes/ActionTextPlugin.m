#import "ActionTextPlugin.h"
#import <action_text/action_text-Swift.h>

@implementation ActionTextPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftActionTextPlugin registerWithRegistrar:registrar];
}
@end
