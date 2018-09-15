//
//  JFRippleAnimation.m
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

#import "JFRippleAnimation.h"

@interface MZDRippleLayer: CAShapeLayer <CAAnimationDelegate>
@end

@implementation MZDRippleLayer

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        [self removeAllAnimations];
        [self removeFromSuperlayer];
    }
}
@end

@interface JFRippleAnimation ()
@property (nonatomic, weak) NSTimer *timer;
@end

@implementation JFRippleAnimation
@synthesize duration = _duration;
@synthesize view = _view;
@synthesize animating = _animating;

- (instancetype)init {
    if (self = [super init]) {
        _repeatForever = YES;
    }
    return self;
}

- (void)addTimer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:self.interval repeats:YES block:^(NSTimer *timer) {
            [self animate];
        }];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

- (void)removeTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (CGRect)makeStartRect {
    CGRect rect = self.view.frame;
    CGFloat diffX = self.view.transform.a - CGAffineTransformIdentity.a;
    CGFloat diffY = self.view.transform.d - CGAffineTransformIdentity.d;
    rect = CGRectInset(rect, -1 * CGRectGetWidth(rect) * diffX, -1 * CGRectGetHeight(rect) * diffY);
    return rect;
}

- (CGRect)makeEndRect {
    CGRect rect = [self makeStartRect];
    rect = CGRectInset(rect, -self.radius, -self.radius);
    return rect;
}

- (void)addAnimationForLayer:(MZDRippleLayer *)layer {
    CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
    group.duration = self.duration;
    group.beginTime = self.beginTime;

    UIBezierPath *beginPath = [UIBezierPath bezierPathWithOvalInRect:[self makeStartRect]];
    UIBezierPath *endPath = [UIBezierPath bezierPathWithOvalInRect:[self makeEndRect]];
    layer.path = beginPath.CGPath;
    layer.opacity = 0.0;

    CABasicAnimation *rippleAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    rippleAnimation.fromValue = (__bridge id _Nullable)(beginPath.CGPath);
    rippleAnimation.toValue = (__bridge id _Nullable)(endPath.CGPath);
    rippleAnimation.duration = self.duration;

    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @(1.0);
    opacityAnimation.toValue = @(0.0);
    opacityAnimation.duration = self.duration;

    group.animations = @[rippleAnimation, opacityAnimation];
    group.delegate = layer;

    [layer addAnimation:group forKey:@"rippleAnimation"];
}

- (MZDRippleLayer *)rippleLayer {
    MZDRippleLayer *rippleLayer = [[MZDRippleLayer alloc] init];
    rippleLayer.strokeColor = self.borderColor.CGColor;
    rippleLayer.lineWidth = self.borderWidth;
    rippleLayer.fillColor = self.rippleColor.CGColor;
    return rippleLayer;
}

- (void)animate {
    MZDRippleLayer *rippleLayer = [self rippleLayer];

    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:[self makeStartRect]];
    rippleLayer.path = path.CGPath;
    [self.view.superview.layer insertSublayer:rippleLayer atIndex:0];

    [self addAnimationForLayer:rippleLayer];
}

- (void)rippleForView:(UIView *)view {
    [self setAnimatableView:view];
    [self startAnimation];
}

#pragma mark - MZDAnimationProtocol

- (void)setAnimatableView:(UIView *)view {
    _view = view;
}

- (void)startAnimation {
    if (self.interval > 0 && self.repeatForever) {
        [self addTimer];
    }

    if (self.isAnimating) {
        return;
    }
    _animating = YES;

    [self animate];
}

- (void)stopAnimation {
    [self removeTimer];
    _animating = NO;
    NSArray *layers = self.view.superview.layer.sublayers;
    NSEnumerator *enumerator = [layers reverseObjectEnumerator];
    for (CALayer *layer in enumerator) {
        if ([layer isKindOfClass:[MZDRippleLayer class]]) {
            [layer removeAllAnimations];
            [layer removeFromSuperlayer];
        }
    }
}
@end
