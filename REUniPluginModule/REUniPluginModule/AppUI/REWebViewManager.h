//
//  REWebViewManager.h
//  RESimpleUniPlugin
//
//  Created by Apple on 2025/6/12.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@protocol REWebViewManagerDelegate <NSObject>
@optional
- (void)webViewManager:(id)manager didReceiveResult:(NSDictionary *)result;
- (void)webViewManager:(id)manager didFinishLoading:(BOOL)success;
@end


@interface REWebViewManager : NSObject <WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, weak) id<REWebViewManagerDelegate> delegate;
@property (nonatomic, assign) BOOL isShowing;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, assign) BOOL isUrlLoaded;
@property (nonatomic, copy) NSString *webViewUrl;
@property (nonatomic, strong) NSDictionary *webViewParams;

// 初始化
+ (REWebViewManager *)initWithDelegate:(id<REWebViewManagerDelegate>)delegate
							parentView:(UIView *)parentView
								height:(int)height
							webViewUrl:(NSString *)webViewUrl
						 webViewParams:(NSDictionary *)webViewParams;

// 显示/隐藏（仅切换可见性）
- (void)showWebPop;
- (void)hiddenWebPop;

// 全屏切换
- (void)setFullScreen:(BOOL)isFull;
- (void)toggleFullScreen;

// 发送消息
- (void)sendMsgAppToWebWithMessage:(NSString *)message;
- (void)sendObjAppToWebWithObject:(id)object type:(NSString *)type isResponse:(BOOL)isResponse msgId:(NSString *)msgId;
- (void)sendObjAppToWebWithObject:(id)object type:(NSString *)type;
- (void)sendObjAppToWebWithObject:(id)object;
- (void)sendObjAppToWebWithType:(NSString *)type;
- (void)sendObjAppToWebCallbackWithObject:(id)object msgId:(NSString *)msgId;

// 销毁
- (void)destroy;

@end

NS_ASSUME_NONNULL_END
	
