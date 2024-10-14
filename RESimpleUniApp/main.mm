//
//  main.m
//  RESimpleUniApp
//
//  Created by Apple on 2024/8/29.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

//int main(int argc, char * argv[])
//{
//	_uniArgc = argc;
//	_uniArgv = argv;
//	@autoreleasepool {
//		return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
//	}
//}


#import <UIKit/UIKit.h>
#import "SDL2/SDL.h"

extern SDLMAIN_DECLSPEC int SDL_main(int argc, char * argv[]) {
	_uniArgc = argc;
	_uniArgv = argv;
	return 0;
}
