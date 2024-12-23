//
//  FacePhotoManager.m
//  FaceCheck
//
//  Created by FaceCheck on 2024/7/23.
//

#import "FacePhotoManager.h"

#import "FaceTool.h"

#import "FaceImageTool.h"

#import "FaceToastView.h"

@interface FacePhotoManager ()

@property (nonatomic, weak) id<FaceIndicateInterface> indicate;

@property (nonatomic, strong) AVCaptureDevice *device;

@property (nonatomic, strong) AVCaptureDeviceInput *input;

@property (nonatomic ,strong) AVCapturePhotoOutput *imageOutput;

@property (nonatomic, strong) AVCaptureSession *session;

@property (nonatomic ,strong) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic, strong) AVCaptureVideoDataOutput *videoDataOutput;

@property (nonatomic, strong) AVCaptureMetadataOutput *metaout;

@property (nonatomic, strong) UIView *presentView;

@property (nonatomic, strong) FaceTool *faceTool;

@property (nonatomic, assign) FaceStatus status;

@property (nonatomic)         dispatch_queue_t queue;

@property (nonatomic, assign) CGPoint maskCenterPoint;
@property (nonatomic, assign) CGFloat maskRadius;

@end

@implementation FacePhotoManager

- (void)dealloc {
    printf("%s", __func__);
}

- (AVCaptureDeviceInput *)input {
    if (_input == nil) {
        NSArray *devices = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionFront].devices;
        AVCaptureDevice *deviceF = devices[0];
        
        _input = [[AVCaptureDeviceInput alloc] initWithDevice:deviceF error:nil];
    }
    
    return _input;
}

- (AVCaptureVideoPreviewLayer *)previewLayer {
    if (_previewLayer == nil) {
        AVCaptureSession *session = self.session;
        _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        _previewLayer.frame = self.presentView.bounds;
    }
    
    return _previewLayer;
}

- (AVCaptureVideoDataOutput *)videoDataOutput {
    if (_videoDataOutput == nil) {
        _videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
        // kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange
        // kCVPixelFormatType_32BGRA
        [_videoDataOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
        [_videoDataOutput setSampleBufferDelegate:self queue:self.queue];
    }
    
    return _videoDataOutput;
}

- (AVCaptureMetadataOutput *)metaout {
    if (_metaout == nil) {
        _metaout = [[AVCaptureMetadataOutput alloc] init];
        _metaout.rectOfInterest = self.presentView.bounds;
        [_metaout setMetadataObjectsDelegate:self queue:self.queue];
    }
    
    return _metaout;
}

- (instancetype)initWith:(id<FaceIndicateInterface>)indicate {
    self = [super init];
    
    if (self) {
        self.indicate = indicate;
        
        self.queue = dispatch_queue_create("face_check", DISPATCH_QUEUE_SERIAL);
        self.status = FaceWaiting;
        self.presentView = [indicate faceGetPreview];
        
        self.faceTool = [[FaceTool alloc] initWithDelegate:self];
        
        [self faceDeviceInit];
    }
    
    return self;
}

- (BOOL)modelFileLoadSuccess {
    return self.faceTool.modelFileLoadSuccess;
}

- (void)changeFaceStatus:(FaceStatus)status {
    _status = status;
    
    switch (status) {
        case FaceStart:
        {
            if (self.session.isRunning) {
                return;
            }
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [self.session startRunning];
            });
            
            break;
        }
        case FaceTimeOut:
        {
            if (self.session.isRunning) {
                [self.session stopRunning];
            }
            
            break;
        }
        case FaceFinish:
        {
            if (self.session.isRunning) {
                [self.session stopRunning];
            }
            
            break;
        }
        default:
            break;
    }
}

- (void)facePreRelase {
    [self.faceTool facePreRelase];
}

- (void)faceDeviceInit {
    self.session = [[AVCaptureSession alloc] init];
    
    [self setBestSupportPreset];
    
    [self.session beginConfiguration];
    
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    
    if ([self.session canAddOutput:self.metaout]) {
        [self.session addOutput:self.metaout];
    }
    
    if ([_session canAddOutput:self.videoDataOutput]) {
        [_session addOutput:self.videoDataOutput];
    }
    
    [self.session commitConfiguration];
    
    [self.metaout setMetadataObjectTypes:@[AVMetadataObjectTypeFace]];
    
    [self.presentView.layer addSublayer:self.previewLayer];
    
    AVCaptureSession *session = (AVCaptureSession *)self.session;
    
    for (AVCaptureVideoDataOutput *output in session.outputs) {
        for (AVCaptureConnection *av in output.connections) {
            if (av.supportsVideoMirroring) {
                av.videoOrientation = AVCaptureVideoOrientationPortrait;
            }
        }
    }
    
    _maskCenterPoint = [self.indicate faceGetMaskCenter];
    
    _maskRadius = [self.indicate faceGetMaskRadius];
}

- (void)setBestSupportPreset {
    if ([self.session canSetSessionPreset:AVCaptureSessionPreset640x480]) {
        [self.session setSessionPreset:AVCaptureSessionPreset640x480];
    } else if ([self.session canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
        [self.session setSessionPreset:AVCaptureSessionPreset1280x720];
    }
}

@end

@implementation FacePhotoManager (AVCaptureOutputObjectsDelegate)

- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    if (self.status == FaceWaiting) {
        return;
    }
    
    if (self.status == FaceChecking) {
        return;
    }
    
    if (self.status == FaceFinish) {
        NSLog(@"detect finish...");
        return;
    }
    
    if (self.status == FaceTimeOut) {
        NSLog(@"detect time out...");
        return;
    }
    
    self.status = FaceChecking;

    UIImage *image = [FaceImageTool imageFromSampleBuffer:sampleBuffer];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), self.queue, ^{
        int result = [self.faceTool faceCheckFaceByImage:image centerPoint:self.maskCenterPoint radius:self.maskRadius];
        
        [self faceHandleResult:result image:image];
        
        if (result == 4) {
            sleep(1);
        }
        
        self.status = FaceStart;
    });
}

@end

@implementation FacePhotoManager (FaceDelegate)

- (void)faceComplete {
    self.status = FaceFinish;
    
    [self.session stopRunning];
    
    [self.indicate faceComplete];
    [self.delegate faceComplete];
}

- (void)faceFailWithErrorCode:(NSString *)code message:(NSString *)message {
    [self.delegate faceFailWithErrorCode:code message:message];
}

- (void)faceHandleResult:(int)detectResult image:(UIImage *)image {
    [self.delegate faceHandleResult:detectResult image:image];
}

- (void)faceDrawPoints:(NSArray *)facePoints fivePoints:(NSArray *)fivePoints faceBoundPoints:(NSArray *)faceBoundPoints {
    [self.delegate faceDrawPoints:facePoints fivePoints:fivePoints faceBoundPoints:faceBoundPoints];
}

@end
