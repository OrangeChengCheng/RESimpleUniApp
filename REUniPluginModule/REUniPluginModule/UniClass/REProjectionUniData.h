//
//  REProjectionUniData.h
//  REUniPluginModule
//
//  Created by Apple on 2026/7/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class REProjectionClipPlaneUniInfo;

@interface REProjectionUniData : NSObject
@property (nonatomic, copy) NSString *projectionId;
@property (nonatomic, strong) NSArray<NSNumber *> *camPos;
@property (nonatomic, strong) NSArray<NSNumber *> *targetPos;
@property (nonatomic, assign) int type;
@property (nonatomic, strong) NSArray<NSNumber *> *planeNormal;
@property (nonatomic, strong) NSArray<NSNumber *> *planeRight;
@property (nonatomic, strong) NSArray<NSNumber *> *nearFarPlaneOffset;
@property (nonatomic, strong) NSArray<NSNumber *> *nearPlaneRect;
@property (nonatomic, assign) double aspectRatio;
@property (nonatomic, assign) double fieldAngle;
@property (nonatomic, copy) NSString *texPath;
@property (nonatomic, assign) int texType;
@property (nonatomic, strong) NSArray<NSNumber *> *texClrMult;
@property (nonatomic, strong) NSArray<NSNumber *> *uvRect;
@property (nonatomic, strong) NSArray<NSNumber *> *uvMapPtNum;
@property (nonatomic, strong) NSArray<NSArray<NSNumber *> *> *uvMapPtPosList;
@property (nonatomic, assign) int showState;
@property (nonatomic, strong) REProjectionClipPlaneInfo *clipPlaneValid;
@property (nonatomic, strong) NSArray<NSArray<NSNumber *> *> *clipBoxGeom;
@property (nonatomic, assign) int picth;

@end


@interface REProjectionClipPlaneUniInfo : NSObject

@property (nonatomic, assign) BOOL topValid; //裁剪包围体（上面）限制区域有效
@property (nonatomic, assign) BOOL bottomValid; //裁剪包围体（下面）限制区域有效
@property (nonatomic, assign) BOOL leftValid; //裁剪包围体（左面）限制区域有效
@property (nonatomic, assign) BOOL rightValid; //裁剪包围体（右面）限制区域有效
@property (nonatomic, assign) BOOL frontValid; //裁剪包围体（前面）限制区域有效
@property (nonatomic, assign) BOOL backValid; //裁剪包围体（后面）限制区域有效

@end

NS_ASSUME_NONNULL_END
