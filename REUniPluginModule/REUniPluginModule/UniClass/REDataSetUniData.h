//
//  REDataSetUniData.h
//  REUniPluginModule
//
//  Created by Apple on 2024/8/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface REDataSetUniData : NSObject

@property (nonatomic, assign) int type;// 0:模型  13：遥感影像 10：WMTS工程  11：OSGB工程  14：360全景图  15：点云工程  16：CAD图纸  20：矢量数据
@property (nonatomic, copy) NSString *dataSetId;
@property (nonatomic, copy) NSString *dataSetId_noline;//平台处理了数据造成数据使用混乱，无奈之举，自行调整（平台的数据中有的有横线，有的没有）
@property (nonatomic, copy) NSString *resourcesAddress;
@property (nonatomic, strong) NSArray *scale;
@property (nonatomic, strong) NSArray *rotate;
@property (nonatomic, strong) NSArray *offset;
@property (nonatomic, copy) NSString *dataSetCRS;
@property (nonatomic, assign) double dataSetCRSNorth;
@property (nonatomic, strong) NSArray *engineOrigin;
@property (nonatomic, copy) NSString *dataSetSGContent;
@property (nonatomic, assign) int dataSetType;
@property (nonatomic, assign) RECadUnitEm unit;// 单位 Meter：米 Centimeter：厘米 Millimeter：毫米 Kilometer：千米 Inch：英寸 Foot：英尺 Mile：英里
@property (nonatomic, assign) int terrainLayerLev;// 地形层级

@end

NS_ASSUME_NONNULL_END
