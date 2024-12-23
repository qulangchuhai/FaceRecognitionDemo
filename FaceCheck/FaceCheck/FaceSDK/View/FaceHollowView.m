//
//  FaceHollowView.m
//  FaceCheck
//
//  Created by FaceCheck on 2024/7/23.
//

#import "FaceHollowView.h"

@interface FaceHollowView ()

@property (nonatomic, strong) UIView   *circleView;

@end

@implementation FaceHollowView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        
        _radius = 130;
        
        _centerPoint = CGPointMake(frame.size.width * 0.5, frame.size.height * 0.5);
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = self.bounds;
        layer.path = [self getHollowPath];
        layer.fillRule = kCAFillRuleEvenOdd;
        
        self.layer.mask = layer;
        self.layer.masksToBounds = YES;
    }
    
    return self;
}

- (CGPathRef)getHollowPath {
    UIBezierPath *circlePath = [UIBezierPath bezierPath];
    
    [circlePath addArcWithCenter:self.centerPoint radius:self.radius startAngle:-M_PI_2 endAngle:M_PI_2*3 clockwise:YES];
    
    UIBezierPath *rectPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:0];
    
    rectPath.usesEvenOddFillRule = true;
    
    [rectPath appendPath:circlePath];
    
    return rectPath.CGPath;
}

@end
