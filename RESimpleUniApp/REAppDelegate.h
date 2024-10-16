//
//  REAppDelegate.h
//  IOSApp
//
//  Created by Lemon on 2022/11/27.
//

#import <UIKit/UIKit.h>
#include "SDL2/uikit/SDL_uikitappdelegate.h"

NS_ASSUME_NONNULL_BEGIN


@interface REAppDelegate : SDLUIKitDelegate

@property (nonatomic, strong) UIWindow *window;


@end

NS_ASSUME_NONNULL_END
