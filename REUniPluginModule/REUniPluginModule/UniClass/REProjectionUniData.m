//
//  REProjectionUniData.m
//  REUniPluginModule
//
//  Created by Apple on 2026/7/20.
//

#import "REProjectionUniData.h"
#import "NSObject+YYModel.h"

@implementation REProjectionUniData

- (instancetype)init {
	self = [super init];
	if (self) {
		_projectionId = REEmptyStr; _texPath = REEmptyStr;
		_camPos = @[@(0.0), @(0.0), @(0.0)]; _targetPos = @[@(0.0), @(0.0), @(0.0)];
		_type = 1; _showState = 0;
		_planeNormal = @[@(0.0), @(1.0), @(0.0)]; _planeRight = @[@(-1.0), @(0.0), @(0.0)];
		_nearFarPlaneOffset = @[@(0.0), @(1.0)]; _nearPlaneRect = @[@(-10.0), @(10.0), @(-10.0), @(10.0)];
		_aspectRatio = 16.0 / 9.0; _fieldAngle = 60.0;
		_texType = 0; _texClrMult = @[@255, @255, @255, @255];
		_uvRect = @[@0, @1, @0, @1];
		_uvMapPtNum = @[@0, @0]; _uvMapPtPosList = @[];
		_clipPlaneValid = [[REProjectionClipPlaneInfo alloc] init];
		_clipBoxGeom = @[];
		_picth = 0.0;
	}
	return self;
}




@end





@implementation REProjectionClipPlaneUniInfo


@end

