//
//  RETestView.m
//  RETestUniPlugin
//
//  Created by Apple on 2023/12/20.
//

#import "RETestView.h"

@implementation RETestView


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	for (UITouch *touch in touches) {
		NSLog(@"%@ touchesBegan *** touch._timestamp: %f  \n", NSStringFromClass([self class]), touch.timestamp);
	}
	NSLog(@"%@ touchesBegan *** event._timestamp: %f  \n", NSStringFromClass([self class]), event.timestamp);
	NSTimeInterval beginTime = [[NSDate date] timeIntervalSince1970] * 1000;
	NSLog(@"touchesBegan --- beginTime:%f \n", beginTime);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	for (UITouch *touch in touches) {
		NSLog(@"%@ touchesEnded *** touch._timestamp: %f  \n", NSStringFromClass([self class]), event.timestamp);
	}
	NSLog(@"%@ touchesEnded *** event._timestamp: %f  \n", NSStringFromClass([self class]), event.timestamp);
	NSTimeInterval endTime = [[NSDate date] timeIntervalSince1970] * 1000;
	NSLog(@"touchesBegan --- endTime:%f \n", endTime);
}


@end
