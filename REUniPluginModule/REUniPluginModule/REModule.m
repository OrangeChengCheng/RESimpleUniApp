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


#pragma mark - 注册UniToApp消息

// 类方法，用于注册接受uniapp消息
+ (void)registerUniToAppMsg:(REModuleCallback)callback {
	uniToAppCallBack = callback;
}


#pragma mark - 加载引擎

// 通过宏 UNI_EXPORT_METHOD 将异步方法暴露给 js 端
UNI_EXPORT_METHOD(@selector(realEngineRender:callback:))

/// 异步方法（注：异步方法会在主线程（UI线程）执行）
/// @param options js 端调用方法时传递的参数
/// @param callback 回调方法，回传参数给 js 端
- (void)realEngineRender:(NSDictionary *)options callback:(UniModuleKeepAliveCallback)callback {
	// options 为 js 端调用此方法时传递的参数
	NSLog(@"************* 【uni -> app】 : (realEngineRender)  %@",options);
	
	RESceneUniData *sceneUniData = [RESceneUniData yy_modelWithDictionary:options];
	
	NSMutableArray *toolDataList = [NSMutableArray array];
	// 添加自定义按钮数据
//	{
//		REToolData *tool_tree = [REToolData initWithType:1 popViewHeight:360 toolBtnId:@"web_pop_tree" btnImg:@"https://realbim.bjblackhole.cn:7999/TestPages/pic/pics/cancelcut_nor.png" popWebUrl:@"https://demo.bjblackhole.com/WebProj/AppExpand/index.html#/tree"];
//		REToolData *tool_property = [REToolData initWithType:2 popViewHeight:360 toolBtnId:@"web_pop_property" btnImg:@"https://realbim.bjblackhole.cn:7999/TestPages/pic/pics/confirmcut_nor.png" popWebUrl:@"https://demo.bjblackhole.com/WebProj/AppExpand/index.html#/property"];
//		REToolData *tool_cad = [REToolDat/*a initWithType:3 popViewHeight:400 toolBtnId:@"retool_btn_cad" btnImg:@"https://realbim.bjblackhole.cn:7999/TestPages/pic/pics/ctrlmouse_nor.png" popWebUrl:@"http://192.168.31.164:8080/#/cad"];*/
//		[toolDataList addObject:tool_tree];
//		[toolDataList addObject:tool_property];
//		[toolDataList addObject:tool_cad];
//	}
	
	
	// 添加webPop数据
	NSMutableArray *webPopList = [NSMutableArray array];
	{
		NSDictionary *params = @{
			@"token":sceneUniData.token,
			@"baseUrl":sceneUniData.baseUrl,
			@"shareType":[NSString stringWithFormat:@"%d", sceneUniData.shareType],
			@"sceneId":sceneUniData.sceneId,
		};
		REWebPopData *webPopData_tree = [REWebPopData initWithWebPopManager:nil webPopId:@"web_pop_tree" webPopUrl:@"https://demo.bjblackhole.com/WebProj/AppExpand/index.html#/tree" webPopParams:params webPopHeight:300];
		REWebPopData *webPopData_property = [REWebPopData initWithWebPopManager:nil webPopId:@"web_pop_property" webPopUrl:@"https://demo.bjblackhole.com/WebProj/AppExpand/index.html#/property" webPopParams:params webPopHeight:300];
		
		[webPopList addObjectsFromArray:@[webPopData_tree, webPopData_property]];
	}
	
	
	REEngineVC *engineVC = [[REEngineVC alloc] init];
	engineVC.sceneUniData = sceneUniData;
	engineVC.toolDataList = toolDataList;
	engineVC.webPopList = webPopList;
	engineVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
	UIWindow *currWindow = [UIApplication sharedApplication].keyWindow;
	[currWindow.rootViewController presentViewController:engineVC animated:YES completion:nil];
	

	// 回调方法，传递参数给 js 端 注：只支持返回 String 或 NSDictionary (map) 类型
	if (callback) {
		// 第一个参数为回传给js端的数据，第二个参数为标识，表示该回调方法是否支持多次调用，如果原生端需要多次回调js端则第二个参数传 YES;
		callback(@"success",NO);
	}
}


#pragma mark - 打印消息

// 通过宏 UNI_EXPORT_METHOD 将异步方法暴露给 js 端
UNI_EXPORT_METHOD(@selector(unipluginLog:))

/// 异步方法（注：异步方法会在主线程（UI线程）执行）
/// @param options js 端调用方法时传递的参数
- (void)unipluginLog:(NSDictionary *)options {
	// options 为 js 端调用此方法时传递的参数
	NSLog(@"************* 【uni -> app】 : (unipluginLog)   %@", options);
}


#pragma mark - 注册AppToUni消息

// 通过宏 UNI_EXPORT_METHOD_SYNC 将同步方法暴露给 js 端
UNI_EXPORT_METHOD_SYNC(@selector(registerAppMsg:))
/// 同步方法（注：同步方法会在 js 线程执行）
/// @param callback 回调方法，回传参数给 js 端
- (void)registerAppMsg:(UniModuleKeepAliveCallback)callback {
	appToUniCallBack = callback;
}


#pragma mark - UniToApp消息

// 通过宏 UNI_EXPORT_METHOD_SYNC 将同步方法暴露给 js 端
UNI_EXPORT_METHOD_SYNC(@selector(sendMsgUniToApp:))
/// 同步方法（注：同步方法会在 js 线程执行）
/// @param options js 端调用方法时传递的参数   支持：String、Number、Boolean、JsonObject 类型
- (void)sendMsgUniToApp:(NSDictionary *)options {
	NSLog(@"************* 【uni -> app】 : (sendMsgUniToApp)   %@", options);
	if (uniToAppCallBack != nil) {
		uniToAppCallBack(options);
	}
}


#pragma mark - AppToUni消息

+ (void)sendMsgAppToUni:(REModuleMsgType)type message:(id)message {
	NSLog(@"************* 【app -> uni】 : (sendMsgAppToUni)  %@", message);
	switch (type) {
		case REModuleMsg_T1:
		{
			if (appToUniCallBack != nil) {
				appToUniCallBack(@{@"code":@"success"}, YES);
			}
		}
			break;
		case REModuleMsg_T2:
		{
			if (appToUniCallBack != nil) {
				NSString *msg = (NSString *)message;
				appToUniCallBack(@{@"code":@"error", @"msg":msg}, YES);
			}
		}
			break;
		default:
			break;
	}
}



@end
