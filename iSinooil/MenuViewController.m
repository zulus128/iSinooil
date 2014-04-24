//
//  MenuViewController.m
//  iSinooil
//
//  Created by вадим on 1/2/14.
//  Copyright (c) 2014 Zul. All rights reserved.
//

#import "MenuViewController.h"
#import "Common.h"
#import "MapViewController.h"
#import "HotlineViewController.h"

@implementation MenuViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

//-(UIStatusBarStyle)preferredStatusBarStyle {
//
//    return UIStatusBarStyleLightContent;
//}

//- (BOOL)prefersStatusBarHidden {
//    return NO; // your own visibility code
//}

- (void)viewDidLoad {
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.


    [Common instance].menucontr = self;
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?
//                                @"Main_iPad":@"Main_iPhone" bundle:nil];
    UIViewController *viewController =  [self.storyboard instantiateViewControllerWithIdentifier:@"mainController"];
    viewController.view.tag = MAIN_VIEW_TAG;
//    viewController.view.hidden = YES;
    [self addChildViewController:viewController];
    [self.view addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
    
    viewController =  [self.storyboard instantiateViewControllerWithIdentifier:@"priceController"];
    viewController.view.tag = PRICE_VIEW_TAG;
    [self addChildViewController:viewController];
    [self.view addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
    CGRect fr = self.view.frame;
    viewController.view.frame = CGRectMake(fr.size.width - deltaX, fr.origin.y, fr.size.width, fr.size.height);
    viewController.view.hidden = YES;
    
    viewController =  [self.storyboard instantiateViewControllerWithIdentifier:@"mapsController"];
    viewController.view.tag = MAPS_VIEW_TAG;
    [self addChildViewController:viewController];
    [self.view addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
    fr = self.view.frame;
    viewController.view.frame = CGRectMake(fr.size.width - deltaX, fr.origin.y, fr.size.width, fr.size.height);
    viewController.view.hidden = YES;
    
    viewController =  [self.storyboard instantiateViewControllerWithIdentifier:@"newsController"];
    viewController.view.tag = NEWS_VIEW_TAG;
    [self addChildViewController:viewController];
    [self.view addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
    fr = self.view.frame;
    viewController.view.frame = CGRectMake(fr.size.width - deltaX, fr.origin.y, fr.size.width, fr.size.height);
    viewController.view.hidden = YES;
    
    viewController =  [self.storyboard instantiateViewControllerWithIdentifier:@"actsController"];
    viewController.view.tag = ACTS_VIEW_TAG;
    [self addChildViewController:viewController];
    [self.view addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
    fr = self.view.frame;
    viewController.view.frame = CGRectMake(fr.size.width - deltaX, fr.origin.y, fr.size.width, fr.size.height);
    viewController.view.hidden = YES;
    
    viewController =  [self.storyboard instantiateViewControllerWithIdentifier:@"aboutController"];
    viewController.view.tag = ABOUT_VIEW_TAG;
    [self addChildViewController:viewController];
    [self.view addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
    fr = self.view.frame;
    viewController.view.frame = CGRectMake(fr.size.width - deltaX, fr.origin.y, fr.size.width, fr.size.height);
    viewController.view.hidden = YES;
    
    viewController =  [self.storyboard instantiateViewControllerWithIdentifier:@"settingsController"];
    viewController.view.tag = SETT_VIEW_TAG;
    [self addChildViewController:viewController];
    [self.view addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
    fr = self.view.frame;
    viewController.view.frame = CGRectMake(fr.size.width - deltaX, fr.origin.y, fr.size.width, fr.size.height);
    viewController.view.hidden = YES;
    
    viewController =  [self.storyboard instantiateViewControllerWithIdentifier:@"hotlineController"];
    viewController.view.tag = HOT_VIEW_TAG;
    [self addChildViewController:viewController];
    [self.view addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
    fr = self.view.frame;
    viewController.view.frame = CGRectMake(fr.size.width - deltaX, fr.origin.y, fr.size.width, fr.size.height);
    viewController.view.hidden = YES;
    
    [[self.bmain titleLabel] setFont:FONT_MENU];
    [[self.babout titleLabel] setFont:FONT_MENU];
    [[self.bmap titleLabel] setFont:FONT_MENU];
    [[self.bnews titleLabel] setFont:FONT_MENU];
    [[self.bacts titleLabel] setFont:FONT_MENU];
    [[self.bhotline titleLabel] setFont:FONT_MENU];
    [[self.bsettings titleLabel] setFont:FONT_MENU];
    [[self.bshop titleLabel] setFont:FONT_MENU];
    [[self.bsite titleLabel] setFont:FONT_MENU];
    self.network.font = FONT_MENU;
    
    [self refresh];

    
    // Add swipeGestures
    UISwipeGestureRecognizer *oneFingerSwipeLeft = [[UISwipeGestureRecognizer alloc]
                                                     initWithTarget:self
                                                     action:@selector(oneFingerSwipeLeft:)];
    [oneFingerSwipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [[self view] addGestureRecognizer:oneFingerSwipeLeft];
    
    UISwipeGestureRecognizer *oneFingerSwipeRight = [[UISwipeGestureRecognizer alloc]
                                                      initWithTarget:self
                                                      action:@selector(oneFingerSwipeRight:)];
    [oneFingerSwipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [[self view] addGestureRecognizer:oneFingerSwipeRight];
    
    
}

- (void) swipeView:(UIView*)v toLeft:(BOOL)left {

    CGRect fr = v.frame;
    BOOL b = (fr.origin.x < 1);
    if((b && !left) || (!b && left)) {
        

        [UIView animateWithDuration:anim_delay delay:0.0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         v.frame = CGRectMake(b?(fr.size.width - deltaX):0, fr.origin.y, fr.size.width, fr.size.height);
                         
                     }
                     completion:^(BOOL finished) {
                     }];
    }

}

- (void)oneFingerSwipeLeft:(UITapGestureRecognizer *)recognizer {
    // Insert your own code to handle swipe left
    
//    NSLog(@"- (void)oneFingerSwipeLeft");
    for(UIViewController* vc in self.childViewControllers) {
        
        if(!vc.view.hidden) {
            
            [self swipeView:vc.view toLeft:YES];

        }
    }

}

- (void)oneFingerSwipeRight:(UITapGestureRecognizer *)recognizer {
    // Insert your own code to handle swipe right
    
//    NSLog(@"- (void)oneFingerSwipeRight");
    for(UIViewController* vc in self.childViewControllers) {
        
        if(!vc.view.hidden) {
            
            [self swipeView:vc.view toLeft:NO];
            
        }
    }

}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) refresh {
    
    [self.bmain setTitle:NSLocalizedString(@"Main", nil) forState:UIControlStateNormal];
    [self.babout setTitle:NSLocalizedString(@"About", nil) forState:UIControlStateNormal];
    [self.bmap setTitle:NSLocalizedString(@"Map", nil) forState:UIControlStateNormal];
    [self.bnews setTitle:NSLocalizedString(@"News", nil) forState:UIControlStateNormal];
    [self.bacts setTitle:NSLocalizedString(@"Actions", nil) forState:UIControlStateNormal];
    [self.bhotline setTitle:NSLocalizedString(@"HotLine", nil) forState:UIControlStateNormal];
    [self.bsettings setTitle:NSLocalizedString(@"Settings", nil) forState:UIControlStateNormal];
    [self.bshop setTitle:NSLocalizedString(@"IShop", nil) forState:UIControlStateNormal];
    [self.bsite setTitle:NSLocalizedString(@"Site", nil) forState:UIControlStateNormal];
    self.network.text = NSLocalizedString(@"Networks", nil);
    
    for(UIViewController* vc in self.childViewControllers) {
        
        [vc refresh];
    }
    
}

- (void) makeInvisibleExcludeTag:(int)tag {

    for(UIViewController* vc in self.childViewControllers) {

        vc.view.hidden = (vc.view.tag != tag);
    }

    [[UIApplication sharedApplication] setStatusBarStyle:(tag == MAIN_VIEW_TAG)?UIStatusBarStyleDefault:UIStatusBarStyleLightContent animated:YES];

}

- (void) goLeft:(int) tag {

//    NSLog(@"tag = %d", tag);

    [self makeInvisibleExcludeTag:tag];

//    self.view.hidden = NO;


    UIView* view = [self.view viewWithTag:tag];
    CGRect fr = self.view.frame;
    view.frame = CGRectMake(fr.size.width - deltaX, fr.origin.y, fr.size.width, fr.size.height);
    [UIView animateWithDuration:anim_delay delay:0.0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         view.frame = CGRectMake(0, fr.origin.y, fr.size.width, fr.size.height);
                     }
                     completion:^(BOOL finished) {
                     }];

}

- (IBAction)mainPressed:(id)sender {
    
//    NSLog(@"main");

    [self goLeft:MAIN_VIEW_TAG];
}

- (IBAction)mapsPressed:(id)sender {
    
//    NSLog(@"map");

    [self goLeft:MAPS_VIEW_TAG];
}

- (IBAction)aboutPressed:(id)sender {
    
    [self goLeft:ABOUT_VIEW_TAG];
}

- (IBAction)actionsPressed:(id)sender {
    
    [self goLeft:ACTS_VIEW_TAG];
}

- (IBAction)hotlinePressed:(id)sender {
}

- (IBAction)settingsPressed:(id)sender {
}

- (IBAction)shopPressed:(id)sender {
}

- (IBAction)newsPressed:(id)sender {
    
//    NSLog(@"news");

    [self goLeft:NEWS_VIEW_TAG];

}

- (void) showMaps {
    
    CGRect fr = self.view.frame;
    UIView* view = [self.view viewWithTag:MAPS_VIEW_TAG];
    view.frame = CGRectMake(0, fr.origin.y, fr.size.width, fr.size.height);
    
    [self makeInvisibleExcludeTag:MAPS_VIEW_TAG];
    
}

- (void) showPrices {
    
    CGRect fr = self.view.frame;
    UIView* view = [self.view viewWithTag:PRICE_VIEW_TAG];
    view.frame = CGRectMake(0, fr.origin.y, fr.size.width, fr.size.height);
    
    [self makeInvisibleExcludeTag:PRICE_VIEW_TAG];
    
}

- (void) showNews {
    
    CGRect fr = self.view.frame;
    UIView* view = [self.view viewWithTag:NEWS_VIEW_TAG];
    view.frame = CGRectMake(0, fr.origin.y, fr.size.width, fr.size.height);
    
    [self makeInvisibleExcludeTag:NEWS_VIEW_TAG];
    
}

- (void) showActions {
    
    CGRect fr = self.view.frame;
    UIView* view = [self.view viewWithTag:ACTS_VIEW_TAG];
    view.frame = CGRectMake(0, fr.origin.y, fr.size.width, fr.size.height);
    
    [self makeInvisibleExcludeTag:ACTS_VIEW_TAG];
}

- (void) showAbout {
    
    CGRect fr = self.view.frame;
    UIView* view = [self.view viewWithTag:ABOUT_VIEW_TAG];
    view.frame = CGRectMake(0, fr.origin.y, fr.size.width, fr.size.height);
    
    [self makeInvisibleExcludeTag:ABOUT_VIEW_TAG];
}

- (void) showSettings {

    CGRect fr = self.view.frame;
    UIView* view = [self.view viewWithTag:SETT_VIEW_TAG];
    view.frame = CGRectMake(0, fr.origin.y, fr.size.width, fr.size.height);
    
    [self makeInvisibleExcludeTag:SETT_VIEW_TAG];

}

- (void) showHotline {

    CGRect fr = self.view.frame;
    UIView* view = [self.view viewWithTag:HOT_VIEW_TAG];
    view.frame = CGRectMake(0, fr.origin.y, fr.size.width, fr.size.height);
    
    [self makeInvisibleExcludeTag:HOT_VIEW_TAG];

    for(UIViewController* vc in self.childViewControllers) {
        
        if(vc.view.tag == HOT_VIEW_TAG) {
            
            ((HotlineViewController*)vc).timer = YES;
            [((HotlineViewController*)vc) recvMsg];
            
        }
    }

}

- (void) showStationWithId:(int) sid {
    
    [self showMaps];

    for(UIViewController* vc in self.childViewControllers) {
        
        if(vc.view.tag == MAPS_VIEW_TAG) {
            
            [((MapViewController*)vc) showStationWithId:sid];
        }
    }
    
    
}

@end
