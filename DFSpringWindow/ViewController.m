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
    m = [[DFSpringMenu alloc]initWithDirection:DFDisPlayDirectionDownToUp widthHeight:200 backgroundColor:[UIColor whiteColor] buttonImages:nil];
    m.buttonBlock = ^(NSInteger index) {
        NSLog(@"%zd",index);
    };
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [m pushMenu];
}

@end
