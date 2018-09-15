//
//  JFRadarAnimation.m
//  JFAnimation
//
//  Created by jumpingfrog0 on 2018/09/16.
//  Copyright (c) 2017 Jumpingfrog0 LLC
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "JFRadarAnimation.h"
#import "AngleGradientLayer.h"
#import "JFRippleAnimation.h"
#import "JFZoomAnimation.h"

@interface JFRadarAnimation ()
@property (nonatomic, strong) AngleGradientLayer *gradientLayer;
@property (nonatomic, strong) CAShapeLayer *circleLayer;

@property (nonatomic, strong) UIView *centerView;

@property (nonatomic, assign) CGFloat circleScaleFactor;
@property (nonatomic, assign) CGFloat centerScaleFactor;

@property (nonatomic, assign) CGFloat centerZoomDuration;
@property (nonatomic, assign) CGFloat circleRippleDuration;
@property (nonatomic, assign) CGFloat dismissDuration;

@end

@implementation JFRadarAnimation
@synthesize view = _view;
@synthesize duration = _duration;
@synthesize animating = _animating;

- (instancetype)init {
    if (self = [super init]) {
        _angle = 90;
        _circleScaleFactor = 1.2;
        _centerScaleFactor = 1.5;
        _centerZoomDuration = 1;
        _circleRippleDuration = 2.0;
        _dismissDuration = 1.0;
    }
    return self;
}

- (void)animate {
    AngleGradientLayer *gradientLayer = self.gradientLayer;
    [self.view.layer addSublayer:gradientLayer];

    [self addCenterZoomAnimation];
    [self addCircleRippleAnimation];
    [self addRotateAnimation];
}

- (void)addCenterZoomAnimation {
//    CAKeyframeAnimation *zoomAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
//    zoomAnimation.values = @[
//            @(1.0),
//            @(self.centerScaleFactor + 0.2),
//            @(self.centerScaleFactor)
//    ];
    // 使用弹性动画
    CASpringAnimation *zoomAnimation = [CASpringAnimation animationWithKeyPath:@"transform.scale"];
    zoomAnimation.fromValue = @(1.0);
    zoomAnimation.toValue = @(self.centerScaleFactor);
    zoomAnimation.damping = 8;
    zoomAnimation.duration = self.centerZoomDuration;
    zoomAnimation.fillMode = kCAFillModeForwards;
    zoomAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    zoomAnimation.removedOnCompletion = NO;
    [self.centerView.layer addAnimation:zoomAnimation forKey:@"centerZoomAnimation"];
}

- (void)addCircleRippleAnimation {
    CGRect circleRect = CGRectInset(self.centerView.frame, -20, -20);
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:circleRect];
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.path = circlePath.CGPath;
    circleLayer.strokeColor = self.color.CGColor;
    circleLayer.fillColor = [UIColor clearColor].CGColor;
    circleLayer.lineWidth = 1;

    [self.view.layer insertSublayer:circleLayer atIndex:0];
    self.circleLayer = circleLayer;
    
    // 缩放动画
    UIBezierPath *beginPath = [UIBezierPath bezierPathWithOvalInRect:circleRect];
    UIBezierPath *middlePath = [UIBezierPath bezierPathWithOvalInRect:[self makeRect:circleRect scale:self.circleScaleFactor]];

    CABasicAnimation *zoomAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    zoomAnimation.fromValue = (__bridge id _Nullable)(beginPath.CGPath);
    zoomAnimation.toValue = (__bridge id _Nullable)(middlePath.CGPath);
    zoomAnimation.duration = self.centerZoomDuration;
    zoomAnimation.fillMode = kCAFillModeForwards;
    zoomAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    zoomAnimation.removedOnCompletion = NO;

    [self.circleLayer addAnimation:zoomAnimation forKey:@"circleZoomAnimation"];
    
    // 波纹扩散动画
    CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
    group.duration = self.circleRippleDuration;
    group.beginTime = CACurrentMediaTime() + _centerZoomDuration - 0.4;
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    
    UIBezierPath *endPath = [UIBezierPath bezierPathWithOvalInRect:[self makeEndRect:middlePath.bounds]];
    
    CABasicAnimation *rippleAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    // 这里不设置开始的path，圆环的贝塞尔路径会从当前缩放状态时的路径开始变换，使得动画衔接更自然
//    rippleAnimation.fromValue = (__bridge id _Nullable)(middlePath.CGPath);
    rippleAnimation.toValue = (__bridge id _Nullable)(endPath.CGPath);
    rippleAnimation.duration = self.circleRippleDuration;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @(1.0);
    opacityAnimation.toValue = @(0.0);
    opacityAnimation.duration = self.circleRippleDuration;
    
    group.animations = @[rippleAnimation, opacityAnimation];
    
    [self.circleLayer addAnimation:group forKey:@"rippleAnimation"];
}

// 旋转动画
- (void)addRotateAnimation {
    CABasicAnimation* rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.toValue = @(M_PI * 2.0);
    rotateAnimation.duration = self.duration;
    rotateAnimation.cumulative = YES;
    rotateAnimation.repeatCount = HUGE_VALF;
    rotateAnimation.fillMode = kCAFillModeForwards;
    rotateAnimation.removedOnCompletion = NO;
    [self.gradientLayer addAnimation:rotateAnimation forKey:@"rotateAnimation"];
}

- (void)addDismissAnimation {
    // 恢复视图原样
    self.view.layer.borderColor = [UIColor clearColor].CGColor;
    self.view.layer.borderWidth = 0.0;

    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @(1.0);
    opacityAnimation.toValue = @(0.0);
    opacityAnimation.duration = self.dismissDuration;
    opacityAnimation.fillMode = kCAFillModeForwards;
    opacityAnimation.removedOnCompletion = NO;
    
    [self.gradientLayer addAnimation:opacityAnimation forKey:@"dismissAnimation"];
}

- (CGRect)makeEndRect:(CGRect)rect {
    CGFloat radius = (CGRectGetWidth(self.view.bounds) - CGRectGetWidth(rect)) / 2;
    rect = CGRectInset(rect, -radius, -radius);
    return rect;
}

- (CGRect)makeRect:(CGRect)rect scale:(CGFloat)scale {
    CGFloat factor = scale - 1.0;
    return CGRectInset(rect, -1 * CGRectGetWidth(rect) * factor / 2, -1 * CGRectGetHeight(rect) * factor / 2);
}

- (AngleGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        // 渐变图层
        _gradientLayer = [AngleGradientLayer layer];
        _gradientLayer.backgroundColor = [UIColor clearColor].CGColor;
        _gradientLayer.colors = @[(id)self.color.CGColor,
                (id)[self.color colorWithAlphaComponent:0].CGColor,
                (id)[self.color colorWithAlphaComponent:0].CGColor];
        _gradientLayer.locations = @[@0, @(self.angle/360.0), @1];
        _gradientLayer.bounds = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
        _gradientLayer.position = CGPointMake(CGRectGetWidth(self.view.bounds) * 0.5f, CGRectGetHeight(self.view.bounds) * 0.5f);

        // 裁剪成圆形
        CAShapeLayer *mask = [CAShapeLayer layer];
        mask.path = [UIBezierPath bezierPathWithOvalInRect:_gradientLayer.bounds].CGPath;
        _gradientLayer.mask = mask;
    }

    return _gradientLayer;
}

- (void)setCenterView:(UIView *)centerView {
    _centerView = centerView;
    [_view addSubview:centerView];
    centerView.center = CGPointMake(CGRectGetWidth(_view.bounds) / 2, CGRectGetHeight(_view.bounds) / 2);
}

#pragma mark - MZDAnimationProtocol
- (void)setAnimatableView:(UIView *)view {
    _view = view;
    view.layer.borderColor = self.color.CGColor;
    view.layer.borderWidth = 1;
}

- (void)startAnimation {
    if (self.isAnimating) {
        return;
    }

    _animating = YES;
    [self animate];
}

- (void)stopAnimation {
    [self addDismissAnimation];
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.dismissDuration * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        self.animating = NO;
        [self.circleLayer removeAllAnimations];
        [self.gradientLayer removeAllAnimations];
        [self.centerView.layer removeAllAnimations];
        [self.view.layer removeAllAnimations];
        
        // 中心位置的视图保持不变
        self.centerView.frame = [self makeRect:self.centerView.frame scale:self.centerScaleFactor];
        self.centerView.layer.masksToBounds = YES;
        self.centerView.layer.cornerRadius = CGRectGetWidth(self.centerView.frame) / 2;
        
        self.gradientLayer.opacity = 0.0;

        [self.circleLayer removeFromSuperlayer];
        [self.gradientLayer removeFromSuperlayer];
    });
}
@end
