//
//  FaceSDK.h
//  FaceCheck
//
//  Created by FaceCheck on 2024/7/19.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FaceSDK : NSObject

+ (void)startFaceRecognizeWithViewController:(UIViewController *)target success:(void(^)(UIImage *image))successBlock failure:(void(^)(NSError *error))failureBlock;

@end

NS_ASSUME_NONNULL_END
