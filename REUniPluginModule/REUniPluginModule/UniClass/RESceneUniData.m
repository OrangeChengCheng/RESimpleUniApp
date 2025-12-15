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
		_name = REEmptyStr; _noExternalNetwork = NO;
		_token = REEmptyStr; _baseUrl = REEmptyStr; _source = 0;
		_shareUrl = REEmptyStr; _projName = REEmptyStr; _maxInstDrawFaceNum = 1500000;
		_worldCRS = REEmptyStr; _dataSetList = @[]; _collect = NO;
		_authorData = nil;
		_urlHeaderList = @[];
		_shareType = 0; _sceneId = REEmptyStr;
		_camDefaultDataSetId = REEmptyStr; _shareViewMode = REEmptyStr; _shareDataType = REEmptyStr;
		_defaultCamLoc = nil;
		_entityList = @[]; _waterList = @[]; _extrudeList = @[]; _extrudeTexList = @[];
	}
	return self;
}


+ (NSDictionary *)modelContainerPropertyGenericClass {
	return @{
		@"authorData": [REAuthorUniData class],
		@"defaultCamLoc": [RECamInfoUniData class],
		@"dataSetList": [REDataSetUniData class],
		@"entityList": [REEntityUniData class],
		@"waterList": [REWaterUniData class],
		@"extrudeList": [REExtrudeUniData class],
		@"extrudeTexList": [REExtrudeTexUniData class],
		@"urlHeaderList": [REUrlUniData class],
	};
}


@end
