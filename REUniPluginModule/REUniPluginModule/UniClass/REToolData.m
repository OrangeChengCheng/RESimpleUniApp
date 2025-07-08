//
//  REToolData.m
//  REUniPluginModule
//
//  Created by Apple on 2025/7/7.
//

#import "REToolData.h"

@implementation REToolData

+ (REToolData *)initWithType:(int)type popViewHeight:(int)popViewHeight toolBtnId:(NSString *)toolBtnId btnImg:(NSString *)btnImg popWebUrl:(NSString *)popWebUrl {
	REToolData *toolData = [[REToolData alloc] init];
	toolData.type = type; toolData.popViewHeight = popViewHeight;
	toolData.toolBtnId = toolBtnId; toolData.btnImg = btnImg;
	toolData.popWebUrl = popWebUrl;
	return toolData;
}

@end
