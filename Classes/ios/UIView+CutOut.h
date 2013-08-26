//
//  UIView+CutOut.h
//  NHSeeThroughView
//
//  Created by Nils Hayat on 8/21/13.
//  Copyright (c) 2013 Nils Hayat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CutOut)

/**
 These methods set the provided mask image at the supplied position. All the remaining area is visible.
 
 For example, if you set a 10x10 mask image in the middle of a 100x100 view the mask will be applied to the center portion of the view and the view will be visible all around it.
 */
-(void)setMaskImage:(UIImage *)maskImage;
-(void)setMaskImage:(UIImage *)maskImage atPosition:(CGPoint)position;


/**
 These methods create a mask by drawing text with the supplied font.
 
 Optionally you can supply an image and the mask will be drawn like this: [image]-(spacing)-[text].
 */
-(void)setMaskWithText:(NSString *)text font:(UIFont *)font;
-(void)setMaskWithImage:(UIImage *)image text:(NSString *)text font:(UIFont *)font spacing:(CGFloat)spacing;

@end
