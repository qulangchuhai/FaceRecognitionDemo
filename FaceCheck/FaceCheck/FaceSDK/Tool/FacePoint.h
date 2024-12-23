//
//  FacePoint.h
//  FaceCheck
//
//  Created by FaceCheck on 2024/7/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FacePoint : NSObject

@property (nonatomic, assign) float x;
@property (nonatomic, assign) float y;

- (instancetype)initWithX:(float)x y:(float)y;

@end

NS_ASSUME_NONNULL_END
