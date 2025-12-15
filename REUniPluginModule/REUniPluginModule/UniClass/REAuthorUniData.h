//
//  REAuthorUniData.h
//  REUniPluginModule
//
//  Created by Apple on 2025/12/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface REAuthorUniData : NSObject

@property (nonatomic, assign) BOOL isMinio;
@property (nonatomic, copy) NSString *resMode;
@property (nonatomic, copy) NSString *commonUrl;
@property (nonatomic, copy) NSString *resourcesAddress;
@property (nonatomic, copy) NSString *authorTxt;
@property (nonatomic, copy) NSString *authorRes;
@property (nonatomic, copy) NSString *authorIndex;
@property (nonatomic, copy) NSString *authorTxtId;
@property (nonatomic, copy) NSString *authorIndexId;

@end

NS_ASSUME_NONNULL_END
