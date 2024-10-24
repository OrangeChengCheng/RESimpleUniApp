//
//  RETip.h
//  REUniPluginModule
//
//  Created by Apple on 2024/10/23.
//

#import <UIKit/UIKit.h>

typedef enum :int {
	RETip_L0 = 0,//父组件中心
	RETip_L1 = 1,//一级面板上方
	RETip_L2 = 2,//二级面板上方
} RETip_Level;

NS_ASSUME_NONNULL_BEGIN

@interface RETip : UIView

+ (void)showTipStaticAnimte:(UIView *)superView message:(NSString *)message level:(RETip_Level)level;


@end

NS_ASSUME_NONNULL_END
