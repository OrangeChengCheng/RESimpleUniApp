//
//  REUrlUniData.m
//  REUniPluginModule
//
//  Created by Apple on 2025/12/1.
//

#import "REUrlUniData.h"

@implementation REUrlUniData

- (instancetype)init {
	self = [super init];
	if (self) {
		_urlWildcard = REEmptyStr; _headerStr = REEmptyStr;
	}
	return self;
}

@end
