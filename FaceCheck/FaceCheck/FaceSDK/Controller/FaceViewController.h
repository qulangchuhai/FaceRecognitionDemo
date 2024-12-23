//
//  FaceViewController.h
//  FaceCheck
//
//  Created by FaceCheck on 2024/7/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^FaceSuccess)(UIImage *image);

typedef void(^FaceFailure)(NSError *error);


@interface FaceViewController : UIViewController

@property (nonatomic, copy) FaceSuccess successBlock;

@property (nonatomic, copy) FaceFailure failureBlock;

@end

NS_ASSUME_NONNULL_END
