//
//  ViewController.m
//  DFSpringWindow
//
//  Created by huitong on 2019/7/17.
//  Copyright © 2019 duanfeng. All rights reserved.
//

#import "ViewController.h"
#import "DFSpringMenu.h"

@interface ViewController ()

@end

@implementation ViewController{
    DFSpringMenu *m;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSMutableArray *am = [NSMutableArray array];
    for (int i = 0; i < 4; i++) {
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        b.tag = i;
        [b setTitle:[NSString stringWithFormat:@"哈哈%d",i] forState:UIControlStateNormal];
        [b setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [b addTarget:self action:@selector(bClick:) forControlEvents:UIControlEventTouchUpInside];
        [am addObject:b];
    }
//    m = [[DFSpringMenu alloc]initWithDirection:DFDisPlayDirectionDownToUp widthHeight:200 backgroundColor:[UIColor whiteColor] buttons:[am copy]];
    m = [[DFSpringMenu alloc]initWithDirection:DFDisPlayDirectionLeftToRight widthHeight:200 backgroundColor:[UIColor whiteColor] buttons:[am copy]];
}

- (void)bClick:(UIButton *)sender{
    NSLog(@"%@",sender.titleLabel.text);
    [m popMenu];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [m pushMenu];
}

@end
