//
//  NHCutOutButton.m
//  NHSeeThroughView
//
//  Created by Nils Hayat on 8/22/13.
//  Copyright (c) 2013 Nils Hayat. All rights reserved.
//

#import "NHSeeThroughButton.h"
#import "UIView+CutOut.h"
#import "UIColor+LightAndDark.h"

@interface NHSeeThroughButton ()

@end

@implementation NHSeeThroughButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

-(void)awakeFromNib
{
	[self setupView];
}

-(void)setupView
{
	self.titleLabel.alpha = 0;
	[self.imageView removeFromSuperview];
	
	[self updateMask];
}

#pragma mark - Highlighted Background

-(void)setBackgroundColor:(UIColor *)backgroundColor
{
	[super setBackgroundColor:backgroundColor];
	
	UIImage *normalBackgroundImage = [self imageWithColor:backgroundColor];
	UIImage *highlightedBackgroundImage = [self imageWithColor:[backgroundColor darkerColor]];
	
	[self setBackgroundImage:normalBackgroundImage forState:UIControlStateNormal];
	[self setBackgroundImage:highlightedBackgroundImage forState:UIControlStateHighlighted];
}

-(void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state
{
	[super setBackgroundImage:image forState:state];
}

#pragma mark - Accessors

-(NSNumber *)spacing
{
	if (!_spacing) {
		_spacing = @16.0;
	}
	return _spacing;
}

-(void)setTitle:(NSString *)title forState:(UIControlState)state
{
	[self updateMask];
}

-(void)setImage:(UIImage *)image forState:(UIControlState)state
{
	[self updateMask];
}

#pragma mark - Masking Helpers

-(void)updateMask
{
	UIImage *image = [self imageForState:UIControlStateNormal];
	NSString *title = [self titleForState:UIControlStateNormal];
	
	if (image && title.length > 0) {
		[self setMaskWithImage:image text:title font:self.titleLabel.font spacing:self.spacing.floatValue];
	} else if (image) {
		[self setMaskImage:image];
	} else if (title.length >0) {
		[self setMaskWithText:title font:self.titleLabel.font];
	}
}

-(UIImage *)imageWithColor:(UIColor *)color
{
	UIGraphicsBeginImageContext(CGSizeMake(1.0, 1.0));
	[color setFill];
	[[UIBezierPath bezierPathWithRect:CGRectMake(0.0, 0.0, 1.0, 1.0)] fill];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return image;
}

@end
