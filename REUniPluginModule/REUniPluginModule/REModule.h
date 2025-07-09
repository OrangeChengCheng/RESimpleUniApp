//
//  REModule.h
//  RETestUniPlugin
//
//  Created by Apple on 2023/11/23.
//

#import <Foundation/Foundation.h>
#import "DCUniModule.h"

typedef enum :int {
	REModuleMsg_T1 = 1,
	REModuleMsg_T2 = 2,
	REModule_CheckboxCallback = 3,// checkbox点击
	REModule_GetCamLoc = 4,// 获取相机信息
} REModuleMsgType;

NS_ASSUME_NONNULL_BEGIN

typedef void (^ REModuleCallback)(NSDictionary *options);


@interface REModule : DCUniModule


// 类方法，用于发送消息并接收回调
+ (void)sendMsgAppToUni:(REModuleMsgType)type message:(id)message;

// 类方法，用于注册接受uniapp消息
+ (void)registerUniToAppMsg:(REModuleCallback)callback;


@end

NS_ASSUME_NONNULL_END
