//
//  REEntityUniData.m
//  REUniPluginModule
//
//  Created by Apple on 2025/6/5.
//

#import "REEntityUniData.h"
#import "NSObject+YYModel.h"

@implementation REEntityUniData

//重写初始化方法，附默认值
- (instancetype)init {
	self = [super init];
	if (self) {
		_dataSetId = @""; _entityType = @""; _dataSetCRS = @""; _elemId = 0;
		_scale = @[@1.0, @1.0, @1.0]; _rotate = @[@0.0, @0.0, @0.0, @1.0]; _offset = @[@0.0, @0.0, @0.0];
	}
	return self;
}



@end
