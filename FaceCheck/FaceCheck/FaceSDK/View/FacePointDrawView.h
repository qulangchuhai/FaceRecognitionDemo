//
//  FacePointDrawView.h
//  FaceCheck
//
//  Created by FaceCheck on 2024/7/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FacePointDrawView : UIView

- (UIImage *)showImage:(UIImage *)image facePoints:(NSArray *)facePoints fivePoints:(NSArray *)fivePoints faceBoundPoints:(NSArray *)faceBoundPoints centerPoint:(CGPoint)centerPoint radius:(CGFloat)radius;

@end

NS_ASSUME_NONNULL_END
