//
//  REToolHandle.m
//  REUniPluginModule
//
//  Created by Apple on 2025/7/7.
//

#import "REToolHandle.h"
#import "BlackHole3D.h"
#import "REUniClass.h"

@implementation REToolHandle


+ (void)handleEngineSDK:(NSDictionary *)jsonObject msgWhere:(int)msgWhere {
	NSLog(@"jsonObject: %@", jsonObject);
	NSString *type = [[jsonObject objectForKey:@"type"] stringValue];
	NSDictionary *json_data = [jsonObject.allKeys containsObject:@"data"] ? [jsonObject objectForKey:@"data"] : nil;
	if (!json_data) {
		return;
	}
	
	if ([type isEqualToString:@"cloose"]) {
		
	}
}

@end
