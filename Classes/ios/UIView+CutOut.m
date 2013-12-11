//
//  UIView+CutOut.m
//  NHSeeThroughView
//
//  Created by Nils Hayat on 8/21/13.
//  Copyright (c) 2013 Nils Hayat. All rights reserved.
//

#import "UIView+CutOut.h"

@implementation UIView (CutOut)

#pragma mark - CutOut

-(void)setMaskImage:(UIImage *)maskImage {
	CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
	[self setMaskImage:maskImage atCenter:center];
}

-(void)setMaskImage:(UIImage *)maskImage atCenter:(CGPoint)center {
	CGPoint position = CGPointMake((int)(center.x - maskImage.size.width/2.0), (int)(center.y - maskImage.size.height/2.0));
	[self setMaskImage:maskImage atPosition:position];
}

-(void)setMaskImage:(UIImage *)maskImage atPosition:(CGPoint)position {
	CALayer *maskingLayer = [CALayer layer];
	maskingLayer.frame = self.bounds;
	
	CGRect imageFrame = {position, maskImage.size};
	
	UIColor *fillColor = [UIColor blackColor];
	
	// Top
	CALayer *topLayer = [CALayer layer];
	topLayer.frame = CGRectMake(0.0,
								0.0,
								CGRectGetWidth(self.bounds),
								CGRectGetMinY(imageFrame));
	topLayer.backgroundColor = fillColor.CGColor;
	[maskingLayer addSublayer:topLayer];
	
	// Left
	CALayer *leftLayer = [CALayer layer];
	leftLayer.frame = CGRectMake(0.0,
								 CGRectGetMinY(imageFrame),
								 CGRectGetMinX(imageFrame),
								 CGRectGetHeight(imageFrame));
	leftLayer.backgroundColor = fillColor.CGColor;
	[maskingLayer addSublayer:leftLayer];
	
	// Right
	CALayer *rightLayer = [CALayer layer];
	rightLayer.frame = CGRectMake(CGRectGetMaxX(imageFrame),
								  CGRectGetMinY(imageFrame),
								  CGRectGetWidth(self.bounds) - CGRectGetMaxX(imageFrame),
								  CGRectGetHeight(imageFrame));
	rightLayer.backgroundColor = fillColor.CGColor;
	[maskingLayer addSublayer:rightLayer];
	
	// Bottom
	CALayer *bottomLayer = [CALayer layer];
	bottomLayer.frame = CGRectMake(0.0,
								   CGRectGetMaxY(imageFrame),
								   CGRectGetWidth(self.bounds),
								   CGRectGetHeight(self.bounds) - CGRectGetMaxY(imageFrame));
	bottomLayer.backgroundColor = fillColor.CGColor;
	[maskingLayer addSublayer:bottomLayer];
	
	// Center
	CALayer *imageLayer = [CALayer layer];
	imageLayer.frame = imageFrame;
	imageLayer.contents = (id)[maskImage CGImage];
	[maskingLayer addSublayer:imageLayer];
	
	self.layer.mask = maskingLayer;
}

#pragma mark - Text Mask

-(void)setMaskWithText:(NSString *)text font:(UIFont *)font
{
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds) + 1.0);
	UIImage *maskImage = [self maskImageWithText:text font:font];
	[self setMaskImage:maskImage atCenter:center];
}


static inline CGSize CGSizeIntegral(CGSize size) {
	return CGSizeMake(ceilf(size.width), ceilf(size.height));
}

-(UIImage *)maskImageWithText:(NSString *)text font:(UIFont *)font {
	NSDictionary *attributes = @{NSFontAttributeName : font, NSForegroundColorAttributeName : [UIColor blackColor]};
	CGSize textSize = CGSizeIntegral([text sizeWithAttributes:attributes]);
	
	UIGraphicsBeginImageContextWithOptions(textSize, YES, [UIScreen mainScreen].scale);
	[[UIColor whiteColor] setFill];
    [[UIBezierPath bezierPathWithRect:CGRectMake(0, 0, textSize.width, textSize.height)] fill];
	[text drawAtPoint:CGPointZero withAttributes:attributes];
	UIImage *textImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	CIImage *inputImage = [CIImage imageWithCGImage:textImage.CGImage];
	CIContext *context = [CIContext contextWithOptions:nil];
	CIFilter *filter = [CIFilter filterWithName:@"CIMaskToAlpha" keysAndValues:kCIInputImageKey, inputImage, nil];
	CIImage *outputImage = [filter outputImage];
	CGImageRef outputCGImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
	UIImage *maskImage = [UIImage imageWithCGImage:outputCGImage scale:textImage.scale orientation:UIImageOrientationUp];
	
	return maskImage;
}

#pragma mark - Composite Mask

-(void)setMaskWithImage:(UIImage *)image text:(NSString *)text font:(UIFont *)font spacing:(CGFloat)spacing {
	UIImage *maskImage = [self compositeMaskWithText:text font:font image:image spacing:spacing textVerticalOffset:1.0];
	[self setMaskImage:maskImage];
}

-(UIImage *)compositeMaskWithText:(NSString *)text font:(UIFont *)font image:(UIImage *)image spacing:(CGFloat)spacing textVerticalOffset:(CGFloat)textVerticalOffset{
    UIImage *textMask = [self maskImageWithText:text font:font];
	
	CGSize maskSize = CGSizeIntegral(CGSizeMake(textMask.size.width + spacing + image.size.width, MAX(textMask.size.height, image.size.height)));
	
	CGRect spacingRect = CGRectMake(image.size.width, 0.0, spacing, maskSize.height);
	
	CGPoint imageOrigin, textMaskOrigin;
	CGRect firstFillRect, secondFillRect;
	if (image.size.height > textMask.size.height) {
		imageOrigin = CGPointZero;
		textMaskOrigin = CGPointMake(image.size.width + spacing, ceilf((image.size.height - textMask.size.height) / 2.0) + textVerticalOffset);
		firstFillRect = CGRectIntegral(CGRectMake(image.size.width + spacing, 0.0, textMask.size.width, ceilf((image.size.height - textMask.size.height) / 2.0) + textVerticalOffset));
		secondFillRect = CGRectMake(image.size.width + spacing, textMask.size.height + ceilf((image.size.height - textMask.size.height) / 2.0) + textVerticalOffset, textMask.size.width, ceilf((image.size.height - textMask.size.height) / 2.0) - textVerticalOffset);
	} else {
		imageOrigin = CGPointMake(0.0, ceilf((textMask.size.height - image.size.height) / 2.0));
		textMaskOrigin	= CGPointMake(image.size.width + spacing, 0.0);
		firstFillRect = CGRectIntegral(CGRectMake(0.0, 0.0, image.size.width, ceilf((textMask.size.height - image.size.height) / 2.0)));
		secondFillRect = CGRectMake(0.0, ceilf((textMask.size.height - image.size.height) / 2.0) + image.size.height, image.size.width, ceilf((textMask.size.height - image.size.height) / 2.0));
	}
	
	UIGraphicsBeginImageContextWithOptions(maskSize, NO, [UIScreen mainScreen].scale);
	[image drawAtPoint:imageOrigin];
	[textMask drawAtPoint:textMaskOrigin];
	[[UIColor whiteColor] setFill];
	[[UIBezierPath bezierPathWithRect:spacingRect] fill];
	[[UIBezierPath bezierPathWithRect:firstFillRect] fill];
	[[UIBezierPath bezierPathWithRect:secondFillRect] fill];
	UIImage *finalMaskImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return finalMaskImage;
}

@end
