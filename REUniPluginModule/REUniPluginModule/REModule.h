//
//  REModule.h
//  RETestUniPlugin
//
//  Created by Apple on 2023/11/23.
//

#import <Foundation/Foundation.h>
#import "DCUniModule.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^ REModuleCallback)(NSString *response);


@interface REModule : DCUniModule


// 类方法，用于发送消息并接收回调
+ (void)sendMessage:(NSString *)message completion:(REModuleCallback)completion;

@end

NS_ASSUME_NONNULL_END
