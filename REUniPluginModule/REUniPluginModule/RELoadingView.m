//
//  RELoadingView.m
//  REUniPluginModule
//
//  Created by Apple on 2024/10/10.
//

#import "RELoadingView.h"
#import "UIImage+GIF.h"
#import <SDWebImageManager.h>

@interface RELoadingView ()
@property (nonatomic, strong) NSArray *tipsArray;
@property (nonatomic, strong) NSTimer *timer;

@end


@implementation RELoadingView

- (void)awakeFromNib {
	[super awakeFromNib];
	self.tipsArray = @[
		@"推荐使用谷歌、Edge、狐浏览器登录黑洞引擎",
		@"你知道吗，模型的加载速度与它的大小没有直接关系，而与它的三角面片数相关。三角面片数量越少，加载速度越快",
		@"小提示：按住ctrl键的同时：鼠标点击，代表多选；鼠标拖动，代表框选",
		@"小提示：想要隐藏批量芒果，可以选中目录树基础知识再点击【隐藏组件】",
		@"小提示:引擎工具栏的【视野】仅对GIS数据生效",
		@"小提示:WASD可以进行漫游操作，Q和E控制上升和下降",
		@"小tips:场景范围过大怎么办，点击目录树可以快速定位",
		@"小tips:鼠标左键代表平移，右键代表旋转，按住中键可绕指定点旋转"
	];
	self.tipLB.numberOfLines = 0;
	// 显示第一条提示
	self.tipLB.text = self.tipsArray.firstObject;
}


+ (RELoadingView *)initWithFrame:(CGRect)frame {
	NSArray *nibs = [REUniPluginModule_bundle loadNibNamed:@"RELoadingView" owner:nil options:nil];
	RELoadingView *loadingView = nibs.firstObject;
	loadingView.frame = frame;
	
	loadingView.loadingProgress.progress = 0.0;
	
	NSString *path = [REUniPluginModule_bundle pathForResource:@"loading" ofType:@"gif"];
	NSData *data = [NSData dataWithContentsOfFile:path];
	UIImage *image = [UIImage sd_imageWithGIFData:data];
	loadingView.loadingIV.image = image;
	return loadingView;
}



- (IBAction)cancelAction:(UIButton *)sender {
	[self clearTimer];
	VDBlockSafeRun(self.cancelCallBack);
}



- (void)showLoading {
	self.hidden = NO;
	// 设置定时器，每3秒更换一次提示
	self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(changeTip) userInfo:nil repeats:YES];
}

- (void)hiddenLoading {
	[self changeTip];
	self.hidden = YES;
}


- (void)changeTip {
	// 随机选择一条提示
	NSInteger index = arc4random_uniform((int)self.tipsArray.count);
	self.tipLB.text = self.tipsArray[index];
}


- (void)clearTimer {
	// 清除定时器
	if (self.timer) {
		[self.timer invalidate];
		self.timer = nil;
	}
}

@end
