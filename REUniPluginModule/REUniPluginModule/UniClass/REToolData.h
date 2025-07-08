//
//  REToolData.h
//  REUniPluginModule
//
//  Created by Apple on 2025/7/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface REToolData : NSObject

@property (nonatomic, assign) int type;// 功能类型 1: 目录树 2: 查看图纸 3: 属性查询
@property (nonatomic, assign) int popViewHeight;
@property (nonatomic, copy) NSString *toolBtnId;
@property (nonatomic, copy) NSString *btnImg;
@property (nonatomic, copy) NSString *popWebUrl;

+ (REToolData *)initWithType:(int)type popViewHeight:(int)popViewHeight toolBtnId:(NSString *)toolBtnId btnImg:(NSString *)btnImg popWebUrl:(NSString *)popWebUrl;

@end

NS_ASSUME_NONNULL_END
