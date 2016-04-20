//
//  LBGuideView.h
//  test
//
//  Created by luobbe on 16/4/20.
//  Copyright © 2016年 luobbe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBGuideView : UIView

@property(nonatomic,copy) UIColor *backgroundColor; // RGBA 0 0 0 0.7

@property(nonatomic, copy) UIBezierPath *path;
@property (nonatomic, assign) CGRect visibleRect;  // visible rect

@property (nonatomic, strong) CAAnimation *animation;
@property (nonatomic, assign) CGFloat duration; // default 0.25s

- (void)show:(UIView *)view;
- (void)hide;

@end
