//
//  REEngineVC.m
//  RETestUniPlugin
//
//  Created by Apple on 2023/11/23.
//

#import "REEngineVC.h"
#import "BlackHole3D.h"
#import "Masonry.h"
#import "REUniClass.h"
#import "RELoadingView.h"
#import "RETip.h"
#import "RENav.h"
#import "REQRCode.h"
#import "REModule.h"
#import "REWebVC.h"

static CGFloat stateBarHeight = 0.0;

@interface REEngineVC ()
@property (nonatomic, strong) RELoadingView *loadingView;
@property (nonatomic, strong) RENav *re_nav;

@end

@implementation REEngineVC
- (RELoadingView *)loadingView {
	if (!_loadingView) {
		_loadingView = [RELoadingView initWithFrame:self.view.bounds];
		WEAKSELF
		_loadingView.cancelCallBack = ^{
			STRONGSELF
			[strongSelf endRenderAndExit];
		};
	}
	return _loadingView;
}

- (RENav *)re_nav {
	if (!_re_nav) {
		_re_nav = [RENav initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, CGRectGetWidth(self.view.bounds), stateBarHeight + kNavBarHeight) title:self.projName];
		_re_nav.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		WEAKSELF
		_re_nav.backCallBack = ^{
			STRONGSELF
			[strongSelf endRenderAndExit];
		};
		_re_nav.qrCodeCallBack = ^{
			STRONGSELF
//			[REQRCode showQRCode:strongSelf.shareUrl name:strongSelf.projName];
			[REModule sendMessage:REModuleMsg_T1 message:@"Hello from ActivityA to ClassB" completion:^(NSString * _Nonnull response) {
				NSLog(@"*****************   %@", response);
			}];
		};
	}
	return _re_nav;
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
	return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
	return false;
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self loadDataSet];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.view.backgroundColor = [UIColor whiteColor];
	stateBarHeight = kStatusBarHeight;
	
	[self addReaderView];
	
	[self.view addSubview:self.re_nav];
	
	[self.view addSubview:self.loadingView];
	[self.loadingView showLoading];
	
	WEAKSELF
	[[BlackHole3D sharedSingleton] dataSetLoadProgress:^(float progress, NSString * _Nullable info) {
		STRONGSELF
		strongSelf.loadingView.loadingProgress.progress = progress / 100.0;
	}];
	[[BlackHole3D sharedSingleton] systemUIEvent:^(NSString * _Nullable btnName, int btnState) {
		STRONGSELF
		NSLog(@"btnName = %@  btnState = %d", btnName, btnState);
		RETip_Level level = RETip_L0;
		if ([btnName isEqualToString:@"BuiltIn_Btn_MainView"] || [btnName isEqualToString:@"BuiltIn_Btn_PickClipPlane"]) {
			level = RETip_L1;
		} else {
			level = RETip_L2;
		}
		if (([btnName isEqualToString:@"BuiltIn_Btn_PickClipPlane"] && btnState == 1)) {
			[RETip showTipStaticAnimte:strongSelf.view message:@"请在场景中选择剖切基点" level:level];
		}
//		if (([btnName isEqualToString:@"BuiltIn_Btn_MainView"] && btnState == 0)) {
//			[RETip showTipStaticAnimte:strongSelf.view message:@"主视图" level:level];
//		}
//		if (([btnName isEqualToString:@"BuiltIn_Btn_SelElem"] && btnState == 1)) {
//			[RETip showTipStaticAnimte:strongSelf.view message:@"选择模式" level:level];
//		}
//		if (([btnName isEqualToString:@"BuiltIn_Btn_Measure"] && btnState == 1)) {
//			[RETip showTipStaticAnimte:strongSelf.view message:@"测量" level:level];
//		}
//		if (([btnName isEqualToString:@"BuiltIn_Btn_More"] && btnState == 1)) {
//			[RETip showTipStaticAnimte:strongSelf.view message:@"更多" level:level];
//		}
	}];
}

//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
//	[super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
//	
//	UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
//	[coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
//		// 在动画过程中执行布局更改
//		if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) {
//			_re_nav.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, CGRectGetWidth(self.view.bounds), kNavBarHeight);
//			_customView.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y + kNavBarHeight, CGRectGetWidth(self.view.bounds), (CGRectGetHeight(self.view.bounds) - kNavBarHeight));
//		} else if (orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationPortraitUpsideDown) {
//			_re_nav.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, CGRectGetWidth(self.view.bounds), stateBarHeight + kNavBarHeight);
//			self.customView.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y + stateBarHeight + kNavBarHeight, CGRectGetWidth(self.view.bounds), (CGRectGetHeight(self.view.bounds) - kNavBarHeight - stateBarHeight));
//		}
//		
//	} completion:nil];
//}

- (void)addReaderView {
	[self changeEngineUI];
//	if (!self.isUniAppComp) [self addBtn];
//	[self addBtn];
}

#pragma mark - 创建显示界面
- (void)changeEngineUI {
	// 创建自定义界面
	self.customView = [[UIView alloc] init];
	self.customView.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y + stateBarHeight + kNavBarHeight, CGRectGetWidth(self.view.bounds), (CGRectGetHeight(self.view.bounds) - kNavBarHeight - stateBarHeight));
	[self.view addSubview:self.customView];
	self.customView.clipsToBounds = YES;
	self.customView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;

	[[BlackHole3D sharedSingleton] getRenderView].frame = self.customView.bounds;
	[self.customView addSubview:[[BlackHole3D sharedSingleton] getRenderView]];
}


- (void)addBtn {
	UIView *backView = [[UIView alloc] init];
	[self.customView addSubview:backView];
	[backView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(14 + kStatusBarHeight);
		make.left.mas_equalTo(20);
		make.width.mas_equalTo(60.0);
		make.height.mas_equalTo(60.0);
	}];
	
	UIImageView *backIV = [[UIImageView alloc] init];
	backIV.image = [UIImage imageNamed:@"icon_back_circle.png" inBundle:REUniPluginModule_bundle compatibleWithTraitCollection:nil];
	[backView addSubview:backIV];
	[backIV mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(0);
		make.left.mas_equalTo(0);
		make.width.mas_equalTo(52.0);
		make.height.mas_equalTo(52.0);
	}];
	
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
	[btn setTitle:@"" forState:UIControlStateNormal];
	[backView addSubview:btn];
	[btn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.right.bottom.left.equalTo(backView);
	}];
	[btn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)backBtnAction:(UIButton *)sender {
//	[self endRenderAndExit];
	NSLog(@"");
	REWebVC *webVC = [[REWebVC alloc] init];
//	webVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
//	UIWindow *currWindow = [UIApplication sharedApplication].keyWindow;
	[self presentViewController:webVC animated:YES completion:nil];
}


- (void)endRenderAndExit {
	[[BlackHole3D sharedSingleton].Graphics setSysUIPanelVisible:NO];//关闭ui方式重新加载项目的时候先加载出来
	[[BlackHole3D sharedSingleton] setViewMode:BIM viewport1:None screenMode:Single];
	// 卸载所有场景
	if (self.shareType == 1 && [self.shareDataType isEqual:@"Cad"]) {
		[[BlackHole3D sharedSingleton].CAD unloadCAD];
	} else {
		[[BlackHole3D sharedSingleton].Model unloadAllDataSet];
	}
	double delayInSeconds = 0.15;
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
	dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
		// 界面移除
		if (self.isUniAppComp) {
			if ([self.delegate respondsToSelector:@selector(exitRenderCallback:)]) {
				[self.delegate exitRenderCallback:YES];
			}
		} else {
			// 界面移除
			[self.customView removeFromSuperview];
			[[BlackHole3D sharedSingleton] endRender];
			[self dismissViewControllerAnimated:YES completion:^{
				UINavigationController *rootC = [UIApplication sharedApplication].keyWindow.rootViewController;
				UIViewController *currentViewController = rootC.visibleViewController;
				[currentViewController setNeedsStatusBarAppearanceUpdate];
			}];
		}
	});
}




#pragma mark - 模型加载
- (void)loadDataSet {
	if (self.worldCRS.length > 0) {
		[[BlackHole3D sharedSingleton].Coordinate setEngineWorldCRS:self.worldCRS];
	}
	
	// 设置渲染模式
	if (self.shareViewMode.length > 0 && [self.shareViewMode isEqual:@"Sphere"]) {
		[[BlackHole3D sharedSingleton].Common setFakeSphMode:YES];
	} else {
		[[BlackHole3D sharedSingleton].Common setFakeSphMode:NO];
	}

	if (self.shareType == 1) {
		if ([self.shareDataType isEqual:@"Bim"]
			|| [self.shareDataType isEqual:@"Rs"]
			|| [self.shareDataType isEqual:@"Wmts"]
			|| [self.shareDataType isEqual:@"Osgb"]
			|| [self.shareDataType isEqual:@"PointCloud"]) {
			[self loadBim];
		} else if ([self.shareDataType isEqual:@"Cad"]) {
			[self loadCad];
		} else {
			[self endRenderAndExit];
		}
	} else {
		if (self.defaultCamLoc && self.defaultCamLoc.force) {
			[[BlackHole3D sharedSingleton].Camera setCamForcedInitLoc:self.defaultCamLoc];
		}
		[self loadBim];
	}
	
	[[BlackHole3D sharedSingleton].Common setExpectMaxInstDrawFaceNum:self.maxInstDrawFaceNum];
}


- (void)loadBim {
	//加载场景
	NSMutableArray *dataSetList_temp = [NSMutableArray array];
	for (REDataSetInfo *dataSetInfo in self.dataSetList) {
		REDataSet *dataSet = [[REDataSet alloc] init];
		dataSet.dataSetId = dataSetInfo.dataSetId;
		dataSet.resourcesAddress = dataSetInfo.resourcesAddress;
		dataSet.scale = REDVec3Make([dataSetInfo.scale[0] doubleValue], [dataSetInfo.scale[1] doubleValue], [dataSetInfo.scale[2] doubleValue]);
		dataSet.rotate = REDVec4Make([dataSetInfo.rotate[0] doubleValue], [dataSetInfo.rotate[1] doubleValue], [dataSetInfo.rotate[2] doubleValue], [dataSetInfo.rotate[3] doubleValue]);
		dataSet.offset = REDVec3Make([dataSetInfo.offset[0] doubleValue], [dataSetInfo.offset[1] doubleValue], [dataSetInfo.offset[2] doubleValue]);
		dataSet.dataSetCRS = dataSetInfo.dataSetCRS;
		dataSet.dataSetCRSNorth = dataSetInfo.dataSetCRSNorth;
		dataSet.engineOrigin = REDVec3Make([dataSetInfo.engineOrigin[0] doubleValue], [dataSetInfo.engineOrigin[1] doubleValue], [dataSetInfo.engineOrigin[2] doubleValue]);
		dataSet.dataSetSGContent = dataSetInfo.dataSetSGContent;
		[dataSetList_temp addObject:dataSet];
	}
	if (!self.dataSetList.count) {
		REDataSet *dataSet = [REDataSet initModel:@"res_jifang" resourcesAddress:@"https://demo.bjblackhole.com/default.aspx?dir=url_res03&path=7624a001668d4e5495f101da54d3bee0"];
		[dataSetList_temp addObject:dataSet];
	}
	
	[[BlackHole3D sharedSingleton] startRender];
	[[BlackHole3D sharedSingleton] setViewMode:BIM viewport1:None screenMode:Single];
	WEAKSELF
	[[BlackHole3D sharedSingleton].Model loadDataSet:dataSetList_temp clearLoaded:YES callBack:^(BOOL success) {
		STRONGSELF
		if (strongSelf.isUniAppComp) {
			if ([strongSelf.delegate respondsToSelector:@selector(loadDataSetFinishCallback:)]) {
				[strongSelf.delegate loadDataSetFinishCallback:success];
			}
		} else {
			if (success) {
				if (![[BlackHole3D sharedSingleton].Model getAllDataSetReady]) return;
				[[BlackHole3D sharedSingleton].Graphics setSysUIPanelVisible:YES];
				if (strongSelf.shareType == 2 && strongSelf.camDefaultDataSetId.length > 0 && (!strongSelf.defaultCamLoc || !strongSelf.defaultCamLoc.force)) {
					[[BlackHole3D sharedSingleton].Camera setCamLocateToDataSet:strongSelf.camDefaultDataSetId backDepth:1.0];
				}
				// 处理地形数据层级
				for (REDataSetInfo *dataSetInfo in strongSelf.dataSetList) {
					if (dataSetInfo.terrainLayerLev > 0) {
						NSArray *unitIDs = [[BlackHole3D sharedSingleton].Terrain getAllUnitNames:dataSetInfo.dataSetId];
						NSString *unitID = unitIDs.count > 0 ? unitIDs.firstObject : @"";
						[[BlackHole3D sharedSingleton].Terrain setUnitLayerlev:dataSetInfo.dataSetId unitId:unitID resType:RETerrResEm_ALL layerLev:dataSetInfo.terrainLayerLev];
					}
				}
				[strongSelf addEntity];
				[strongSelf addWater];
				[strongSelf addExtrude];
				[strongSelf.loadingView hiddenLoading];
			} else {
				[REModule sendMessage:REModuleMsg_T2 message:@"模型资源加载失败！" completion:^(NSString * _Nonnull response) {
					NSLog(@"*****************   %@", response);
				}];
				[strongSelf endRenderAndExit];
			}
		}
	}];
}


#pragma mark - CAD加载
- (void)loadCad {
	REDataSetInfo *dataSetInfo = self.dataSetList.firstObject;
	
	[[BlackHole3D sharedSingleton] startRender];
	[[BlackHole3D sharedSingleton] setViewMode:CAD viewport1:None screenMode:Single];
	WEAKSELF
	[[BlackHole3D sharedSingleton].CAD loadCAD:dataSetInfo.resourcesAddress unit:dataSetInfo.unit scale:1.0 callBack:^(BOOL success) {
		STRONGSELF
		if (success) {
			[strongSelf.loadingView hiddenLoading];
			[[BlackHole3D sharedSingleton].Graphics setSysUIPanelVisible:NO];
		} else {
			[REModule sendMessage:REModuleMsg_T2 message:@"模型资源加载失败！" completion:^(NSString * _Nonnull response) {
				NSLog(@"*****************   %@", response);
			}];
			[strongSelf endRenderAndExit];
		}
	}];
}




#pragma mark - 单构件加载
- (void)addEntity {
	if (!self.entityList || !self.entityList.count) {
		return;
	}
	NSMutableArray *re_entityList = [NSMutableArray array];
	for (REEntityUniData *entityInfo in self.entityList) {
		REEntityInfo *entity = [[REEntityInfo alloc] init];
		entity.dataSetId = entityInfo.dataSetId;
		entity.entityType = entityInfo.entityType;
		entity.dataSetCRS = entityInfo.dataSetCRS;
		entity.elemId = entityInfo.elemId;
		entity.scale = REDVec3Make([entityInfo.scale[0] doubleValue], [entityInfo.scale[1] doubleValue], [entityInfo.scale[2] doubleValue]);
		entity.rotate = REDVec4Make([entityInfo.rotate[0] doubleValue], [entityInfo.rotate[1] doubleValue], [entityInfo.rotate[2] doubleValue], [entityInfo.rotate[3] doubleValue]);
		entity.offset = REDVec3Make([entityInfo.offset[0] doubleValue], [entityInfo.offset[1] doubleValue], [entityInfo.offset[2] doubleValue]);
		[re_entityList addObject:entity];
	}
	[[BlackHole3D sharedSingleton].Entity enterEditMode];
	[[BlackHole3D sharedSingleton].Entity addEntities:re_entityList callBack:^(BOOL success) {
		NSLog(@"add entity success: %d", success);
	}];
	[[BlackHole3D sharedSingleton].Entity exitEditMode];
}



#pragma mark - 水面加载
- (void)addWater {
	if (!self.waterList || !self.waterList.count) {
		return;
	}
	
	NSMutableArray *re_waterList = [NSMutableArray array];
	for (REWaterUniData *waterInfo in self.waterList) {
		NSMutableArray *rgnList = [NSMutableArray array];
		RECornerRgnUniData *uni_cornerRgnInfo = waterInfo.rgnList.firstObject;
		RECornerRgnInfo *cornerRgnInfo = [[RECornerRgnInfo alloc] init];
		NSMutableArray *potList = [NSMutableArray array];
		for (NSArray<NSNumber *> *pot in uni_cornerRgnInfo.pointList) {
			[potList addObject:[REPoint3D initDvec3:[RETool arrtToDVec3:pot]]];
		}
		cornerRgnInfo.pointList = potList;
		cornerRgnInfo.indexList = uni_cornerRgnInfo.indexList;
		[rgnList addObject:cornerRgnInfo];
		
		REWaterInfo *re_waterInfo = [[REWaterInfo alloc] init];
		re_waterInfo.waterName = waterInfo.waterName;
		re_waterInfo.waterClr = [RETool arrtToColor:waterInfo.waterClr];
		re_waterInfo.blendDist = waterInfo.blendDist;
		re_waterInfo.visible = waterInfo.visible;
		re_waterInfo.visDist = waterInfo.visDist;
		re_waterInfo.depthBias = waterInfo.depthBias;
		re_waterInfo.expandDist = waterInfo.expandDist;
		re_waterInfo.rgnList = rgnList;
		
		[re_waterList addObject:re_waterInfo];
	}
	[[BlackHole3D sharedSingleton].Water setData:re_waterList];
}



#pragma mark - 挤出加载
- (void)addExtrude {
	if (!self.extrudeList || !self.extrudeList.count) {
		return;
	}
	
	NSMutableArray *re_extrudeList = [NSMutableArray array];
	for (REExtrudeUniData *extrudeInfo in self.extrudeList) {
		NSMutableArray *rgnList = [NSMutableArray array];
		NSMutableArray *potList = [NSMutableArray array];
		NSArray *uni_cornerRgnInfo = extrudeInfo.rgnList.firstObject;
		for (NSArray<NSNumber *> *pot in uni_cornerRgnInfo) {
			[potList addObject:[REPoint3D initDvec3:[RETool arrtToDVec3:pot]]];
		}
		[rgnList addObject:potList];
		
		REExtrudeInfo *re_extrudeInfo = [[REExtrudeInfo alloc] init];
		re_extrudeInfo.extrudeId = extrudeInfo.extrudeId;
		re_extrudeInfo.dataSetIdList = extrudeInfo.dataSetIdList;
		re_extrudeInfo.depthLimitRange = [RETool arrtToDVec2:extrudeInfo.depthLimitRange];
		re_extrudeInfo.type = extrudeInfo.type;
		re_extrudeInfo.texId = extrudeInfo.texId;
		re_extrudeInfo.texPath = extrudeInfo.texPath;
		re_extrudeInfo.texSize = [RETool arrtToDVec2:extrudeInfo.texSize];
		re_extrudeInfo.rgnList = rgnList;
		
		[re_extrudeList addObject:re_extrudeInfo];
	}
	[[BlackHole3D sharedSingleton].Extrude setData:re_extrudeList];
}





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
