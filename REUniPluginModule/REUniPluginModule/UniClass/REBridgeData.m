//
//  REBridgeData.m
//  REUniPluginModule
//
//  Created by Apple on 2025/11/20.
//

#import "REBridgeData.h"

@implementation REBridgeData


- (instancetype)init {
	self = [super init];
	if (self) {
		_log = REEmptyStr;
		_dataSetId = REEmptyStr; _elemIdList = @[];
		_elemClr = @[]; _elemClrObj = REColorMake_RGBA(255, 255, 255, 255);
		_visible = YES; _alpha = 255; _attrValid = YES; _probeMask = 1;
		_unitId = REEmptyStr; _active = YES;
		_resType = REEmptyStr; _terrResEm = RETerrResEm_ALL;
		_waterNameList = @[]; _extrudeIdst = @[]; _waterName = REEmptyStr; _extrudeId = REEmptyStr; _monomerIds = @[];
		_depthBias = 1.0; _locIDList = @[];
		_locType = @"CAM_DIR_CURRENT"; _locTypeEm = CAM_DIR_CURRENT;
		_arrBound = @[]; _box3D = [REBBox3D new]; _depthBias = 0; _topHeight = 0; _bottomHeight = 0;
		_single = NO; _visibalOnly = NO;
		_lineClr = @[]; _lineClrObj = REColorMake_RGBA(255, 255, 255, 255); _lineClrWeight = 255; _lineAlphaWeight = 255;
		_faceClr = @[]; _faceClrObj = REColorMake_RGBA(255, 255, 255, 255); _faceClrWeight = 255; _faceAlphaWeight = 255;
		_camPos = @[]; _camPosObj = REDvec3Zero;
		_camDir = @[]; _camDirObj = REDvec3Zero;
		_camRotate = @[]; _camRotateObj = REDvec4Zero;
		_force = YES; _locDelay = 0; _locTime = 0; _full = NO;
		_webPopId = REEmptyStr;
		_requestData = nil;
		_treeData = @[];
	}
	return self;
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
	return @{
		@"locIDList": [RESelElemInfo class]
	};
}


- (void)setElemClr:(NSArray<NSNumber *> *)elemClr {
	_elemClr = elemClr;
	self.elemClrObj = [RETool arrToColor:elemClr];
}

- (void)setResType:(NSString *)resType {
	_resType = resType;
	if ([resType isEqualToString:@"HEIGHT"]) {
		self.terrResEm = RETerrResEm_HEIGHT;
	} else if ([resType isEqualToString:@"EXTRUDE"]) {
		self.terrResEm = RETerrResEm_EXTRUDE;
	} else if ([resType isEqualToString:@"IMG_PIC"]) {
		self.terrResEm =  RETerrResEm_IMG_PIC;
	} else if ([resType isEqualToString:@"IMG_SHP"]) {
		self.terrResEm =  RETerrResEm_IMG_SHP;
	} else if ([resType isEqualToString:@"ALL"]) {
		self.terrResEm =  RETerrResEm_ALL;
	}
}


- (void)setLocType:(NSString *)locType {
	_locType = locType;
	if ([locType isEqualToString:@"CAM_DIR_FRONT"]) {
		self.locTypeEm = CAM_DIR_FRONT;
	} else if ([locType isEqualToString:@"CAM_DIR_BACK"]) {
		self.locTypeEm = CAM_DIR_BACK;
	} else if ([locType isEqualToString:@"CAM_DIR_LEFT"]) {
		self.locTypeEm = CAM_DIR_LEFT;
	} else if ([locType isEqualToString:@"CAM_DIR_RIGHT"]) {
		self.locTypeEm = CAM_DIR_RIGHT;
	} else if ([locType isEqualToString:@"CAM_DIR_TOP"]) {
		self.locTypeEm = CAM_DIR_TOP;
	} else if ([locType isEqualToString:@"CAM_DIR_BOTTOM"]) {
		self.locTypeEm = CAM_DIR_BOTTOM;
	} else if ([locType isEqualToString:@"CAM_DIR_TOPFRONT"]) {
		self.locTypeEm = CAM_DIR_TOPFRONT;
	} else if ([locType isEqualToString:@"CAM_DIR_TOPRIGHT"]) {
		self.locTypeEm = CAM_DIR_TOPRIGHT;
	} else if ([locType isEqualToString:@"CAM_DIR_TOPBACK"]) {
		self.locTypeEm = CAM_DIR_TOPBACK;
	} else if ([locType isEqualToString:@"CAM_DIR_TOPLEFT"]) {
		self.locTypeEm = CAM_DIR_TOPLEFT;
	} else if ([locType isEqualToString:@"CAM_DIR_LEFTFRONT"]) {
		self.locTypeEm = CAM_DIR_LEFTFRONT;
	} else if ([locType isEqualToString:@"CAM_DIR_RIGHTFRONT"]) {
		self.locTypeEm = CAM_DIR_RIGHTFRONT;
	} else if ([locType isEqualToString:@"CAM_DIR_RIGHTBACK"]) {
		self.locTypeEm = CAM_DIR_RIGHTBACK;
	} else if ([locType isEqualToString:@"CAM_DIR_LEFTBACK"]) {
		self.locTypeEm = CAM_DIR_LEFTBACK;
	} else if ([locType isEqualToString:@"CAM_DIR_BOTTOMFRONT"]) {
		self.locTypeEm = CAM_DIR_BOTTOMFRONT;
	} else if ([locType isEqualToString:@"CAM_DIR_BOTTOMRIGHT"]) {
		self.locTypeEm = CAM_DIR_BOTTOMRIGHT;
	} else if ([locType isEqualToString:@"CAM_DIR_BOTTOMBACK"]) {
		self.locTypeEm = CAM_DIR_BOTTOMBACK;
	} else if ([locType isEqualToString:@"CAM_DIR_BOTTOMLEFT"]) {
		self.locTypeEm = CAM_DIR_BOTTOMLEFT;
	} else if ([locType isEqualToString:@"CAM_DIR_TOPRIGHTBACK"]) {
		self.locTypeEm = CAM_DIR_TOPRIGHTBACK;
	} else if ([locType isEqualToString:@"CAM_DIR_TOPLEFTBACK"]) {
		self.locTypeEm = CAM_DIR_TOPLEFTBACK;
	} else if ([locType isEqualToString:@"CAM_DIR_TOPLEFTFRONT"]) {
		self.locTypeEm = CAM_DIR_TOPLEFTFRONT;
	} else if ([locType isEqualToString:@"CAM_DIR_TOPRIGHTFRONT"]) {
		self.locTypeEm = CAM_DIR_TOPRIGHTFRONT;
	} else if ([locType isEqualToString:@"CAM_DIR_BOTTOMRIGHTBACK"]) {
		self.locTypeEm = CAM_DIR_BOTTOMRIGHTBACK;
	} else if ([locType isEqualToString:@"CAM_DIR_BOTTOMLEFTBACK"]) {
		self.locTypeEm = CAM_DIR_BOTTOMLEFTBACK;
	} else if ([locType isEqualToString:@"CAM_DIR_BOTTOMLEFTFRONT"]) {
		self.locTypeEm = CAM_DIR_BOTTOMLEFTFRONT;
	} else if ([locType isEqualToString:@"CAM_DIR_BOTTOMRIGHTFRONT"]) {
		self.locTypeEm = CAM_DIR_BOTTOMRIGHTFRONT;
	} else if ([locType isEqualToString:@"CAM_DIR_DEFAULT"]) {
		self.locTypeEm = CAM_DIR_DEFAULT;
	} else if ([locType isEqualToString:@"CAM_DIR_CURRENT"]) {
		self.locTypeEm = CAM_DIR_CURRENT;
	}
}



- (void)setArrBound:(NSArray<NSArray<NSNumber *> *> *)arrBound {
	_arrBound = arrBound;
	self.box3D = [REBBox3D initModel:[RETool arrToDVec3:arrBound[0]] max:[RETool arrToDVec3:arrBound[1]]];
}


- (void)setLineClr:(NSArray<NSNumber *> *)lineClr {
	_lineClr = lineClr;
	self.lineClrObj = [RETool arrToColor:lineClr];
}

- (void)setFaceClr:(NSArray<NSNumber *> *)faceClr {
	_faceClr = faceClr;
	self.faceClrObj = [RETool arrToColor:faceClr];
}


- (void)setCamPos:(NSArray<NSNumber *> *)camPos {
	_camPos = camPos;
	self.camPosObj = [RETool arrToDVec3:camPos];
}


- (void)setCamRotate:(NSArray<NSNumber *> *)camRotate {
	_camRotate = camRotate;
	self.camRotateObj = [RETool arrToDVec4:camRotate];
}


- (void)setCamDir:(NSArray<NSNumber *> *)camDir {
	_camDir = camDir;
	_camDirObj = [RETool arrToDVec3:camDir];
}



@end
