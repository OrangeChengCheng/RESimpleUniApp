//
//  REQRCode.h
//  REUniPluginModule
//
//  Created by Apple on 2024/10/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface REQRCode : UIView

+ (void)showQRCode:(NSString *)code name:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
