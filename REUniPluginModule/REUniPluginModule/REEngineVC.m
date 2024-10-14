//
//  REEngineVC.m
//  RETestUniPlugin
//
//  Created by Apple on 2023/11/23.
//

#import "REEngineVC.h"
#import "BlackHole3D.h"
#import "Masonry.h"
#import "REDataSetInfo.h"
#import "RELoadingView.h"



@interface REEngineVC ()
@property (nonatomic, strong) RELoadingView *loadingView;

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


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self loadDataSet];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.view.backgroundColor = [UIColor whiteColor];
	[self addReaderView];
	
	[self.view addSubview:self.loadingView];
	[self.loadingView showLoading];
	
	WEAKSELF
	[[BlackHole3D sharedSingleton] dataSetLoadProgress:^(float progress, NSString * _Nullable info) {
		STRONGSELF
		strongSelf.loadingView.loadingProgress.progress = progress / 100.0;
	}];
}

- (void)addReaderView {
	[self changeEngineUI];
	if (!self.isUniAppComp) [self addBtn];
}

#pragma mark - 创建显示界面
- (void)changeEngineUI {
	// 创建自定义界面
	self.customView = [[UIView alloc] init];
	self.customView.frame = self.view.frame;
	[self.view addSubview:self.customView];
	self.customView.clipsToBounds = YES;
	self.customView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

	[[BlackHole3D sharedSingleton] getRenderView].frame = self.customView.frame;
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
	[self endRenderAndExit];
}


- (void)endRenderAndExit {
	[[BlackHole3D sharedSingleton].Graphics setSysUIPanelVisible:NO];//关闭ui方式重新加载项目的时候先加载出来
	[[BlackHole3D sharedSingleton] setViewMode:BIM viewport1:None screenMode:Single];
	// 卸载所有场景
	[[BlackHole3D sharedSingleton].Model unloadAllDataSet];
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
			[self dismissViewControllerAnimated:YES completion:nil];
		}
	});
}




#pragma mark - 模型加载
- (void)loadDataSet {
	if (self.worldCRS.length > 0) {
		[[BlackHole3D sharedSingleton].Coordinate setEngineWorldCRS:self.worldCRS];
	}

	
	[[BlackHole3D sharedSingleton] startRender];
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
		dataSet.dataSetSGContent = dataSetInfo.dataSetSGContent;
		[dataSetList_temp addObject:dataSet];
	}
	if (!self.dataSetList.count) {
		REDataSet *dataSet = [REDataSet initModel:@"res_jifang" resourcesAddress:@"https://demo.bjblackhole.com/default.aspx?dir=url_res03&path=7624a001668d4e5495f101da54d3bee0"];
		[dataSetList_temp addObject:dataSet];
	}
	
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
//				[[BlackHole3D sharedSingleton].BIM setContourLineClr:@"" lineClr:REColorMake_RGB(0, 0, 0)];
				[[BlackHole3D sharedSingleton].Graphics setSysUIPanelVisible:YES];
				if (strongSelf.shareType == 2 && strongSelf.camDefaultDataSetId.length > 0) {
					[[BlackHole3D sharedSingleton].Camera setCamLocateToDataSet:strongSelf.camDefaultDataSetId backDepth:1.0];
				}
				[strongSelf.loadingView hiddenLoading];
			} else {
				[strongSelf endRenderAndExit];
			}
		}
	}];
	
	[[BlackHole3D sharedSingleton].Common setExpectMaxInstDrawFaceNum:self.maxInstDrawFaceNum];
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