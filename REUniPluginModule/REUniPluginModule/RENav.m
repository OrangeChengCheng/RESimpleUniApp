//
//  RENav.m
//  REUniPluginModule
//
//  Created by Apple on 2024/10/29.
//

#import "RENav.h"
#import <CoreImage/CoreImage.h>


@interface RENav ()
@property (weak, nonatomic) IBOutlet UILabel *titleLB;

@end

@implementation RENav

- (void)awakeFromNib {
	[super awakeFromNib];
}

+ (RENav *)initWithFrame:(CGRect)frame title:(NSString *)title {
	NSArray *nibs = [REUniPluginModule_bundle loadNibNamed:@"RENav" owner:nil options:nil];
	RENav *re_nav = nibs.firstObject;
	re_nav.frame = frame;
	re_nav.titleLB.text = title;
	return re_nav;
}


- (IBAction)backAction:(UIButton *)sender {
	VDBlockSafeRun(self.backCallBack);
}

- (IBAction)qrCodeAction:(UIButton *)sender {
	VDBlockSafeRun(self.qrCodeCallBack);
}







@end
