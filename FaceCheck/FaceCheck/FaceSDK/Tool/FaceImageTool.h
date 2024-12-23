//
//  FaceImageTool.h
//  FaceCheck
//
//  Created by FaceCheck on 2024/7/22.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FaceImageTool : NSObject

+ (unsigned char *)rgbaFromImage:(UIImage *)image;

+ (unsigned char *)changeSampleBufferToRGB:(CMSampleBufferRef)sampleBuffer;

+ (UIImage *)imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer;

@end

NS_ASSUME_NONNULL_END
