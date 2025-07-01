//
//  REWaterUniData.h
//  REUniPluginModule
//
//  Created by Apple on 2025/7/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class RECornerRgnUniData;
@interface REWaterUniData : NSObject

@property (nonatomic, copy) NSString *waterName;
@property (nonatomic, strong) NSArray<NSNumber *> *waterClr;
@property (nonatomic, assign) float blendDist;
@property (nonatomic, assign) float expandDist;
@property (nonatomic, assign) float depthBias;
@property (nonatomic, assign) float visDist;
@property (nonatomic, assign) BOOL visible;
@property (nonatomic, strong) NSArray<RECornerRgnUniData *> *rgnList;

@end



@interface RECornerRgnUniData : NSObject

@property (nonatomic, strong) NSArray<NSArray<NSNumber *> *> *pointList;
@property (nonatomic, strong) NSArray<NSNumber *> *indexList;

@end



NS_ASSUME_NONNULL_END
