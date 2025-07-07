//
//  RESceneUniData.m
//  REUniPluginModule
//
//  Created by Apple on 2025/7/7.
//

#import "RESceneUniData.h"
#import "NSObject+YYModel.h"
#import "REUniClass.h"


@implementation RESceneUniData


- (instancetype)init {
	self = [super init];
	if (self) {
		_name = REEmptyStr; _token = REEmptyStr; _baseUrl = REEmptyStr; _shareUrl = REEmptyStr;
		_projName = REEmptyStr; _worldCRS = REEmptyStr; _camDefaultDataSetId = REEmptyStr;
		_shareViewMode = REEmptyStr; _shareDataType = REEmptyStr;
		_maxInstDrawFaceNum = 1500000; _shareType = 0; _collect = NO;
		_defaultCamLoc = nil;
		_dataSetList = @[]; _entityList = @[]; _waterList = @[]; _extrudeList = @[];
	}
	return self;
}


+ (NSDictionary *)modelContainerPropertyGenericClass {
	return @{
		@"defaultCamLoc": [RECamInfoUniData class],
		@"dataSetList": [REDataSetUniData class],
		@"entityList": [REEntityUniData class],
		@"waterList": [REWaterUniData class],
		@"extrudeList": [REExtrudeUniData class],
	};
}


@end
