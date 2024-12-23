//
//  FaceTool.m
//  FaceCheck
//
//  Created by FaceCheck on 2024/7/23.
//

#import "FaceTool.h"

#import "face_jni.h"
#import "global_listener.h"

#import "FaceImageTool.h"

@interface FaceTool ()

@property (nonatomic, weak) id<FaceDelegate> delegate;

@property (nonatomic, copy) DetectDrawPointsCallback drawPointsBlock;

@property (nonatomic, copy) DetectClearPointsCallBack clearPointsBlock;

@end

@implementation FaceTool

- (void)dealloc {
    printf("%s", __func__);
    
    SmartDetector_release();
}

- (instancetype)initWithDelegate:(id<FaceDelegate>)delegate {
    self = [super init];
    
    if (self) {
        _delegate = delegate;
        
        _modelFileLoadSuccess = NO;
        
        [self faceLoadLiteFile];
        
        [self bindListener];
    }
    
    return self;
}

- (void)faceLoadLiteFile {
    NSString *bundle = @"Model.bundle";
    
    NSString *modelBundlePath = [[NSBundle mainBundle] pathForResource:bundle ofType:NULL];
    if (modelBundlePath == NULL) {
        modelBundlePath = [[NSBundle bundleForClass:[self class]] pathForResource:bundle ofType:NULL];
    }
    
    if (modelBundlePath == nil || [modelBundlePath length] == 0) {
        _modelFileLoadSuccess = NO;
        return;
    }
    
    BOOL result = SmartDetector_loadModel([modelBundlePath UTF8String]);
    if (result) {
        _modelFileLoadSuccess = YES;
    } else {
        _modelFileLoadSuccess = NO;
    }
}

- (void)bindListener {
    __weak typeof(self) weakSelf = self;
    
    self.drawPointsBlock = ^(Face face) {
        NSLog(@"$$face point");
        
        [weakSelf runInMain:^{
            int count = (int)face.fs.size();
            
            if (count > 0) {
                NSMutableArray *faces_array = [[NSMutableArray alloc] init];
                NSMutableArray *face_areas_array = [[NSMutableArray alloc] init];
                
                for (int i = 0; i < count; i++) {
                    FaceResult fs = face.fs[i];
                    
                    int faceCount = (int)fs.face.pts.size();
                    
                    if (faceCount > 0) {
                        NSMutableArray *fivePoints = [[NSMutableArray alloc] init];
                        
                        for (int j = 0; j < faceCount; j++) {
                            cv::Point2f point = fs.face.pts[j];
                            FacePoint *p = [[FacePoint alloc] initWithX:point.x y:point.y];
                            [fivePoints addObject:p];
                        }
                        
                        NSArray *fives = fivePoints.copy;
                        
                        [faces_array addObject:fives];
                        
                        BoundingBox boundingBox = fs.face_area;
                        
                        NSArray *faceBoundPoints = @[
                            [[FacePoint alloc] initWithX:boundingBox.left y:boundingBox.top],
                            [[FacePoint alloc] initWithX:boundingBox.right y:boundingBox.top],
                            [[FacePoint alloc] initWithX:boundingBox.right y:boundingBox.bottom],
                            [[FacePoint alloc] initWithX:boundingBox.left y:boundingBox.bottom]
                        ];
                        
                        [face_areas_array addObject:faceBoundPoints];
                    } else {
                        [faces_array addObject:@[]];
                        [face_areas_array addObject:@[]];
                    }
                }
                
                [weakSelf.delegate faceDrawPoints:@[] fivePoints:faces_array faceBoundPoints:face_areas_array];
            } else {
                [weakSelf.delegate faceDrawPoints:@[] fivePoints:@[] faceBoundPoints:@[]];
            }
            
            
            //            int count = (int)faceObject.pts.size();
            //
            //            NSMutableArray *fivePoints = [[NSMutableArray alloc] init];
            //
            //            for (int i = 0; i < count; i++) {
            //                cv::Point2f point = faceObject.pts[i];
            //                FacePoint *p = [[FacePoint alloc] initWithX:point.x y:point.y];
            //                [fivePoints addObject:p];
            //            }
            //
            //            NSArray *faceBoundPoints = @[
            //                [[FacePoint alloc] initWithX:boundingBox.left y:boundingBox.top],
            //                [[FacePoint alloc] initWithX:boundingBox.right y:boundingBox.top],
            //                [[FacePoint alloc] initWithX:boundingBox.right y:boundingBox.bottom],
            //                [[FacePoint alloc] initWithX:boundingBox.left y:boundingBox.bottom]
            //            ];
            //
            //            [weakSelf.delegate faceDrawPoints:@[] fivePoints:fivePoints faceBoundPoints:faceBoundPoints];
        }];
    };
    
    self.clearPointsBlock = ^{
        [weakSelf runInMain:^{
            [weakSelf.delegate faceDrawPoints:@[] fivePoints:@[] faceBoundPoints:@[]];
        }];
    };
    
    // block copy stack to heap, relative by self
    global_listener *listener = new global_listener();
    listener->bindDrawPointsCallback(self.drawPointsBlock);
    listener->bindClearPointsCallBack(self.clearPointsBlock);
    
    SmartDetector_bindListen(listener);
}

- (void)runInMain:(void(^)())block {
    if ([NSThread currentThread].isMainThread) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            block();
        });
    }
}

- (int)faceCheckFaceByBuffer:(CMSampleBufferRef)sampleBuffer centerPoint:(CGPoint)centerPoint radius:(CGFloat)radius {
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    unsigned char *rgbData = [FaceImageTool changeSampleBufferToRGB:sampleBuffer];
    
    FaceDetectCppMaskPoint point {(float)centerPoint.x, (float)centerPoint.y, (float)radius};
    
    int result = SmartDetector_faceDetect(rgbData, (int)width, (int)height, point);
    
    if (result) {
        NSLog(@"face detect result is %d", result);
    }
    
    free(rgbData);
    
    return result;
}

- (int)faceCheckFaceByImage:(UIImage *)image centerPoint:(CGPoint)centerPoint radius:(CGFloat)radius {
    FaceDetectCppMaskPoint point {(float)centerPoint.x, (float)centerPoint.y, (float)radius};
    
    unsigned char *rgbData = [FaceImageTool rgbaFromImage:image];
    
    int result = SmartDetector_faceDetect(rgbData, (int)image.size.width, (int)image.size.height, point);
    
    free(rgbData);
    
    return result;
}

- (void)facePreRelase {
    
}

@end
