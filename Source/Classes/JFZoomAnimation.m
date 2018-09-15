//
//  JFZoomAnimation.m
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

#import "JFZoomAnimation.h"

@interface JFZoomAnimation () <CAAnimationDelegate>
@end

@implementation JFZoomAnimation
@synthesize duration = _duration;
@synthesize view = _view;
@synthesize animating = _animating;

- (instancetype)init {
    if (self = [super init]) {
        _autoReverse = YES;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"%@ -- dealloc", [self class]);
}

- (void)zoomForView:(UIView *)view {
    [self setAnimatableView:view];
    [self startAnimation];
}

- (void)animate {
    CABasicAnimation *zoomAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    zoomAnimation.fromValue = @(1.0);
    zoomAnimation.toValue = @(self.scale);
    zoomAnimation.duration = self.duration;
    zoomAnimation.fillMode = kCAFillModeForwards;
    zoomAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    zoomAnimation.autoreverses = self.autoReverse;
    zoomAnimation.delegate = self;
    zoomAnimation.removedOnCompletion = NO;

    [self.view.layer addAnimation:zoomAnimation forKey:@"zoomAnimation"];
}

#pragma mark - MZDAnimationProtocol

- (void)setAnimatableView:(UIView *)view {
    _view = view;
}

- (void)startAnimation {
    if (self.isAnimating) {
        return;
    }
    
    _animating = YES;
    [self animate];
}

- (void)stopAnimation {
    _animating = NO;
    [self.view.layer removeAllAnimations];
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        _animating = NO;
    }
}
@end
