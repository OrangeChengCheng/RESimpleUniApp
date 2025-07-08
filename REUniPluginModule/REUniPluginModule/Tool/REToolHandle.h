//
//  REToolHandle.h
//  REUniPluginModule
//
//  Created by Apple on 2025/7/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface REToolHandle : NSObject

+ (void)handleEngineSDK:(NSDictionary *)jsonObject msgWhere:(int)msgWhere;

@end

NS_ASSUME_NONNULL_END
