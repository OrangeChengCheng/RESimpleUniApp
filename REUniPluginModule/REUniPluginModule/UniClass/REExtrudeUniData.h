//
//  REExtrudeUniData.h
//  REUniPluginModule
//
//  Created by Apple on 2025/7/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface REExtrudeUniData : NSObject

@property (nonatomic, copy) NSString *extrudeId;
@property (nonatomic, strong) NSArray<NSString *> *dataSetIdList;
@property (nonatomic, strong) NSArray<NSNumber *> *depthLimitRange;
@property (nonatomic, assign) int type;
@property (nonatomic, assign) int texId;
@property (nonatomic, copy) NSString *texPath;
@property (nonatomic, strong) NSArray<NSNumber *> *texSize;
@property (nonatomic, strong) NSArray<NSArray<NSArray<NSNumber *> *> *> *rgnList;

@end

NS_ASSUME_NONNULL_END
