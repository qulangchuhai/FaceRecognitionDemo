//
//  FaceInterface.h
//  FaceCheck
//
//  Created by FaceCheck on 2024/7/23.
//

#ifndef FaceInterface_h
#define FaceInterface_h

#import <UIKit/UIKit.h>
#import "FacePoint.h"

typedef NS_ENUM(NSInteger, FaceStatus) {
    FaceWaiting,
    FaceStart,
    FaceChecking,
    FaceFinish,
    FaceTimeOut
};

@protocol FaceResultDelegate <NSObject>

- (void)faceCheckImage:(UIImage *)faceImage;

- (void)faceFailWithErrorCode:(NSString *)errorCode errorMessage:(NSString *)message;

@end

@protocol FaceDelegate <NSObject>

- (void)faceComplete;

- (void)faceFailWithErrorCode:(NSString *)code message:(NSString *)message;

- (void)faceHandleResult:(int)detectResult image:(UIImage *)image;

- (void)faceDrawPoints:(NSArray *)facePoints fivePoints:(NSArray *)fivePoints faceBoundPoints:(NSArray *)faceBoundPoints;

@end

@protocol FaceIndicateInterface <NSObject>

- (void)faceComplete;

- (UIView *)faceGetPreview;

- (CGPoint)faceGetMaskCenter;

- (CGFloat)faceGetMaskRadius;

- (void)faceChangeErrorTip:(NSString *)tip;

@end

#endif /* FaceInterface_h */
