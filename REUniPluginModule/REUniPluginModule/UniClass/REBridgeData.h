//
//  REBridgeData.h
//  REUniPluginModule
//
//  Created by Apple on 2025/11/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface REBridgeData : NSObject


@property (nonatomic, copy) NSString *log;
@property (nonatomic, copy) NSString *dataSetId;
@property (nonatomic, strong) NSArray<NSNumber *> *elemIdList;
@property (nonatomic, strong) NSArray<NSNumber *> *elemClr;
@property (nonatomic, assign) REColor elemClrObj;
@property (nonatomic, assign) BOOL visible;
@property (nonatomic, assign) int alpha;
@property (nonatomic, assign) BOOL attrValid;
@property (nonatomic, assign) int probeMask;
@property (nonatomic, copy) NSString *unitId;
@property (nonatomic, copy) NSString *resType;
@property (nonatomic, assign) RETerrResEm terrResEm;
@property (nonatomic, assign) BOOL active;
@property (nonatomic, strong) NSArray<NSString *> *waterNameList;
@property (nonatomic, strong) NSArray<NSString *> *extrudeIdst;

@property (nonatomic, copy) NSString *waterName;
@property (nonatomic, copy) NSString *extrudeId;
@property (nonatomic, assign) double backDepth;
@property (nonatomic, strong) NSArray<RESelElemInfo *> *locIDList;
@property (nonatomic, copy) NSString *locType;
@property (nonatomic, assign) RECamDirEm locTypeEm;
@property (nonatomic, strong) NSArray<NSArray<NSNumber *> *> *arrBound;
@property (nonatomic, strong) REBBox3D *box3D;
@property (nonatomic, assign) float depthBias;
@property (nonatomic, assign) double topHeight;
@property (nonatomic, assign) double bottomHeight;
@property (nonatomic, assign) BOOL single;
@property (nonatomic, strong) NSArray<NSNumber *> *lineClr;
@property (nonatomic, assign) REColor lineClrObj;
@property (nonatomic, assign) BOOL visibalOnly;
@property (nonatomic, strong) NSArray<NSNumber *> *camPos;
@property (nonatomic, assign) REDVec3 camPosObj;
@property (nonatomic, strong) NSArray<NSNumber *> *camRotate;
@property (nonatomic, assign) REDVec4 camRotateObj;
@property (nonatomic, strong) NSArray<NSNumber *> *camDir;
@property (nonatomic, assign) REDVec3 camDirObj;
@property (nonatomic, assign) BOOL force;
@property (nonatomic, assign) double locDelay;
@property (nonatomic, assign) double locTime;
@property (nonatomic, assign) BOOL full;
@property (nonatomic, copy) NSString *webPopId;
@property (nonatomic, strong) NSDictionary *requestData;

@end

NS_ASSUME_NONNULL_END
