//
//  ImageManipulator.m
//  Friendmash
//
//  Created by Peter Shih on 10/11/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import "ImageManipulator.h"

@implementation ImageManipulator

static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight)
{
  float fw, fh;
  if (ovalWidth == 0 || ovalHeight == 0) {
    CGContextAddRect(context, rect);
    return;
  }
  CGContextSaveGState(context);
  CGContextTranslateCTM (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
  CGContextScaleCTM (context, ovalWidth, ovalHeight);
  fw = CGRectGetWidth (rect) / ovalWidth;
  fh = CGRectGetHeight (rect) / ovalHeight;
  CGContextMoveToPoint(context, fw, fh/2);
  CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
  CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
  CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
  CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
  CGContextClosePath(context);
  CGContextRestoreGState(context);
}

+ (UIImage *)roundCornerImageWithImage:(UIImage*)img withCornerWidth:(NSUInteger)cornerWidth withCornerHeight:(NSUInteger)cornerHeight {
	UIImage * newImage = nil;
  
	if(img){
		NSUInteger w = img.size.width;
		NSUInteger h = img.size.height;
    
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    
		CGContextBeginPath(context);
		CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
		addRoundedRectToPath(context, rect, cornerWidth, cornerHeight);
		CGContextClosePath(context);
		CGContextClip(context);
    
		CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    
		CGImageRef imageMasked = CGBitmapContextCreateImage(context);
		CGContextRelease(context);
		CGColorSpaceRelease(colorSpace);
    
		newImage = [UIImage imageWithCGImage:imageMasked];
		CGImageRelease(imageMasked);
	}
  
  return newImage;
}

+ (UIImage *)imageWithBorderFromImage:(UIImage *)source {
  CGSize size = [source size];
  UIGraphicsBeginImageContext(size);
  CGRect rect = CGRectMake(0, 0, size.width, size.height);
  [source drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
  
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetRGBStrokeColor(context, 1.0, 0.5, 1.0, 1.0); 
  CGContextStrokeRect(context, rect);
  UIImage *testImg =  UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return testImg;
}

@end