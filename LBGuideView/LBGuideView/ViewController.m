//
//  ViewController.m
//  LBGuideView
//
//  Created by luobbe on 16/4/20.
//  Copyright © 2016年 luobbe. All rights reserved.
//

#import "ViewController.h"
#import "LBGuideView.h"

#define kDeviceWidth           [UIScreen mainScreen].bounds.size.width
#define KDeviceHeight          [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UIButton *homeBt;

@property (nonatomic, strong) LBGuideView *guideView;
@property (nonatomic, strong) UILabel *detailLB;
@property (nonatomic, copy) NSArray *rectArray;

@end

@implementation ViewController

static int tapcount = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // rect data
    NSValue *value1 = [NSValue valueWithCGRect:(CGRect){ 5, 20, 44, 44 }];
    NSValue *value2 = [NSValue valueWithCGRect:(CGRect){ kDeviceWidth - 50, 20, 44, 44 }];
    NSValue *value3 = [NSValue valueWithCGRect:(CGRect)self.homeBt.frame];
    NSValue *value4 = [NSValue valueWithCGRect:(CGRect){ (kDeviceWidth - 50) / 2.0, KDeviceHeight - 50, 50, 50 }];
    // avatar path
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0,0, self.guideView.bounds.size.width, self.guideView.bounds.size.height) cornerRadius:0];
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:self.avatar.frame cornerRadius:CGRectGetWidth(self.avatar.frame)/2.0];
    [path appendPath:circlePath];
    [path setUsesEvenOddFillRule:YES];
    _rectArray = @[value1, value2, value3, value4, path];
    [self show:nil];
}

- (LBGuideView *)guideView
{
    if (_guideView == nil) {
        //
        _guideView = [[LBGuideView alloc] initWithFrame:self.view.bounds];
        _guideView.animation.delegate = self;
        [_guideView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)]];
    }
    return _guideView;
}

- (UILabel *)detailLB
{
    if (_detailLB == nil) {
        _detailLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
        _detailLB.backgroundColor = [UIColor clearColor];
        _detailLB.textColor = [UIColor whiteColor];
    }
    return _detailLB;
}

- (void)tapAction
{
    if (tapcount == _rectArray.count) {
        [_guideView hide];
        tapcount = 0;
        return;
    }
    if (tapcount == _rectArray.count - 1) {
        // avatar path
        _guideView.path = _rectArray[tapcount];
    } else {
        // rect
        NSValue *value = _rectArray[tapcount];
        _guideView.visibleRect = value.CGRectValue;
    }
    self.detailLB.text = [NSString stringWithFormat:@"第%d步描述",tapcount + 1];
    [UIView animateWithDuration:tapcount == 0 ? 0 : _guideView.duration animations:^{
        [self changeDetailLBFrame];
    }];
    tapcount ++;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)show:(id)sender {
    _guideView = nil;
    [self.guideView show:self.tabBarController.view];
    self.detailLB = nil;
    [self.guideView addSubview:self.detailLB];
    [self tapAction];
}

- (void)changeDetailLBFrame;
{
    [self.detailLB sizeToFit];
    CGRect rect = CGRectMake(CGRectGetMinX(_guideView.visibleRect), CGRectGetMaxY(_guideView.visibleRect) + 10, CGRectGetWidth(self.detailLB.frame), CGRectGetHeight(self.detailLB.frame));
    if (tapcount == 1) {
        rect.origin.x = kDeviceWidth - CGRectGetWidth(self.detailLB.frame) - 10;
    } else if (tapcount == 3) {
        rect.origin.y = CGRectGetMinY(_guideView.visibleRect) - 10 - CGRectGetHeight(self.detailLB.frame);
    } else if (tapcount == _rectArray.count - 1) {
        rect.origin.x = self.avatar.frame.origin.x;
        rect.origin.y = CGRectGetMaxY(self.avatar.frame) + 10;
    }
    self.detailLB.frame = rect;
}

@end
