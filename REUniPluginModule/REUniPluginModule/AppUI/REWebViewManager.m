//
//  REWebViewManager.m
//  RESimpleUniPlugin
//
//  Created by Apple on 2025/6/12.
//

#import "REWebViewManager.h"
#import "Masonry.h"
#import "YYModel.h"

@interface REWebViewManager ()

@property (nonatomic, strong) WKWebViewConfiguration *config;
@property (nonatomic, strong) WKUserContentController *userContentController;
@property (nonatomic, strong) UIView *overlayView;
@property (nonatomic, strong) id initData;

@end

@implementation REWebViewManager

- (instancetype)initWithDelegate:(id<REWebViewManagerDelegate>)delegate {
	self = [super init];
	if (self) {
		_delegate = delegate;
		_isShowing = NO;
		
		[self setupWebView];
	}
	return self;
}

- (void)setupWebView {
	// 创建 WebView 配置
	_userContentController = [[WKUserContentController alloc] init];
	[_userContentController addScriptMessageHandler:self name:@"REMobileApp"];
	
	_config = [[WKWebViewConfiguration alloc] init];
	_config.userContentController = _userContentController;
	_config.defaultWebpagePreferences.allowsContentJavaScript = YES;
	
	// 创建 WebView
	_webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:_config];
	_webView.UIDelegate = self;
	_webView.navigationDelegate = self;
	_webView.backgroundColor = [UIColor whiteColor];
//	_webView.backgroundColor = [UIColor clearColor];
//	_webView.opaque = NO;
	
	// 创建容器视图
	_containerView = [[UIView alloc] init];
	_containerView.backgroundColor = [UIColor whiteColor];
//	_containerView.backgroundColor = [UIColor clearColor];
	[_containerView addSubview:_webView];
	
	// 添加约束
	[_webView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(_containerView);
	}];
}

- (void)loadUrl:(NSString *)url {
	[self loadUrl:url withParams:nil];
}

- (void)loadUrl:(NSString *)url withParams:(NSDictionary *)params {
	if (!url) return;
	
	NSString *fullUrl = url;
	if (params && params.count > 0) {
		fullUrl = [self appendParams:url params:params];
	}
	
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:fullUrl]];
	[_webView loadRequest:request];
}

- (NSString *)appendParams:(NSString *)url params:(NSDictionary *)params {
	if (!params || params.count == 0) return url;
	
	NSMutableString *result = [NSMutableString stringWithString:url];
	
	// 添加查询参数
	if (![url containsString:@"?"]) {
		[result appendString:@"?"];
	} else if (![url hasSuffix:@"?"] && ![url hasSuffix:@"&"]) {
		[result appendString:@"&"];
	}
	
	[params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
		NSString *value = [obj isKindOfClass:[NSString class]] ? obj : [obj description];
		[result appendFormat:@"%@=%@&", key, [self urlEncode:value]];
	}];
	
	// 移除最后的 &
	if ([result hasSuffix:@"&"]) {
		[result deleteCharactersInRange:NSMakeRange(result.length - 1, 1)];
	}
	
	return result;
}

- (NSString *)urlEncode:(NSString *)string {
	return [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (void)showInView:(UIView *)parentView
		   withRect:(CGRect)rect
		fromBottom:(BOOL)fromBottom
		  animated:(BOOL)animated {
	if (_isShowing || !parentView) return;
	
	_containerView.frame = rect;
	
	// 初始位置（如果从底部滑入）
	if (fromBottom && animated) {
		CGRect startRect = rect;
		startRect.origin.y = parentView.bounds.size.height;
		_containerView.frame = startRect;
	}
	
	[parentView addSubview:_containerView];
	
	_isShowing = YES;
	
	// 动画显示
	if (animated) {
		[UIView animateWithDuration:0.3 animations:^{
			_containerView.frame = rect;
		}];
	}
}

- (void)hideAnimated:(BOOL)animated {
	if (!_isShowing) return;
	
	if (animated) {
		CGRect endRect = _containerView.frame;
		endRect.origin.y = _containerView.superview.bounds.size.height;
		
		[UIView animateWithDuration:0.3 animations:^{
			_containerView.frame = endRect;
		} completion:^(BOOL finished) {
			[_containerView removeFromSuperview];
			_isShowing = NO;
		}];
	} else {
		[_containerView removeFromSuperview];
		_isShowing = NO;
	}
}





- (void)sendMessage:(NSString *)message {
	if (!_webView || !message) return;
	
	NSString *escapedMessage = [message stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
	NSString *script = [NSString stringWithFormat:@"window.REWebApp.onAppToWebMessage(\"%@\")", escapedMessage];
	
	[_webView evaluateJavaScript:script completionHandler:nil];
}

- (void)sendObject:(id)object {
	if (!object) return;
	
	NSString *jsonString = [object yy_modelToJSONString];
	
//	NSString *jsonString = [REJSONSerializer jsonStringFromObject:object];
	if (jsonString) {
		[self sendMessage:jsonString];
	}
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController
	  didReceiveScriptMessage:(WKScriptMessage *)message {
	if ([message.name isEqualToString:@"REMobileApp"]) {
		
		NSDictionary *result = @{};
		// 1. 将 NSString 转为 NSData
		NSData *jsonData = [message.body dataUsingEncoding:NSUTF8StringEncoding];
		if (jsonData == nil) {
			NSLog(@"消息字符串转 NSData 失败");
		} else {
			// 2. 使用 NSJSONSerialization 解析为 NSDictionary
			NSError *error;
			result = [NSJSONSerialization JSONObjectWithData:jsonData
													 options:0
													   error:&error];
		}
		NSLog(@"收到来自 WebView 的消息: %@", message.body);
		if (_delegate && [_delegate respondsToSelector:@selector(webViewManager:didReceiveResult:)]) {
			[_delegate webViewManager:self didReceiveResult:result];
		}
	}
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
	if (_delegate && [_delegate respondsToSelector:@selector(webViewManager:didFinishLoading:)]) {
		[_delegate webViewManager:self didFinishLoading:YES];
	}
	
	// 页面加载完成后发送初始化数据
	if (_initData) {
		[self sendObject:_initData];
		_initData = nil;
	}
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
	if (_delegate && [_delegate respondsToSelector:@selector(webViewManager:didFinishLoading:)]) {
		[_delegate webViewManager:self didFinishLoading:NO];
	}
}



@end
