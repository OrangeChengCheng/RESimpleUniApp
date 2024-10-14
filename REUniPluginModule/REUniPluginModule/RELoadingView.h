//
//  RELoadingView.h
//  REUniPluginModule
//
//  Created by Apple on 2024/10/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RELoadingView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *loadingIV;
@property (weak, nonatomic) IBOutlet UILabel *tipLB;
@property (weak, nonatomic) IBOutlet UIProgressView *loadingProgress;


@property (copy, nonatomic) void(^ cancelCallBack)(void);


+ (RELoadingView *)initWithFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
