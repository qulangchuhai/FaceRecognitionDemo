//
//  FaceTool.h
//  FaceCheck
//
//  Created by FaceCheck on 2024/7/23.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import "FaceInterface.h"

NS_ASSUME_NONNULL_BEGIN

@interface FaceTool : NSObject

@property (nonatomic, assign, readonly) BOOL modelFileLoadSuccess;

- (instancetype)initWithDelegate:(id<FaceDelegate>)delegate;

- (int)faceCheckFaceByBuffer:(CMSampleBufferRef)sampleBuffer centerPoint:(CGPoint)centerPoint radius:(CGFloat)radius;

- (int)faceCheckFaceByImage:(UIImage *)image centerPoint:(CGPoint)centerPoint radius:(CGFloat)radius;

- (void)facePreRelase;

@end

NS_ASSUME_NONNULL_END
