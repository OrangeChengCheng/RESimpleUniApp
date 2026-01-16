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
@class REExtrudeTexUniData;
@class REUrlUniData;
@class REAuthorUniData;
@class REMonomerUniData;

@interface RESceneUniData : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) BOOL noExternalNetwork;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *baseUrl;
@property (nonatomic, assign) int source;
@property (nonatomic, copy) NSString *shareUrl;
@property (nonatomic, copy) NSString *projName;
@property (nonatomic, assign) int maxInstDrawFaceNum;
@property (nonatomic, copy) NSString *worldCRS;
@property (nonatomic, strong) REAuthorUniData *authorData;
@property (nonatomic, strong) NSArray<REUrlUniData *> *urlHeaderList;
@property (nonatomic, strong) NSArray<REDataSetUniData *> *dataSetList;
@property (nonatomic, assign) BOOL collect;
@property (nonatomic, assign) int shareType;
@property (nonatomic, copy) NSString *sceneId;
@property (nonatomic, copy) NSString *camDefaultDataSetId;
@property (nonatomic, copy) NSString *shareViewMode;
@property (nonatomic, copy) NSString *shareDataType;
@property (nonatomic, strong) RECamInfoUniData *defaultCamLoc;
@property (nonatomic, strong) NSArray<REEntityUniData *> *entityList;
@property (nonatomic, strong) NSArray<REWaterUniData *> *waterList;
@property (nonatomic, strong) NSArray<REExtrudeUniData *> *extrudeList;
@property (nonatomic, strong) NSArray<REExtrudeTexUniData *> *extrudeTexList;
@property (nonatomic, strong) NSArray<REMonomerUniData *> *monomerList;

@end

NS_ASSUME_NONNULL_END
