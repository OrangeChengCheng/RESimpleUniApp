//
//  RECamInfoUniData.h
//  REUniPluginModule
//
//  Created by Apple on 2025/7/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RECamInfoUniData : NSObject

@property (nonatomic, strong) NSArray *camPos;
@property (nonatomic, strong) NSArray *camRotate;
@property (nonatomic, strong) NSArray *camDir;
@property (nonatomic, assign) BOOL force;
@property (nonatomic, assign) double locDelay;
@property (nonatomic, assign) double locTime;

@end

NS_ASSUME_NONNULL_END
