//
//  REUrlUniData.h
//  REUniPluginModule
//
//  Created by Apple on 2025/12/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface REUrlUniData : NSObject

@property (nonatomic, copy) NSString *urlWildcard;//表示要匹配的URL通配符
@property (nonatomic, copy) NSString *headerStr;//表示匹配的URL需要添加的自定义请求头 字符串

@end

NS_ASSUME_NONNULL_END
