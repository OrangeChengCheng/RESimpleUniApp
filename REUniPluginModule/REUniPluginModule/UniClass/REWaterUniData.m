//
//  REWaterUniData.m
//  REUniPluginModule
//
//  Created by Apple on 2025/7/1.
//

#import "REWaterUniData.h"
#import "NSObject+YYModel.h"

@implementation REWaterUniData

- (instancetype)init {
	self = [super init];
	if (self) {
		_waterName = REEmptyStr; _waterClr = @[@61, @158, @135, @255];
		_blendDist = 1.0; _visible = YES; _expandDist = 0.0; _depthBias = 0.0; _visDist = 200000.0;
		_rgnList = @[];
	}
	return self;
}


+ (NSDictionary *)modelContainerPropertyGenericClass {
	return @{
		@"rgnList": [RECornerRgnUniData class]
	};
}


@end





@implementation RECornerRgnUniData


- (instancetype)init {
	self = [super init];
	if (self) {
		_pointList = @[]; _indexList = @[];
	}
	return self;
}


@end
