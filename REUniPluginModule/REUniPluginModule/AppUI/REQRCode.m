//
//  REQRCode.m
//  REUniPluginModule
//
//  Created by Apple on 2024/10/30.
//

#import "REQRCode.h"

@interface REQRCode ()
@property (weak, nonatomic) IBOutlet UIImageView *qrCodeIV;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UIView *contentView;


@end

@implementation REQRCode

- (void)awakeFromNib {
	[super awakeFromNib];
	self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
	self.alpha = 0.0;
}


+ (void)showQRCode:(NSString *)code name:(NSString *)name {
	NSArray *nibs = [REUniPluginModule_bundle loadNibNamed:@"REQRCode" owner:nil options:nil];
	REQRCode *qrCode = nibs.firstObject;
	qrCode.frame = [UIApplication sharedApplication].keyWindow.bounds;
	qrCode.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[[UIApplication sharedApplication].keyWindow addSubview:qrCode];
	
	qrCode.titleLB.text = name;
	// 调用方法生成二维码并展示
	qrCode.qrCodeIV.image = [REQRCode generateQRCodeFromString:code];
	
	[qrCode show];
}

- (IBAction)cancelAction:(UIButton *)sender {
	[self hide];
}

- (void)show {
	// 实现弹出动画（示例：使用alpha动画）
	[UIView animateWithDuration:0.3 animations: ^{
		self.alpha = 1.0;
	}];
}

- (void)hide {
	// 实现关闭动画（示例：使用alpha动画）
	[UIView animateWithDuration:0.3 animations: ^{
		self.alpha = 0.0;
	} completion: ^(BOOL finished) {
		// 动画完成后，从父视图中移除自己（可选）
		[self removeFromSuperview];
	}];
}



- (IBAction)saveImageAction:(UIButton *)sender {
	[self saveCurrentViewAsImage];
}



- (IBAction)shareUrlAction:(UIButton *)sender {
}






- (void)saveCurrentViewAsImage {
	// 获取当前视图（假设是self.view）的快照
	UIImage *image = [self captureView:self.contentView];
	
	// 定义保存图片的路径
	// 此处将图片保存在应用的Documents目录下，以时间戳命名
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%f.png", [[NSDate date] timeIntervalSince1970]]];
	
	// 将图片数据写入文件
	[UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];
	
	// 输出保存路径（可选，便于调试）
	NSLog(@"Image saved to: %@", imagePath);
}

- (UIImage *)captureView:(UIView *)view {
	// 开始图像上下文（考虑屏幕分辨率）
	UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
	
	// 对于iOS 7及以上版本，使用drawViewHierarchyInRect
	if ([view respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
		[view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
	} else {
		// 对于旧版iOS，使用renderInContext
		[view.layer renderInContext:UIGraphicsGetCurrentContext()];
	}
	
	// 从上下文中获取图像
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	
	// 结束图像上下文
	UIGraphicsEndImageContext();
	
	return image;
}







+ (UIImage *)generateQRCodeFromString:(NSString *)string {
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
