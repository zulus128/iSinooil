//
//  ViewController.m
//  iSinooil
//
//  Created by Zul on 11/24/13.
//  Copyright (c) 2013 Zul. All rights reserved.
//

#import "MainViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Common.h"
#import "MenuViewController.h"
#import "MapSource.h"
#import "UIImageView+WebCache.h"

@implementation MainViewController

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {

//    NSLog(@"will rotate main");
    
    CGSize s = [Common currentScreenBoundsDependOnOrientation:toInterfaceOrientation];
    self.topView.frame = CGRectMake(0, 0, s.width, s.height);
    self.contentViewH.constant = s.height > VERT_SIZE?s.height:VERT_SIZE;
    self.contentViewW.constant = s.width;

}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    CGSize s = [Common currentScreenBounds];
    self.contentViewH.constant = s.height > VERT_SIZE?s.height:VERT_SIZE;

    [self refresh];

}

- (void) refresh {

    [self updateFuelPrice];
    [self updateNewsActs];

    self.hotlineLabel.text = NSLocalizedString(@"HotLine", nil);
    self.settingsLabel.text = NSLocalizedString(@"Settings", nil);
    self.seealsoLabel.text = NSLocalizedString(@"SeeAlso", nil);
    self.ishopLabel.text = NSLocalizedString(@"IShop", nil);
    self.siteLabel.text = NSLocalizedString(@"Site", nil);
    self.netwLabel.text = NSLocalizedString(@"Networks", nil);
}

- (void) updateFuelPrice {
 
    NSString* icon = NSLocalizedString(@"AI97", nil);
    switch ([Common instance].fuelSelected) {
        case 0://FUEL_BIT_97:
            icon = NSLocalizedString(@"AI97", nil);
            break;
        case 1://FUEL_BIT_96:
            icon = NSLocalizedString(@"AI96", nil);
            break;
        case 2://FUEL_BIT_93:
            icon = NSLocalizedString(@"AI93", nil);
            break;
        case 3://FUEL_BIT_92:
            icon = NSLocalizedString(@"AI92", nil);
            break;
        case 4://FUEL_BIT_80:
            icon = NSLocalizedString(@"AI80", nil);
            break;
        case 5://FUEL_BIT_DT:
            icon = NSLocalizedString(@"AIDI", nil);
            break;
        case 6://FUEL_BIT_GAS:
            icon = NSLocalizedString(@"AIGAS", nil);
            break;
        case 7://FUEL_BIT_DTW:
            icon = NSLocalizedString(@"AIDIW", nil);
            break;
    }
    
    self.aiLabel.text = icon;
    self.aiLabel.font = FONT_NAME_PRICE_LIST;
    
    for(NSDictionary* d in [Common instance].fueljson) {
        
        NSNumber* n = [d valueForKey:FUEL_BITS];
        if((n.intValue - 1) == [Common instance].fuelSelected) {
            
            NSNumber* cost = [d valueForKey:FUEL_COST];
            self.priceLabel.text = [NSString stringWithFormat:@"%d", cost.intValue];
            self.priceLabel.font = FONT_PRICE_LIST;
            break;
        }
    }
    
    self.distLabel.text = @"...";
    self.distLabel.font = FONT_KM_PRICE_LIST;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
        
        if(![Common instance].freeOfSems)
            dispatch_semaphore_wait([Common instance].allowSemaphore, DISPATCH_TIME_FOREVER);
//        NSLog(@"go1");

        float dist = [[Common instance] distToNearestStaionWithFuelBit:([Common instance].fuelSelected + 1) forCell:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{

//            self.distLabel.text = [NSString stringWithFormat:@"%.1f %@", dist, NSLocalizedString(@"km", nil)];
            switch ([Common instance].metrics) {
                case M_KM:
                    self.distLabel.text = [NSString stringWithFormat:@"%.1f %@", dist, NSLocalizedString(@"km", nil)];
                    break;
                case M_MI:
                    self.distLabel.text = [NSString stringWithFormat:@"%.1f %@", dist / KM_IN_MILE, NSLocalizedString(@"miles", nil)];
                    break;
                case M_MT:
                    self.distLabel.text = [NSString stringWithFormat:@"%.0f %@", dist * 1000, NSLocalizedString(@"metres", nil)];
                    break;
            }

        });
        
    });

}

- (void) updateNewsActs {

//    NSLog(@"topnews = %@", [Common instance].newsjson);
    @try {

        NSString* pic = [[Common instance].topnews valueForKey:NEWS_PIC];
        [self.newsImage setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"placeholder-icon"]];
        //    self.ttlLabel.text = [[Common instance].topnews valueForKey:NEWS_TTL];
        self.ttlLabel.text = NSLocalizedString(@"daynews", nil);
        //    self.briefLabel.text = [[Common instance].topnews valueForKey:NEWS_BRIEF];
        NSString *labelText = [[Common instance].topnews valueForKey:NEWS_BRIEF];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:4];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
        self.briefLabel.attributedText = attributedString;
        
        pic = [[Common instance].topact valueForKey:NEWS_PIC];
        [self.actImage setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"placeholder-icon"]];
        //    self.abriefLabel.text = [[Common instance].topact valueForKey:NEWS_BRIEF];
        labelText = [[Common instance].topact valueForKey:NEWS_BRIEF];
        attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
        self.abriefLabel.attributedText = attributedString;
        
        NSNumber* n = [[Common instance].topact valueForKey:NEWS_START_DATE];
        NSDate* date = [NSDate dateWithTimeIntervalSince1970:n.longValue];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [dateFormatter setDateFormat:@"dd.MM.yy"];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        NSString *formattedDateString = [dateFormatter stringFromDate:date];
        
        n = [[Common instance].topact valueForKey:NEWS_END_DATE];
        date = [NSDate dateWithTimeIntervalSince1970:n.longValue];
        NSString *formattedDateString1 = [dateFormatter stringFromDate:date];
        
        self.attlLabel.text = [NSString stringWithFormat:@"%@ - %@", formattedDateString, formattedDateString1];
    }
    @catch (NSException *exception) {

        NSLog(@"updateNewsActs: %@", exception.description);
    }
    @finally {
        
    }
    
}

//-(UIStatusBarStyle)preferredStatusBarStyle {
//    
////    return UIStatusBarStyleLightContent;
//    return UIStatusBarStyleDefault;
//}



- (void)viewDidLoad {
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    [self setNeedsStatusBarAppearanceUpdate];
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
//    self.navigationController.navigationBarHidden = YES;
    
    if([Common instance].userCoordinate.longitude < -1e4) {
    
        CLLocationCoordinate2D noLocation = {43.240682, 76.892621};
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(noLocation, 5000, 5000);
        MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
        [self.mapView setRegion:adjustedRegion animated:YES];
    }
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
   
    self.mapView.layer.cornerRadius = 5;
    self.mapView.layer.masksToBounds = YES;
    
    self.newsView.layer.cornerRadius = 5;
    self.newsView.layer.masksToBounds = YES;
    self.actView.layer.cornerRadius = 5;
    self.actView.layer.masksToBounds = YES;
    
    self.mapsour = [[MapSource alloc] initWithType:MAPTYPE_MAINMENU];
    self.mapView.delegate = self.mapsour;
    
    CGSize s = [Common currentScreenBounds];
    self.topView.frame = CGRectMake(0, 0, s.width, s.height);
    self.contentViewH.constant = s.height * 2;
    self.contentViewW.constant = s.width;

    self.ttlLabel.font = FONT_NEWS_TITLE;
    self.briefLabel.font = FONT_NEWS_BRIEF;
    self.attlLabel.font = FONT_ACTS_TITLE;
    self.attlLabel.textColor = [UIColor grayColor];
    self.abriefLabel.font = FONT_NEWS_BRIEF;

    self.hotlineLabel.font = FONT_MAINMENU_HOTLINE;
    self.settingsLabel.font = FONT_MAINMENU_HOTLINE;
    self.seealsoLabel.font = FONT_MAINMENU_SEEALSO;
    self.ishopLabel.font = FONT_MAINMENU_ISHOP;
    self.siteLabel.font = FONT_MAINMENU_ISHOP;
    self.netwLabel.font = FONT_MAINMENU_ISHOP;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];

}

- (BOOL)shouldAutorotate
{
//    NSLog(@"%s", __PRETTY_FUNCTION__);

    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
//    NSLog(@"%s", __PRETTY_FUNCTION__);
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)menu:(id)sender {
    
//    CGRect fr = self.view.frame;
//    BOOL b = (fr.origin.x < 1);

    [self doMenu];
    
//    [[UIApplication sharedApplication] setStatusBarStyle:!b?UIStatusBarStyleDefault:UIStatusBarStyleLightContent animated:YES];

}

- (IBAction)tapPrice:(id)sender {
    
    [((MenuViewController*)self.parentViewController) showPrices];
}

- (IBAction)tapMap:(id)sender {
    
    [((MenuViewController*)self.parentViewController) showMaps];
}

- (IBAction)tapNews:(id)sender {

    [((MenuViewController*)self.parentViewController) showNews];
}

- (IBAction)tapActions:(id)sender {
    
    [((MenuViewController*)self.parentViewController) showActions];
}

- (IBAction)tapTop:(id)sender {
    
//    NSLog(@"tap top");
    [((MenuViewController*)self.parentViewController) showAbout];

}

- (IBAction)tapShop:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URL_SHOP]];
}

- (IBAction)tapSite:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URL_SITE]];
}

- (IBAction)tapFB:(id)sender {
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:URL_FB_SPEC]]){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URL_FB_SPEC]];
    }
    else {
        //Open the url as usual
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URL_FB]];
    }
}

- (IBAction)tapVK:(id)sender {
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:URL_VK_SPEC]]){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URL_VK_SPEC]];
    }
    else {
        //Open the url as usual
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URL_VK]];
    }
}

- (IBAction)tapSettings:(id)sender {
    
    [((MenuViewController*)self.parentViewController) showSettings];
}

- (IBAction)tapHotline:(id)sender {
    
    [((MenuViewController*)self.parentViewController) showHotline];
}

@end
