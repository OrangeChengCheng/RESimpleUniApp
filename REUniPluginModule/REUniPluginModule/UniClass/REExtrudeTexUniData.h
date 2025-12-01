//
//  REExtrudeTexUniData.h
//  REUniPluginModule
//
//  Created by Apple on 2025/11/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface REExtrudeTexUniData : NSObject

@property (nonatomic, copy) NSString *picPath;
@property (nonatomic, strong) NSArray<NSNumber *> *picSize;
@property (nonatomic, assign) REDVec2 picSizeObj;
@property (nonatomic, copy) NSString *textureGuid;


@end

NS_ASSUME_NONNULL_END
