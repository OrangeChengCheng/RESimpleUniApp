//
//  REWebViewManager.m
//  RESimpleUniPlugin
//
//  Created by Apple on 2025/6/12.
//

#import "REWebViewManager.h"
#import "YYModel.h"

@interface REWebViewManager ()

@property (nonatomic, strong) WKWebViewConfiguration *config;
@property (nonatomic, strong) WKUserContentController *userContentController;
@property (nonatomic, strong) UIView *overlayView;
@property (nonatomic, strong) id initData;

@property (nonatomic, assign) CGRect originalRect;     // 原始位置和尺寸
@property (nonatomic, assign) CGRect fullScreenRect;   // 全屏位置和尺寸
@property (nonatomic, assign) BOOL isFullScreen;       // 是否全屏


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


#pragma mark - 初始化
- (void)setupWebView {
	// 创建 WebView 配置
	_userContentController = [[WKUserContentController alloc] init];
	[_userContentController addScriptMessageHandler:self name:@"REMobileApp"];
	
	_config = [[WKWebViewConfiguration alloc] init];
	_config.userContentController = _userContentController;
	if (@available(iOS 14.0, *)) {
		_config.defaultWebpagePreferences.allowsContentJavaScript = YES;
	} else {
		// Fallback on earlier versions
	}
	
	// 创建 WebView
	_webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:_config];
	_webView.UIDelegate = self;
	_webView.navigationDelegate = self;
//	_webView.backgroundColor = [UIColor whiteColor];
	_webView.backgroundColor = [UIColor clearColor];
	_webView.opaque = NO;
	
	// 创建容器视图
	_containerView = [[UIView alloc] init];
	_containerView.backgroundColor = [UIColor whiteColor];
//	_containerView.backgroundColor = [UIColor clearColor];
	[_containerView addSubview:_webView];
	

}



#pragma mark - 加载数据
- (void)loadUrl:(NSString *)url {
	[self loadUrl:url withParams:nil];
}

- (void)loadUrl:(NSString *)url withParams:(NSDictionary *)params {
	if (!url) return;
	
	NSString *fullUrl = url;
	if (params && params.count > 0) {
		fullUrl = [self appendParams:url params:params];
	}
	NSLog(@"完整的webview url: %@", fullUrl);
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:fullUrl]];
	[_webView loadRequest:request];
}

- (NSString *)appendParams:(NSString *)url params:(NSDictionary *)params {
	if (!params || params.count == 0) return url;
	
	NSMutableString *result = [NSMutableString stringWithString:url];
	BOOL hasQuery = [url containsString:@"?"];
	
	if (!hasQuery) {
		[result appendString:@"?"];
	} else if (![url hasSuffix:@"?"] && ![url hasSuffix:@"&"]) {
		[result appendString:@"&"];
	}
	
	[params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
		NSString *value = [obj isKindOfClass:[NSString class]] ? obj : [obj description];
		[result appendFormat:@"%@=%@&", key, [self urlEncode:value]];
	}];
	
	if ([result hasSuffix:@"&"]) {
		[result deleteCharactersInRange:NSMakeRange(result.length - 1, 1)];
	}
	
	return result;
}

- (NSString *)urlEncode:(NSString *)string {
	return [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}




#pragma mark - 显示WebView（核心调整：使用约束适配父容器）
- (void)showInView:(UIView *)parentView
		withHeight:(CGFloat)height {
	CGFloat screenHeight = parentView.bounds.size.height;
	CGRect rect = CGRectMake(0, screenHeight - height, parentView.bounds.size.width, height);
	[self showInView:parentView withRect:rect fromBottom:YES animated:YES];
}

// 核心调整：使用 CGRect 管理布局
- (void)showInView:(UIView *)parentView
		   withRect:(CGRect)rect
		fromBottom:(BOOL)fromBottom
		  animated:(BOOL)animated {
	if (_isShowing || !parentView) return;
	
	// 处理宽度：0 或未传则使用屏幕宽度
	if (rect.size.width <= 0) {
		rect.size.width = parentView.bounds.size.width;
	}
	
	// 处理高度：0 或未传则使用默认高度（屏幕的 50%）
	if (rect.size.height <= 0) {
		rect.size.height = parentView.bounds.size.height * 0.5;
	}
	
	// 保存原始布局和全屏布局
	_originalRect = rect;
	_fullScreenRect = CGRectMake(0, 0, parentView.bounds.size.width, parentView.bounds.size.height);
	
	// 设置容器和 WebView 的初始 frame
	if (fromBottom && animated) {
		// 从底部滑入的初始位置
		CGRect startRect = rect;
		startRect.origin.y = parentView.bounds.size.height;
		_containerView.frame = startRect;
	} else {
		_containerView.frame = rect;
	}
	
	_webView.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
	
	[parentView addSubview:_containerView];
	_isShowing = YES;
	
	// 动画显示
	if (animated) {
		[UIView animateWithDuration:0.5 animations:^{
			self->_containerView.frame = rect;
		}];
	} else {
		_containerView.frame = rect;
	}
}

#pragma mark - 隐藏WebView
- (void)hideAnimated:(BOOL)animated {
	if (!_isShowing) return;
	
	if (animated) {
		// 底部滑出动画
		CGRect endRect = _containerView.frame;
		endRect.origin.y = _containerView.superview.bounds.size.height;
		
		[UIView animateWithDuration:0.3 animations:^{
			self->_containerView.frame = endRect;
		} completion:^(BOOL finished) {
			[self->_containerView removeFromSuperview];
			self->_isShowing = NO;
		}];
	} else {
		[_containerView removeFromSuperview];
		_isShowing = NO;
	}
}



#pragma mark - 全屏切换
// 核心调整：使用 CGRect 实现全屏切换
- (void)toggleFullScreen:(BOOL)isFullScreen animated:(BOOL)animated {
	if (!_isShowing || !_containerView) return;
	
	_isFullScreen = isFullScreen;
	CGRect targetRect = isFullScreen ? _fullScreenRect : _originalRect;
	
	if (animated) {
		[UIView animateWithDuration:0.5 animations:^{
			self->_containerView.frame = targetRect;
			if (isFullScreen) {
				// webview改变要比正常的view快，比较特殊，缩小不让其改变了，不然webview先改变，会闪背景
				self->_webView.frame = CGRectMake(0, 0, targetRect.size.width, targetRect.size.height);
			}
		} completion:^(BOOL finished) {
			
		}];
	} else {
		_containerView.frame = targetRect;
	}
}




#pragma mark - 消息处理
- (void)sendMessage:(NSString *)message {
	if (!_webView || !message) return;
	
	NSString *escapedMessage = [message stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
	NSString *script = [NSString stringWithFormat:@"window.REWebApp.onAppToWebMessage(\"%@\")", escapedMessage];
	
	[_webView evaluateJavaScript:script completionHandler:nil];
}

- (void)sendObjectToJs:(id)object type:(NSString *)type {
	if (!object) return;
	
	NSDictionary *result = @{
		@"type": type,
		@"data": object
	};
	
	NSString *jsonString = [result yy_modelToJSONString];
	
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
//	if (_initData) {
//		[self sendObject:_initData];
//		_initData = nil;
//	}
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
	if (_delegate && [_delegate respondsToSelector:@selector(webViewManager:didFinishLoading:)]) {
		[_delegate webViewManager:self didFinishLoading:NO];
	}
}




#pragma mark - 销毁方法
- (void)destroy {
	[_webView stopLoading];
	[_webView removeFromSuperview];
	_webView = nil;
	[_containerView removeFromSuperview];
	_containerView = nil;
	_isShowing = NO;
	// 移除JS交互监听（避免循环引用）
	[_webView.configuration.userContentController removeScriptMessageHandlerForName:@"REMobileApp"];
}


@end
