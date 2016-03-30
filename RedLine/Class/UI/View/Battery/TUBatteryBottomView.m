//
//  TUBatteryBottomView.m
//  RedLine
//
//  Created by LXJ on 16/3/28.
//  Copyright © 2016年 cn. All rights reserved.
//

#import "TUBatteryBottomView.h"
#import "UIView+Category.h"
#import "UIColor+GGColor.h"
#import "UIImage+Color.h"
#import "UIImage+YYWebImage.h"

#define DegreesToRadians(_degrees) ((M_PI * (_degrees))/180)

@interface TUBatteryBottomView ()

@property (strong, nonatomic) UIView *temperatureView;
@property (strong, nonatomic) UIView *batteryLifeView;

@property (strong, nonatomic) CAShapeLayer *temperatureDotLayer;
@property (strong, nonatomic) CAShapeLayer *batteryDotLayer;

@property (strong, nonatomic) UIImageView *temperatureImage;
@property (strong, nonatomic) UIImageView *batteryLifeImage;


@property (strong, nonatomic) UILabel *temperatureLabel;

@property (strong, nonatomic) UILabel *batteryLabel;

@property (assign, nonatomic) CGFloat lastTemperature;
@end

@implementation TUBatteryBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setup];
}

- (void)setup {
    
    [self addSubview:self.temperatureImage];
    [self.temperatureImage addSubview:self.temperatureLabel];
    [self.temperatureImage addSubview:self.temperatureValueLabel];
    
//    [self addSubview:self.temperatureView];
    [self addSubview:self.batteryLifeView];
    
//    [self.temperatureView addSubview:self.temperatureLabel];
//    [self.temperatureView addSubview:self.temperatureValueLabel];
    
    [self.batteryLifeView addSubview:self.batteryLabel];
    [self.batteryLifeView addSubview:self.batteryValueLabel];
    
    [self temperatureUI];
    [self batteryUI];
}

- (void)temperatureUI {
    self.temperatureDotLayer = [CAShapeLayer layer];
    self.temperatureDotLayer.position = CGPointMake(self.temperatureImage.width/2, self.temperatureImage.height/2);
    self.temperatureDotLayer.fillColor = [UIColor whiteColor].CGColor;
    
    //设置圆的半径
    //设置路径
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(30, 30, 10, 10)];
    self.temperatureDotLayer.path = circlePath.CGPath;
    
    [self.temperatureImage.layer addSublayer:self.temperatureDotLayer];
}

- (void)batteryUI {
    self.batteryDotLayer = [CAShapeLayer layer];
    self.batteryDotLayer.position = CGPointMake(55, 55);
    self.batteryDotLayer.fillColor = [UIColor whiteColor].CGColor;
    
    //设置圆的半径
    //设置路径
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(32, 32, 10, 10)];
    self.batteryDotLayer.path = circlePath.CGPath;
    
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    anima.duration = 10.f;
    anima.repeatCount = HUGE;
    anima.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
    //    anima.removedOnCompletion = NO;
    //    anima.fillMode = kCAFillModeForwards;
    [self.batteryDotLayer addAnimation:anima forKey:nil];
    
    //画圆
    CAShapeLayer * trackLayer = [CAShapeLayer layer];
    trackLayer.frame = self.batteryDotLayer.bounds;
    trackLayer.fillColor = [[UIColor clearColor] CGColor];//填充颜色，这里应该是  clearColor
    trackLayer.strokeColor = [[UIColor redColor] CGColor];//边框颜色
    trackLayer.opacity = 1;
    trackLayer.lineCap = kCALineCapRound;
    trackLayer.lineWidth = 4.0;  // 红色的边框宽度
    
    UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(55, 55) radius:53 startAngle:DegreesToRadians(-210) endAngle:DegreesToRadians(30) clockwise:YES];
    //角度是从 -210到30度，具体可以看如下图所示
    trackLayer.path = [path CGPath];
    
    [self.batteryLifeView.layer addSublayer:trackLayer];
    
    
    CALayer * gradinetLayer = [CALayer layer];
    
    CAGradientLayer * gradLayer1 = [CAGradientLayer layer];
    gradLayer1.frame = CGRectMake(0, 0, self.batteryLifeView.width/2, self.batteryLifeView.height);
    [gradLayer1 setColors:[NSArray arrayWithObjects:(id)[[UIColor colorWithARGB:0xff3ed0bd] CGColor],(id)[UIColor colorWithARGB:0xfff2e562].CGColor, nil]];
    [gradLayer1 setLocations:@[@0.5,@0.9,@1 ]];
    [gradLayer1 setStartPoint:CGPointMake(0.5, 1)];
    [gradLayer1 setEndPoint:CGPointMake(0.5, 0)];
    [gradinetLayer addSublayer:gradLayer1];
    
    CAGradientLayer * gradLayer2 = [CAGradientLayer layer];
    gradLayer2.frame = CGRectMake(self.batteryLifeView.width/2, 0, self.batteryLifeView.width/2, self.temperatureView.height);
    [gradLayer2 setColors:[NSArray arrayWithObjects:(id)[UIColor colorWithARGB:0xfff2e562].CGColor,(id)[[UIColor colorWithARGB:0xffd93d64] CGColor], nil]];
    [gradLayer2 setLocations:@[@0.2,@0.5,@1 ]];
    [gradLayer2 setStartPoint:CGPointMake(0.5, 0)];
    [gradLayer2 setEndPoint:CGPointMake(0.5, 1)];
    [gradinetLayer addSublayer:gradLayer2];
    
    [gradinetLayer setMask:trackLayer];
    
    [self.batteryLifeView.layer addSublayer:gradinetLayer];
    [self.batteryLifeView.layer addSublayer:self.batteryDotLayer];

    
}

- (void)updateTemperatureUI:(CGFloat)temperature {
    self.temperatureValueLabel.text = [NSString stringWithFormat:@"%.1f℃",temperature];
    self.temperatureDotLayer.transform = CATransform3DMakeRotation(M_PI_4 * 3, 0, 0, 1);
    
    CGFloat lastTemp = self.lastTemperature ? self.lastTemperature : 0;
    
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    anima.duration = 2.f;

    anima.fromValue = [NSNumber numberWithFloat:M_PI_4 * 3 + DegreesToRadians(lastTemp/35.0*180)];
    anima.toValue = [NSNumber numberWithFloat:M_PI_4 * 3 + DegreesToRadians(temperature/35.0*180)];
    //1.2设置动画执行完毕之后不删除动画
    anima.removedOnCompletion = NO;
    //1.3设置保存动画的最新状态,即动画执行完后保持在最后的位置
    anima.fillMode = kCAFillModeForwards;
    anima.delegate = self;
    [self.temperatureDotLayer addAnimation:anima forKey:@"temperature"];
    
    self.lastTemperature = temperature;

}

#pragma mark - setter & getter
- (UIView *)temperatureView {
    if (!_temperatureView) {
        _temperatureView = [[UIView alloc] initWithFrame:CGRectMake(self.width/2 - 130, 20, 110, 110)];
        _temperatureView.backgroundColor = [UIColor clearColor];
    }
    return _temperatureView;
}

- (UIView *)batteryLifeView {
    if (!_batteryLifeView) {
        _batteryLifeView = [[UIView alloc] initWithFrame:CGRectMake(self.width/2 + 20, 20, 110, 110)];
        _batteryLifeView.backgroundColor = [UIColor clearColor];
    }
    return _batteryLifeView;
}

- (UILabel *)temperatureLabel {
    if (!_temperatureLabel) {
        _temperatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, 45, 90, 20)];
        _temperatureLabel.textColor = [UIColor whiteColor];
        _temperatureLabel.font = [UIFont systemFontOfSize:14.f];
        _temperatureLabel.textAlignment = NSTextAlignmentCenter;
        _temperatureLabel.text = @"当前电池温度";
    }
    return _temperatureLabel;
}

- (UILabel *)temperatureValueLabel {
    if (!_temperatureValueLabel) {
        _temperatureValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, 65, 90, 20)];
        _temperatureValueLabel.textColor = [UIColor whiteColor];
        _temperatureValueLabel.font = [UIFont systemFontOfSize:20.f];
        _temperatureValueLabel.textAlignment = NSTextAlignmentCenter;
        _temperatureValueLabel.text = [NSString stringWithFormat:@"%dC",30];
    }
    return _temperatureValueLabel;
}

- (UILabel *)batteryLabel {
    if (!_batteryLabel) {
        _batteryLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 90, 20)];
        _batteryLabel.textColor = [UIColor whiteColor];
        _batteryLabel.font = [UIFont systemFontOfSize:15.f];
        _batteryLabel.textAlignment = NSTextAlignmentCenter;
        _batteryLabel.text = @"电池剩余寿命";

    }
    return _batteryLabel;
}

- (UILabel *)batteryValueLabel {
    if (!_batteryValueLabel) {
        _batteryValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 55, 90, 20)];
        _batteryValueLabel.textColor = [UIColor whiteColor];
        _batteryValueLabel.font = [UIFont systemFontOfSize:20.f];
        _batteryValueLabel.textAlignment = NSTextAlignmentCenter;
        _batteryValueLabel.text = @"2年6个月";
    }
    return _batteryValueLabel;
}

- (UIImageView *)temperatureImage {
    if (!_temperatureImage) {
        _temperatureImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.width/2 - 140, 10, 130, 130)];
        _temperatureImage.image = [UIImage imageNamed:@"battery_wendu"];
    }
    return _temperatureImage;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    // 130, (65,65)
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, 4, 4);
    view.backgroundColor = [UIColor redColor];
    
    NSNumber *toValue = [(CABasicAnimation *)anim toValue];
    NSLog(@"%@", toValue);
    
    CGPoint point = [self.class calcCircleCoordinateWithCenter:CGPointMake(65, 65) andWithAngle:toValue.floatValue andWithRadius:50];
    
    view.center = point;
    
    [self.temperatureImage addSubview:view];
    
    NSLog(@"self.temperatureImage: %@", NSStringFromCGRect(self.temperatureDotLayer.contentsCenter));
    
    //
    UIColor *color = [self.temperatureImage.image colorAtPoint:view.center];
    
//    CGRect cropRect = CGRectMake(point.x-2, point.y-2, 4, 4);
//    UIImage *cropImage = [self.temperatureImage.image yy_imageByCropToRect:cropRect];
//    UIColor *color = [self.temperatureImage.image colorAtPoint:point imageRect:self.temperatureImage.frame];
    
    view.backgroundColor = color;
    self.temperatureDotLayer.fillColor = color.CGColor;
}

+(CGPoint) calcCircleCoordinateWithCenter:(CGPoint) center  andWithAngle : (CGFloat) angle andWithRadius: (CGFloat) radius{
    CGFloat x2 = radius*cosf(angle*M_PI/180);
    CGFloat y2 = radius*sinf(angle*M_PI/180);
    return CGPointMake(center.x+x2, center.y-y2);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
