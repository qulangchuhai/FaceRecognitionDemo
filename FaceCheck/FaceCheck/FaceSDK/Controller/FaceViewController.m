//
//  FaceViewController.m
//  FaceCheck
//
//  Created by FaceCheck on 2024/7/19.
//

#import "FaceViewController.h"

#import "FaceToastView.h"

#import "FaceEngine.h"

#import "FaceInterface.h"

@interface FaceViewController ()<FaceResultDelegate>

@property (nonatomic, strong) FaceEngine *engine;

@end

@implementation FaceViewController

- (void)dealloc {
    printf("**********%s", __FUNCTION__);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.engine facePreRelase];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"FaceSDK";
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.engine = [[FaceEngine alloc] initWithViewController:self];
}

- (void)backHome {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark Interface

- (void)faceCheckImage:(UIImage *)faceImage {
    if (self.successBlock) {
        self.successBlock(faceImage);
    }
    
    [self backHome];
}

- (void)faceFailWithErrorCode:(NSString *)errorCode errorMessage:(NSString *)message {
    NSError *error = [[NSError alloc] initWithDomain:@"www.facedemo.com" code:errorCode.integerValue userInfo:@{@"message" : (message ? : @"")}];
    
    if (self.failureBlock) {
        self.failureBlock(error);
    }
    
    [self backHome];
    
    [FaceToastView showMessageWithText:(message ? : @"no message")];
}

@end
