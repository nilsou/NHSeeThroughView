//
//  NHMainViewController.m
//  NHSeeThroughView
//
//  Created by Nils Hayat on 8/21/13.
//  Copyright (c) 2013 Nils Hayat. All rights reserved.
//

#import "NHMainViewController.h"
#import <NHSeeThroughView/NHSeeThroughButton.h>

@interface NHMainViewController ()

@property (weak, nonatomic) IBOutlet UIButton *facebookButton;

@end

@implementation NHMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.facebookButton.layer.cornerRadius = 5.0;
	self.facebookButton.layer.masksToBounds = YES;
	
	UIImage *facebookLogo = [UIImage imageNamed:@"facebook-logo-mask"];
	[self.facebookView setMaskWithImage:facebookLogo text:@"facebook" font:[UIFont fontWithName:@"AvenirNext-DemiBold" size:20.0] spacing:16.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - User Interactions

- (IBAction)panned:(UIPanGestureRecognizer *)sender {
	CGPoint translation = [sender translationInView:self.view];
	
	CGPoint center = sender.view.center;
	center.x += translation.x;
	center.y += translation.y;
	
	CGRect squareViewFrame = sender.view.frame;
	CGRect frame = self.view.frame;
	
	
	if (center.x - squareViewFrame.size.width / 2.0 < 0) {
		center.x = squareViewFrame.size.width/2.0;
	}
	
	if (center.y - squareViewFrame.size.height / 2.0 < 0) {
		center.y = squareViewFrame.size.height/2.0;
	}
	
	if (center.x + squareViewFrame.size.width/2.0 > frame.size.width) {
		center.x = frame.size.width - squareViewFrame.size.width/2.0;
	}
	
	if (center.y + squareViewFrame.size.height/2.0 > frame.size.height){
		center.y = frame.size.height - squareViewFrame.size.height/2.0;
		
	}
	
	sender.view.center = center;
	
	[sender setTranslation:CGPointZero inView:self.view];
}


@end
