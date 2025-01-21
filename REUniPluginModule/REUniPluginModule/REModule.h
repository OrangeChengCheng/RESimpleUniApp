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
} REModuleMsgType;

NS_ASSUME_NONNULL_BEGIN

typedef void (^ REModuleCallback)(NSString *response);


@interface REModule : DCUniModule


// 类方法，用于发送消息并接收回调
+ (void)sendMessage:(REModuleMsgType)type message:(id)message completion:(REModuleCallback)completion;


@end

NS_ASSUME_NONNULL_END
