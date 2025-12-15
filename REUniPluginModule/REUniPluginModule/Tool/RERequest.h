//
//  RERequest.h
//  REUniPluginModule
//
//  Created by Apple on 2025/12/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ RERequestCallback)(id respone);

@interface RERequest : NSObject


+ (void)requestWithUrl:(NSString *)url
				method:(NSString *)method
				headers:(NSArray *)headers
				params:(NSDictionary *)params
				finish:(RERequestCallback)finish;




@end

NS_ASSUME_NONNULL_END
