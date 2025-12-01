//
//  REBtnPlane.m
//  REUniPluginModule
//
//  Created by Apple on 2025/11/21.
//

#import "REBtnPlane.h"


#define RREBtnPlaneLeft (12)
#define RREBtnPlaneTop (20)
#define RREBtnPlaneWidth (40)
#define RREBtnPlaneHeight (92)


@interface REBtnPlane ()
@property (weak, nonatomic) IBOutlet UIView *reBtnPlanTree;
@property (weak, nonatomic) IBOutlet UIView *reBtnPlanProperty;

@property (weak, nonatomic) IBOutlet UIImageView *reImgVTree;
@property (weak, nonatomic) IBOutlet UIImageView *reImgVProperty;


@property (nonatomic, assign) BOOL isTreeSelected;
@property (nonatomic, assign) BOOL isPropertySelected;


@end

@implementation REBtnPlane

- (void)awakeFromNib {
	[super awakeFromNib];
	
	// 初始化状态（未选中）
	self.isTreeSelected = NO;
	self.isPropertySelected = NO;
	// 初始化样式
	self.reBtnPlanTree.layer.cornerRadius = 10;
	self.reBtnPlanTree.clipsToBounds = YES;
	self.reBtnPlanProperty.layer.cornerRadius = 10;
	self.reBtnPlanProperty.clipsToBounds = YES;
	
	[self updateTreeButtonStyle];
	[self updatePropertyButtonStyle];
}


/// 初始化方法
/// @param callback 点击回调
+ (instancetype)initWithCallback:(REBtnPlaneCallback)callback {
	NSArray *nibs = [REUniPluginModule_bundle loadNibNamed:@"REBtnPlane" owner:nil options:nil];
	REBtnPlane *re_btnPlane = nibs.firstObject;
	re_btnPlane.frame = CGRectMake(RREBtnPlaneLeft, kStatusBarHeight + kNavBarHeight + RREBtnPlaneTop, RREBtnPlaneWidth, RREBtnPlaneHeight);
	re_btnPlane.onClickCallback = callback;
		
	return re_btnPlane;
}




- (IBAction)btnClick_tree:(UIButton *)sender {
	self.isTreeSelected = !self.isTreeSelected;
	
	// 互斥：选树则取消属性
	if (self.isTreeSelected && self.isPropertySelected) {
		self.isPropertySelected = NO;
		[self updatePropertyButtonStyle];
		VDBlockSafeRun(self.onClickCallback, @"web_pop_property", self.isPropertySelected);
	}
	
	[self updateTreeButtonStyle];
	VDBlockSafeRun(self.onClickCallback, @"web_pop_tree", self.isTreeSelected);
}


- (IBAction)btnClick_property:(UIButton *)sender {
	self.isPropertySelected = !self.isPropertySelected;
	
	// 互斥：选属性则取消树
	if (self.isPropertySelected && self.isTreeSelected) {
		self.isTreeSelected = NO;
		[self updateTreeButtonStyle];
		VDBlockSafeRun(self.onClickCallback, @"web_pop_tree", self.isTreeSelected);
	}
	
	[self updatePropertyButtonStyle];
	VDBlockSafeRun(self.onClickCallback, @"web_pop_property", self.isPropertySelected);
}


#pragma mark - 样式更新
- (void)updateTreeButtonStyle {
	// 选中/未选中背景色
	self.reBtnPlanTree.backgroundColor = [RETool hexToUIColor:self.isTreeSelected ? @"#1D2129" : @"#FFFFFF"];
	
	// 按钮图片切换
	self.reImgVTree.image = [UIImage imageNamed:self.isTreeSelected ? @"icon_tree_checked.png" : @"icon_tree_normal.png" inBundle:REUniPluginModule_bundle compatibleWithTraitCollection:nil];
}

- (void)updatePropertyButtonStyle {
	// 选中/未选中背景色
	self.reBtnPlanProperty.backgroundColor = [RETool hexToUIColor:self.isPropertySelected ? @"#1D2129" : @"#FFFFFF"];
	
	// 按钮图片切换
	self.reImgVProperty.image = [UIImage imageNamed:self.isPropertySelected ? @"icon_property_checked.png" : @"icon_property_normal.png" inBundle:REUniPluginModule_bundle compatibleWithTraitCollection:nil];
}

#pragma mark - 外部更新状态
- (void)updateStateWithBtnId:(NSString *)btnId isSelected:(BOOL)isSelected {
	if ([btnId isEqualToString:@"web_pop_tree"]) {
		self.isTreeSelected = isSelected;
		[self updateTreeButtonStyle];
	} else if ([btnId isEqualToString:@"web_pop_property"]) {
		self.isPropertySelected = isSelected;
		[self updatePropertyButtonStyle];
	}
}

@end
