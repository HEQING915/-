//
//  TogetherRightView.m
//  侧拉菜单
//
//  Created by 何青 on 2018/1/22.
//  Copyright © 2018年 何青. All rights reserved.
//

#import "TogetherRightView.h"
#define LEFTVIEWWIDTH 200

@interface TogetherRightView()
@property (nonatomic, assign) float centerX;
@property (nonatomic, assign) float centerY;
@property (nonatomic, strong) UIPanGestureRecognizer *pangestureRecognizer;
@property (nonatomic, strong) UIButton *leftBtn;
@end

@implementation TogetherRightView

- (UIPanGestureRecognizer *)pangestureRecognizer{
    if (!_pangestureRecognizer) {
        _pangestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    }
    return _pangestureRecognizer;
}

- (UIButton *)leftBtn{
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _leftBtn.frame = CGRectMake(100, 100, 100, 30);
        [_leftBtn setTitle:@"点我" forState:UIControlStateNormal];
        [_leftBtn addTarget:self action:@selector(clickLeftBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect screen = [UIScreen mainScreen].bounds;
        self.centerX = screen.size.width / 2;
        self.centerY = screen.size.height / 2;
        self.backgroundColor = [UIColor yellowColor];
        [self addSubview:self.leftBtn];
        [self addGestureRecognizer:self.pangestureRecognizer];
    }
    return self;
}

- (void)handlePan:(UIPanGestureRecognizer *)tap{
    
    CGPoint translation = [tap translationInView:self];
    float x = self.center.x +translation.x;
    if (x < _centerX) {
        x = _centerX;
    }
    self.center = CGPointMake(x, _centerY);
    
    if (tap.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.2f animations:^{
            if (x > self.centerX + LEFTVIEWWIDTH) {
                self.center = CGPointMake(self.centerX + LEFTVIEWWIDTH, _centerY);
            }else{
                self.center = CGPointMake(_centerX, _centerY);
            }
        }];
    }
    [tap setTranslation:CGPointZero inView:self];
}

- (void)clickLeftBtn:(UIButton *)sender{
    [UIView animateWithDuration:0.2f animations:^{
        if (self.center.x == self.centerX) {
            self.center = CGPointMake(self.centerX + LEFTVIEWWIDTH, _centerY);
        }else{
            self.center = CGPointMake(_centerX, _centerY);
        }
    }];
}

@end
