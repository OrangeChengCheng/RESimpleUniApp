//
//  AppDelegate.h
//  Pandora
//
//  Created by Mac Pro_C on 12-12-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "REAppDelegate.h"
extern int _uniArgc;
extern char** _uniArgv;
@interface AppDelegate : REAppDelegate
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *rootViewController;
@end
