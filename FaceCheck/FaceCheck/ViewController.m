//
//  ViewController.m
//  FaceCheck
//
//  Created by FaceCheck on 2024/7/11.
//

#import "ViewController.h"

#import "FaceSDK/FaceSDK.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Face Check";
    self.view.backgroundColor = UIColor.whiteColor;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = UIColor.redColor;
    button.frame = CGRectMake(10, 160, self.view.frame.size.width - 20, 40);
    [button setTitle:@"Face Check" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)btnClick:(UIButton *)btn {
    [FaceSDK startFaceRecognizeWithViewController:self success:^(UIImage * _Nonnull image) {
        NSLog(@"success");
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"failure");
    }];
}

@end
