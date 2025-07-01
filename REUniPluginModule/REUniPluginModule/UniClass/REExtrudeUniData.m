//
//  REExtrudeUniData.m
//  REUniPluginModule
//
//  Created by Apple on 2025/7/1.
//

#import "REExtrudeUniData.h"

@implementation REExtrudeUniData

- (instancetype)init {
	self = [super init];
	if (self) {
		_extrudeId = REEmptyStr; 
		_dataSetIdList = @[]; _depthLimitRange = @[@0, @0];
		_type = 0; _texId = 0; _texPath = REEmptyStr; _texSize = @[@0, @0];
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
