//
//  FacePointDrawView.m
//  FaceCheck
//
//  Created by FaceCheck on 2024/7/23.
//

#import "FacePointDrawView.h"

#import "FacePoint.h"

#import "UIView+Face.h"

static FacePointDrawView *drawView;

@interface FacePointDrawView ()

@property (nonatomic, strong) UIView      *pointBackView;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIView      *backView;

@end

@implementation FacePointDrawView

+ (FacePointDrawView *)shared {
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        drawView = [[FacePointDrawView alloc] init];
    });
    
    return drawView;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:self.backView.bounds];
    }
    
    return _imageView;
}

- (UIView *)backView {
    if (_backView == nil) {
        _backView = [[UIView alloc] initWithFrame:self.bounds];
    }
    
    return _backView;
}

- (UIView *)pointBackView {
    if (_pointBackView == nil) {
        _pointBackView = [[UIView alloc] initWithFrame:self.backView.bounds];
    }
    
    return _pointBackView;
}

- (UIImage *)showImage:(UIImage *)image facePoints:(NSArray *)facePoints fivePoints:(NSArray *)fivePoints faceBoundPoints:(NSArray *)faceBoundPoints centerPoint:(CGPoint)centerPoint radius:(CGFloat)radius {
    UIImage *result = [self configImage:image facePoints:facePoints fivePoints:fivePoints faceBoundPoints:faceBoundPoints centerPoint:centerPoint radius:radius];
    
    return result;
}

- (UIImage *)configImage:(UIImage *)image facePoints:(NSArray *)facePoints fivePoints:(NSArray *)fivePoints faceBoundPoints:(NSArray *)faceBoundPoints centerPoint:(CGPoint)center radius:(CGFloat)radius {
    float scale = self.width / image.size.width;
    self.backView.size = image.size;
    
    [self.backView addSubview:self.imageView];
    self.imageView.image = image;
    
    [self.backView addSubview:self.pointBackView];
    self.backView.center = CGPointMake(self.width * 0.5, self.height * 0.5);

    self.backView.transform = CGAffineTransformMakeScale(scale, scale);
    
    for (NSArray *face in fivePoints) {
        if (face.count > 0) {
            [self drawPoints:face width:8];
        }
    }
    
    for (NSArray *area in faceBoundPoints) {
        if (area.count > 0) {
            [self drawRectangle:area];
        }
    }
    
    [self drawCircle:center radius:radius];
    
    UIGraphicsBeginImageContextWithOptions(self.backView.bounds.size, NO, 0.0);

    CGContextRef context = UIGraphicsGetCurrentContext();

    [self.backView.layer renderInContext:context];

    UIImage *handleImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    
    return handleImage;
}

- (void)drawPoints:(NSArray *)points width:(CGFloat)width {
    for (FacePoint *point in points) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, width, width);
        layer.cornerRadius = width / 2;
        layer.masksToBounds = YES;
        layer.backgroundColor = UIColor.redColor.CGColor;
        layer.center = CGPointMake(point.x, point.y);
        [self.pointBackView.layer addSublayer:layer];
    }
}

- (void)drawRectangle:(NSArray *)points {
    if (points.count <= 1) {
        return;
    }
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (int i = 0; i < points.count; i++) {
        FacePoint *point = points[i];
        if (i == 0) {
            [path moveToPoint:CGPointMake(point.x, point.y)];
        } else {
            [path addLineToPoint:CGPointMake(point.x, point.y)];
        }
        
        if (i == points.count - 1) {
            [path closePath];
        }
    }
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = self.pointBackView.bounds;
    layer.path = path.CGPath;
    layer.fillColor = UIColor.clearColor.CGColor;
    layer.strokeColor = [UIColor cyanColor].CGColor;
    layer.lineWidth = 4;
    [self.pointBackView.layer addSublayer:layer];
}

- (void)drawCircle:(CGPoint)centerPoint radius:(CGFloat)radius {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:centerPoint radius:radius startAngle:-M_PI_2 endAngle:M_PI_2*3 clockwise:YES];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = self.pointBackView.bounds;
    layer.path = path.CGPath;
    layer.fillColor = UIColor.clearColor.CGColor;
    layer.strokeColor = [UIColor redColor].CGColor;
    layer.lineWidth = 4;
    [self.pointBackView.layer addSublayer:layer];
}

@end
