//
//  ViewController.m
//  侧拉菜单
//
//  Created by 何青 on 2018/1/22.
//  Copyright © 2018年 何青. All rights reserved.
//

#import "ViewController.h"
#import "TogetherLeftView.h"
#import "TogetherRightView.h"
#define LEFTVIEWWIDTH 200
#import "HQHttpTool.h"

@interface ViewController ()
@property (nonatomic, strong) TogetherLeftView *    leftView;
@property (nonatomic, strong) TogetherRightView *   rightView;
@end

@implementation ViewController

-(TogetherLeftView *)leftView{
    if (!_leftView) {
        _leftView = [[TogetherLeftView alloc] initWithFrame:CGRectMake(0, 0, LEFTVIEWWIDTH, [UIScreen mainScreen].bounds.size.height)];
        _leftView.dataArr = @[@"个人资料",@"我的金币",@"福利礼盒",@"设置",@"清除缓存",@"退出登录"];
    }
    return _leftView;
}

- (TogetherRightView *)rightView{
    if (!_rightView) {
        _rightView = [[TogetherRightView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    }
    return _rightView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.leftView];
    [self.view addSubview:self.rightView];
    [[HQHttpTool shareManager] requestWithMethod:GET WithPath:@"" withParams:nil withSuccessBlock:^(NSDictionary *dic) {
        
    } withFailureBlock:^(NSError *error) {
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
