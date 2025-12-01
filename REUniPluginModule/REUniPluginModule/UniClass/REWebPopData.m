//
//  REWebPopData.m
//  REUniPluginModule
//
//  Created by Apple on 2025/11/20.
//

#import "REWebPopData.h"
#import "REWebViewManager.h"

@implementation REWebPopData

- (instancetype)init {
	self = [super init];
	if (self) {
		_webPopManager = nil; _webPopId = REEmptyStr; _webPopUrl = REEmptyStr;
		_webPopShow = NO; _webPopHeight = 400;
		_webPopParams = @{};
	}
	return self;
}


+ (REWebPopData *)initWithWebPopManager:(REWebViewManager *)webPopManager
							 webPopId:(NSString *)webPopId
							webPopUrl:(NSString *)webPopUrl
						  webPopParams:(NSDictionary *)webPopParams
						 webPopHeight:(CGFloat)webPopHeight {
	REWebPopData *webPopData = [[REWebPopData alloc] init];
	webPopData.webPopManager = webPopManager;
	webPopData.webPopId = webPopId;
	webPopData.webPopUrl = webPopUrl;
	webPopData.webPopParams = webPopParams;
	webPopData.webPopHeight = webPopHeight;
	webPopData.webPopShow = NO;
	return webPopData;
}


@end
