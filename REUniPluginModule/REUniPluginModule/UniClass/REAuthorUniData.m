//
//  REAuthorUniData.m
//  REUniPluginModule
//
//  Created by Apple on 2025/12/10.
//

#import "REAuthorUniData.h"

@implementation REAuthorUniData

- (instancetype)init {
	self = [super init];
	if (self) {
		_isMinio = NO;
		_resMode = REEmptyStr; _commonUrl = REEmptyStr; _resourcesAddress = REEmptyStr;
		_authorTxt = REEmptyStr; _authorRes = REEmptyStr; _authorIndex = REEmptyStr;
		_authorTxtId = REEmptyStr; _authorIndexId = REEmptyStr;
	}
	return self;
}

@end
