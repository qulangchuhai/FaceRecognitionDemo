//
//  FaceSDK.m
//  FaceCheck
//
//  Created by FaceCheck on 2024/7/19.
//

#import "FaceSDK.h"

#import "FaceViewController.h"

@implementation FaceSDK

+ (void)startFaceRecognizeWithViewController:(UIViewController *)target success:(void(^)(UIImage *image))successBlock failure:(void(^)(NSError *error))failureBlock {
    FaceViewController *vc = [[FaceViewController alloc] init];
    vc.successBlock = successBlock;
    vc.failureBlock = failureBlock;
    
    if (target.navigationController) {
        [target.navigationController pushViewController:vc animated:YES];
    } else {
        [target presentViewController:vc animated:YES completion:^{
            NSLog(@"completed");
        }];
    }
}

@end
