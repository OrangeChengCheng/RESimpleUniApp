//
//  REBtnPlane.h
//  REUniPluginModule
//
//  Created by Apple on 2025/11/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ REBtnPlaneCallback)(NSString *btnId, BOOL isSelected);

@interface REBtnPlane : UIView

@property (copy, nonatomic) void(^ onClickCallback)(NSString *btnId, BOOL isSelected);


/// 初始化方法
/// @param callback 点击回调
+ (instancetype)initWithCallback:(REBtnPlaneCallback)callback;


- (void)updateStateWithBtnId:(NSString *)btnId isSelected:(BOOL)isSelected;

@end

NS_ASSUME_NONNULL_END
