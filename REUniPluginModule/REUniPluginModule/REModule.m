//
//  REModule.m
//  RETestUniPlugin
//
//  Created by Apple on 2023/11/23.
//

#import "REModule.h"
#import "REEngineVC.h"
#import "BlackHole3D.h"
#import <objc/runtime.h>
#import "YYModel.h"
#import "REUniClass.h"



static UniModuleKeepAliveCallback appToUniCallBack = nil;
static REModuleCallback uniToAppCallBack = nil;

@implementation REModule

// 通过宏 UNI_EXPORT_METHOD 将异步方法暴露给 js 端
UNI_EXPORT_METHOD(@selector(realEngineRender:callback:))

/// 异步方法（注：异步方法会在主线程（UI线程）执行）
/// @param options js 端调用方法时传递的参数
/// @param callback 回调方法，回传参数给 js 端
- (void)realEngineRender:(NSDictionary *)options callback:(UniModuleKeepAliveCallback)callback {
	// options 为 js 端调用此方法时传递的参数
	NSLog(@"************* 【uni -> app】 : (realEngineRender)  %@",options);
	
	RESceneUniData *sceneUniData = [RESceneUniData yy_modelWithDictionary:options];
	
	REEngineVC *engineVC = [[REEngineVC alloc] init];
	engineVC.sceneUniData = sceneUniData;
	engineVC.isUniAppComp = NO;
	engineVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
	UIWindow *currWindow = [UIApplication sharedApplication].keyWindow;
	[currWindow.rootViewController presentViewController:engineVC animated:YES completion:nil];
	

	// 回调方法，传递参数给 js 端 注：只支持返回 String 或 NSDictionary (map) 类型
	if (callback) {
		// 第一个参数为回传给js端的数据，第二个参数为标识，表示该回调方法是否支持多次调用，如果原生端需要多次回调js端则第二个参数传 YES;
		callback(@"success",NO);
	}
}


// 通过宏 UNI_EXPORT_METHOD 将异步方法暴露给 js 端
UNI_EXPORT_METHOD(@selector(unipluginLog:))

/// 异步方法（注：异步方法会在主线程（UI线程）执行）
/// @param options js 端调用方法时传递的参数
- (void)unipluginLog:(NSDictionary *)options {
	// options 为 js 端调用此方法时传递的参数
	NSLog(@"************* 【uni -> app】 : (unipluginLog)   %@", options);
}


// 通过宏 UNI_EXPORT_METHOD_SYNC 将同步方法暴露给 js 端
UNI_EXPORT_METHOD_SYNC(@selector(reAppToUniMessageHandler:))
/// 同步方法（注：同步方法会在 js 线程执行）
/// @param callback 回调方法，回传参数给 js 端
- (void)reAppToUniMessageHandler:(UniModuleKeepAliveCallback)callback {
	appToUniCallBack = callback;
}


// 通过宏 UNI_EXPORT_METHOD_SYNC 将同步方法暴露给 js 端
UNI_EXPORT_METHOD_SYNC(@selector(reUniPostData:))
/// 同步方法（注：同步方法会在 js 线程执行）
/// @param options js 端调用方法时传递的参数   支持：String、Number、Boolean、JsonObject 类型
- (void)reUniPostData:(NSDictionary *)options {
	NSLog(@"************* 【uni -> app】 : (reUniPostData)   %@", options);
	if (uniToAppCallBack != nil) {
		uniToAppCallBack(@"--------------------------");
	}
}


+ (void)sendMessage:(REModuleMsgType)type message:(id)message completion:(REModuleCallback)completion {
	NSLog(@"************* 【app -> uni】 :  %@", message);
	switch (type) {
		case REModuleMsg_T1:
		{
			if (appToUniCallBack != nil) {
				appToUniCallBack(@{@"code":@"success"}, YES);
				uniToAppCallBack = completion;
			}
		}
			break;
		case REModuleMsg_T2:
		{
			if (appToUniCallBack != nil) {
				NSString *msg = (NSString *)message;
				appToUniCallBack(@{@"code":@"error", @"msg":msg}, YES);
				uniToAppCallBack = completion;
			}
		}
			break;
		default:
			break;
	}
}



@end
