

#import "REWebVC.h"
#import <WebKit/WebKit.h>
#import "PDRCore.h"


@interface REWebVC () <WKUIDelegate, WKNavigationDelegate, PDRCoreDelegate, WKScriptMessageHandler>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIActivityIndicatorView *loadingIndicator;
@end

@implementation REWebVC

- (void)viewDidLoad {
	[super viewDidLoad];
	
//	// 1. 初始化 H5+ 引擎（必须！确保 uni-app 原生功能可用）
//	[PDRCore initEngineWihtOptions:nil
//					   withRunMode:PDRCoreRunModeNormal
//					  withDelegate:self];
//	
//	// 2. 配置 WKWebView
//	WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
//	config.defaultWebpagePreferences.allowsContentJavaScript = YES;
//	
//	// 3. 创建 WebView 并设置代理
//	self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
//	self.webView.UIDelegate = self;
//	self.webView.navigationDelegate = self;
//	[self.view addSubview:self.webView];
//	
//	// 4. 添加加载指示器
//	self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
//	self.loadingIndicator.center = self.view.center;
//	[self.view addSubview:self.loadingIndicator];
//	[self.loadingIndicator startAnimating];
//	
//	// 5. 加载 uni-app 主页面
//	NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"__uniappview"
//														 ofType:@"html"
//													inDirectory:@"Pandora/apps/__UNI__C5A81A5/www"];
//	
//	if (htmlPath) {
//		NSURL *fileURL = [NSURL fileURLWithPath:htmlPath];
//		NSURL *baseURL = [fileURL URLByDeletingLastPathComponent]; // baseURL 设为 www 目录
//		
//		// 关键：允许 WebView 访问 www 目录下的所有资源
//		[self.webView loadFileURL:fileURL allowingReadAccessToURL:baseURL];
//	} else {
//		NSLog(@"错误：找不到 __uniappview.html 文件");
//		[self.loadingIndicator stopAnimating];
//	}
//	
//	// 配置监听前端 console.log 消息
//		WKUserContentController *userContentController = self.webView.configuration.userContentController;
//		[userContentController addScriptMessageHandler:self name:@"consoleLog"];
//		
//		// 注入脚本，将前端 console.log 转发到原生
//		NSString *js = @"console.log = function(msg) { window.webkit.messageHandlers.consoleLog.postMessage(msg); }";
//		WKUserScript *script = [[WKUserScript alloc] initWithSource:js injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
//		[userContentController addUserScript:script];
	
	
	// 1. 设置应用路径
//	   [[PDRCore Instance] setAppsInstallPath:@"Pandora/apps"];
//	   [[PDRCore Instance] setAppsRunPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"Pandora/apps"]];
//	   
//	   // 2. 初始化引擎
//	   BOOL initSuccess = [PDRCore initEngineWihtOptions:nil
//											 withRunMode:PDRCoreRunModeNormal
//											withDelegate:self];
//	   NSLog(@"引擎初始化结果: %@", initSuccess ? @"成功" : @"失败");
//	   
//	   // 3. 设置自动启动的应用
//	   [[PDRCore Instance] setAutoStartAppid:@"__UNI__C5A81A5"];
//	   
//	   // 4. 启动主应用
//	   [PDRCore startMainApp];
//	// 5. 延迟检查 RootViewController
//	   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//		   H5CoreRootViewController *rootVC = [[PDRCore Instance] rootViewController];
//		   
//		   if (rootVC) {
//			   NSLog(@"RootViewController 初始化成功");
//			   [self addChildViewController:rootVC];
//			   [self.view addSubview:((UIViewController *)rootVC).view];
//			   [(UIViewController *)rootVC didMoveToParentViewController:self];
//		   } else {
//			   NSLog(@"❌ RootViewController 仍为 nil");
//			   [self loadWebViewManually]; // 备选方案
//		   }
//	   });
//	
//	
//	// 检查引擎状态
//	NSLog(@"PDRCore 实例: %@", [PDRCore Instance]);
//	NSLog(@"AppManager: %@", [[PDRCore Instance] appManager]);
//	NSLog(@"RootViewController: %@", [[PDRCore Instance] rootViewController]);
//
//	// 检查资源路径
//	NSString *appsPath = [[PDRCore Instance] mainBundlePath];
//	NSLog(@"Pandora 路径: %@", appsPath);
//	NSArray *apps = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:appsPath error:nil];
//	NSLog(@"Pandora 目录内容: %@", apps);
//	
//	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//		NSLog(@"启动图是否已关闭: %d", [[PDRCore Instance] isSplashPageClosed]);
//	});
	
	[self loadWebViewManually];
}

// 备选方案：手动加载 WebView
- (void)loadWebViewManually {
	// 1. 配置 WebView
		WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
		config.defaultWebpagePreferences.allowsContentJavaScript = YES;
		
	// 2. 允许文件访问（严格匹配你的头文件）
//		if (@available(iOS 11.0, *)) {
//			NSString *rule = @"{\"trigger\": {\"url-filter\": \".*\",\"resource-type\": [\"script\",\"style-sheet\",\"image\",\"font\"]},\"action\": {\"type\": \"allow\"}}";
//			
//			// 必须用 encodedContentRuleList 参数（NSString 类型）
//			[WKContentRuleListStore.defaultStore compileContentRuleListForIdentifier:@"allowAllFiles"
//														  encodedContentRuleList:rule
//															  completionHandler:^(WKContentRuleList *list, NSError *error) {
//				if (error) {
//					NSLog(@"❌ 规则编译失败: %@", error.localizedDescription);
//				} else {
//					[config.userContentController addContentRuleList:list];
//					NSLog(@"✅ 规则已添加");
//				}
//			}];
//		} else {
//			NSLog(@"⚠️ iOS 版本过低，不支持 WKContentRuleListStore");
//		}
		
		// 3. 创建 WebView 并设置代理
		self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
		self.webView.navigationDelegate = self;
		[self.view addSubview:self.webView];
		
//		// 4. 加载 uni-app 主页面
//		NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"__uniappview"
//															 ofType:@"html"
//														inDirectory:@"Pandora/apps/__UNI__C5A81A5/www"];
//		NSURL *fileURL = [NSURL fileURLWithPath:htmlPath];
//		NSURL *baseURL = [fileURL URLByDeletingLastPathComponent];
//		
//		[self.webView loadFileURL:fileURL allowingReadAccessToURL:baseURL];
	
	// 替换原加载代码
//	NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"__uniappview"
	NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"PrivacyPolicy"
														 ofType:@"html"
													inDirectory:@"Pandora/apps/__UNI__C5A81A5/www"];
	NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:htmlPath]
											  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
										  timeoutInterval:10];
	[self.webView loadRequest:request];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
	if ([message.name isEqualToString:@"plusRuntimeQuit"]) {
		NSLog(@"前端调用 plus.runtime.quit");
		// 实现退出逻辑（如关闭当前页面）
		//[self dismissViewControllerAnimated:YES completion:nil];
	}
}



#pragma mark - WKNavigationDelegate

// 页面开始加载时显示指示器
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
	NSLog(@"------------");
	[self.loadingIndicator startAnimating];
}

// 页面加载完成（包括所有资源）
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
	NSLog(@"++++++++++++");
	[self.loadingIndicator stopAnimating];
	
//	// 可选：自动跳转到指定页面（如首页）
//	[webView evaluateJavaScript:@"uni.navigateTo({url: '/pages/Main/Main'})"
//			  completionHandler:^(id _Nullable result, NSError * _Nullable error) {
//		if (error) {
//			NSLog(@"路由跳转失败: %@", error.localizedDescription);
//		}
//	}];
}

// 页面加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
	[self.loadingIndicator stopAnimating];
	NSLog(@"页面加载失败: %@", error.localizedDescription);
}









#pragma mark - PDRCoreDelegate

// 必须实现的方法
- (UIColor *)getStatusBarBackground {
	return [UIColor clearColor];
}

- (BOOL)canCloseSplash {
	NSLog(@"询问是否可以关闭启动屏");
	return YES; // 允许关闭启动屏
}

- (BOOL)closeCore {
	return YES; // 允许关闭核心引擎
}

// 其他可选但建议实现的方法
- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle {}
- (void)setStatusBarHidden:(BOOL)isHidden {}
- (BOOL)getStatusBarHidden { return NO; }
- (void)wantsFullScreen:(BOOL)fullScreen {}
- (void)refreshTopWebviewStart { NSLog(@"开始刷新顶部WebView"); }
- (void)refreshTopWebviewEnd { NSLog(@"顶部WebView刷新完成"); }
- (void)settingLoadEnd { NSLog(@"设置加载完成"); }




@end
