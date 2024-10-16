//
//  REAppDelegate.m
//  IOSApp
//
//  Created by Lemon on 2022/11/27.
//

#import "REAppDelegate.h"
#import "BlackHole3D.h"
#import <CoreTelephony/CTCellularData.h>
#import <SystemConfiguration/SystemConfiguration.h>

@implementation SDLUIKitDelegate (reAppDelegate)

+ (NSString *)getAppDelegateClassName {
	return @"AppDelegate";
}

@end


@interface REAppDelegate ()
@property (assign, nonatomic) SCNetworkReachabilityRef reachabilityRef;

@end


@implementation REAppDelegate
@synthesize window = _window;

- (UIWindow *)window {
	if (!_window) {
		_window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	}
	return _window;
}

// 引擎初始化（在有网络之后进行）
- (void)initBlackHoleEngine {
	// 延时0.1秒，主线程初始化引擎
	double delayInSeconds = 0.1;
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
	dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
		[[BlackHole3D sharedSingleton] createBlackHoleIOSSDK:nil];
	});
}

/* 获取网络权限状态 */
- (void)networkStatus {
	//2.根据权限执行相应的交互
	CTCellularData *cellularData = [[CTCellularData alloc] init];
	/* 此函数会在网络权限改变时再次调用 */
	cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state) {
		switch (state) {
			case kCTCellularDataRestricted:
				NSLog(@"Restricted");
				//2.1权限关闭的情况下 再次请求网络数据会弹出设置网络提示
				[self testHttp];//模拟一次请求
				break;
			case kCTCellularDataNotRestricted:
				NSLog(@"NotRestricted");
				//2.2已经开启网络权限 监听网络状态
				if (![[BlackHole3D sharedSingleton] getRealEngineExist]) {
					[self initBlackHoleEngine];
				}
				break;
			case kCTCellularDataRestrictedStateUnknown:
				NSLog(@"Unknown");
				break;
			default:
				break;
		}
	};
}

- (void)testHttp {
	NSURL *url = [NSURL URLWithString:@"https://developer.bjblackhole.com"];//此处修改为自己公司的服务器地址
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	NSURLSession *session = [NSURLSession sharedSession];
	NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		if (error == nil) {
			NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
			NSLog(@"%@",dict);
		}
	}];
	[dataTask resume];
}


// 前往设置
- (void)gotoSysSetting {
	// 在主线程中弹出提示框
	dispatch_async(dispatch_get_main_queue(), ^{
		UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"网络设置"
																			   message:@"当前网络不可用，是否前往设置？"
																		preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:@"设置"
															   style:UIAlertActionStyleDefault
															 handler:^(UIAlertAction * _Nonnull action) {
																 // 跳转到设置页面
																 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
															 }];
		UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
															   style:UIAlertActionStyleCancel
															 handler:nil];
		[alertController addAction:settingsAction];
		[alertController addAction:cancelAction];
		[self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
	});
}


// 该方法不要写内容
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	[super application:application didFinishLaunchingWithOptions:launchOptions];
	
	[self networkStatus];
	
	//1.获取网络权限 根据权限进行人机交互
//	if (__IPHONE_10_0) {
//		[self networkStatus];
//	}else {
//		//2.2已经开启网络权限 监听网络状态
//		[self initBlackHoleEngine];
//	}
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
