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


@property (nonatomic, weak) UIView *parentView; // 父视图（保存）
@property (nonatomic, assign) CGFloat marginBottom; // 底部边距
@property (nonatomic, assign) CGFloat originalWidth; // 原始宽度
@property (nonatomic, assign) CGFloat originalHeight; // 原始高度
@property (nonatomic, assign) CGFloat fullHeight; // 全屏高度
//@property (nonatomic, assign) BOOL isFullScreen; // 是否全屏


@property (nonatomic, strong) UIView *overlayView;
@property (nonatomic, strong) id initData;

@property (nonatomic, assign) CGRect originalRect;     // 原始位置和尺寸
@property (nonatomic, assign) CGRect fullScreenRect;   // 全屏位置和尺寸
@property (nonatomic, assign) BOOL isFullScreen;       // 是否全屏


@end

@implementation REWebViewManager

+ (REWebViewManager *)initWithDelegate:(id<REWebViewManagerDelegate>)delegate
							parentView:(UIView *)parentView
								height:(int)height
							webViewUrl:(NSString *)webViewUrl
						 webViewParams:(NSDictionary *)webViewParams {
	
	REWebViewManager *webViewManager = [[REWebViewManager alloc] initWithDelegate:delegate];
	webViewManager.webViewUrl = webViewUrl;
	webViewManager.webViewParams = webViewParams;
	webViewManager.parentView = parentView;
	
	// 初始化时就设置样式（先配置样式，再加载URL）
	[webViewManager setWebviewStyleWithWidth:CGRectGetWidth(parentView.bounds) height:height marginBottom:0];
	// 加载URL（仅首次初始化时加载）
	if (webViewManager.webViewUrl.length > 0 && !webViewManager.isUrlLoaded) {
		[webViewManager loadUrl:webViewManager.webViewUrl withParams:webViewManager.webViewParams];
	}
	return webViewManager;
}

- (instancetype)initWithDelegate:(id<REWebViewManagerDelegate>)delegate {
	self = [super init];
	if (self) {
		_delegate = delegate;
		_isShowing = NO;
		_isUrlLoaded = NO;
		_isFullScreen = NO;
		
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
//	_containerView.backgroundColor = [UIColor whiteColor];
	_containerView.backgroundColor = [UIColor clearColor];
	_containerView.hidden = YES; // 核心：静默加载时隐藏
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
	_isUrlLoaded = NO;
	NSLog(@"\n");
	NSLog(@"【完整的webview】--> url: %@", fullUrl);
	NSLog(@"\n");
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




#pragma mark - 核心：设置WebView样式（对应安卓setWebviewStyle）
- (void)setWebviewStyleWithWidth:(CGFloat)width
						  height:(CGFloat)height
					 marginBottom:(CGFloat)marginBottom {
	// 1. 获取屏幕尺寸（适配iOS安全区，对应安卓的realScreenHeight）
	CGRect screenBounds = [UIScreen mainScreen].bounds;
	CGFloat screenWidth = screenBounds.size.width;
	CGFloat screenHeight = screenBounds.size.height;
	
	// 适配底部安全区（对应安卓的底部导航栏）
	UIEdgeInsets safeAreaInsets = UIEdgeInsetsZero;
	if (@available(iOS 11.0, *)) {
		safeAreaInsets = [UIApplication sharedApplication].keyWindow.safeAreaInsets;
	}
	CGFloat customNavHeight = 44.0; // 对应安卓的customNavHeight
	_fullHeight = screenHeight - safeAreaInsets.top - customNavHeight; // 全屏高度（去掉顶部导航栏）
	
	// 2. 处理宽度（0则使用屏幕宽度）
	_originalWidth = (width <= 0) ? screenWidth : width;
	
	// 3. 处理高度（0则使用全屏高度的50%，限制不超过可用高度）
	CGFloat maxAvailableHeight = _fullHeight - marginBottom;
	if (height <= 0) {
		_originalHeight = _fullHeight * 0.5;
	} else {
		_originalHeight = height;
	}
	// 限制高度不超过可用高度
	if (_originalHeight > maxAvailableHeight) {
		_originalHeight = maxAvailableHeight;
	}
	
	// 4. 保存底部边距
	_marginBottom = marginBottom;
	
	[self setWebViewLayoutWithParentView:_parentView];
}



#pragma mark - 核心：应用布局（对应安卓setWebViewLayout）
- (void)setWebViewLayoutWithParentView:(UIView *)parentView {
	if (!parentView) return;
	_parentView = parentView;
	
	// 1. 移除旧容器（避免重复添加）
	[_containerView removeFromSuperview];
	
	// 2. 计算容器frame（底部对齐+水平居中+底部边距，对应安卓的布局逻辑）
	CGFloat containerX = (parentView.bounds.size.width - _originalWidth) / 2.0; // 水平居中
	CGFloat containerY = parentView.bounds.size.height - _originalHeight - _marginBottom; // 底部边距
	CGRect containerFrame = CGRectMake(containerX, containerY, _originalWidth, _originalHeight);
	
	// 3. 设置容器和WebView的frame
	_containerView.frame = containerFrame;
	_webView.frame = _containerView.bounds; // WebView填充满容器
	
	// 4. 添加容器到父视图（保持隐藏状态，等待showWebPop）
	[parentView addSubview:_containerView];
}

#pragma mark - 显示/隐藏（仅切换可见性，对应安卓showWebPop/hiddenWebPop）
- (void)showWebPop {
	// 主线程执行（对应安卓的mMainHandler.post）
	dispatch_async(dispatch_get_main_queue(), ^{
		if (self.containerView && !self.isShowing) {
			self.containerView.hidden = NO;
			self.isShowing = YES;
			NSLog(@"[REWebView] 显示Web弹窗");
		}
	});
}

- (void)hiddenWebPop {
	dispatch_async(dispatch_get_main_queue(), ^{
		if (self.containerView && self.isShowing) {
			self.containerView.hidden = YES;
			self.isShowing = NO;
			NSLog(@"[REWebView] 隐藏Web弹窗");
		}
	});
}

#pragma mark - 全屏切换（对应安卓setFullScreen/toggleFullScreen）
- (void)setFullScreen:(BOOL)isFull {
	if (_isFullScreen == isFull || !_parentView) return;
	
	_isFullScreen = isFull;
	dispatch_async(dispatch_get_main_queue(), ^{
		CGRect targetFrame;
		if (isFull) {
			// 全屏：宽度=父视图宽度，高度=全屏高度，底部边距=0，Y=顶部安全区
			targetFrame = CGRectMake(0,
									[UIApplication sharedApplication].keyWindow.safeAreaInsets.top,
									self.parentView.bounds.size.width,
									self.fullHeight);
		} else {
			// 恢复原始尺寸：水平居中，底部边距，原始宽高
			targetFrame = CGRectMake((self.parentView.bounds.size.width - self.originalWidth)/2.0,
									self.parentView.bounds.size.height - self.originalHeight - self.marginBottom,
									self.originalWidth,
									self.originalHeight);
		}
		
		// 动画切换（对应安卓的requestLayout）
		[UIView animateWithDuration:0.3 animations:^{
			self.containerView.frame = targetFrame;
			self.webView.frame = self.containerView.bounds; // WebView填充满容器
		} completion:^(BOOL finished) {
			NSLog(@"[REWebView] 全屏切换完成: %@", isFull ? @"全屏" : @"原始尺寸");
		}];
	});
}


- (void)toggleFullScreen {
	[self setFullScreen:!_isFullScreen];
}



//
//
//#pragma mark - 显示WebView（核心调整：使用约束适配父容器）
//- (void)showInView:(UIView *)parentView
//		withHeight:(CGFloat)height {
//	CGFloat screenHeight = parentView.bounds.size.height;
//	CGRect rect = CGRectMake(0, screenHeight - height, parentView.bounds.size.width, height);
//	[self showInView:parentView withRect:rect fromBottom:YES animated:YES];
//}
//
//// 核心调整：使用 CGRect 管理布局
//- (void)showInView:(UIView *)parentView
//		   withRect:(CGRect)rect
//		fromBottom:(BOOL)fromBottom
//		  animated:(BOOL)animated {
//	if (_isShowing || !parentView) return;
//	
//	// 处理宽度：0 或未传则使用屏幕宽度
//	if (rect.size.width <= 0) {
//		rect.size.width = parentView.bounds.size.width;
//	}
//	
//	// 处理高度：0 或未传则使用默认高度（屏幕的 50%）
//	if (rect.size.height <= 0) {
//		rect.size.height = parentView.bounds.size.height * 0.5;
//	}
//	
//	// 保存原始布局和全屏布局
//	_originalRect = rect;
//	_fullScreenRect = CGRectMake(0, 0, parentView.bounds.size.width, parentView.bounds.size.height);
//	
//	// 设置容器和 WebView 的初始 frame
//	if (fromBottom && animated) {
//		// 从底部滑入的初始位置
//		CGRect startRect = rect;
//		startRect.origin.y = parentView.bounds.size.height;
//		_containerView.frame = startRect;
//	} else {
//		_containerView.frame = rect;
//	}
//	
//	_webView.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
//	
//	[parentView addSubview:_containerView];
//	_isShowing = YES;
//	
//	// 动画显示
//	if (animated) {
//		[UIView animateWithDuration:0.5 animations:^{
//			self->_containerView.frame = rect;
//		}];
//	} else {
//		_containerView.frame = rect;
//	}
//}
//
//#pragma mark - 隐藏WebView
//- (void)hideAnimated:(BOOL)animated {
//	if (!_isShowing) return;
//	
//	if (animated) {
//		// 底部滑出动画
//		CGRect endRect = _containerView.frame;
//		endRect.origin.y = _containerView.superview.bounds.size.height;
//		
//		[UIView animateWithDuration:0.3 animations:^{
//			self->_containerView.frame = endRect;
//		} completion:^(BOOL finished) {
//			[self->_containerView removeFromSuperview];
//			self->_isShowing = NO;
//		}];
//	} else {
//		[_containerView removeFromSuperview];
//		_isShowing = NO;
//	}
//}


//
//#pragma mark - 全屏切换
//// 核心调整：使用 CGRect 实现全屏切换
//- (void)toggleFullScreen:(BOOL)isFullScreen animated:(BOOL)animated {
//	if (!_isShowing || !_containerView) return;
//	
//	_isFullScreen = isFullScreen;
//	CGRect targetRect = isFullScreen ? _fullScreenRect : _originalRect;
//	
//	if (animated) {
//		[UIView animateWithDuration:0.5 animations:^{
//			self->_containerView.frame = targetRect;
//			if (isFullScreen) {
//				// webview改变要比正常的view快，比较特殊，缩小不让其改变了，不然webview先改变，会闪背景
//				self->_webView.frame = CGRectMake(0, 0, targetRect.size.width, targetRect.size.height);
//			}
//		} completion:^(BOOL finished) {
//			
//		}];
//	} else {
//		_containerView.frame = targetRect;
//	}
//}
//



#pragma mark - 消息处理
//发送消息到 JavaScript
- (void)sendMsgAppToWebWithMessage:(NSString *)message {
	if (!_webView || !message) return;
	
	NSString *escapedMessage = [message stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
	NSString *script = [NSString stringWithFormat:@"window.REWebApp.onAppToWebMessage(\"%@\")", escapedMessage];
	
	[_webView evaluateJavaScript:script completionHandler:nil];
}

//发送对象到 JavaScript（自动序列化为 JSON）
- (void)sendObjAppToWebWithObject:(id)object type:(NSString *)type isResponse:(BOOL)isResponse msgId:(NSString *)msgId {
	if (!_webView) return;
	
	NSDictionary *result = @{
		@"type": type,
		@"data": object,
		@"isResponse": @(isResponse),
		@"msgId": msgId,
	};
	
	NSString *jsonString = [result yy_modelToJSONString];
	if (!jsonString) {
		NSLog(@"序列化失败");
		return;
	}
	
	NSString *safeJsonString = [self fixYYModelJSONEscape:jsonString];
	
	if (safeJsonString) {
		[self sendMsgAppToWebWithMessage:safeJsonString];
	}
}

//发送对象到 JavaScript（自动序列化为 JSON）
- (void)sendObjAppToWebWithObject:(id)object type:(NSString *)type {
	[self sendObjAppToWebWithObject:object type:type isResponse:NO msgId:@""];
}

//发送对象到 JavaScript（自动序列化为 JSON）
- (void)sendObjAppToWebWithObject:(id)object {
	[self sendObjAppToWebWithObject:object type:@"" isResponse:NO msgId:@""];
}

//发送对象到 JavaScript（自动序列化为 JSON）
- (void)sendObjAppToWebWithType:(NSString *)type {
	[self sendObjAppToWebWithObject:@{} type:type isResponse:NO msgId:@""];
}

//发送对象到 JavaScript（自动序列化为 JSON）【含有回调信息】
- (void)sendObjAppToWebCallbackWithObject:(id)object msgId:(NSString *)msgId {
	[self sendObjAppToWebWithObject:object type:@"" isResponse:YES msgId:msgId];
}


// 修复YYModel生成的JSON字符串中的转义符问题
- (NSString *)fixYYModelJSONEscape:(NSString *)jsonString {
	if (!jsonString) return @"";
	
	// 关键：将所有 \ 转为 \\（确保JS解析时识别为单个 \）
	NSString *fixed = [jsonString stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
	
	// 补充处理其他可能的特殊字符（可选，根据实际数据）
	fixed = [fixed stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
	fixed = [fixed stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];
	
	return fixed;
}

//- (void)sendObjectToJs:(id)object type:(NSString *)type {
//	if (!object) return;
//	
//	NSDictionary *result = @{
//		@"type": type,
//		@"data": object
//	};
//	
//	NSString *jsonString = [result yy_modelToJSONString];
//	
////	NSString *jsonString = [REJSONSerializer jsonStringFromObject:object];
//	if (jsonString) {
//		[self sendMessage:jsonString];
//	}
//}




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
	_isUrlLoaded = YES;
	if (_delegate && [_delegate respondsToSelector:@selector(webViewManager:didFinishLoading:)]) {
		[_delegate webViewManager:self didFinishLoading:YES];
	}
	
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
	_isUrlLoaded = NO;
	if (_delegate && [_delegate respondsToSelector:@selector(webViewManager:didFinishLoading:)]) {
		[_delegate webViewManager:self didFinishLoading:NO];
	}
}




#pragma mark - 销毁方法
- (void)destroy {
	dispatch_async(dispatch_get_main_queue(), ^{
		[self.webView stopLoading];
		// 移除JS交互监听（避免循环引用）
		[self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"REMobileApp"];
		
		[self.webView removeFromSuperview];
		self.webView = nil;
		
		[self.containerView removeFromSuperview];
		self.containerView = nil;
		
		self.isShowing = NO;
		self.isFullScreen = NO;
	});
}


@end
