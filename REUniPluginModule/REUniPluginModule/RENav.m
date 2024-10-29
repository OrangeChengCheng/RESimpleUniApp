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
@property (weak, nonatomic) IBOutlet UIImageView *qrCodeIV;

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
	// 调用方法生成二维码并展示
	UIImage *qrImage = [re_nav generateQRCodeFromString:title];
	re_nav.qrCodeIV.image = qrImage;
	return re_nav;
}


- (IBAction)backAction:(UIButton *)sender {
	VDBlockSafeRun(self.backCallBack);
}

- (IBAction)qrCodeAction:(UIButton *)sender {
	VDBlockSafeRun(self.qrCodeCallBack);
}




- (UIImage *)generateQRCodeFromString:(NSString *)string {
	// 1. 创建数据对象
	NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
	
	// 2. 创建一个空的CIFilter对象
	CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
	
	// 3. 设置输入数据
	[filter setValue:data forKey:@"inputMessage"];
	
	// 4. 设置二维码的纠错水平
	[filter setValue:@"H" forKey:@"inputCorrectionLevel"];
	
	// 5. 获取生成的二维码图像
	CIImage *qrImage = [filter outputImage];
	
	// 6. 创建一个CGImage，因为UIImageView需要CGImage来显示
	CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
	
	// 7. 转换为UIImage并返回
	UIImage *uiImage = [UIImage imageWithCGImage:cgImage];
	
	// 8. 释放CGImage
	CGImageRelease(cgImage);
	
	return uiImage;
}


@end
