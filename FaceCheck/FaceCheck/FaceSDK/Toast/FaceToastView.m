//
//  FaceToastView.m
//  FaceCheck
//
//  Created by FaceCheck on 2024/7/23.
//

#import "FaceToastView.h"

@implementation FaceToastView

+ (void)showMessageWithText:(NSString *)text
{
    if (![text isKindOfClass:NSString.class] || text.length == 0) {
        return;
    }
    
    UIWindow *window = UIApplication.sharedApplication.windows.firstObject;
    
    if (window == nil) {
        return;
    }
    
    UIView *view = [window viewWithTag:2024];
    if (view != nil) {
        [view removeFromSuperview];
        view = nil;
    }
    
    UILabel *toastLabel = [[UILabel alloc] init];
    toastLabel.backgroundColor = UIColor.orangeColor;
    toastLabel.frame = CGRectMake(20, UIScreen.mainScreen.bounds.size.height - 100, UIScreen.mainScreen.bounds.size.width - 40, 40);
    toastLabel.textColor = UIColor.blackColor;
    toastLabel.textAlignment = NSTextAlignmentCenter;
    toastLabel.font = [UIFont systemFontOfSize:14];
    toastLabel.text = text;
    toastLabel.tag = 2024;
    [window addSubview:toastLabel];
    
    toastLabel.alpha = 0;
    
    [UIView animateWithDuration:0.2 animations:^{
        toastLabel.alpha = 1;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.2 animations:^{
                toastLabel.alpha = 0;
            } completion:^(BOOL finished) {
                [toastLabel removeFromSuperview];
            }];
        });
    }];
}

@end
