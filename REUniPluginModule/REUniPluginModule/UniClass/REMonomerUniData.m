//
//  REMonomerUniData.m
//  REUniPluginModule
//
//  Created by Apple on 2026/1/16.
//

#import "REMonomerUniData.h"

@implementation REMonomerUniData

- (instancetype)init {
	self = [super init];
	if (self) {
		_monomerId = REEmptyStr; _dataSetId = REEmptyStr;
		_heightMin = 0.0f; _heightMax = 0.0f; _showState = 1;
		_faceClr = @[@255, @255, @255, @127]; _lineClr = @[@255, @255, @255, @127];
		_rgnList = @[];
	}
	return self;
}


+ (NSDictionary *)modelContainerPropertyGenericClass {
	return @{
		@"rgnList": [NSArray class]
	};
}

@end
