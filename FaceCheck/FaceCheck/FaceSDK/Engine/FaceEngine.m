//
//  FaceEngine.m
//  FaceCheck
//
//  Created by FaceCheck on 2024/7/23.
//

#import "FaceEngine.h"
#import "FaceIndicateView.h"
#import "FacePointDrawView.h"

#import "FacePhotoManager.h"

#import "CameraAuthTool.h"

#import "FaceToastView.h"

@interface FaceEngine ()

// Tip: use weak, otherwise cycle reference
@property (nonatomic, weak) UIViewController<FaceResultDelegate> *viewController;

@property (nonatomic, strong) FaceIndicateView *indicateView;

@property (nonatomic, strong) FacePhotoManager *photoManager;

@property (nonatomic, strong) NSArray          *facePoints;
@property (nonatomic, strong) NSArray          *fivePoints;
@property (nonatomic, strong) NSArray          *faceBoundPoints;

@end

@implementation FaceEngine

- (void)dealloc {
    printf("%s", __func__);
}

- (instancetype)initWithViewController:(UIViewController<FaceResultDelegate> *)vc
{
    self = [super init];
    
    if (self) {
        self.viewController = vc;
        
        _indicateView = [[FaceIndicateView alloc] initWithFrame:self.viewController.view.bounds];
        [vc.view addSubview:_indicateView];
        
        _photoManager = [[FacePhotoManager alloc] initWith:_indicateView];
        _photoManager.delegate = self;
        
        [self preStartAuthCheck];
    }
    
    return self;
}

- (void)facePreRelase {
    [self.photoManager facePreRelase];
}

- (void)preStartAuthCheck {
    [CameraAuthTool checkAuthWithReject:^{
        [FaceToastView showMessageWithText:@"No permission or not allow"];
    } agree:^{
        [self startAuth];
    }];
}

- (void)startAuth {
    if (!self.photoManager.modelFileLoadSuccess) {
        [FaceToastView showMessageWithText:@"Model file load failure"];
        
        return;
    }
    
    [self.photoManager changeFaceStatus:FaceStart];
}

- (void)handleWarningCode:(int)detectResult {
    NSString *tip = @"";
    
    if (self.fivePoints.count > 0) {
        tip = @"Face Recognize Success";
    } else {
        tip = @"Please put your face into the frame";
    }
    
    [self.indicateView faceChangeErrorTip:tip];
}

@end

@implementation FaceEngine (FaceDelegate)

- (void)faceComplete {
    [self.indicateView faceComplete];
    
    [self.viewController faceCheckImage:self.indicateView.resultImage];
}

- (void)faceFailWithErrorCode:(NSString *)code message:(NSString *)message {
    [self.viewController faceFailWithErrorCode:code errorMessage:message];
}

- (void)faceHandleResult:(int)detectResult image:(UIImage *)image {
    dispatch_async(dispatch_get_main_queue(), ^{
        FacePointDrawView *view = [[FacePointDrawView alloc] init];
        
        UIImage *result = [view showImage:image facePoints:self.facePoints fivePoints:self.fivePoints faceBoundPoints:self.faceBoundPoints centerPoint:self.indicateView.faceGetMaskCenter radius:self.indicateView.faceGetMaskRadius];
        
        self.indicateView.resultImage = result;
        
        [self handleWarningCode:detectResult];
        
        // Complete condition
//        if (self.fivePoints.count > 0) {
//            [self.viewController faceCheckImage:self.indicateView.resultImage];
//        }
    });
}

- (void)faceDrawPoints:(NSArray *)facePoints fivePoints:(NSArray *)fivePoints faceBoundPoints:(NSArray *)faceBoundPoints {
    self.facePoints = facePoints;
    self.fivePoints = fivePoints;
    self.faceBoundPoints = faceBoundPoints;
}

@end
