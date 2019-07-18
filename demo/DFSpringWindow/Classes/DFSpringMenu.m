//
//  DFSpringMenu.m
//  DFSpringWindow
//
//  Created by huitong on 2019/7/17.
//  Copyright © 2019 duanfeng. All rights reserved.
//

#import "DFSpringMenu.h"

#define DFHelperViewWidthHeight 40
// 这是视图边界流出的空白view间距，方便做形变
#define DFDisplayMargin 50
#define DFScreenWidth [UIScreen mainScreen].bounds.size.width
#define DFScreenHeight [UIScreen mainScreen].bounds.size.height

static NSTimeInterval kmengbanAnimationDurning = 0.3f;
static NSTimeInterval khelperViewAnimationDurning = 0.7f;
static NSTimeInterval kdelayAnimationDurning = 0.0f;
@interface DFSpringMenu ()

@property (nonatomic,strong) CADisplayLink *displayLink;
@property (nonatomic,assign) NSInteger animationCount;
@property(nonatomic,assign) CGFloat menuHeight; // 菜单高度 上下push有效
@property(nonatomic,assign) CGFloat menuWidth; // 菜单宽度 左右push有效

@end

@implementation DFSpringMenu{
    UIColor *_viewBackgroundColor;
    UIView *_helperCenterView;
    UIView *_helperSliderView;
    UIVisualEffectView *_mengbanView;
    UIWindow *keyWindow;
    CGFloat _helperViewDiff;
    BOOL _isDisplay;
    NSArray<__kindof UIButton *> *_buttons;
}

#pragma mark - 初始化
- (instancetype)initWithDirection:(DFDisPlayDirection)direction widthHeight:(CGFloat)widthHeight backgroundColor:(UIColor*)menuBackgroundColor buttons:(nonnull NSArray<__kindof UIButton *> *)buttons
{
    self = [super init];
    if (self) {
        _viewBackgroundColor = menuBackgroundColor;
        self.displayDirection = direction;
        _isDisplay = NO;
        _buttons = [NSArray arrayWithArray:buttons];
        switch (self.displayDirection) {
            case DFDisPlayDirectionDownToUp:
                self.menuHeight = widthHeight;
                break;
            case DFDisPlayDirectionLeftToRight:
                self.menuWidth = widthHeight;
                break;
        }
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI{
    keyWindow = [UIApplication sharedApplication].keyWindow;
    _mengbanView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    _mengbanView.frame = keyWindow.frame;
    _mengbanView.alpha = 0.0f;
    switch (self.displayDirection) {
        case DFDisPlayDirectionDownToUp:
            _helperCenterView = [[UIView alloc]initWithFrame:CGRectMake((keyWindow.frame.size.width - DFHelperViewWidthHeight) / 2, keyWindow.frame.size.height, DFHelperViewWidthHeight, DFHelperViewWidthHeight)];
            _helperCenterView.backgroundColor = [UIColor redColor];
            _helperSliderView = [[UIView alloc]initWithFrame:CGRectMake(0, keyWindow.frame.size.height, DFHelperViewWidthHeight, DFHelperViewWidthHeight)];
            _helperSliderView.backgroundColor = [UIColor yellowColor];
            _helperCenterView.hidden = YES;
            _helperSliderView.hidden = YES;
            [keyWindow addSubview:_helperSliderView];
            [keyWindow addSubview:_helperCenterView];
            self.frame = CGRectMake(0, keyWindow.frame.size.height + DFDisplayMargin, DFScreenWidth, self.menuHeight + DFDisplayMargin);
            self.backgroundColor = [UIColor clearColor];
            [keyWindow insertSubview:self belowSubview:_helperSliderView];
            break;
        case DFDisPlayDirectionLeftToRight:
            _helperCenterView = [[UIView alloc]initWithFrame:CGRectMake(-DFHelperViewWidthHeight , (keyWindow.frame.size.height - DFHelperViewWidthHeight) / 2, DFHelperViewWidthHeight, DFHelperViewWidthHeight)];
            _helperCenterView.backgroundColor = [UIColor redColor];
            _helperSliderView = [[UIView alloc]initWithFrame:CGRectMake(-DFHelperViewWidthHeight , 0, DFHelperViewWidthHeight, DFHelperViewWidthHeight)];
            _helperSliderView.backgroundColor = [UIColor yellowColor];
            _helperCenterView.hidden = YES;
            _helperSliderView.hidden = YES;
            [keyWindow addSubview:_helperSliderView];
            [keyWindow addSubview:_helperCenterView];
            self.frame = CGRectMake(-(self.menuWidth + DFDisplayMargin), 0, self.menuWidth + DFDisplayMargin, DFScreenHeight);
            self.backgroundColor = [UIColor clearColor];
            [keyWindow insertSubview:self belowSubview:_helperSliderView];
            break;
    }
    [self addButtons:_buttons];
}

- (void)addButtons:(NSArray *)buttons{
    switch (self.displayDirection) {
        case DFDisPlayDirectionDownToUp:
            for (int i = 0; i < buttons.count; i++) {
                UIButton *button = buttons[i];
                button.tag = i;
                CGFloat width = DFScreenWidth / buttons.count;
                button.frame = CGRectMake(0 + i * width, 0, width, self.menuHeight);
                [self addSubview:button];
            }
            break;
         case DFDisPlayDirectionLeftToRight:
            for (int i = 0; i < buttons.count; i++) {
                UIButton *button = buttons[i];
                button.tag = i;
                CGFloat height = DFScreenHeight / buttons.count;
                button.frame = CGRectMake(0 ,0 + i * height, self.menuWidth, height);
                [self addSubview:button];
            }
            break;
    }
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIBezierPath *path = [UIBezierPath bezierPath];
    switch (self.displayDirection) {
        case DFDisPlayDirectionDownToUp:
            [path moveToPoint:CGPointMake(0, DFDisplayMargin + self.menuHeight)];
            [path addLineToPoint:CGPointMake(keyWindow.frame.size.width, DFDisplayMargin + self.menuHeight)];
            [path addLineToPoint:CGPointMake(keyWindow.frame.size.width, DFDisplayMargin)];
            [path addQuadCurveToPoint:CGPointMake(0, DFDisplayMargin) controlPoint:CGPointMake(keyWindow.frame.size.width / 2, DFDisplayMargin + _helperViewDiff)];
            [path closePath];
            break;
        case DFDisPlayDirectionLeftToRight:
            [path moveToPoint:CGPointMake(0, 0)];
            [path addLineToPoint:CGPointMake(0, keyWindow.frame.size.height)];
            [path addLineToPoint:CGPointMake(self.menuWidth, keyWindow.frame.size.height)];
            [path addQuadCurveToPoint:CGPointMake(self.menuWidth, 0) controlPoint:CGPointMake(self.menuWidth + _helperViewDiff, keyWindow.frame.size.height / 2)];
            [path closePath];
            break;
    }
    CGContextAddPath(context, path.CGPath);
    [_viewBackgroundColor set];
    CGContextFillPath(context);
}

- (void)animationButton{
    switch (self.displayDirection) {
        case DFDisPlayDirectionDownToUp:
            for (int i = 0 ; i<_buttons.count; i++) {
                UIButton *button = _buttons[i];
                button.transform = CGAffineTransformMakeTranslation(0, self.menuHeight);
                [UIView animateWithDuration:khelperViewAnimationDurning delay:i*(0.3/_buttons.count) usingSpringWithDamping:0.6f initialSpringVelocity:0.0f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
                    button.transform = CGAffineTransformIdentity;
                } completion:^(BOOL finished) {}];
            }
            break;
        case DFDisPlayDirectionLeftToRight:
            for (int i = 0 ; i<_buttons.count; i++) {
                UIButton *button = _buttons[i];
                button.transform = CGAffineTransformMakeTranslation(-self.menuWidth, 0);
                [UIView animateWithDuration:khelperViewAnimationDurning delay:i*(0.3/_buttons.count) usingSpringWithDamping:0.6f initialSpringVelocity:0.0f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
                    button.transform = CGAffineTransformIdentity;
                } completion:^(BOOL finished) {}];
            }
            break;
    }
}

- (void)pushMenu{
    if (!_isDisplay) {
        [keyWindow insertSubview:_mengbanView belowSubview:self];
        [UIView animateWithDuration:kmengbanAnimationDurning animations:^{
            switch (self.displayDirection) {
                case DFDisPlayDirectionDownToUp:
                    self.frame = CGRectMake(0, self->keyWindow.frame.size.height - DFDisplayMargin - self.menuHeight, DFScreenWidth, self.menuHeight + DFDisplayMargin);
                    break;
                case DFDisPlayDirectionLeftToRight:
                    self.frame = self.bounds;
                    break;
            }
        }];
        [self beforeAnimation];
        [UIView animateWithDuration:khelperViewAnimationDurning delay:kdelayAnimationDurning usingSpringWithDamping:0.5f initialSpringVelocity:0.9f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
            switch (self.displayDirection) {
                case DFDisPlayDirectionDownToUp:
                    self->_helperCenterView.frame = CGRectMake((self->keyWindow.frame.size.width - DFHelperViewWidthHeight) / 2, self->keyWindow.frame.size.height - self.menuHeight, DFHelperViewWidthHeight, DFHelperViewWidthHeight);
                    break;
                case DFDisPlayDirectionLeftToRight:
                    self->_helperCenterView.frame = CGRectMake(self.menuWidth - DFHelperViewWidthHeight / 2, self->keyWindow.frame.size.height / 2, DFHelperViewWidthHeight, DFHelperViewWidthHeight);
                    break;
            }
        } completion:^(BOOL finished) {
            [self finishAnimation];
        }];
        [UIView animateWithDuration:kmengbanAnimationDurning animations:^{
            self->_mengbanView.alpha = 1.0f;
        }];
        [self beforeAnimation];
        [UIView animateWithDuration:khelperViewAnimationDurning delay:kdelayAnimationDurning usingSpringWithDamping:0.8f initialSpringVelocity:2.0f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
            switch (self.displayDirection) {
                case DFDisPlayDirectionDownToUp:
                    self->_helperSliderView.frame = CGRectMake(0, self->keyWindow.frame.size.height - self.menuHeight, DFHelperViewWidthHeight, DFHelperViewWidthHeight);
                    break;
                case DFDisPlayDirectionLeftToRight:
                    self->_helperSliderView.frame = CGRectMake(self.menuWidth - DFHelperViewWidthHeight / 2, 0, DFHelperViewWidthHeight, DFHelperViewWidthHeight);
                    break;
            }
        } completion:^(BOOL finished) {
            [self finishAnimation];
        }];
        [self animationButton];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        [_mengbanView addGestureRecognizer:tap];
        UITapGestureRecognizer *menuTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(menuTapClick:)];
        [self addGestureRecognizer:menuTap];
        _isDisplay = YES;
    }else{
        [self popMenu];
    }
}

- (void)popMenu{
    [UIView animateWithDuration:kmengbanAnimationDurning animations:^{
        switch (self.displayDirection) {
            case DFDisPlayDirectionDownToUp:
                self.frame = CGRectMake(0, self->keyWindow.frame.size.height + DFDisplayMargin, DFScreenWidth, self.menuHeight + DFDisplayMargin);
                break;
            case DFDisPlayDirectionLeftToRight:
                self.frame = CGRectMake(-(self.menuWidth + DFDisplayMargin), 0, self.menuWidth + DFDisplayMargin, DFScreenHeight);
                break;
        }
    }];
    [self beforeAnimation];
    [UIView animateWithDuration:khelperViewAnimationDurning delay:kdelayAnimationDurning usingSpringWithDamping:0.5f initialSpringVelocity:0.9f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
        switch (self.displayDirection) {
            case DFDisPlayDirectionDownToUp:
                self->_helperCenterView.frame = CGRectMake((self->keyWindow.frame.size.width - DFHelperViewWidthHeight) / 2, self->keyWindow.frame.size.height, DFHelperViewWidthHeight, DFHelperViewWidthHeight);
                break;
            case DFDisPlayDirectionLeftToRight:
                self->_helperCenterView.frame = CGRectMake(-DFHelperViewWidthHeight , (self->keyWindow.frame.size.height - DFHelperViewWidthHeight) / 2, DFHelperViewWidthHeight, DFHelperViewWidthHeight);
                break;
        }
    } completion:^(BOOL finished) {
        [self finishAnimation];
    }];
    [UIView animateWithDuration:kmengbanAnimationDurning animations:^{
        self->_mengbanView.alpha = 0.0f;
    }];
    [self beforeAnimation];
    [UIView animateWithDuration:khelperViewAnimationDurning delay:kdelayAnimationDurning usingSpringWithDamping:0.8f initialSpringVelocity:2.0f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
        switch (self.displayDirection) {
            case DFDisPlayDirectionDownToUp:
                self->_helperSliderView.frame = CGRectMake(0, self->keyWindow.frame.size.height, DFHelperViewWidthHeight, DFHelperViewWidthHeight);
                break;
            case DFDisPlayDirectionLeftToRight:
                self->_helperSliderView.frame = CGRectMake(-DFHelperViewWidthHeight , 0, DFHelperViewWidthHeight, DFHelperViewWidthHeight);
                break;
        }
    } completion:^(BOOL finished) {
        [self finishAnimation];
    }];
    _isDisplay = NO;
}

//- (void)buttonClick:(UIButton *)button{
//    if (self.buttonBlock) {
//        self.buttonBlock(button.tag);
//    }
//}

- (void)tapClick:(UITapGestureRecognizer *)gesture{
    [self popMenu];
}

- (void)menuTapClick:(UITapGestureRecognizer *)gesture{
    UIGestureRecognizerState state = gesture.state;
    CGPoint point = [gesture locationInView:gesture.view];
    if (point.y <= DFDisplayMargin && self.displayDirection == DFDisPlayDirectionDownToUp) {
        [self popMenu];
    }else if (self.displayDirection == DFDisPlayDirectionLeftToRight && point.x > self.menuWidth){
        [self popMenu];
    }
}

- (void)beforeAnimation{
    if (!self.displayLink) {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkAction:)];
        [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    self.animationCount++;
}

- (void)finishAnimation{
    self.animationCount--;
    if (self.animationCount == 0) {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}

- (void)displayLinkAction:(CADisplayLink *)link{
    CALayer *sliderLayer = (CALayer*)[_helperSliderView.layer presentationLayer];
    CALayer *centerLayer = (CALayer *)[_helperCenterView.layer presentationLayer];
    
    CGRect sliderRect = [[sliderLayer valueForKey:@"frame"] CGRectValue];
    CGRect centerRect = [[centerLayer valueForKey:@"frame"] CGRectValue];
    
    switch (self.displayDirection) {
        case DFDisPlayDirectionDownToUp:
            _helperViewDiff = sliderRect.origin.y - centerRect.origin.y;
            break;
        case DFDisPlayDirectionLeftToRight:
            _helperViewDiff = sliderRect.origin.x - centerRect.origin.x;
            break;
    }
    [self setNeedsDisplay];
}

@end
