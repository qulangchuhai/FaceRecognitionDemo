//
//  FaceIndicateView.h
//  FaceCheck
//
//  Created by FaceCheck on 2024/7/23.
//

#import <UIKit/UIKit.h>

#import "FaceInterface.h"

NS_ASSUME_NONNULL_BEGIN

@interface FaceIndicateView : UIView

@property (nonatomic, strong) UIImage   *resultImage;

@end

@interface FaceIndicateView (FaceIndicateInterface)<FaceIndicateInterface>

@end

NS_ASSUME_NONNULL_END
