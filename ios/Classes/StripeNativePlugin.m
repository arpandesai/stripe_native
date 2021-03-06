#import "StripeNativePlugin.h"
#if __has_include(<stripe_native/stripe_native-Swift.h>)
#import <stripe_native/stripe_native-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "stripe_native-Swift.h"
#endif

@implementation StripeNativePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftStripeNativePlugin registerWithRegistrar:registrar];
}
@end
