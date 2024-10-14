//
//  RERenderComponent.m
//  RETestUniPlugin
//
//  Created by Apple on 2023/11/27.
//

#import "RERenderComponent.h"
#import "REEngineVC.h"
#import "BlackHole3D.h"

@interface RERenderComponent () <RERenderDelegate>

@property (nonatomic, strong) REEngineVC *engineVC;

@property (nonatomic, copy) UniModuleKeepAliveCallback endRenderCallback;

@end

@implementation RERenderComponent

- (REEngineVC *)engineVC {
	if (!_engineVC) {
		_engineVC = [[REEngineVC alloc] init];
		_engineVC.isUniAppComp = YES;
		_engineVC.delegate = self;
	}
	return _engineVC;
}

- (void)onCreateComponentWithRef:(NSString *)ref type:(NSString *)type styles:(NSDictionary *)styles attributes:(NSDictionary *)attributes events:(NSArray *)events uniInstance:(DCUniSDKInstance *)uniInstance
{
	NSLog(@"componentInfo : { \n ref: %@,\n type: %@,\n styles: %@,\n attributes: %@,\n events: %@,\n uniInstance: %@,\n }", ref, type, styles, attributes, events, uniInstance);
}

- (UIView *)loadView {
	return self.engineVC.view;
//	return [UIView new];
}

- (void)viewDidLoad {
	
	self.view.backgroundColor = [UIColor grayColor];
}


/// 前端更新属性回调方法
/// @param attributes 更新的属性
- (void)updateAttributes:(NSDictionary *)attributes {
	// 解析属性
	NSLog(@" ** updateAttributes ** attributes: %@", attributes);
}

/// 前端注册的事件会调用此方法
/// @param eventName 事件名称
- (void)addEvent:(NSString *)eventName {
	NSLog(@" ** addEvent ** eventName: %@", eventName);
	if ([eventName isEqualToString:@"engineEndRender"]) {
		
	}
}

/// 对应的移除事件回调方法
/// @param eventName 事件名称
- (void)removeEvent:(NSString *)eventName {
	NSLog(@" ** removeEvent ** eventName: %@", eventName);
	if ([eventName isEqualToString:@"engineEndRender"]) {

	}
}



#pragma mark - RERenderDelegate

- (void)loadDataSetFinishCallback:(Boolean)success {
	// 向前端发送事件，params 为传给前端的数据 注：数据最外层为 NSDictionary 格式，需要以 "detail" 作为 key 值
	[self fireEvent:@"loadDataSetFinish" params:@{@"detail":@{@"success":@(success)}} domChanges:nil];
	[[BlackHole3D sharedSingleton].Graphics setSysUIPanelVisible:YES];
}

- (void)exitRenderCallback:(Boolean)success {
	if (_endRenderCallback) {
		_endRenderCallback(@(success), YES);
	}
	[_engineVC.customView removeFromSuperview];
	[[BlackHole3D sharedSingleton] endRender];
	[self removeFromSuperview];
	NSLog(@"结束渲染");
}


UNI_EXPORT_METHOD(@selector(engineEndRenderCallback:))
- (void)engineEndRenderCallback:(UniModuleKeepAliveCallback)callback {
	_endRenderCallback = callback;
	[_engineVC endRenderAndExit];
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	NSLog(@"%@ touchesBegan *** event._timestamp: %f  \n", NSStringFromClass([self class]), event.timestamp);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	NSLog(@"%@ touchesEnded *** event._timestamp: %f  \n", NSStringFromClass([self class]), event.timestamp);
}

@end
