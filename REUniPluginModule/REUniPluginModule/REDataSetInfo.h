//
//  REDataSetInfo.h
//  REUniPluginModule
//
//  Created by Apple on 2024/8/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface REDataSetInfo : NSObject

@property (nonatomic, assign) int type;// 0:模型  13：遥感影像 10：WMTS工程  11：OSGB工程  14：360全景图  15：点云工程  16：CAD图纸  20：矢量数据
@property (nonatomic, copy) NSString *dataSetId;
@property (nonatomic, copy) NSString *resourcesAddress;
@property (nonatomic, strong) NSArray *scale;
@property (nonatomic, strong) NSArray *rotate;
@property (nonatomic, strong) NSArray *offset;
@property (nonatomic, copy) NSString *dataSetCRS;
@property (nonatomic, assign) double dataSetCRSNorth;
@property (nonatomic, copy) NSString *dataSetSGContent;

@end

NS_ASSUME_NONNULL_END
