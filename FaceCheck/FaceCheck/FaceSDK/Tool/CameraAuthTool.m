//
//  CameraAuthTool.m
//  FaceCheck
//
//  Created by FaceCheck on 2024/7/22.
//

#import "CameraAuthTool.h"
#import <AVFoundation/AVFoundation.h>

@implementation CameraAuthTool

+ (void)checkAuthWithReject:(void(^)(void))rejectBlock agree:(void(^)(void))agreeBlock {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!granted) { // not open
                    if (rejectBlock) {
                        rejectBlock();
                    }
                } else { // open
                    if (agreeBlock) {
                        agreeBlock();
                    }
                }
            });
        }];
    } else if (authStatus == AVAuthorizationStatusDenied) {
        // not allow
        if (rejectBlock) {
            rejectBlock();
        }
    } else {
        // allow
        if (agreeBlock) {
            agreeBlock();
        }
    }
}

@end
