//
//  RERequest.m
//  REUniPluginModule
//
//  Created by Apple on 2025/12/10.
//

#import "RERequest.h"


@implementation RERequest



#pragma mark - 核心请求方法（包含拦截器逻辑）
+ (void)requestWithUrl:(NSString *)url
				method:(NSString *)method
				headers:(NSArray *)headers
				params:(NSDictionary *)params
				finish:(RERequestCallback)finish {
	
	// 创建请求（请求拦截器逻辑）
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
	request.HTTPMethod = method;
	request.timeoutInterval = 30; // 30秒超时
	
	// 设置请求头
	if (headers.count) {
		for (NSDictionary *header in headers) {
			[request setValue:header[@"value"] forHTTPHeaderField:header[@"key"]];
		}
	}
	
	// 处理POST参数
	if ([method isEqualToString:@"POST"] && params) {
		NSError *jsonError;
		NSData *postData = [NSJSONSerialization dataWithJSONObject:params
														   options:0
															 error:&jsonError];
		if (jsonError) {
			
			if (finish) {
				finish(@{@"status":@(444), @"response":@{}});
			}
			return;
		}
		request.HTTPBody = postData;
	}
	
	// 发起请求
	NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
																 completionHandler:^(NSData * _Nullable data,
																					 NSURLResponse * _Nullable response,
																					 NSError * _Nullable error) {
		dispatch_async(dispatch_get_main_queue(), ^{
			NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
			
			// 处理成功响应：解析为字典
			if (data.length > 0) {
				NSError *jsonError;
				NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data
																			 options:NSJSONReadingMutableContainers
																			   error:&jsonError];
				
				if (jsonError) {
					// 解析失败时的处理
					if (finish) {
						finish(@{@"appStatus":@(statusCode), @"appResponse":@{}});
					}
					return;
				}
				
				if (finish) {
					finish(@{@"appStatus":@(statusCode), @"appResponse":responseDict});
				}
			} else {
				// 空数据时返回空字典
				if (finish) {
					finish(@{@"appStatus":@(statusCode), @"appResponse":@{}});
				}
			}
			
			
		});
	}];
	[task resume];
}



@end


