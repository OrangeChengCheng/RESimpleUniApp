//
//  REMonomerUniData.h
//  REUniPluginModule
//
//  Created by Apple on 2026/1/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface REMonomerUniData : NSObject

@property (nonatomic, copy) NSString *monomerId;
@property (nonatomic, copy) NSString *dataSetId;
@property (nonatomic, assign) float heightMin;
@property (nonatomic, assign) float heightMax;
@property (nonatomic, strong) NSArray<NSNumber *> *faceClr;
@property (nonatomic, strong) NSArray<NSNumber *> *lineClr;
@property (nonatomic, assign) int showState;
@property (nonatomic, strong) NSArray<NSArray<NSArray<NSNumber *> *> *> *rgnList;

@end

NS_ASSUME_NONNULL_END
