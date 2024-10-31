//
//  REModule.m
//  RETestUniPlugin
//
//  Created by Apple on 2023/11/23.
//

#import "REModule.h"
#import "REEngineVC.h"
#import "BlackHole3D.h"
#import <objc/runtime.h>
#import "YYModel.h"
#import "REDataSetInfo.h"

@implementation REModule

// 通过宏 UNI_EXPORT_METHOD 将异步方法暴露给 js 端
UNI_EXPORT_METHOD(@selector(realEngineRender:callback:))

/// 异步方法（注：异步方法会在主线程（UI线程）执行）
/// @param options js 端调用方法时传递的参数
/// @param callback 回调方法，回传参数给 js 端
- (void)realEngineRender:(NSDictionary *)options callback:(UniModuleKeepAliveCallback)callback {
	// options 为 js 端调用此方法时传递的参数
	NSLog(@"realEngineRender : %@",options);
	
	// 可以在该方法中实现原生能力，然后通过 callback 回调到 js
	
	NSArray *list = [NSArray yy_modelArrayWithClass:REDataSetInfo.class json:options[@"dataSetList"]];
	id maxInstDrawFaceNum = [options objectForKey:@"maxInstDrawFaceNum"];
	id shareUrl = [options objectForKey:@"shareUrl"];
	id projName = [options objectForKey:@"projName"];
	id worldCRS = [options objectForKey:@"worldCRS"];
	id shareType = [options objectForKey:@"shareType"];
	id camDefaultDataSetId = [options objectForKey:@"camDefaultDataSetId"];
	id shareViewMode = [options objectForKey:@"shareViewMode"];
	id shareDataType = [options objectForKey:@"shareDataType"];
	id defaultCamLoc = [options objectForKey:@"defaultCamLoc"];
	
	REEngineVC *engineVC = [[REEngineVC alloc] init];
	engineVC.dataSetList = list;
	engineVC.maxInstDrawFaceNum = maxInstDrawFaceNum ?  [options[@"maxInstDrawFaceNum"] intValue] : 1500000;
	engineVC.shareUrl = shareUrl ? [options[@"shareUrl"] stringValue] : @"";
	engineVC.projName = projName ? [options[@"projName"] stringValue] : @"";
	engineVC.worldCRS = worldCRS ? [options[@"worldCRS"] stringValue] : @"";
	engineVC.shareType = shareType ?  [options[@"shareType"] intValue] : 0;
	engineVC.camDefaultDataSetId = camDefaultDataSetId ? [options[@"camDefaultDataSetId"] stringValue] : @"";
	engineVC.shareViewMode = shareViewMode ? [options[@"shareViewMode"] stringValue] : @"";
	engineVC.shareDataType = shareDataType ? [options[@"shareDataType"] stringValue] : @"";
	if (defaultCamLoc && [(NSDictionary *)defaultCamLoc allKeys].count > 0) {
		REForceCamLoc *forceCamLoc = [REForceCamLoc yy_modelWithDictionary:options[@"defaultCamLoc"]];
		forceCamLoc.force = YES;
		engineVC.defaultCamLoc = forceCamLoc;
	}
	engineVC.isUniAppComp = NO;
	engineVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
	UIWindow *currWindow = [UIApplication sharedApplication].keyWindow;
	[currWindow.rootViewController presentViewController:engineVC animated:YES completion:nil];
	

	// 回调方法，传递参数给 js 端 注：只支持返回 String 或 NSDictionary (map) 类型
	if (callback) {
		// 第一个参数为回传给js端的数据，第二个参数为标识，表示该回调方法是否支持多次调用，如果原生端需要多次回调js端则第二个参数传 YES;
		callback(@"success",NO);
	}
}



// 通过宏 UNI_EXPORT_METHOD 将异步方法暴露给 js 端
UNI_EXPORT_METHOD(@selector(unipluginLog:))

/// 异步方法（注：异步方法会在主线程（UI线程）执行）
/// @param options js 端调用方法时传递的参数
- (void)unipluginLog:(NSDictionary *)options {
	// options 为 js 端调用此方法时传递的参数
	NSLog(@"************* uni-app ->   %@", options);
}



// 通过宏 UNI_EXPORT_METHOD 将异步方法暴露给 js 端
UNI_EXPORT_METHOD(@selector(showEngineRender:callback:))

/// 异步方法（注：异步方法会在主线程（UI线程）执行）
/// @param options js 端调用方法时传递的参数
/// @param callback 回调方法，回传参数给 js 端
- (void)showEngineRender:(NSDictionary *)options callback:(UniModuleKeepAliveCallback)callback {
	// options 为 js 端调用此方法时传递的参数
	NSLog(@"showEngineRender : %@",options);
	
	// 可以在该方法中实现原生能力，然后通过 callback 回调到 js
	
	
	REEngineVC *engineVC = [[REEngineVC alloc] init];
	engineVC.isUniAppComp = NO;
	engineVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
	UIWindow *currWindow = [UIApplication sharedApplication].keyWindow;
	[currWindow.rootViewController presentViewController:engineVC animated:YES completion:nil];
	

	// 回调方法，传递参数给 js 端 注：只支持返回 String 或 NSDictionary (map) 类型
	if (callback) {
		// 第一个参数为回传给js端的数据，第二个参数为标识，表示该回调方法是否支持多次调用，如果原生端需要多次回调js端则第二个参数传 YES;
		callback(@"success",NO);
	}
}



UNI_EXPORT_METHOD(@selector(reUniAppBridge:callback:))
- (void)reUniAppBridge:(NSDictionary *)options callback:(UniModuleKeepAliveCallback)callback {
	// options 为 js 端调用此方法时传递的参数
	
	NSString *jsonString = @"{\"funcType\":\"\",\"funcName\":\"systemSelElement\",\"funcParams\":[\"RESystemSelElementBlock\"]}";
	NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
	NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
	options = dictionary;
	
	NSLog(@"reUniAppBridge : %@",options);
	
	if (!options) {
		if (callback) {
			callback(@{@"success":@(0), @"errMsg":@"方法调用异常，请检查参数是否正确"}, YES);
		}
		return;
	}
	
	// 方法映射（由于oc是强类型语言，js是弱类型语言，暂时只能一一对应，无法用运行时进行反射，主要原因在于有结构体、自定义对象、基本数据类型等各种类型参数，js没有类型对应）
	
	// 创建 BlackHole 实例
	id funcType_obj = [self getREType:options[@"funcType"]];
	
	// 获取 BlackHole对应类型的 类的方法列表
	unsigned int methodCount;
	Method *methods = class_copyMethodList([funcType_obj class], &methodCount);
	// 判断方法列表是否存在
	if (methods) {
		// 要查找的方法名前缀
		NSString *methodNamePrefix = options[@"funcName"];
		
		// 遍历方法列表，查找符合条件的方法并调用
		for (unsigned int i = 0; i < methodCount; i++) {
			Method method = methods[i];
			SEL method_selector = method_getName(method);
			const char *methodNameString = sel_getName(method_selector);
			NSString *methodNameStr = [NSString stringWithUTF8String:methodNameString];
			
			id tran_obj = NULL;
			// 假设你要调用的方法名包含指定的前缀
			if ([methodNameStr hasPrefix:methodNamePrefix]) {
				// 获取方法签名类
				NSMethodSignature *method_signature = [funcType_obj methodSignatureForSelector:method_selector];
				// 创建 NSInvocation 对象
				NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:method_signature];
				// 设置消息接受者
				[invocation setTarget:funcType_obj];
				// 设置方法选择器
				[invocation setSelector:method_selector];
				
				// 获取方法参数数量
				unsigned int numberOfArguments = method_getNumberOfArguments(method);
				// 获取参数信息
				NSArray *funcParams = options[@"funcParams"];
				if (funcParams.count && numberOfArguments > 2) {
					// 遍历参数，从JSON中取值并设置到 NSInvocation
					for (unsigned int i = 2; i < numberOfArguments; i++) {
						const char *argumentType = [method_signature getArgumentTypeAtIndex:i];
						id jsonValue = funcParams[i - 2];
						
						if (jsonValue) {
							// 对参数类型进行适配
							if (strcmp(argumentType, @encode(int)) == 0) {
								int intValue = [jsonValue intValue];
								[invocation setArgument:&intValue atIndex:i];
							}
							else if (strcmp(argumentType, @encode(double)) == 0) {
								double doubleValue = [jsonValue doubleValue];
								[invocation setArgument:&doubleValue atIndex:i];
							}
							else if (strcmp(argumentType, @encode(float)) == 0) {
								float floatValue = [jsonValue floatValue];
								[invocation setArgument:&floatValue atIndex:i];
							}
							else if (strcmp(argumentType, @encode(BOOL)) == 0) {
								BOOL boolValue = [jsonValue boolValue];
								[invocation setArgument:&boolValue atIndex:i];
							}
							else if (strcmp(argumentType, @encode(REDVec2)) == 0) {
								REDVec2 dVec2Value = [RETool arrtToDVec2:jsonValue];
								tran_obj = [NSValue valueWithBytes:&dVec2Value objCType:@encode(REDVec2)];
								[invocation setArgument:&tran_obj atIndex:i];
							}
							else if (strcmp(argumentType, @encode(REDVec3)) == 0) {
								REDVec3 dVec3Value = [RETool arrtToDVec3:jsonValue];
								tran_obj = [NSValue valueWithBytes:&dVec3Value objCType:@encode(REDVec3)];
								[invocation setArgument:&tran_obj atIndex:i];
							}
							else if (strcmp(argumentType, @encode(REDVec4)) == 0) {
								REDVec4 dVec4Value = [RETool arrtToDVec4:jsonValue];
								tran_obj = [NSValue valueWithBytes:&dVec4Value objCType:@encode(REDVec4)];
								[invocation setArgument:&tran_obj atIndex:i];
							}
							else if (strcmp(argumentType, @encode(REIVec2)) == 0) {
								REIVec2 iVec2Value = [RETool arrtToIVec2:jsonValue];
								tran_obj = [NSValue valueWithBytes:&iVec2Value objCType:@encode(REIVec2)];
								[invocation setArgument:&tran_obj atIndex:i];
							}
							else if (strcmp(argumentType, @encode(REIVec4)) == 0) {
								REIVec4 iVec4Value = [RETool arrtToIVec4:jsonValue];
								tran_obj = [NSValue valueWithBytes:&iVec4Value objCType:@encode(REIVec4)];
								[invocation setArgument:&tran_obj atIndex:i];
							}
							else if (strcmp(argumentType, @encode(REFVec3)) == 0) {
								REFVec3 fVec3Value = [RETool arrtToFVec3:jsonValue];
								tran_obj = [NSValue valueWithBytes:&fVec3Value objCType:@encode(REFVec3)];
								[invocation setArgument:&tran_obj atIndex:i];
							}
							else if (strcmp(argumentType, @encode(REColor)) == 0) {
								REColor colorValue = [RETool arrtToColor:jsonValue];
								tran_obj = [NSValue valueWithBytes:&colorValue objCType:@encode(REColor)];
								[invocation setArgument:&tran_obj atIndex:i];
							}
							else if (strcmp(argumentType, @encode(REAABB_D)) == 0) {
								REAABB_D aabb_dValue = [RETool arrtToAABB_D:jsonValue];
								tran_obj = [NSValue valueWithBytes:&aabb_dValue objCType:@encode(REAABB_D)];
								[invocation setArgument:&tran_obj atIndex:i];
							}
							else if (strcmp(argumentType, @encode(id)) == 0) {
								// 处理自定义对象类型
								if ([jsonValue isKindOfClass:NSString.class]) {
									NSString *stringValue = jsonValue;
									[invocation setArgument:&stringValue atIndex:i];
								}
								else {
									tran_obj = [[self handleObj:options[@"funcType"] funcName:options[@"funcName"] jsonValue:jsonValue] yy_modelCopy];
									if (!tran_obj) {
										NSLog(@"第 %lu 参数类型异常", (unsigned long)(i - 1));
										return;
									}
									[invocation setArgument:&tran_obj atIndex:i];
								}
							}
							else if (strcmp(argumentType, @encode(RESystemSelElementBlock)) == 0) {
								// 处理回调类型
								tran_obj = [self handleCallback:options[@"funcType"] funcName:options[@"funcName"] callback:callback];
								[invocation setArgument:&tran_obj atIndex:i];
							}
//							else if (strcmp(argumentType, @encode(void (^)(NSString *result))) == 0) {
//								// 处理回调类型
//								void (^callback)(NSString *result) = ^(NSString *result) {
//									
//								};
//								[invocation setArgument:&callback atIndex:i];
//							}
							else {
								NSLog(@"第 %lu 参数类型异常", (unsigned long)(i - 1));
								return;
							}
						}
					}
				}
				
				// 反射 调用方法
				[invocation invoke];
				
				// 如果方法有返回值，获取返回值
				const char *returnType = [method_signature methodReturnType];
				if (strcmp(returnType, @encode(void)) != 0) {
					// 非 void 返回值，获取返回值
					if (strcmp(returnType, @encode(id)) == 0) {
						id __unsafe_unretained returnValue = nil;
						[invocation getReturnValue:&returnValue];
						NSLog(@"Method returned: %@", returnValue);
						if (callback) {
							// 将返回值转成 JSON 并传递
							NSString *obj_str = [returnValue yy_modelToJSONString];
							NSDictionary *resultDict = @{@"success":@(1), @"errMsg":@"", @"data":obj_str};
							NSString *resultString = [resultDict yy_modelToJSONString];
							callback(resultString, YES);
						}
					}
					else {
						id returnValue;
						if (strcmp(returnType, @encode(int)) == 0) {
							int intValue;
							[invocation getReturnValue:&intValue];
							returnValue = @(intValue);
						}
						else if (strcmp(returnType, @encode(double)) == 0) {
							double doubleValue;
							[invocation getReturnValue:&doubleValue];
							returnValue = @(doubleValue);
						}
						else if (strcmp(returnType, @encode(float)) == 0) {
							float floatValue;
							[invocation getReturnValue:&floatValue];
							returnValue = @(floatValue);
						}
						else if (strcmp(returnType, @encode(BOOL)) == 0) {
							BOOL boolValue;
							[invocation getReturnValue:&boolValue];
							returnValue = @(boolValue);
						}
						else if (strcmp(returnType, @encode(REDVec2)) == 0) {
							REDVec2 dVec2Value;
							[invocation getReturnValue:&dVec2Value];
							returnValue = [RETool dVec2ToArr:dVec2Value];
						}
						else if (strcmp(returnType, @encode(REDVec3)) == 0) {
							REDVec3 dVec3Value;
							[invocation getReturnValue:&dVec3Value];
							returnValue = [RETool dVec3ToArr:dVec3Value];
						}
						else if (strcmp(returnType, @encode(REDVec4)) == 0) {
							REDVec4 dVec4Value;
							[invocation getReturnValue:&dVec4Value];
							returnValue = [RETool dVec4ToArr:dVec4Value];
						}
						else if (strcmp(returnType, @encode(REIVec2)) == 0) {
							REIVec2 iVec2Value;
							[invocation getReturnValue:&iVec2Value];
							returnValue = [RETool iVec2ToArr:iVec2Value];
						}
						else if (strcmp(returnType, @encode(REIVec4)) == 0) {
							REIVec4 iVec4Value;
							[invocation getReturnValue:&iVec4Value];
							returnValue = [RETool iVec4ToArr:iVec4Value];
						}
						else if (strcmp(returnType, @encode(REFVec3)) == 0) {
							REFVec3 fVec3Value;
							[invocation getReturnValue:&fVec3Value];
							returnValue = [RETool fVec3ToArr:fVec3Value];
						}
						else if (strcmp(returnType, @encode(REColor)) == 0) {
							REColor colorValue;
							[invocation getReturnValue:&colorValue];
							returnValue = [RETool colorToArr:colorValue];
						}
						else if (strcmp(returnType, @encode(REAABB_D)) == 0) {
							REAABB_D aabb_dValue;
							[invocation getReturnValue:&aabb_dValue];
							returnValue = [RETool aabb_dToArr:aabb_dValue];
						}
						if (callback) {
							// 将返回值转成 JSON 并传递
							NSDictionary *resultDict = @{@"success":@(1), @"errMsg":@"", @"data":returnValue};
							NSString *resultString = [resultDict yy_modelToJSONString];
							callback(resultString, YES);
						}
					}
				}
				break;
			}
		}
		
		// 释放方法列表
		free(methods);
	} else {
		NSLog(@"Failed to retrieve method list");
		if (callback) {
			callback(@{@"success":@(0), @"errMsg":@"方法不存在"}, YES);
		}
	}
}

// 获取调用对象
- (id)getREType:(NSString *)funcType {
	if ([funcType isEqual:@"Common"]) {
		//公共模块（Common）
		return [BlackHole3D sharedSingleton].Common;
	}
	else if ([funcType isEqual:@"Model"]) {
		//模型加载（Model）
		return [BlackHole3D sharedSingleton].Model;
	}
	else if ([funcType isEqual:@"Camera"]) {
		//相机（Camera）
		return [BlackHole3D sharedSingleton].Camera;
	}
	else if ([funcType isEqual:@"BIM"]) {
		//BIM（BIM）
		return [BlackHole3D sharedSingleton].BIM;
	}
	else if ([funcType isEqual:@"CAD"]) {
		//CAD（CAD）
		return [BlackHole3D sharedSingleton].CAD;
	}
	else if ([funcType isEqual:@"Panorama"]) {
		//360全景（Panorama）
		return [BlackHole3D sharedSingleton].Panorama;
	}
	else if ([funcType isEqual:@"Grid"]) {
		//栅格（Grid）
		return [BlackHole3D sharedSingleton].Grid;
	}
	else if ([funcType isEqual:@"Anchor"]) {
		//锚点（Anchor）
		return [BlackHole3D sharedSingleton].Anchor;
	}
	else if ([funcType isEqual:@"Tag"]) {
		//标签（Tag）
		return [BlackHole3D sharedSingleton].Tag;
	}
	else if ([funcType isEqual:@"Probe"]) {
		//探测（Probe）
		return [BlackHole3D sharedSingleton].Probe;
	}
	else if ([funcType isEqual:@"Coordinate"]) {
		//坐标（Coordinate）
		return [BlackHole3D sharedSingleton].Coordinate;
	}
	else if ([funcType isEqual:@"SkyBox"]) {
		//天空盒（SkyBox）
		return [BlackHole3D sharedSingleton].SkyBox;
	}
	else if ([funcType isEqual:@"Graphics"]) {
		//图形显示（Graphics）
		return [BlackHole3D sharedSingleton].Graphics;
	}
	else if ([funcType isEqual:@"MiniMap"]) {
		//小地图（MiniMap）
		return [BlackHole3D sharedSingleton].MiniMap;
	}
	else {
		//引擎模块
		return [BlackHole3D sharedSingleton];
	}
}

// 处理对象参数
- (id)handleObj:(NSString *)funcType funcName:(NSString *)funcName jsonValue:(id)jsonValue  {
	if ([funcType isEqual:@"Common"]) {
		//公共模块（Common）
	}
	else if ([funcType isEqual:@"Model"]) {
		//模型加载（Model）
		if ([funcName isEqual:@"loadDataSet"]) {
			return [NSArray yy_modelArrayWithClass:[REDataSet class] json:jsonValue];
		}
	}
	else if ([funcType isEqual:@"Camera"]) {
		//相机（Camera）
	}
	else if ([funcType isEqual:@"BIM"]) {
		//BIM（BIM）
		if ([funcName isEqual:@"setElemsValidState"]) {
			return (NSArray *)jsonValue;
		}
		else if ([funcName isEqual:@"setElemAttr"]) {
			return [REElemAttr yy_modelWithJSON:jsonValue];
		}
		else if ([funcName isEqual:@"resetElemAttr"]) {
			return (NSArray *)jsonValue;
		}
		else if ([funcName isEqual:@"setSelElemsAttr"]) {
			return [RESelElemsAttr yy_modelWithJSON:jsonValue];
		}
		else if ([funcName isEqual:@"setSelElemsBlendAttr"]) {
			return [RESelElemsBlendAttr yy_modelWithJSON:jsonValue];
		}
	}
	else if ([funcType isEqual:@"CAD"]) {
		//CAD（CAD）
	}
	else if ([funcType isEqual:@"Panorama"]) {
		//360全景（Panorama）
	}
	else if ([funcType isEqual:@"Grid"]) {
		//栅格（Grid）
	}
	else if ([funcType isEqual:@"Anchor"]) {
		//锚点（Anchor）
	}
	else if ([funcType isEqual:@"Tag"]) {
		//标签（Tag）
	}
	else if ([funcType isEqual:@"Probe"]) {
		//探测（Probe）
	}
	else if ([funcType isEqual:@"Coordinate"]) {
		//坐标（Coordinate）
	}
	else if ([funcType isEqual:@"SkyBox"]) {
		//天空盒（SkyBox）
	}
	else if ([funcType isEqual:@"Graphics"]) {
		//图形显示（Graphics）
	}
	else if ([funcType isEqual:@"MiniMap"]) {
		//小地图（MiniMap）
	}
	return NULL;
}

// 处理回调参数
- (id)handleCallback:(NSString *)funcType funcName:(NSString *)funcName callback:(UniModuleKeepAliveCallback)callback {
	if ([funcType isEqual:@"Model"]) {
		//公共模块（Common）
	}
	else if ([funcType isEqual:@"CAD"]) {
		//CAD（CAD）
		if ([funcName isEqual:@"loadCAD"]) {
			RECADLoadFinish iosCallback = ^(BOOL success) {
				if (callback) {
					// 将返回值转成 JSON 并传递
					NSString *obj_str = [@{@"success":@(success)} yy_modelToJSONString];
					NSDictionary *resultDict = @{@"success":@(1), @"errMsg":@"", @"data":obj_str};
					NSString *resultString = [resultDict yy_modelToJSONString];
					callback(resultString, YES);
				}
			};
			return iosCallback;
		}
	}
	else {
		if ([funcName isEqual:@"systemSelElement"]) {
			RESystemSelElementBlock iosCallback = ^(BOOL probeValid) {
				if (callback) {
					// 将返回值转成 JSON 并传递
					NSString *obj_str = [@{@"probeValid":@(probeValid)} yy_modelToJSONString];
					NSDictionary *resultDict = @{@"success":@(1), @"errMsg":@"", @"data":obj_str};
					NSString *resultString = [resultDict yy_modelToJSONString];
					callback(resultString, YES);
				}
			};
			return iosCallback;
		}
	}
	return NULL;
}






// 通过宏 UNI_EXPORT_METHOD_SYNC 将同步方法暴露给 js 端
UNI_EXPORT_METHOD_SYNC(@selector(testSyncFunc:))

/// 同步方法（注：同步方法会在 js 线程执行）
/// @param options js 端调用方法时传递的参数
- (NSString *)testSyncFunc:(NSDictionary *)options {
	// options 为 js 端调用此方法时传递的参数
	NSLog(@"testSyncFunc : %@",options);

	/*
	 可以在该方法中实现原生功能，然后直接通过 return 返回参数给 js
	 */

	// 同步返回参数给 js 端 注：只支持返回 String 或 NSDictionary (map) 类型
	return @"success";
}






@end
