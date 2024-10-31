//
//  RETip.m
//  REUniPluginModule
//
//  Created by Apple on 2024/10/23.
//

#import "RETip.h"

#define RETipHeight (40)
#define RETipSpaceY_L1 (105)
#define RETipSpaceY_L2 (175)
#define RETipAnimateHeight (40)
#define RETipStaticDelay (0.8)
#define RETipAnimateTime (0.5)
#define RETipAlpha (0.8)
#define RETipPadding (10.0f)


static RETip *curr_tip = nil;



@implementation RETip

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = [UIColor blackColor];
		self.alpha = 0;
		self.layer.cornerRadius = 6;
		self.hidden = YES;
	}
	return self;
}

+ (void)showTipStaticAnimte:(UIView *)superView message:(NSString *)message level:(RETip_Level)level {
	if (curr_tip) {
		[curr_tip clear];
	}
	
	UIFont *font = [UIFont systemFontOfSize:14];
	CGSize size = [message sizeWithAttributes:@{NSFontAttributeName: font}];
	CGFloat tipWidth = size.width + RETipPadding * 2;
	tipWidth = MIN(tipWidth, CGRectGetWidth(superView.frame) * 0.7);
	CGFloat tipSpaceY = CGRectGetHeight(superView.frame) / 2 + (RETipHeight / 2);
	switch (level) {
		case RETip_L1:
			tipSpaceY = RETipSpaceY_L1;
			break;
		case RETip_L2:
			tipSpaceY = RETipSpaceY_L2;
			break;
		default:
			break;
	}
	CGFloat tipX = CGRectGetWidth(superView.frame) / 2 - (tipWidth / 2);
	CGFloat tipY = CGRectGetHeight(superView.frame) - tipSpaceY - RETipHeight;
	CGRect initRect = CGRectMake(tipX, tipY, tipWidth, RETipHeight);
	RETip *re_tip = [[RETip alloc] initWithFrame:initRect];
	[superView addSubview:re_tip];
	
	curr_tip = re_tip;
	
	UILabel *textLB = [[UILabel alloc] initWithFrame:CGRectMake(RETipPadding, 0, tipWidth - RETipPadding * 2, RETipHeight)];
	textLB.text = message;
	textLB.font = font;
	textLB.textColor = [UIColor whiteColor];
	textLB.textAlignment = NSTextAlignmentCenter;
	[re_tip addSubview:textLB];
	
	[re_tip show];
}

- (void)show {
	if (self.hidden) {
		self.hidden = NO;
	}
	WEAKSELF
	[UIView animateWithDuration:RETipAnimateTime animations: ^{
		self.alpha = RETipAlpha;
	} completion: ^(BOOL finished) {
		double delayInSeconds = RETipStaticDelay;
		dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
		dispatch_after(popTime, dispatch_get_main_queue(), ^{
			STRONGSELF
			[strongSelf hide];
		});
	}];
}

- (void)showHeight {
	if (self.hidden) {
		self.hidden = NO;
	}
	WEAKSELF
	[UIView animateWithDuration:RETipAnimateTime animations: ^{
		STRONGSELF
		CGFloat endY = strongSelf.frame.origin.y - RETipAnimateHeight;
		strongSelf.frame = CGRectMake(strongSelf.frame.origin.x, endY, strongSelf.frame.size.width, strongSelf.frame.size.height); // 高度2
	} completion: ^(BOOL finished) {
		STRONGSELF
		// 1秒后执行消失动画
		double delayInSeconds = RETipStaticDelay;
		dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
		dispatch_after(popTime, dispatch_get_main_queue(), ^{
			[strongSelf hide];
		});
	}];
}


- (void)hide {
	[UIView animateWithDuration:RETipAnimateTime animations: ^{
		self.alpha = 0; // 消失动画（透明度渐变）
	} completion: ^(BOOL finished) {
		[self clear];
	}];
}

- (void)clear {
	self.hidden = YES;
	[self removeFromSuperview];
	if (curr_tip == self) {
		curr_tip = nil;
	}
}

@end
