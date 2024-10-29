//
//  RENav.h
//  REUniPluginModule
//
//  Created by Apple on 2024/10/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RENav : UIView

@property (copy, nonatomic) void(^ backCallBack)(void);
@property (copy, nonatomic) void(^ qrCodeCallBack)(void);

+ (RENav *)initWithFrame:(CGRect)frame title:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
