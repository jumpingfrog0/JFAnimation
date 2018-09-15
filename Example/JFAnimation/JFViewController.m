//
//  JFViewController.m
//  JFAnimation
//
//  Created by jumpingfrog0 on 09/15/2018.
//  Copyright (c) 2018 jumpingfrog0. All rights reserved.
//

#import "JFViewController.h"
#import <JFAnimation/JFZoomAnimation.h>
#import <JFAnimation/JFPopupAnimation.h>
#import <JFAnimation/JFRippleAnimation.h>
#import <JFAnimation/JFRadarAnimation.h>
#import <JFAnimation/JFFloatingAnimation.h>

@interface JFViewController ()
@property (nonatomic, strong) UIView *radarView;

@property (nonatomic, strong) UIView *redView;
@property (nonatomic, strong) UIView *blueView;
@property (nonatomic, strong) UIButton *cyanView;
@property (nonatomic, strong) UIView *v3;

@property (nonatomic, strong) JFZoomAnimation *zoomAnimation;
@end

@implementation JFViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.radarView];

    [self setup];
    [self testRipple];
    [self testRadar];
}

- (void)setup {
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:redView];
    self.redView = redView;

    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(50, 50, 50, 20)];
    [button1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button1 setTitle:@"ripple" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(testRipple) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];

    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(120, 50, 50, 20)];
    [button2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button2 setTitle:@"floating" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(testFloating) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];

    UIButton *button3 = [[UIButton alloc] initWithFrame:CGRectMake(190, 50, 50, 20)];
    [button3 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button3 setTitle:@"zoom" forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(testZoom) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];

    UIButton *button4 = [[UIButton alloc] initWithFrame:CGRectMake(260, 50, 60, 20)];
    [button4 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button4 setTitle:@"popup" forState:UIControlStateNormal];
    [button4 addTarget:self action:@selector(testPopup) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button4];

    UIButton *button5 = [[UIButton alloc] initWithFrame:CGRectMake(330, 50, 50, 20)];
    [button5 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button5 setTitle:@"radar" forState:UIControlStateNormal];
    [button5 addTarget:self action:@selector(testRadar) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button5];

    [self setUpBlueView];
    [self setUpCyanView];
}

- (void)setUpBlueView
{
    _blueView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    _blueView.layer.backgroundColor = [UIColor blueColor].CGColor;
    _blueView.layer.cornerRadius = 25;
    _blueView.layer.masksToBounds = YES;
    _blueView.layer.borderColor = [UIColor yellowColor].CGColor;
    _blueView.layer.borderWidth = 2;

    [self.redView addSubview:_blueView];
}

- (void)setUpCyanView {
    _cyanView = [[UIButton alloc] initWithFrame:CGRectMake(50, 50, 50, 50)];
    _cyanView.layer.backgroundColor = [UIColor cyanColor].CGColor;
    _cyanView.layer.cornerRadius = 25;
    _cyanView.layer.masksToBounds = YES;
    _cyanView.layer.borderColor = [UIColor yellowColor].CGColor;
    _cyanView.layer.borderWidth = 2;
    [_cyanView addTarget:self action:@selector(touchButton:) forControlEvents:UIControlEventTouchUpInside];

    [self.redView addSubview:_cyanView];
}


- (void)testRadar {
    [[self.view viewWithTag:1000] removeFromSuperview];
    [[self.view viewWithTag:1001] removeFromSuperview];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(150, 420, 50, 30);
    button.tag = 1001;
    [button setTitle:@"重置" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(testRadar) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

    UIView *v2 = [[UIView alloc] init];
    v2.backgroundColor = [UIColor orangeColor];
    v2.frame = CGRectMake(100, 450, 300, 300);
    v2.layer.masksToBounds = YES;
    v2.layer.cornerRadius = 150;
    v2.tag = 1000;
    [self.view addSubview:v2];

    [self performSelector:@selector(startRadar) withObject:nil afterDelay:1];
}

- (void)startRadar {
    UIView *v3 = [[UIView alloc] init];
    v3.backgroundColor = [UIColor blueColor];
    v3.frame = CGRectMake(0, 0, 50, 50);
    v3.layer.masksToBounds = YES;
    v3.layer.cornerRadius = 25;

    UIView *v2 = [self.view viewWithTag:1000];

    JFRadarAnimation *radar = [[JFRadarAnimation alloc] init];
    radar.bounds = CGRectMake(0, 0, 300, 300);
    radar.color = [UIColor colorWithRed:253.0/255.0 green:73.0/255.0 blue:128.0/255.0 alpha:1];
    radar.angle = 90;
    radar.duration = 4;
    [radar setAnimatableView:v2];
    [radar setCenterView:v3];
    [radar startAnimation];

    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [radar stopAnimation];
    });
}

- (void)testPopup {
    [self.cyanView.layer removeAllAnimations];

    JFPopupAnimation *popup = [[JFPopupAnimation alloc] init];
    popup.duration = 1;
    [popup setAnimatableView:self.cyanView];
    [popup startAnimation];
}

- (void)testFloating {
    [self.cyanView.layer removeAllAnimations];

    JFFloatingAnimation *floating = [[JFFloatingAnimation alloc] init];
    floating.duration = 1.0;
    floating.distance = -5;
    [floating setAnimatableView:self.cyanView];
    [floating startAnimation];
}

- (void)testZoom {
    [self.cyanView.layer removeAllAnimations];

    if (self.zoomAnimation) {
        [self.zoomAnimation startAnimation];
        return;
    }

    JFZoomAnimation *zoom = [[JFZoomAnimation alloc] init];
    zoom.duration = 0.2;
    zoom.scale = 0.9;
    [zoom setAnimatableView:self.cyanView];
    [zoom startAnimation];
    self.zoomAnimation = zoom;
}

- (void)testRipple {
    JFRippleAnimation *ripple = [[JFRippleAnimation alloc] init];
    ripple.rippleColor = [UIColor greenColor];
//    ripple.borderColor = [UIColor greenColor];
//    ripple.borderWidth = 5;
    ripple.duration = 3;
    ripple.interval = 1;
    ripple.radius = 200;
    [ripple setAnimatableView:self.blueView];
    [ripple startAnimation];

    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [ripple stopAnimation];
    });
}

- (void)touchButton:(UIButton *)sender {
    [self testZoom];
}
@end

