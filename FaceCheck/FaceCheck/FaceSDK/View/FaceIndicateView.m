//
//  FaceIndicateView.m
//  FaceCheck
//
//  Created by FaceCheck on 2024/7/23.
//

#import "FaceIndicateView.h"

#import "FaceHollowView.h"

#import "FaceImageTool.h"

#import "UIView+Face.h"

@interface FaceIndicateView ()

@property (nonatomic, strong) UIImageView      *preView;

@property (nonatomic, strong) FaceHollowView   *hollowView;

@property (nonatomic, strong) UILabel          *tipLabel;

@property (nonatomic, strong) UIImageView      *actionView;

@end

@implementation FaceIndicateView

- (void)setResultImage:(UIImage *)resultImage {
    _resultImage = resultImage;
    
    self.actionView.image = resultImage;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, UIApplication.sharedApplication.windows.firstObject.safeAreaInsets.top + 44 + 20, self.frame.size.width - 40, 40)];
        _tipLabel.backgroundColor = UIColor.yellowColor;
        _tipLabel.textColor = UIColor.orangeColor;
        _tipLabel.text = @"Please put your face into the frame";
        _tipLabel.font = [UIFont systemFontOfSize:14];
        _tipLabel.numberOfLines = 0;
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        
        _preView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 220, 220)];
        _preView.backgroundColor = UIColor.blackColor;
        _preView.frame = self.bounds;
        _preView.center = CGPointMake(self.center.x, self.center.y - 100);
        
        _hollowView = [[FaceHollowView alloc] initWithFrame:_preView.frame];
        
        _actionView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 210, 280)];
        _actionView.center = CGPointMake(self.center.x, self.center.y + 200);
        
        [self addSubview:_preView];
        [self addSubview:_hollowView];
        
        [self addSubview:_tipLabel];
        [self addSubview:_actionView];
    }
    
    return self;
}

#pragma action

@end

@implementation FaceIndicateView (FaceIndicateInterface)

- (void)faceComplete {
    
}

- (UIView *)faceGetPreview {
    return self.preView;
}

- (void)faceChangeErrorTip:(NSString *)tip {
    if ([tip length] == 0) {
        self.tipLabel.text = @"Please put your face into the frame";
    } else {
        self.tipLabel.text = tip;
    }
}

- (CGPoint)faceGetMaskCenter {
    // 480x640
    CGFloat width = UIScreen.mainScreen.bounds.size.width;
    CGFloat height = UIScreen.mainScreen.bounds.size.height;
    
    float imageW = 480;
    float imageH = 640;
    
    CGFloat currentX = self.hollowView.centerPoint.x / width * imageW;
    CGFloat currentY = self.hollowView.centerPoint.y - (height-imageH)/2.0;
    
    return CGPointMake(currentX, currentY);
}

- (CGFloat)faceGetMaskRadius {
    float imageW = 480;
    CGFloat width = UIScreen.mainScreen.bounds.size.width;

    return self.hollowView.radius * imageW/width;
}

@end
