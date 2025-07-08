//
//  REModelUniData.m
//  REUniPluginModule
//
//  Created by Apple on 2025/7/7.
//

#import "REModelUniData.h"

@implementation REModelUniData

- (instancetype)init {
	self = [super init];
	if (self) {
		_dataSetId = REEmptyStr; _elemIdList = @[]; _elemClr = @[@255, @255, @255, @255];
		_visible = YES; _alpha = 255;
	}
	return self;
}

@end
