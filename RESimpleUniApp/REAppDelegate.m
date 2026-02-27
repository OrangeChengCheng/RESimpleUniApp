//
//  REAppDelegate.m
//  IOSApp
//
//  Created by Lemon on 2022/11/27.
//

#import "REAppDelegate.h"
#import "BlackHole3D.h"

@implementation SDLUIKitDelegate (reAppDelegate)

+ (NSString *)getAppDelegateClassName {
	return @"AppDelegate";
}

@end


@interface REAppDelegate ()

@end


@implementation REAppDelegate
@synthesize window = _window;

- (UIWindow *)window {
	if (!_window) {
		_window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	}
	return _window;
}

// 引擎初始化（在有网络环境引擎才能加载模型）
- (void)initBlackHoleEngine {
	// 延时0.1秒，主线程初始化引擎
	double delayInSeconds = 0.1;
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
	dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
		[[BlackHole3D sharedSingleton] createBlackHoleIOSSDK:^{
			[self createREBlackHoleSuccess];
		}];
	});
}

// 引擎初始化回调 (继承重写获取回调)
- (void)createREBlackHoleSuccess {}



// 该方法不要写内容
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	[super application:application didFinishLaunchingWithOptions:launchOptions];
	[self initBlackHoleEngine];
	return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	[super applicationDidEnterBackground:application];
	[[BlackHole3D sharedSingleton] enterBackground];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	[super applicationWillEnterForeground:application];
	[[BlackHole3D sharedSingleton] enterForeground];
}

@end
