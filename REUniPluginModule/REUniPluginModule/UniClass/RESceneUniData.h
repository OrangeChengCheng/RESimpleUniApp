//
//  RESceneUniData.h
//  REUniPluginModule
//
//  Created by Apple on 2025/7/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class REDataSetUniData;
@class RECamInfoUniData;
@class REEntityUniData;
@class REWaterUniData;
@class REExtrudeUniData;

@interface RESceneUniData : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *baseUrl;
@property (nonatomic, copy) NSString *shareUrl;
@property (nonatomic, copy) NSString *projName;
@property (nonatomic, copy) NSString *worldCRS;
@property (nonatomic, copy) NSString *camDefaultDataSetId;
@property (nonatomic, copy) NSString *shareViewMode;
@property (nonatomic, copy) NSString *shareDataType;
@property (nonatomic, assign) int maxInstDrawFaceNum;
@property (nonatomic, assign) int shareType;
@property (nonatomic, assign) BOOL collect;
@property (nonatomic, strong) RECamInfoUniData *defaultCamLoc;
@property (nonatomic, strong) NSArray<REDataSetUniData *> *dataSetList;
@property (nonatomic, strong) NSArray<REEntityUniData *> *entityList;
@property (nonatomic, strong) NSArray<REWaterUniData *> *waterList;
@property (nonatomic, strong) NSArray<REExtrudeUniData *> *extrudeList;

@end

NS_ASSUME_NONNULL_END
