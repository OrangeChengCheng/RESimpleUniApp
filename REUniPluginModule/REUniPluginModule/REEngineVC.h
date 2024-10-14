//
//  REEngineVC.h
//  RETestUniPlugin
//
//  Created by Apple on 2023/11/23.
//

#import <UIKit/UIKit.h>

@protocol RERenderDelegate <NSObject>

// 退出结束渲染回调
- (void)exitRenderCallback:(Boolean)success;

// 模型加载完成回调
- (void)loadDataSetFinishCallback:(Boolean)success;

@end

NS_ASSUME_NONNULL_BEGIN

@interface REEngineVC : UIViewController
@property (nonatomic, assign) Boolean isUniAppComp;//是否是UniApp插件 yes：uniApp插件  no: 原生组件
@property (nonatomic, weak) id<RERenderDelegate> delegate;
@property (nonatomic, strong) UIView *customView;

@property (nonatomic, strong) NSArray *dataSetList;
@property (nonatomic, assign) int maxInstDrawFaceNum;
@property (nonatomic, copy) NSString *worldCRS;
@property (nonatomic, assign) int shareType;
@property (nonatomic, copy) NSString *camDefaultDataSetId;


- (void)endRenderAndExit;//结束渲染并退出渲染

@end

NS_ASSUME_NONNULL_END
