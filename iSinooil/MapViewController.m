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
#import "MapSource.h"
#import "StationListDataSource.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
//    NSLog(@"will rotate map");
    
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

    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    CLLocationCoordinate2D noLocation;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(noLocation, 500, 500);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];

    self.mapsour = [[MapSource alloc] initWithType:MAPTYPE_FULLWINDOW];
    self.mapView.delegate = self.mapsour;
    self.mapsour.mapcontr = self;
    
    self.listsour = [[StationListDataSource alloc] init];
//    self.stationList.delegate = self.listsour;
    self.stationListTable.delegate = self;
    self.stationListTable.dataSource = self.listsour;
    
    [Common instance].mymapview = self.mapView;
    
    [self mapTouchDown:self.mapButton];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    NSLog(@"!!! MapViewController didReceiveMemoryWarning");
}

- (IBAction) menu:(id)sender {

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

//- (IBAction) pickOne:(id)sender {
//    
//    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
////    NSLog(@"index = %d", segmentedControl.selectedSegmentIndex);
//    
//    switch (segmentedControl.selectedSegmentIndex) {
//        case 0:
//            self.mapView.hidden = NO;
//            self.stationList.hidden = YES;
//            break;
//        case 1:
//            self.mapView.hidden = YES;
//            [self.stationList reloadData];
//            self.stationList.hidden = NO;
//            break;
//    }
//}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(!self.stationDetailView.hidden)
        self.stationDetailView.hidden = YES;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return STATIONCELL_HEIGHT;
}

- (void)callTel:(UIButton*)button {
 
    long i = button.tag - ICON_TAG;
//    NSLog(@"call %ld", i);
    
    NSDictionary* dic = [[Common instance].azsjson objectAtIndex:selectedRow];
    NSArray* tels = [dic objectForKey:STATION_PHONE];
    NSDictionary* d = [tels objectAtIndex:i];
    NSString* tel = [d objectForKey:PHONE_NUMBER];

    NSString *phoneNumber = [@"telprompt://" stringByAppendingString:tel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

- (void) showStationDetails {

    NSDictionary* dic = [[Common instance].azsjson objectAtIndex:selectedRow];
    NSString* num = [dic objectForKey:STATION_TITLE];
    self.stationNumberLab.text = [[num componentsSeparatedByString:@"№"] objectAtIndex:1];
    self.stationDescrLab.text = [dic objectForKey:STATION_DESCR];
    
    for (UIView* v in self.stationDetailView.subviews) {
        if(v.tag >= ICON_TAG)
            [v removeFromSuperview];
    }
    
    float y = 180;
    
    NSArray* tels = [dic objectForKey:STATION_PHONE];
    for (int i = 0; i < tels.count; i++) {
        
        NSDictionary* d = [tels objectAtIndex:i];
        NSString* tel = [d objectForKey:PHONE_NUMBER];
        UILabel* number = [[UILabel alloc] initWithFrame:CGRectMake(20, y, 150, 40)];
        number.text = tel;
        number.tag = ICON_TAG;
        [self.stationDetailView addSubview:number];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(callTel:) forControlEvents:UIControlEventTouchDown];
        [button setTitle:@"Call" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        button.frame = CGRectMake(150.0, y + 5, 40.0, 30.0);
        button.tag = ICON_TAG + i;
        [self.stationDetailView addSubview:button];
        
        y += 40;
    }
    
    int fuel = ((NSNumber*)[dic valueForKey:STATION_FUEL]).intValue;
    //    NSLog(@"fuel = %d", fuel);
    float x = 20;
    y += 10;
    
    for (int i = FUEL_BIT_97; i <= FUEL_BIT_GAS; i = (i << 1)) {
        
        if (!(fuel & i))
            continue;
        
        NSString* icon = @"icon_97.png";
        switch (i) {
            case FUEL_BIT_97:
                icon = @"icon_97.png";
                break;
            case FUEL_BIT_96:
                icon = @"icon_96.png";
                break;
            case FUEL_BIT_93:
                icon = @"icon_93.png";
                break;
            case FUEL_BIT_92:
                icon = @"icon_92.png";
                break;
            case FUEL_BIT_80:
                icon = @"icon_80.png";
                break;
            case FUEL_BIT_DT:
                icon = @"icon_diesel.png";
                break;
            case FUEL_BIT_GAS:
                icon = @"icon_diesel.png";
                break;
        }
        
        UIImageView* iv = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, ICON_SIZE, ICON_SIZE)];
        iv.image = [UIImage imageNamed:icon];
        iv.tag = ICON_TAG;
        [self.stationDetailView addSubview:iv];
        
        x += GAP_SIZE2;
    }
    
    x = 20;
    y += 40;
    int serv = ((NSNumber*)[dic valueForKey:STATION_SERV]).intValue;
    //    NSLog(@"serv = %d", serv);
    for (int i = SERV_BIT_MARKET; i <= SERV_BIT_WHEEL; i = (i << 1)) {
        
        if (!(serv & i))
            continue;
        
        NSString* icon = @"icon_market.png";
        switch (i) {
            case SERV_BIT_MARKET:
                icon = @"icon_market.png";
                break;
            case SERV_BIT_CAFE:
                icon = @"icon_cafe.png";
                break;
            case SERV_BIT_TERM:
                icon = @"icon_terminal.png";
                break;
            case SERV_BIT_ATM:
                icon = @"icon_atm.png";
                break;
            case SERV_BIT_WASH:
                icon = @"icon_wash.png";
                break;
            case SERV_BIT_STO:
                icon = @"icon_service.png";
                break;
            case SERV_BIT_OIL:
                icon = @"icon_oil.png";
                break;
            case SERV_BIT_WHEEL:
                icon = @"icon_wheel.png";
                break;
        }
        
        UIImageView* iv = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, ICON_SIZE, ICON_SIZE)];
        iv.image = [UIImage imageNamed:icon];
        iv.tag = ICON_TAG;
        [self.stationDetailView addSubview:iv];
        
        x += GAP_SIZE2;
    }
    
    x = 20;
    y += 40;
    int card = ((NSNumber*)[dic valueForKey:STATION_CARD]).intValue;
    //    NSLog(@"card = %d", card);
    for (int i = CARD_BIT_VISA; i <= CARD_BIT_MC; i = (i << 1)) {
        
        if (!(card & i))
            continue;
        
        NSString* icon = @"icon_visa.png";
        switch (i) {
            case CARD_BIT_VISA:
                icon = @"icon_visa.png";
                break;
            case CARD_BIT_AE:
                icon = @"icon_amer.png";
                break;
            case CARD_BIT_MC:
                icon = @"icon_master.png";
                break;
        }
        
        UIImageView* iv = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, ICON_SIZE, ICON_SIZE)];
        iv.image = [UIImage imageNamed:icon];
        iv.tag = ICON_TAG;
        [self.stationDetailView addSubview:iv];
        
        x += GAP_SIZE2;
    }
    
    self.stationDetailView.hidden = NO;

}

- (IBAction)mapTouchDown:(UIButton*)button {
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setBackgroundImage: [UIImage imageNamed:@"tab_left_pressed.png"] forState:UIControlStateNormal];

    [self.listButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.listButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [self.listButton setBackgroundImage: [UIImage imageNamed:@"tab_right.png"] forState:UIControlStateNormal];
    
    self.mapView.hidden = NO;
    self.stationListTable.hidden = YES;
}

- (IBAction)listTouchDown:(UIButton*)button {
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setBackgroundImage: [UIImage imageNamed:@"tab_right_pressed.png"] forState:UIControlStateNormal];

    [self.mapButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.mapButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [self.mapButton setBackgroundImage: [UIImage imageNamed:@"tab_left.png"] forState:UIControlStateNormal];

    self.mapView.hidden = YES;
    [self.stationListTable reloadData];
    self.stationListTable.hidden = NO;
}

- (void) showDetail:(int)num {

    selectedRow = num;
    [self showStationDetails];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    selectedRow = indexPath.row;
    [self showStationDetails];
}

@end
