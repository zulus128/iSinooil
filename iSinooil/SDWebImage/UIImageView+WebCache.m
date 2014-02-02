/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImageView+WebCache.h"
#import <objc/runtime.h>

static char const * const ObjectTagKey = "ObjectTag";

@implementation UIImageView (WebCache)

@dynamic masked;

- (void)setMasked:(BOOL)masked {

    NSNumber *number = [NSNumber numberWithBool: masked];
    objc_setAssociatedObject(self, ObjectTagKey, number, OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)masked {
    
    NSNumber *number = objc_getAssociatedObject(self, ObjectTagKey);
    return [number boolValue];
}

- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    
    [self setImageWithURL:url placeholderImage:placeholder options:0];
    self.masked = NO;
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder masked:(BOOL)masked {
    
    [self setImageWithURL:url placeholderImage:placeholder options:0];
    self.masked = masked;
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];

    self.image = placeholder;

    if (url)
    {
        [manager downloadWithURL:url delegate:self options:options];
    }
}

- (void)cancelCurrentImageLoad
{
    [[SDWebImageManager sharedManager] cancelForDelegate:self];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image {
    
//    self.image = image;
    self.image = self.masked?[self getMaskedImage:image]:image;
    
    self.alpha = 0;
    
    [UIView animateWithDuration:0.1f delay:0.0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         self.alpha = 1;
                     }
                     completion:^(BOOL finished) {
                     }];

}

- (UIImage*) getMaskedImage: (UIImage*) originalImage {

    // 1. Convert to black-and-white:

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate(nil, originalImage.size.width, originalImage.size.height, 8, originalImage.size.width, colorSpace, (CGBitmapInfo)kCGImageAlphaNone);

    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextSetShouldAntialias(context, NO);
    CGContextDrawImage(context, CGRectMake(0, 0, originalImage.size.width, originalImage.size.height), [originalImage CGImage]);

    CGImageRef bwImage = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);

//    UIImage * maskedImage1 = [UIImage imageWithCGImage:bwImage];
//    return maskedImage1;

    // 2. Apply PNG mask:

    NSString * maskImageFileName = [[[NSBundle mainBundle] URLForResource:@"icon_bg_mask" withExtension:@"png"] path];

    CGDataProviderRef dataProvider = CGDataProviderCreateWithFilename([maskImageFileName UTF8String]);

    CGImageRef maskRef = CGImageCreateWithPNGDataProvider(dataProvider, NULL, NO, kCGRenderingIntentDefault);

    CGImageRef mask = CGImageMaskCreate(
            CGImageGetWidth(maskRef),
            CGImageGetHeight(maskRef),
            CGImageGetBitsPerComponent(maskRef),
            CGImageGetBitsPerPixel(maskRef),
            CGImageGetBytesPerRow(maskRef),
            CGImageGetDataProvider(maskRef), NULL, YES);

    CGDataProviderRelease(dataProvider);
    CGImageRelease(maskRef);

    CGImageRef masked = CGImageCreateWithMask(bwImage, mask);
    CGImageRelease(bwImage);
    CGImageRelease(mask);

    UIImage * maskedImage = [UIImage imageWithCGImage:masked];

    CGImageRelease(masked);

    return maskedImage;
}

@end
