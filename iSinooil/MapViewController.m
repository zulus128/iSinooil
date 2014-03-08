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
#import "MapPoint.h"
#import "StationDetailViewController.h"

@implementation MapViewController

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
//    NSLog(@"will rotate map");
    
    CGSize s = [Common currentScreenBoundsDependOnOrientation:toInterfaceOrientation];
    self.topView.frame = CGRectMake(0, 0, s.width, s.height);
    
//    self.detailViewH.constant = s.height;
//    self.detailViewW.constant = s.width;
    
//    [self.mapsour removeAllPinsButUserLocation];

}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    [self refresh];
}

-(void)buttonTouchDown1:(id)sender {
    
    //    NSLog(@"down");
    UIButton *button=(UIButton *)sender;
    button.selected = !button.selected;

    int i = button.tag - ICON_TAG;
    if(button.selected)
        [Common instance].fuel = [Common instance].fuel | i;
    else
        [Common instance].fuel = [Common instance].fuel & (~i);
    [self.mapsour refreshPins];

    NSString* icon = @"icon_97";
    switch (i) {
        case FUEL_BIT_97:
            icon = @"icon_97";
            break;
        case FUEL_BIT_96:
            icon = @"icon_96";
            break;
        case FUEL_BIT_93:
            icon = @"icon_93";
            break;
        case FUEL_BIT_92:
            icon = @"icon_92";
            break;
        case FUEL_BIT_80:
            icon = @"icon_80";
            break;
        case FUEL_BIT_DT:
            icon = @"icon_diesel";
            break;
        case FUEL_BIT_GAS:
            icon = @"icon_diesel";
            break;
    }
    
    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:(button.selected?@"%@_pressed.png":@"%@.png"), icon]] forState:UIControlStateNormal];
    
}

-(void)buttonTouchDown2:(id)sender {
    
    //    NSLog(@"down");
    UIButton *button=(UIButton *)sender;
    button.selected = !button.selected;
    
    int i = button.tag - ICON_TAG;
    if(button.selected)
        [Common instance].serv = [Common instance].serv | i;
    else
        [Common instance].serv = [Common instance].serv & (~i);
    [self.mapsour refreshPins];

    NSString* icon = @"icon_market";
    switch (i) {
        case SERV_BIT_MARKET:
            icon = @"icon_market";
            break;
        case SERV_BIT_CAFE:
            icon = @"icon_cafe";
            break;
        case SERV_BIT_TERM:
            icon = @"icon_terminal";
            break;
        case SERV_BIT_ATM:
            icon = @"icon_atm";
            break;
        case SERV_BIT_WASH:
            icon = @"icon_wash";
            break;
        case SERV_BIT_STO:
            icon = @"icon_service";
            break;
        case SERV_BIT_OIL:
            icon = @"icon_oil";
            break;
        case SERV_BIT_WHEEL:
            icon = @"icon_wheel";
            break;
    }
    
    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:(button.selected?@"%@_pressed.png":@"%@.png"), icon]] forState:UIControlStateNormal];
    
}

-(void)buttonTouchDown3:(id)sender {
    
    //    NSLog(@"down");
    UIButton *button=(UIButton *)sender;
    
    button.selected = !button.selected;
    int i = button.tag - ICON_TAG;
    if(button.selected)
        [Common instance].card = [Common instance].card | i;
    else
        [Common instance].card = [Common instance].card & (~i);
    [self.mapsour refreshPins];

    NSString* icon = @"icon_visa";
    switch (i) {
        case CARD_BIT_VISA:
            icon = @"icon_visa";
            break;
        case CARD_BIT_AE:
            icon = @"icon_amer";
            break;
        case CARD_BIT_MC:
            icon = @"icon_master";
            break;
    }
    
    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:(button.selected?@"%@_pressed.png":@"%@.png"), icon]] forState:UIControlStateNormal];
    
}

- (void) refreshDropdown {

    UIView* old = [self.view viewWithTag:POPUP_TAG];
    [old removeFromSuperview];

    NSString* s = NSLocalizedString(@"AllCities", nil);

    switch ([Common instance].selectedCity) {
        case 1:
            s = NSLocalizedString(@"Aktau", nil);
            break;
        case 2:
            s = NSLocalizedString(@"Aktobe", nil);
            break;
        case 3:
            s = NSLocalizedString(@"Almaty", nil);
            break;
        case 4:
            s = NSLocalizedString(@"Astana", nil);
            break;
        case 5:
            s = NSLocalizedString(@"Atyrau", nil);
            break;
        case 6:
            s = NSLocalizedString(@"Kizilorda", nil);
            break;
        case 7:
            s = NSLocalizedString(@"Taraz", nil);
            break;
        case 8:
            s = NSLocalizedString(@"Ust-Kamenogorsk", nil);
            break;
        case 9:
            s = NSLocalizedString(@"Shimkent", nil);
            break;
        case 0:
            s = NSLocalizedString(@"AllCities", nil);
            break;
    }
    
    self.dropdown.text = s;
}

- (void) refresh {
    
//    NSLog(@"fuel: %d", [Common instance].fuel);

    [self refreshDropdown];
    
    UILabel* labelPrices = (UILabel*)[self.topView viewWithTag:TITLELABEL_TAG];
    labelPrices.font = FONT_STD_TOP_MENU;
    labelPrices.text = NSLocalizedString(@"Stations", nil);
    
    CGSize s = [Common currentScreenBounds];
 
    for (UIView* v in self.filterView.subviews) {
        if(v.tag >= ICON_TAG)
            [v removeFromSuperview];
    }
    
    float y = 8;
    float x = 5;
    for (int i = FUEL_BIT_97; i <= FUEL_BIT_GAS; i = (i << 1)) {
        
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
        
//        UIImageView* iv = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, ICON_SIZE, ICON_SIZE)];
//        iv.image = [UIImage imageNamed:icon];
//        iv.tag = ICON_TAG;
//        [self.filterView addSubview:iv];

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(buttonTouchDown1:) forControlEvents:UIControlEventTouchDown];
        button.frame = CGRectMake(x, y, ICON_SIZE, ICON_SIZE);
        [button setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
        button.tag = ICON_TAG + i;
        [self.filterView addSubview:button];
        if ([Common instance].fuel & i)
            [self buttonTouchDown1:button];
        
        x += GAP_SIZE3;
        if(x >= (s.width - 20)) {
            x = 5;
            y += 35;
        }
        
    }
    
    for (int i = SERV_BIT_MARKET; i <= SERV_BIT_WHEEL; i = (i << 1)) {
        
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
        
//        UIImageView* iv = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, ICON_SIZE, ICON_SIZE)];
//        iv.image = [UIImage imageNamed:icon];
//        iv.tag = ICON_TAG;
//        [self.filterView addSubview:iv];

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(buttonTouchDown2:) forControlEvents:UIControlEventTouchDown];
        button.frame = CGRectMake(x, y, ICON_SIZE, ICON_SIZE);
        [button setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
        button.tag = ICON_TAG + i;
        [self.filterView addSubview:button];
        if ([Common instance].serv & i)
            [self buttonTouchDown2:button];
        
        x += GAP_SIZE3;
        if(x >= (s.width - 20)) {
            x = 5;
            y += 35;
        }
    }
    
    for (int i = CARD_BIT_VISA; i <= CARD_BIT_MC; i = (i << 1)) {
        
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
        
//        UIImageView* iv = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, ICON_SIZE, ICON_SIZE)];
//        iv.image = [UIImage imageNamed:icon];
//        iv.tag = ICON_TAG;
//        [self.filterView addSubview:iv];

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(buttonTouchDown3:) forControlEvents:UIControlEventTouchDown];
        button.frame = CGRectMake(x, y, ICON_SIZE, ICON_SIZE);
        [button setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
        button.tag = ICON_TAG + i;
        [self.filterView addSubview:button];
        if ([Common instance].card & i)
            [self buttonTouchDown3:button];

        x += GAP_SIZE3;
        if(x >= (s.width - 20)) {
            x = 5;
            y += 35;
        }
    }

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

//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
//        
//        dispatch_semaphore_wait([Common instance].allowSemaphore, DISPATCH_TIME_FOREVER);
//        
//        NSLog(@"go3");
//        self.stationListTable.delegate = self;
//        self.stationListTable.dataSource = self.listsour;
//        [self.stationListTable reloadData];
//        
//    });
    
    [Common instance].mymapview = self.mapView;
    
    UILabel* labelAZS = (UILabel*)[self.topView viewWithTag:TITLELABEL_TAG];
    labelAZS.font = FONT_STD_TOP_MENU;
    
    [[self.listButton titleLabel] setFont:FONT_ABOUT_TOGGLE_BUTTONS];
    [[self.mapButton titleLabel] setFont:FONT_ABOUT_TOGGLE_BUTTONS];

    self.dropdown.font = FONT_MAP_DROPDOWN;
    
    [self mapTouchDown:self.mapButton];
    
    [self refresh];
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

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(!self.stationDetailView.hidden)
        self.stationDetailView.hidden = YES;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return STATIONCELL_HEIGHT;
}

- (void) showStationDetails {

    StationDetailViewController* detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"stationDetailController"];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (IBAction)mapTouchDown:(UIButton*)button {
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setBackgroundImage: [UIImage imageNamed:@"tab_left_pressed.png"] forState:UIControlStateNormal];

    [self.listButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.listButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [self.listButton setBackgroundImage: [UIImage imageNamed:@"tab_right.png"] forState:UIControlStateNormal];
    
    self.mapView.hidden = NO;
    self.filterView.hidden = NO;
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
    self.filterView.hidden = YES;
    [self.stationListTable reloadData];
    self.stationListTable.hidden = NO;
}

- (void) showStationWithId:(int)sid {
    
    [self mapTouchDown:self.mapButton];
    for(id<MKAnnotation> mp in self.mapView.annotations) {
        
        if ([mp isKindOfClass:[MapPoint class]])
            if (sid == ((MapPoint*)mp).stationId) {
            
                [self.mapView selectAnnotation:mp animated:YES];
                break;
            }
        }
}

- (void) showDetail:(int)num {

//    selectedRow = num;
    [Common instance].stationRowSelected = num;
    [self showStationDetails];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    selectedRow = indexPath.row;
    [Common instance].stationRowSelected = indexPath.row;
    [self showStationDetails];
}

-(void) citySelected:(id)sender {

    UIButton* button = (UIButton*)sender;
//    NSLog(@"city %d selected", button.tag);
    [Common instance].selectedCity = button.tag;
    [self refreshDropdown];
}

- (IBAction)goPopup:(id)sender {
    
    NSLog(@"showPopup");
    
    UIView* old = [self.view viewWithTag:POPUP_TAG];
    [old removeFromSuperview];
    
    int cnt = 10;
    CGRect f = self.dropdown.frame;
    UIView* v = [[UIView alloc] initWithFrame:CGRectMake(f.origin.x + 10, f.origin.y + 20, POPUP_WIDTH, cnt * POPUPBUTTON_HEIGHT)];
    v.layer.cornerRadius = 5;
    v.layer.masksToBounds = YES;
    v.tag = POPUP_TAG;
    v.backgroundColor = [UIColor clearColor];
    [self.view addSubview:v];
    
    UIView* vv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, POPUP_WIDTH, cnt * POPUPBUTTON_HEIGHT)];
    vv.layer.cornerRadius = 5;
    vv.layer.masksToBounds = YES;
    vv.backgroundColor = [UIColor grayColor];
    vv.alpha = 0.7f;
    [v addSubview:vv];
    
    for(int i = 0; i < 10; i++) {
    
        NSString* s = NSLocalizedString(@"AllCities", nil);
        switch (i) {
            case 1:
                s = NSLocalizedString(@"Aktau", nil);
                break;
            case 2:
                s = NSLocalizedString(@"Aktobe", nil);
                break;
            case 3:
                s = NSLocalizedString(@"Almaty", nil);
                break;
            case 4:
                s = NSLocalizedString(@"Astana", nil);
                break;
            case 5:
                s = NSLocalizedString(@"Atyrau", nil);
                break;
            case 6:
                s = NSLocalizedString(@"Kizilorda", nil);
                break;
            case 7:
                s = NSLocalizedString(@"Taraz", nil);
                break;
            case 8:
                s = NSLocalizedString(@"Ust-Kamenogorsk", nil);
                break;
            case 9:
                s = NSLocalizedString(@"Shimkent", nil);
                break;
            case 0:
                s = NSLocalizedString(@"AllCities", nil);
                break;
        }

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(citySelected:) forControlEvents:UIControlEventTouchDown];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:s forState:UIControlStateNormal];
        button.titleLabel.font = MAP_POPUP_FONT;
        button.tag = i;
        button.frame = CGRectMake(0, i * POPUPBUTTON_HEIGHT, POPUP_WIDTH, POPUPBUTTON_HEIGHT);
        [v addSubview:button];
    }}

@end
