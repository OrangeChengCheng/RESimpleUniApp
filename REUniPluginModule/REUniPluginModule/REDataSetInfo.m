//
//  REDataSetInfo.m
//  REUniPluginModule
//
//  Created by Apple on 2024/8/29.
//

#import "REDataSetInfo.h"

@implementation REDataSetInfo

//重写初始化方法，附默认值
- (instancetype)init {
	self = [super init];
	if (self) {
		_type = 0; _dataSetId = @""; _resourcesAddress = @"";
		_scale = @[@1.0, @1.0, @1.0]; _rotate = @[@0.0, @0.0, @0.0, @1.0]; _offset = @[@0.0, @0.0, @0.0];
		_dataSetCRS = @""; _dataSetCRSNorth = 0; _dataSetSGContent = @"";
	}
	return self;
}


@end
