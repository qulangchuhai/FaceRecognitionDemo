//
//  FacePhotoManager.h
//  FaceCheck
//
//  Created by FaceCheck on 2024/7/23.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import "FaceInterface.h"

NS_ASSUME_NONNULL_BEGIN

@interface FacePhotoManager : NSObject

@property (nonatomic, assign, readonly) BOOL modelFileLoadSuccess;

@property (nonatomic, weak) id<FaceDelegate> delegate;

- (instancetype)initWith:(id<FaceIndicateInterface>)indicate;

- (void)changeFaceStatus:(FaceStatus)status;

- (void)facePreRelase;

@end

@interface FacePhotoManager (AVCaptureOutputObjectsDelegate)<AVCaptureMetadataOutputObjectsDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>

@end

@interface FacePhotoManager (FaceDelegate)<FaceDelegate>

@end

NS_ASSUME_NONNULL_END
