//
//  REWebPopData.h
//  REUniPluginModule
//
//  Created by Apple on 2025/11/20.
//

#import <Foundation/Foundation.h>

@class REWebViewManager;

NS_ASSUME_NONNULL_BEGIN

@interface REWebPopData : NSObject

@property (nonatomic, strong) REWebViewManager *webPopManager;
@property (nonatomic, copy) NSString *webPopId;
@property (nonatomic, assign) BOOL webPopShow;
@property (nonatomic, copy) NSString *webPopUrl;
@property (nonatomic, assign) int webPopHeight;
@property (nonatomic, strong) NSDictionary *webPopParams;


+ (REWebPopData *)initWithWebPopId:(NSString *)webPopId
							webPopUrl:(NSString *)webPopUrl
						  webPopParams:(NSDictionary *)webPopParams
						 webPopHeight:(CGFloat)webPopHeight;


@end

NS_ASSUME_NONNULL_END
