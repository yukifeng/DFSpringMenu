//
//  DFSpringMenu.h
//  DFSpringWindow
//
//  Created by huitong on 2019/7/17.
//  Copyright © 2019 duanfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, DFDisPlayDirection) {
    DFDisPlayDirectionDownToUp,
    DFDisPlayDirectionLeftToRight,
};

typedef void(^DFMenuButtonBlock)(NSInteger index);

@interface DFSpringMenu : UIView

/**
 弹出的方向
 */
@property(nonatomic,assign) DFDisPlayDirection displayDirection;
@property(nonatomic,copy) DFMenuButtonBlock buttonBlock;

- (instancetype)initWithDirection:(DFDisPlayDirection)direction widthHeight:(CGFloat)widthHeight backgroundColor:(UIColor*)menuBackgroundColor buttonImages:(NSArray<__kindof UIButton *> *)buttons;
/**
 弹出菜单
 */
- (void)pushMenu;
/**
 收起菜单
 */
- (void)popMenu;

@end

NS_ASSUME_NONNULL_END
