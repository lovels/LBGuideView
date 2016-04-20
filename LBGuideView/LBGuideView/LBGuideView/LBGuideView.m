//
//  LBGuideView.m
//  test
//
//  Created by luobbe on 16/4/20.
//  Copyright © 2016年 luobbe. All rights reserved.
//

#import "LBGuideView.h"

@interface LBGuideView ()

@property (nonatomic, strong) CAShapeLayer *backgroundLayer;

@end

@implementation LBGuideView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initialization];
        [self.layer addSublayer:self.backgroundFillLayer];
    }
    return self;
}

- (void)initialization
{
    //default backgroundColor
    _backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    // default path
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0,0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) cornerRadius:0];
    _path = path;
    //animation
    _duration = 0.25;
}

- (CAShapeLayer *)backgroundFillLayer
{
    if (_backgroundLayer == nil) {
        _backgroundLayer = [CAShapeLayer layer];
        _backgroundLayer.path = _path.CGPath;
        _backgroundLayer.fillRule =kCAFillRuleEvenOdd;
        _backgroundLayer.fillColor = _backgroundColor.CGColor;
    }
    return _backgroundLayer;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    _backgroundColor = backgroundColor;
    self.backgroundFillLayer.fillColor = backgroundColor.CGColor;
}

- (void)setPath:(UIBezierPath *)path
{
    _path = path;
    [self reload:YES];
}

- (void)setVisibleRect:(CGRect)visibleRect
{
    _visibleRect = visibleRect;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0,0, self.bounds.size.width, self.bounds.size.height) cornerRadius:0];
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:visibleRect cornerRadius:0];
    [path appendPath:circlePath];
    [path setUsesEvenOddFillRule:YES];
    _path = path;
    [self reload:YES];
}

- (void)reload:(BOOL)animated
{
    _backgroundLayer.path = _path.CGPath;
    if (!animated) return;
    [_backgroundLayer addAnimation:self.animation forKey:@"PathAnimation"];
}

- (CAAnimation *)animation
{
    if (_animation == nil) {
        _animation = [CABasicAnimation animationWithKeyPath:@"path"];
        _animation.duration = _duration;
        _animation.timingFunction = [CATransaction animationTimingFunction];
    }
    return _animation;
}

- (void)show:(UIView *)view
{
    [view addSubview:self];
}

- (void)hide
{
    [self removeFromSuperview];
}

@end
