//
//  JFFloatingAnimation.m
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

#import "JFFloatingAnimation.h"

@interface JFFloatingAnimation () <CAAnimationDelegate>
@end

@implementation JFFloatingAnimation
@synthesize duration = _duration;
@synthesize view = _view;
@synthesize animating = _animating;

- (instancetype)init {
    if (self = [super init]) {
        _repeatForever = YES;
    }
    return self;
}

- (void)animate {
    CABasicAnimation *floatAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    CGFloat originY = self.view.center.y;
    floatAnimation.fromValue = @(originY);
    floatAnimation.toValue = @(originY + self.distance);
    floatAnimation.duration = self.duration * 0.5;
    floatAnimation.fillMode = kCAFillModeForwards;
    floatAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    floatAnimation.autoreverses = YES;
    floatAnimation.delegate = self;

    if (self.repeatForever) {
        floatAnimation.repeatCount = HUGE_VAL;
    }

    [self.view.layer addAnimation:floatAnimation forKey:@"floatAnimation"];
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
