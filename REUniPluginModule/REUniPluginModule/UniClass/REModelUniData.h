//
//  REModelUniData.h
//  REUniPluginModule
//
//  Created by Apple on 2025/7/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface REModelUniData : NSObject

@property (nonatomic, copy) NSString *dataSetId;
@property (nonatomic, strong) NSArray<NSNumber *> *elemIdList;
@property (nonatomic, strong) NSArray<NSNumber *> *elemClr;
@property (nonatomic, assign) BOOL visible;
@property (nonatomic, assign) int alpha;


@end

NS_ASSUME_NONNULL_END
