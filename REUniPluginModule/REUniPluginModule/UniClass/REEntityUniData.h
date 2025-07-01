//
//  REEntityUniData.h
//  REUniPluginModule
//
//  Created by Apple on 2025/6/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface REEntityUniData : NSObject

@property (nonatomic, copy) NSString *dataSetId;
@property (nonatomic, copy) NSString *entityType;
@property (nonatomic, copy) NSString *dataSetCRS;
@property (nonatomic, assign) unsigned int elemId;
@property (nonatomic, strong) NSArray *scale;
@property (nonatomic, strong) NSArray *rotate;
@property (nonatomic, strong) NSArray *offset;

@end

NS_ASSUME_NONNULL_END
