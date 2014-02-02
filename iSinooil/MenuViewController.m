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

@implementation MenuViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [Common instance];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?
                                @"Main_iPad":@"Main_iPhone" bundle:nil];
    UIViewController *viewController =  [storyboard instantiateViewControllerWithIdentifier:@"mainController"];
    viewController.view.tag = MAIN_VIEW_TAG;
//    viewController.view.hidden = YES;
    [self addChildViewController:viewController];
    [self.view addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
    
    viewController =  [storyboard instantiateViewControllerWithIdentifier:@"priceController"];
    viewController.view.tag = PRICE_VIEW_TAG;
    [self addChildViewController:viewController];
    [self.view addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
    CGRect fr = self.view.frame;
    viewController.view.frame = CGRectMake(fr.size.width - deltaX, fr.origin.y, fr.size.width, fr.size.height);
    viewController.view.hidden = YES;
    
    viewController =  [storyboard instantiateViewControllerWithIdentifier:@"mapsController"];
    viewController.view.tag = MAPS_VIEW_TAG;
    [self addChildViewController:viewController];
    [self.view addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
    fr = self.view.frame;
    viewController.view.frame = CGRectMake(fr.size.width - deltaX, fr.origin.y, fr.size.width, fr.size.height);
    viewController.view.hidden = YES;
    
    viewController =  [storyboard instantiateViewControllerWithIdentifier:@"newsController"];
    viewController.view.tag = NEWS_VIEW_TAG;
    [self addChildViewController:viewController];
    [self.view addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
    fr = self.view.frame;
    viewController.view.frame = CGRectMake(fr.size.width - deltaX, fr.origin.y, fr.size.width, fr.size.height);
    viewController.view.hidden = YES;
    

}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) makeInvisibleExcludeTag:(int)tag {

    for(UIViewController* vc in self.childViewControllers) {

        vc.view.hidden = (vc.view.tag != tag);
    }

//    self.view.hidden = YES;
}

- (void) goLeft:(int) tag {


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

- (void) showStationWithId:(int) sid {
    
    [self showMaps];

    for(UIViewController* vc in self.childViewControllers) {
        
        if(vc.view.tag == MAPS_VIEW_TAG) {
            
            [((MapViewController*)vc) showStationWithId:sid];
        }
    }
    
    
}

@end
