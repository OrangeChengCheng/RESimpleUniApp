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
	
	// 可以在该方法中实现原生能力，然后通过 callback 回调到 js
	
	NSArray *dataSetList = [NSArray yy_modelArrayWithClass:REDataSetInfo.class json:options[@"dataSetList"]];
	NSArray *entityList = [NSArray yy_modelArrayWithClass:REEntityUniData.class json:options[@"entityList"]];
	NSArray *waterList = [NSArray yy_modelArrayWithClass:REWaterUniData.class json:options[@"waterList"]];
	NSArray *extrudeList = [NSArray yy_modelArrayWithClass:REExtrudeUniData.class json:options[@"extrudeList"]];
	id maxInstDrawFaceNum = [options objectForKey:@"maxInstDrawFaceNum"];
	id shareUrl = [options objectForKey:@"shareUrl"];
	id projName = [options objectForKey:@"projName"];
	id worldCRS = [options objectForKey:@"worldCRS"];
	id shareType = [options objectForKey:@"shareType"];
	id camDefaultDataSetId = [options objectForKey:@"camDefaultDataSetId"];
	id shareViewMode = [options objectForKey:@"shareViewMode"];
	id shareDataType = [options objectForKey:@"shareDataType"];
	id defaultCamLoc = [options objectForKey:@"defaultCamLoc"];
	
	REEngineVC *engineVC = [[REEngineVC alloc] init];
	engineVC.dataSetList = dataSetList;
	engineVC.entityList = entityList;
	engineVC.waterList = waterList;
	engineVC.extrudeList = extrudeList;
	engineVC.maxInstDrawFaceNum = maxInstDrawFaceNum ?  [options[@"maxInstDrawFaceNum"] intValue] : 1500000;
	engineVC.shareUrl = shareUrl ? [options[@"shareUrl"] stringValue] : @"";
	engineVC.projName = projName ? [options[@"projName"] stringValue] : @"";
	engineVC.worldCRS = worldCRS ? [options[@"worldCRS"] stringValue] : @"";
	engineVC.shareType = shareType ?  [options[@"shareType"] intValue] : 0;
	engineVC.camDefaultDataSetId = camDefaultDataSetId ? [options[@"camDefaultDataSetId"] stringValue] : @"";
	engineVC.shareViewMode = shareViewMode ? [options[@"shareViewMode"] stringValue] : @"";
	engineVC.shareDataType = shareDataType ? [options[@"shareDataType"] stringValue] : @"";
	if (defaultCamLoc && ![defaultCamLoc isKindOfClass:[NSNull class]] && [(NSDictionary *)defaultCamLoc allKeys].count > 0) {
		REForceCamLoc *forceCamLoc = [REForceCamLoc yy_modelWithDictionary:options[@"defaultCamLoc"]];
		forceCamLoc.force = YES;
		engineVC.defaultCamLoc = forceCamLoc;
	}
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
