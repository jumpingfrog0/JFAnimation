//
//  JFRippleAnimation.h
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

#import <UIKit/UIKit.h>
#import "JFAnimationProtocol.h"

@interface JFRippleAnimation : NSObject <JFAnimationProtocol>
/**
 * 波纹扩散半径
 */
@property(nonatomic, assign) CGFloat radius;

/**
 * 每圈波纹间的时间间隔
 */
@property(nonatomic, assign) NSTimeInterval interval;

/**
 * 波纹颜色
 */
@property (nonatomic, strong) UIColor *rippleColor;

/**
 * 波纹边线的颜色
 */
@property (nonatomic, strong) UIColor *borderColor;

/**
 * 波纹边线的宽度
 */
@property(nonatomic, assign) CGFloat borderWidth;

/**
 * 波纹扩散一圈的时长
 */
@property(nonatomic, assign) NSTimeInterval duration;

/**
 * 无限循环重复动画
 */
@property(nonatomic, assign) BOOL repeatForever;

@property(nonatomic, assign) CFTimeInterval beginTime;

/**
 * 指定一个view，开始波纹扩散动画
 * @param view 做动画的view
 */
- (void)rippleForView:(UIView *)view;
@end
