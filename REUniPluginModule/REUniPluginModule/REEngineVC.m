//
//  REEngineVC.m
//  RETestUniPlugin
//
//  Created by Apple on 2023/11/23.
//

#import "REEngineVC.h"
#import "BlackHole3D.h"
#import "REUniClass.h"
#import "REAppUIClass.h"
#import "REToolHandle.h"
#import "REModule.h"
#import "REToolClass.h"

static CGFloat stateBarHeight = 0.0;

@interface REEngineVC ()<REWebViewManagerDelegate>
@property (nonatomic, strong) RELoadingView *loadingView;
@property (nonatomic, strong) RENav *re_nav;
@property (nonatomic, strong) REBtnPlane *re_btnPlane;

@property (nonatomic, strong) REWebPopData *currWebPop;
@property (nonatomic, strong) NSMutableDictionary *curSelProInfo;
@property (nonatomic, assign) BOOL currIsRoomClip;


@end


@implementation REEngineVC

#pragma mark - 对象初始化

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
		_re_nav = [RENav initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, CGRectGetWidth(self.view.bounds), stateBarHeight + kNavBarHeight) title:self.sceneUniData.projName];
		_re_nav.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		WEAKSELF
		_re_nav.backCallBack = ^{
			STRONGSELF
			[strongSelf endRenderAndExit];
		};
		_re_nav.qrCodeCallBack = ^{
//			STRONGSELF
//			[REQRCode showQRCode:strongSelf.shareUrl name:strongSelf.projName];
		};
	}
	return _re_nav;
}

- (REBtnPlane *)re_btnPlane {
	if (!_re_btnPlane) {
		
		WEAKSELF
		_re_btnPlane = [REBtnPlane initWithCallback:^(NSString * _Nonnull btnId, BOOL isSelected) {
			STRONGSELF
			NSInteger matchIndex = [strongSelf.webPopList indexOfObjectPassingTest:^BOOL(REWebPopData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
				return [obj.webPopId isEqualToString:btnId];
			}];
			if (matchIndex != NSNotFound) {
				REWebPopData *webPopData = [strongSelf.webPopList objectAtIndex:matchIndex];
				NSDictionary *params = @{@"webPopId": webPopData.webPopId};
				if (isSelected) {
					[webPopData.webPopManager showWebPop];
					[webPopData.webPopManager sendObjAppToWebWithObject:params type:@"open"];
					strongSelf.currWebPop = webPopData;
				} else {
					[webPopData.webPopManager sendObjAppToWebWithObject:params type:@"cloose"];
				}
				webPopData.webPopShow = isSelected;
			}
		}];
	}
	return _re_btnPlane;
}


#pragma mark - 界面生命周期
- (void)dealloc {
	if (_webPopList.count) {
		for (REWebPopData *webPopData in _webPopList) {
			[webPopData.webPopManager destroy];
		}
		_webPopList = nil;
	}
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
	
	[self initWebView];
	
	[self.loadingView showLoading];
	
	WEAKSELF
	[[BlackHole3D sharedSingleton] dataSetLoadProgress:^(float progress, NSString * _Nullable info) {
		STRONGSELF
		strongSelf.loadingView.loadingProgress.progress = progress / 100.0;
		
	}];
	[[BlackHole3D sharedSingleton] systemUIEvent:^(NSString * _Nullable btnName, int btnState) {
		STRONGSELF
		NSLog(@"btnName = %@  btnState = %d", btnName, btnState);
		
		REToolData *toolBtn = nil;
		NSInteger matchIndex = [strongSelf.toolDataList indexOfObjectPassingTest:^BOOL(REToolData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
			return [obj.toolBtnId isEqualToString:btnName];
		}];
		if (matchIndex != NSNotFound) {
			toolBtn = [strongSelf.toolDataList objectAtIndex:matchIndex];
		}
		
		if (toolBtn) {
		} else {
			RETip_Level level = RETip_L0;
			if ([btnName isEqualToString:@"BuiltIn_Btn_MainView"] || [btnName isEqualToString:@"BuiltIn_Btn_PickClipPlane"]) {
				level = RETip_L1;
			} else {
				level = RETip_L2;
			}
			if (([btnName isEqualToString:@"BuiltIn_Btn_PickClipPlane"] && btnState == 1)) {
				if (strongSelf.currIsRoomClip && [[BlackHole3D sharedSingleton].Clip getClipState]) {
					strongSelf.currIsRoomClip = NO;
					[[BlackHole3D sharedSingleton].Clip endClip];
					[[BlackHole3D sharedSingleton].BIM resetElemAttr:@"" elemIdList:@[]];
				}
				[RETip showTipStaticAnimte:strongSelf.view message:@"请在场景中选择剖切基点" level:level];
			}
			if ([btnName isEqualToString:@"BuiltIn_Btn_More"]) {
				// 更多操作引擎已经退出了剖切，需要处理样式重置
				if (strongSelf.currIsRoomClip) {
					strongSelf.currIsRoomClip = NO;
					[[BlackHole3D sharedSingleton].BIM resetElemAttr:@"" elemIdList:@[]];
				}
			}
		}
	}];
	
	[[BlackHole3D sharedSingleton] systemSelElement:^(BOOL probeValid) {
		STRONGSELF
		if (probeValid) {
			REProbeInfo *probe = [[BlackHole3D sharedSingleton].Probe getCurCombProbeRet];
			if ([probe.elemType isEqualToString:@"BIMElem"]) {
				NSInteger matchIndex = [strongSelf.sceneUniData.dataSetList indexOfObjectPassingTest:^BOOL(REDataSetUniData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
					return [obj.dataSetId isEqualToString:probe.dataSetId];
				}];
				REDataSetUniData *dataSet = nil;
				if (matchIndex != NSNotFound) {
					dataSet = [strongSelf.sceneUniData.dataSetList objectAtIndex:matchIndex];
				}
				if (dataSet == nil) {
					strongSelf.curSelProInfo = nil;
					return;
				}
				strongSelf.curSelProInfo = [NSMutableDictionary dictionary];
				strongSelf.curSelProInfo[@"dataSetType"] = @(dataSet.dataSetType);
				strongSelf.curSelProInfo[@"probeInfo"] = probe;
				if (dataSet.dataSetType != 0) {
					strongSelf.curSelProInfo[@"entityList"] = strongSelf.sceneUniData.entityList;
				}
			} else {
				strongSelf.curSelProInfo = nil;
				return;
			}
		} else {
			strongSelf.curSelProInfo = nil;
			return;
		}
		if (strongSelf.currWebPop != nil && strongSelf.curSelProInfo != nil) {
			[strongSelf.currWebPop.webPopManager sendObjAppToWebWithObject:strongSelf.curSelProInfo type:@"Probe.getCurCombProbeRet"];
		}
	}];
	
	[[BlackHole3D sharedSingleton] systemSelShpElement:^(BOOL probeValid) {
		STRONGSELF
		if (probeValid) {
			REProbeInfo *probe = [[BlackHole3D sharedSingleton].Probe getCurCombProbeRet];
			if ([probe.elemType isEqualToString:@"ShapeElem"]) {
				strongSelf.curSelProInfo = [NSMutableDictionary dictionary];
				strongSelf.curSelProInfo[@"probeInfo"] = probe;
				strongSelf.curSelProInfo[@"dataSetList"] = strongSelf.sceneUniData.dataSetList;
			} else {
				strongSelf.curSelProInfo = nil;
				return;
			}
		} else {
			strongSelf.curSelProInfo = nil;
			return;
		}
		if (strongSelf.currWebPop != nil && strongSelf.curSelProInfo != nil) {
			[strongSelf.currWebPop.webPopManager sendObjAppToWebWithObject:strongSelf.curSelProInfo type:@"Probe.getCurCombProbeRet"];
		}
	}];
	
	// 注册UniToApp消息
	[REModule registerUniToAppMsg:^(NSDictionary * _Nonnull options) {
		STRONGSELF
		[strongSelf handleEngineSDK:options msgWhere:1];
	}];
	[REModule sendMsgAppToUni:REModuleMsg_T1 message:@"iOS REEngineVC Created!"];
}


#pragma mark - 初始化界面
- (void)addReaderView {
	[self changeEngineUI];
//	if (!self.isUniAppComp) [self addBtn];
}

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


#pragma mark - 返回操作
- (void)backBtnAction:(UIButton *)sender {
	[self endRenderAndExit];
}


- (void)endRenderAndExit {
	[[BlackHole3D sharedSingleton].Graphics setSysUIPanelVisible:NO];//关闭ui方式重新加载项目的时候先加载出来
	[[BlackHole3D sharedSingleton] setViewMode:BIM viewport1:None screenMode:Single];
	// 卸载所有场景
	if (self.sceneUniData.shareType == 1 && [self.sceneUniData.shareDataType isEqual:@"Cad"]) {
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


#pragma mark - 初始化PopWebView
- (void)initWebView {
	for (REWebPopData *webPopData in _webPopList) {
		webPopData.webPopManager = [REWebViewManager initWithDelegate:self parentView:self.view height:webPopData.webPopHeight webViewUrl:webPopData.webPopUrl webViewParams:webPopData.webPopParams];
	}
}


#pragma mark - REWebViewManagerDelegate
- (void)webViewManager:(id)manager didReceiveResult:(NSDictionary *)result {
//	NSLog(@"webData: %@", result);
	
	[self handleEngineSDK:result msgWhere:2];
}

- (void)webViewManager:(id)manager didFinishLoading:(BOOL)success {
	if (success) {
		NSLog(@"WebView 加载成功");
	} else {
		NSLog(@"WebView 加载失败");
	}
}



#pragma mark - 引擎sdk调用
- (void)handleEngineSDK:(NSDictionary *)jsonObject msgWhere:(int)msgWhere {
	NSString *msgId = [[jsonObject objectForKey:@"msgId"] stringValue];
	NSString *type = [[jsonObject objectForKey:@"type"] stringValue];
	NSString *webPopId = [[jsonObject objectForKey:@"webPopId"] stringValue];
	NSDictionary *json_data = [jsonObject.allKeys containsObject:@"data"] ? [jsonObject objectForKey:@"data"] : nil;
	if (!json_data) {
		return;
	}
	REBridgeData *bridgeData = [REBridgeData yy_modelWithDictionary:json_data];
	// 获取弹窗操作
	REWebPopData *webPopData = nil;
	if (webPopId.length > 0) {
		NSInteger matchIndex = [_webPopList indexOfObjectPassingTest:^BOOL(REWebPopData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
			return [obj.webPopId isEqualToString:webPopId];
		}];
		if (matchIndex != NSNotFound) {
			webPopData = [_webPopList objectAtIndex:matchIndex];
		}
	}
	
	if ([type isEqualToString:@"log"]) {
		NSLog(@"--->>【WebLog】: %@", bridgeData.log);
	} else if ([type isEqualToString:@"requestAppToWeb"]) {
		if (webPopData && msgWhere == 2) {
			[RERequest requestWithUrl:bridgeData.requestData[@"url"] method:bridgeData.requestData[@"type"] headers:bridgeData.requestData[@"headers"] params:bridgeData.requestData[@"param"] finish:^(id  _Nonnull respone) {
				[webPopData.webPopManager sendObjAppToWebCallbackWithObject:respone msgId:msgId];
			}];
		}
	} else if ([type isEqualToString:@"cloose"]) {
		if (webPopData) {
			[webPopData.webPopManager hiddenWebPop];
			webPopData.webPopShow = NO;
			[_re_btnPlane updateStateWithBtnId:webPopData.webPopId isSelected:NO];
			if ([_currWebPop.webPopId isEqualToString:webPopData.webPopId]) {
				_currWebPop = nil;
			}
		}
	} else if ([type isEqualToString:@"popWebFull"]) {
		if (_currWebPop) {
			[_currWebPop.webPopManager setFullScreen:bridgeData.full];
		}
	} else if ([type isEqualToString:@"setElemAlpha"]) {
		[[BlackHole3D sharedSingleton].BIM setElemAlpha:bridgeData.dataSetId elemIdList:bridgeData.elemIdList elemAlpha:bridgeData.alpha alphaWeight:255];
	} else if ([type isEqualToString:@"setElemsValidState"]) {
		[[BlackHole3D sharedSingleton].BIM setElemsValidState:bridgeData.dataSetId elemIdList:bridgeData.elemIdList enable:bridgeData.visible];
	} else if ([type isEqualToString:@"setCamLocateToDataSet"]) {
		[[BlackHole3D sharedSingleton].Camera setCamLocateToDataSet:bridgeData.dataSetId backDepth:bridgeData.backDepth locType:bridgeData.locTypeEm];
	} else if ([type isEqualToString:@"setCamLocateToElem"]) {
		[[BlackHole3D sharedSingleton].Camera setCamLocateToElem:bridgeData.locIDList backDepth:bridgeData.backDepth locType:bridgeData.locTypeEm];
	} else if ([type isEqualToString:@"setElemAttr"]) {
		REElemAttr *elemAttr = [[REElemAttr alloc] init];
		elemAttr.dataSetId = bridgeData.dataSetId;
		elemAttr.elemIdList = bridgeData.elemIdList;
		elemAttr.elemClr = bridgeData.elemClrObj;
		[[BlackHole3D sharedSingleton].BIM setElemAttr:elemAttr];
	} else if ([type isEqualToString:@"resetElemAttr"]) {
		[[BlackHole3D sharedSingleton].BIM resetElemAttr:bridgeData.dataSetId elemIdList:bridgeData.elemIdList];
	} else if ([type isEqualToString:@"setCamLocateTo"]) {
		RECamLoc *camLoc = [[RECamLoc alloc] init];
		camLoc.camPos = bridgeData.camPosObj;
		camLoc.camDir = bridgeData.camDirObj;
		camLoc.camRotate = bridgeData.camRotateObj;
		[[BlackHole3D sharedSingleton].Camera setCamLocateTo:camLoc locDelay:bridgeData.locDelay locTime:bridgeData.locTime];
	} else if ([type isEqualToString:@"delAllSelElems"]) {
		[[BlackHole3D sharedSingleton].BIM delAllSelElems];
	} else if ([type isEqualToString:@"getCamLocate"]) {
		RECamLoc *camLoc = [[BlackHole3D sharedSingleton].Camera getCamLocate];
		if (_currWebPop && msgWhere == 2) {
			[_currWebPop.webPopManager sendObjAppToWebCallbackWithObject:camLoc msgId:msgId];
		} else if (msgWhere == 1) {
			[REModule sendMsgAppToUni:REModule_GetCamLoc message:camLoc];
		}
	}else if ([type isEqualToString:@"setSelElemsAttr"]) {
		RESelElemsAttr *reSelElemsAttr = [[RESelElemsAttr alloc] init];
		reSelElemsAttr.elemClr = bridgeData.elemClrObj;
		reSelElemsAttr.probeMask = bridgeData.probeMask;
		reSelElemsAttr.attrValid = bridgeData.attrValid;
		[[BlackHole3D sharedSingleton].BIM setSelElemsAttr:reSelElemsAttr];
	} else if ([type isEqualToString:@"getBIMDataSetBV"]) {
		REBBox3D *bbox = [[BlackHole3D sharedSingleton].BIM getTotalBV:bridgeData.dataSetId];
		if (_currWebPop && msgWhere == 2) {
			[_currWebPop.webPopManager sendObjAppToWebCallbackWithObject:bbox msgId:msgId];
		}
	} else if ([type isEqualToString:@"getGridDataSetBV"]) {
		REBBox3D *bbox = [[BlackHole3D sharedSingleton].Grid getDataSetBV:bridgeData.dataSetId];
		if (_currWebPop && msgWhere == 2) {
			[_currWebPop.webPopManager sendObjAppToWebCallbackWithObject:bbox msgId:msgId];
		}
	} else if ([type isEqualToString:@"setCamLocToWater"]) {
		[[BlackHole3D sharedSingleton].Water setCamToData:bridgeData.waterNameList];
	} else if ([type isEqualToString:@"setCamLocToExtrude"]) {
		[[BlackHole3D sharedSingleton].Extrude setCamToData:bridgeData.extrudeIdst];
	} else if ([type isEqualToString:@"getDataSetTerrId"]) {
		NSString *terrId = [[BlackHole3D sharedSingleton].Terrain getDataSetTerrId:bridgeData.dataSetId];
		if (_currWebPop && msgWhere == 2) {
			[_currWebPop.webPopManager sendObjAppToWebCallbackWithObject:terrId msgId:msgId];
		}
	} else if ([type isEqualToString:@"getAllUnitNames"]) {
		NSArray *unitNames = [[BlackHole3D sharedSingleton].Terrain getAllUnitNames:bridgeData.dataSetId];
		if (_currWebPop && msgWhere == 2) {
			[_currWebPop.webPopManager sendObjAppToWebCallbackWithObject:unitNames msgId:msgId];
		}
	} else if ([type isEqualToString:@"setUnitActive"]) {
		[[BlackHole3D sharedSingleton].Terrain setUnitActive:bridgeData.dataSetId unitId:bridgeData.unitId resType:bridgeData.terrResEm active:bridgeData.active];
	} else if ([type isEqualToString:@"setGridValidState"]) {
		[[BlackHole3D sharedSingleton].Grid setValidState:bridgeData.dataSetId enable:bridgeData.visible];
	} else if ([type isEqualToString:@"waterVisible"]) {
		[[BlackHole3D sharedSingleton].Water setVisible:bridgeData.waterName visible:bridgeData.visible];
	} else if ([type isEqualToString:@"extrudeVisible"]) {
		[[BlackHole3D sharedSingleton].Extrude setVisible:bridgeData.extrudeId visible:bridgeData.visible];
	} else if ([type isEqualToString:@"setCamLocateToBound"]) {
		[[BlackHole3D sharedSingleton].Camera setCamLocateToBound:bridgeData.box3D backDepth:bridgeData.backDepth locType:bridgeData.locTypeEm];
	} else if ([type isEqualToString:@"getDataSetAllElemIDs"]) {
		[[BlackHole3D sharedSingleton].BIM getDataSetAllElemID:bridgeData.dataSetId visibalOnly:bridgeData.visibalOnly];
	} else if ([type isEqualToString:@"setClipPlanesContourLineClr"]) {
		[[BlackHole3D sharedSingleton].BIM setClipPlanesContourLineClr:bridgeData.lineClrObj];
	} else if ([type isEqualToString:@"setClipSpecifyHeight"]) {
		[[BlackHole3D sharedSingleton].Clip setClipSpecifyHeight:bridgeData.dataSetId topHeight:bridgeData.topHeight bottomHeight:bridgeData.bottomHeight single:bridgeData.single];
		_currIsRoomClip = YES;
	} else if ([type isEqualToString:@"endClip"]) {
		_currIsRoomClip = NO;
		[[BlackHole3D sharedSingleton].Clip endClip];
	} else if ([type isEqualToString:@"setElemDepthBias"]) {
		[[BlackHole3D sharedSingleton].BIM setElemDepthBias:bridgeData.dataSetId elemIdList:bridgeData.elemIdList depthBias:bridgeData.depthBias];
	}
}





#pragma mark - 按钮面板
- (void)initBtnPlane {
	if (self.sceneUniData.shareType != 1 || ([self.sceneUniData.shareDataType isEqualToString:@"Bim"] || [self.sceneUniData.shareDataType isEqualToString:@"bim"])) {
		[self.view addSubview:self.re_btnPlane];
	}
}


#pragma mark - 工具栏
- (void)initToolUI {
	for (REToolData *toolData in self.toolDataList) {
		REUIBtnInfo *btnInfo = [[REUIBtnInfo alloc] init];
		btnInfo.uiID = toolData.toolBtnId;
		REUIBtnStateInfo *statePar1 = [[REUIBtnStateInfo alloc] init];
		statePar1.texPath = toolData.btnImg;
		btnInfo.stateParList = @[statePar1];
		[[BlackHole3D sharedSingleton].Graphics createSysPanelBtn:btnInfo];
	}
	[[BlackHole3D sharedSingleton].Graphics setSysUIPanelVisible:YES];
}



#pragma mark - 加载资源
- (void)loadDataSet {
	// 设置请求头
	if (self.sceneUniData.urlHeaderList.count) {
		for(REUrlUniData *urlData in self.sceneUniData.urlHeaderList) {
			[[BlackHole3D sharedSingleton] addUrlExtHeader:urlData.urlWildcard headerStr:urlData.headerStr];
		}
	}
	// 设置授权信息
	if (self.sceneUniData.authorData && self.sceneUniData.authorData.isMinio) {
		[[BlackHole3D sharedSingleton] addAuthorPath:_sceneUniData.authorData.authorTxtId filePath:_sceneUniData.authorData.authorTxt];
		[[BlackHole3D sharedSingleton] addPathIndex:_sceneUniData.authorData.authorIndexId rootURL:_sceneUniData.authorData.authorRes filePath:_sceneUniData.authorData.authorIndex];
	}
	
	if (self.sceneUniData.worldCRS.length > 0) {
		[[BlackHole3D sharedSingleton].Coordinate setEngineWorldCRS:self.sceneUniData.worldCRS];
	}
	
	// 设置渲染模式
	[[BlackHole3D sharedSingleton].Common setFakeSphMode:(self.sceneUniData.shareViewMode.length > 0 && [self.sceneUniData.shareViewMode isEqual:@"Sphere"])];
	
	//提前加载图片资源
	if (_toolDataList.count) {
		for (REToolData *toolData in _toolDataList) {
			[[BlackHole3D sharedSingleton].Graphics setPreLoadPicPath:toolData.btnImg];
		}
	}
	
	//提前加载挤出纹理资源
	if (_sceneUniData.extrudeList.count && _sceneUniData.extrudeTexList.count) {
		for (REExtrudeTexUniData *texUniData in _sceneUniData.extrudeTexList) {
			[[BlackHole3D sharedSingleton].Extrude addExtrudeFaceTex:texUniData.picPath size:texUniData.picSizeObj];
		}
	}

	if (self.sceneUniData.shareType == 1) {
		if ([self.sceneUniData.shareDataType isEqual:@"Bim"]
			|| [self.sceneUniData.shareDataType isEqual:@"bim"]
			|| [self.sceneUniData.shareDataType isEqual:@"Rs"]
			|| [self.sceneUniData.shareDataType isEqual:@"Wmts"]
			|| [self.sceneUniData.shareDataType isEqual:@"Osgb"]
			|| [self.sceneUniData.shareDataType isEqual:@"PointCloud"]) {
			[self loadBim];
		} else if ([self.sceneUniData.shareDataType isEqual:@"Cad"]
				   || [self.sceneUniData.shareDataType isEqual:@"CAD"]) {
			[self loadCad];
		} else {
			[self endRenderAndExit];
		}
	} else {
		//默认相机设置
		if (self.sceneUniData.defaultCamLoc && self.sceneUniData.defaultCamLoc.camPos && self.sceneUniData.defaultCamLoc.force) {
			REForceCamLoc *forceCamLoc = [[REForceCamLoc alloc] init];
			forceCamLoc.force = YES;
			forceCamLoc.camPos = [RETool arrToDVec3:self.sceneUniData.defaultCamLoc.camPos];
			forceCamLoc.camDir = [RETool arrToDVec3:self.sceneUniData.defaultCamLoc.camDir];
			forceCamLoc.camRotate = [RETool arrToDVec4:self.sceneUniData.defaultCamLoc.camRotate];
			[[BlackHole3D sharedSingleton].Camera setCamForcedInitLoc:forceCamLoc];
		}
		[self loadBim];
	}
	
	// 设置最大渲染面数
	[[BlackHole3D sharedSingleton].Common setExpectMaxInstDrawFaceNum:self.sceneUniData.maxInstDrawFaceNum];
}


#pragma mark - 模型加载
- (void)loadBim {
	//加载场景
	NSMutableArray *dataSetList_temp = [NSMutableArray array];
	for (REDataSetUniData *dataSetInfo in self.sceneUniData.dataSetList) {
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
	if (!self.sceneUniData.dataSetList.count) {
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
				if (strongSelf.sceneUniData.shareType == 2 && strongSelf.sceneUniData.camDefaultDataSetId.length > 0 && (!(strongSelf.sceneUniData.defaultCamLoc && strongSelf.sceneUniData.defaultCamLoc.camPos && strongSelf.sceneUniData.defaultCamLoc.force))) {
					[[BlackHole3D sharedSingleton].Camera setCamLocateToDataSet:strongSelf.sceneUniData.camDefaultDataSetId backDepth:1.0 locType:CAM_DIR_CURRENT];
				}
				// 处理地形数据层级
				for (REDataSetUniData *dataSetInfo in strongSelf.sceneUniData.dataSetList) {
					if (dataSetInfo.terrainLayerLev > 0) {
						NSArray *unitIDs = [[BlackHole3D sharedSingleton].Terrain getAllUnitNames:dataSetInfo.dataSetId];
						NSString *unitID = unitIDs.count > 0 ? unitIDs.firstObject : @"";
						[[BlackHole3D sharedSingleton].Terrain setUnitLayerlev:dataSetInfo.dataSetId unitId:unitID resType:RETerrResEm_ALL layerLev:dataSetInfo.terrainLayerLev];
					}
				}
				[strongSelf initToolUI];
				[strongSelf initBtnPlane];
				[strongSelf addEntity];
				[strongSelf addWater];
				[strongSelf addExtrude];
				[strongSelf.loadingView hiddenLoading];
			} else {
				[REModule sendMsgAppToUni:REModuleMsg_T2 message:@"模型资源加载失败！"];
				[strongSelf endRenderAndExit];
			}
		}
	}];
}


#pragma mark - CAD加载
- (void)loadCad {
	REDataSetUniData *dataSetInfo = self.sceneUniData.dataSetList.firstObject;
	
	[[BlackHole3D sharedSingleton] startRender];
	[[BlackHole3D sharedSingleton] setViewMode:CAD viewport1:None screenMode:Single];
	WEAKSELF
	[[BlackHole3D sharedSingleton].CAD loadCAD:dataSetInfo.resourcesAddress unit:dataSetInfo.unit scale:1.0 callBack:^(BOOL success) {
		STRONGSELF
		if (success) {
			[strongSelf.loadingView hiddenLoading];
			[[BlackHole3D sharedSingleton].Graphics setSysUIPanelVisible:NO];
		} else {
			[REModule sendMsgAppToUni:REModuleMsg_T2 message:@"模型资源加载失败！"];
			[strongSelf endRenderAndExit];
		}
	}];
}




#pragma mark - 单构件加载
- (void)addEntity {
	if (!self.sceneUniData.entityList || !self.sceneUniData.entityList.count) {
		return;
	}
	NSMutableArray *re_entityList = [NSMutableArray array];
	for (REEntityUniData *entityInfo in self.sceneUniData.entityList) {
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
	if (!self.sceneUniData.waterList || !self.sceneUniData.waterList.count) {
		return;
	}
	
	NSMutableArray *re_waterList = [NSMutableArray array];
	for (REWaterUniData *waterInfo in self.sceneUniData.waterList) {
		NSMutableArray *rgnList = [NSMutableArray array];
		RECornerRgnUniData *uni_cornerRgnInfo = waterInfo.rgnList.firstObject;
		RECornerRgnInfo *cornerRgnInfo = [[RECornerRgnInfo alloc] init];
		NSMutableArray *potList = [NSMutableArray array];
		for (NSArray<NSNumber *> *pot in uni_cornerRgnInfo.pointList) {
			[potList addObject:[REPoint3D initDvec3:[RETool arrToDVec3:pot]]];
		}
		cornerRgnInfo.pointList = potList;
		cornerRgnInfo.indexList = uni_cornerRgnInfo.indexList;
		[rgnList addObject:cornerRgnInfo];
		
		REWaterInfo *re_waterInfo = [[REWaterInfo alloc] init];
		re_waterInfo.waterName = waterInfo.waterName;
		re_waterInfo.waterClr = [RETool arrToColor:waterInfo.waterClr];
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
	if (!self.sceneUniData.extrudeList || !self.sceneUniData.extrudeList.count) {
		return;
	}
	
	NSMutableArray *re_extrudeList = [NSMutableArray array];
	for (REExtrudeUniData *extrudeInfo in self.sceneUniData.extrudeList) {
		NSMutableArray *dataSetIdList_line = [NSMutableArray array];
		for (REDataSetUniData *dataSet in self.sceneUniData.dataSetList) {
			//无奈处理平台横线数据不一致的问题
			if ([extrudeInfo.dataSetIdList containsObject:dataSet.dataSetId_noline]) {
				[dataSetIdList_line addObject:dataSet.dataSetId];
			}
		}
		NSMutableArray *rgnList = [NSMutableArray array];
		NSMutableArray *potList = [NSMutableArray array];
		NSArray *uni_cornerRgnInfo = extrudeInfo.rgnList.firstObject;
		for (NSArray<NSNumber *> *pot in uni_cornerRgnInfo) {
			[potList addObject:[REPoint3D initDvec3:[RETool arrToDVec3:pot]]];
		}
		[rgnList addObject:potList];
		
		REExtrudeInfo *re_extrudeInfo = [[REExtrudeInfo alloc] init];
		re_extrudeInfo.extrudeId = extrudeInfo.extrudeId;
		re_extrudeInfo.dataSetIdList = dataSetIdList_line;
		re_extrudeInfo.depthLimitRange = [RETool arrToDVec2:extrudeInfo.depthLimitRange];
		re_extrudeInfo.type = extrudeInfo.type;
		re_extrudeInfo.texId = extrudeInfo.texId;
		re_extrudeInfo.texPath = extrudeInfo.texPath;
		re_extrudeInfo.texSize = [RETool arrToDVec2:extrudeInfo.texSize];
		re_extrudeInfo.rgnList = rgnList;
		
		[re_extrudeList addObject:re_extrudeInfo];
	}
	[[BlackHole3D sharedSingleton].Extrude setData:re_extrudeList];
}





#pragma mark - 设备支持操作

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
	return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
	return false;
}



#pragma mark - 可能会用到的设备操作

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






@end
