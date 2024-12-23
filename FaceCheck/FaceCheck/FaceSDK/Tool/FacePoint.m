//
//  FacePoint.m
//  FaceCheck
//
//  Created by FaceCheck on 2024/7/22.
//

#import "FacePoint.h"

@implementation FacePoint

- (instancetype)initWithX:(float)x y:(float)y {
    self = [super init];
    
    if (self) {
        self.x = x;
        self.y = y;
    }
    
    return self;
}

@end
