//
//  REExtrudeTexUniData.m
//  REUniPluginModule
//
//  Created by Apple on 2025/11/25.
//

#import "REExtrudeTexUniData.h"

@implementation REExtrudeTexUniData


- (instancetype)init {
	self = [super init];
	if (self) {
		_picPath = REEmptyStr; _textureGuid = REEmptyStr;
		_picSize = @[@(5.0), @(5.0)]; _picSizeObj = REDVec2Make(5.0, 5.0);
	}
	return self;
}

- (void)setPicSize:(NSArray<NSNumber *> *)picSize {
	_picSize = picSize;
	self.picSizeObj = [RETool arrToDVec2:picSize];
}



@end
