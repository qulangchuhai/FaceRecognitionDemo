//
//  CameraAuthTool.h
//  FaceCheck
//
//  Created by FaceCheck on 2024/7/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CameraAuthTool : NSObject

+ (void)checkAuthWithReject:(void(^)(void))rejectBlock agree:(void(^)(void))agreeBlock;

@end

NS_ASSUME_NONNULL_END
