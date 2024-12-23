//
//  FaceImageTool.m
//  FaceCheck
//
//  Created by FaceCheck on 2024/7/22.
//

#import "FaceImageTool.h"

@implementation FaceImageTool

+ (unsigned char *)rgbaFromImage:(UIImage *)image {
    int width = image.size.width;
    int height = image.size.height;
    
    unsigned char *rgba = malloc(width * height * 4);
    
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    
    CGContextRef contextRef = CGBitmapContextCreate(rgba, width, height, 8, width * 4, colorSpace, kCGImageAlphaNoneSkipLast | kCGBitmapByteOrderDefault);
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, width, height), image.CGImage);
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);
    
    return rgba;
}

+ (unsigned char *)changeSampleBufferToRGB:(CMSampleBufferRef)sampleBuffer {
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);

    CVPixelBufferLockBaseAddress(imageBuffer, kCVPixelBufferLock_ReadOnly);

    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);

    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    CFMutableDictionaryRef dictionary = CFDictionaryCreateMutable(NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    
    CFDictionarySetValue(dictionary, kCVImageBufferCGColorSpaceKey, colorSpace);
    
    CVPixelBufferRef rgbPixelBuffer;
    CVPixelBufferCreateWithBytes(NULL, width, height, kCVPixelFormatType_32BGRA, baseAddress, bytesPerRow, NULL, NULL, dictionary, &rgbPixelBuffer);

    size_t bufferSize = bytesPerRow * height;
    
    unsigned char *buffer = malloc(bufferSize);
    memcpy(buffer, baseAddress, bufferSize);
    
    CVPixelBufferUnlockBaseAddress(imageBuffer, kCVPixelBufferLock_ReadOnly);
    CGColorSpaceRelease(colorSpace);
    CFRelease(dictionary);
    
    return buffer;
}

+ (UIImage *)imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
   
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    CGContextRelease(context); CGColorSpaceRelease(colorSpace);
    
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
    
    CGImageRelease(quartzImage);
    
    return (image);
}

@end
