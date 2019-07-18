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

@interface DFSpringMenu : UIView

/**
 弹出的方向
 */
@property(nonatomic,assign) DFDisPlayDirection displayDirection;

- (instancetype)initWithDirection:(DFDisPlayDirection)direction widthHeight:(CGFloat)widthHeight backgroundColor:(UIColor*)menuBackgroundColor;
/**
 弹出菜单
 */
- (void)pushMenu;

@end

NS_ASSUME_NONNULL_END
