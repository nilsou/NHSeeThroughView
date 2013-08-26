//
//  NHCutOutButton.h
//
//  Created by Nils Hayat on 8/22/13.
//  Copyright (c) 2013 Nils Hayat. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 This class is a UIButton subclass that allows you to easily create a see-through button both in IB or in code.
 
 It takes the button's image and title/font to create a mask using the spacing property.
 
 For now it does not take into account Edge Insets.
 */

@interface NHSeeThroughButton : UIButton

/**
 The spacing between the image and the title.
 */
@property (nonatomic) NSNumber *spacing;

@end
