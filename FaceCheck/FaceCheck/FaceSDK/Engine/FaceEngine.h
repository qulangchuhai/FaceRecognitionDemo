//
//  FaceEngine.h
//  FaceCheck
//
//  Created by FaceCheck on 2024/7/23.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "FaceInterface.h"

NS_ASSUME_NONNULL_BEGIN

@interface FaceEngine : NSObject

- (instancetype)initWithViewController:(UIViewController<FaceResultDelegate> *)vc;

- (void)facePreRelase;

@end

@interface FaceEngine (FaceDelegate)<FaceDelegate>

@end

NS_ASSUME_NONNULL_END
