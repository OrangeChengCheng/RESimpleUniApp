//
//  RELoadingView.m
//  REUniPluginModule
//
//  Created by Apple on 2024/10/10.
//

#import "RELoadingView.h"
#import "UIImage+GIF.h"
#import <SDWebImageManager.h>

@implementation RELoadingView

- (void)awakeFromNib {
	[super awakeFromNib];
}


+ (RELoadingView *)initWithFrame:(CGRect)frame {
	NSArray *nibs = [REUniPluginModule_bundle loadNibNamed:@"RELoadingView" owner:nil options:nil];
	RELoadingView *loadingView = nibs.firstObject;
	loadingView.frame = frame;
	
	NSString *path = [REUniPluginModule_bundle pathForResource:@"loading" ofType:@"gif"];
	NSData *data = [NSData dataWithContentsOfFile:path];
	UIImage *image = [UIImage sd_imageWithGIFData:data];
	loadingView.loadingIV.image = image;
	return loadingView;
}



- (IBAction)cancelAction:(UIButton *)sender {
	VDBlockSafeRun(self.cancelCallBack);
}


@end
