//
//  MapViewController.m
//  iSinooil
//
//  Created by вадим on 12/8/13.
//  Copyright (c) 2013 Zul. All rights reserved.
//

#import "MapViewController.h"
#import "MenuViewController.h"
#import "Common.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    NSLog(@"will rotate map");
    
    CGSize s = [Common currentScreenBoundsDependOnOrientation:toInterfaceOrientation];
    self.topView.frame = CGRectMake(0, 0, s.width, s.height);
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?
//                                @"Main_iPad":@"Main_iPhone" bundle:nil];
//    
//    UIViewController *viewController =  [storyboard instantiateViewControllerWithIdentifier:@"mainMenu"];

//    [self.view insertSubview:viewController.view belowSubview:self.view]
//    [self addChildViewController:viewController];
//    [self didMoveToParentViewController:viewController];
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;

//    [self.view insertSubview:viewController.view atIndex:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)menu:(id)sender {

    self.view.hidden = NO;
   
    CGRect fr = self.view.frame;
    BOOL b = (fr.origin.x < 1);
    [UIView animateWithDuration:anim_delay delay:0.0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{

                         self.view.frame = CGRectMake(b?(fr.size.width - deltaX):0, fr.origin.y, fr.size.width, fr.size.height);
                         
                     }
                     completion:^(BOOL finished) {
                     }];
    
}


@end
