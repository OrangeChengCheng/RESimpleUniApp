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


- (instancetype)initWithDelegate:(id<REWebViewManagerDelegate>)delegate;
- (void)loadUrl:(NSString *)url;
- (void)loadUrl:(NSString *)url withParams:(NSDictionary *)params;
- (void)showInView:(UIView *)parentView
		   withRect:(CGRect)rect
		fromBottom:(BOOL)fromBottom
		  animated:(BOOL)animated;
- (void)showInView:(UIView *)parentView
		withHeight:(CGFloat)height;
- (void)hideAnimated:(BOOL)animated;
- (void)sendMessage:(NSString *)message;
- (void)sendObject:(id)object;
- (void)toggleFullScreen:(BOOL)isFullScreen animated:(BOOL)animated;
- (void)destroy;

@end

NS_ASSUME_NONNULL_END
