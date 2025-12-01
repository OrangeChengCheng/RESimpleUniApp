//
//  REDataSetUniData.m
//  REUniPluginModule
//
//  Created by Apple on 2024/8/29.
//

#import "REDataSetUniData.h"
#import "NSObject+YYModel.h"

@implementation REDataSetUniData

//重写初始化方法，附默认值
- (instancetype)init {
	self = [super init];
	if (self) {
		_type = 0; _dataSetId = @""; _dataSetId_noline = REEmptyStr; _resourcesAddress = @"";
		_scale = @[@1.0, @1.0, @1.0]; _rotate = @[@0.0, @0.0, @0.0, @1.0]; _offset = @[@0.0, @0.0, @0.0];
		_dataSetCRS = @""; _dataSetCRSNorth = 0; _engineOrigin = @[@0.0, @0.0, @0.0]; _dataSetSGContent = @"";
		_dataSetType = 0; _unit = CAD_UNIT_Mile; _terrainLayerLev = 0;
	}
	return self;
}


+ (NSDictionary *)modelCustomPropertyMapper {
	return @{
		@"unit": @"unit",
	};
}


// 重写该方法，实现自定义结构体属性的转换逻辑
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
	NSString *unitStr = dic[@"unit"];
	
	if (unitStr && [unitStr isKindOfClass:[NSString class]]) {
		self.unit = CAD_UNIT_Mile;
		if ([unitStr isEqual:@"CAD_UNIT_Meter"]) {
			self.unit = CAD_UNIT_Mile;
		} else if ([unitStr isEqual:@"CAD_UNIT_Centimeter"]) {
			self.unit = CAD_UNIT_Centimeter;
		} else if ([unitStr isEqual:@"CAD_UNIT_Millimeter"]) {
			self.unit = CAD_UNIT_Millimeter;
		} else if ([unitStr isEqual:@"CAD_UNIT_Kilometer"]) {
			self.unit = CAD_UNIT_Kilometer;
		} else if ([unitStr isEqual:@"CAD_UNIT_Inch"]) {
			self.unit = CAD_UNIT_Inch;
		} else if ([unitStr isEqual:@"CAD_UNIT_Foot"]) {
			self.unit = CAD_UNIT_Foot;
		} else if ([unitStr isEqual:@"CAD_UNIT_Mile"]) {
			self.unit = CAD_UNIT_Mile;
		}
	}
	return YES;
}



- (void)setDataSetId:(NSString *)dataSetId {
	_dataSetId = dataSetId;
	if (dataSetId && ![dataSetId isKindOfClass:[NSNull class]] && dataSetId.length > 0) {
		self.dataSetId_noline = [dataSetId stringByReplacingOccurrencesOfString:@"-" withString:@""];
	} else {
		self.dataSetId_noline = @""; // 空值时赋空字符串，避免野指针
	}
}


- (void)setDataSetSGContent:(NSString *)dataSetSGContent {
	_dataSetSGContent = @"";
}


@end
