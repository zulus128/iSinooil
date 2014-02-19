//
//  StationDetailViewController.m
//  iSinooil
//
//  Created by Admin on 19.02.14.
//  Copyright (c) 2014 Zul. All rights reserved.
//

#import "StationDetailViewController.h"

@implementation StationDetailViewController

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    CGSize s = [Common currentScreenBoundsDependOnOrientation:toInterfaceOrientation];

    self.detailViewH.constant = s.height - 70;
    self.detailViewW.constant = s.width;
 
    [self refresh];
}

- (void) refresh {
    
    NSDictionary* dic = [[Common instance].azsjson objectAtIndex:[Common instance].stationRowSelected];
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
        
        //        NSDictionary* d = [tels objectAtIndex:i];
        //        NSString* tel = [d objectForKey:PHONE_NUMBER];
        NSString* tel = (NSString*)[tels objectAtIndex:i];
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
        
        NSString* icon = @"icon_97_inactive.png";
        switch (i) {
            case FUEL_BIT_97:
                icon = @"icon_97_inactive.png";
                break;
            case FUEL_BIT_96:
                icon = @"icon_96_inactive.png";
                break;
            case FUEL_BIT_93:
                icon = @"icon_93_inactive.png";
                break;
            case FUEL_BIT_92:
                icon = @"icon_92_inactive.png";
                break;
            case FUEL_BIT_80:
                icon = @"icon_80_inactive.png";
                break;
            case FUEL_BIT_DT:
                icon = @"icon_diesel_inactive.png";
                break;
            case FUEL_BIT_GAS:
                icon = @"icon_diesel_inactive.png";
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
        
        NSString* icon = @"icon_market_inactive.png";
        switch (i) {
            case SERV_BIT_MARKET:
                icon = @"icon_market_inactive.png";
                break;
            case SERV_BIT_CAFE:
                icon = @"icon_cafe_inactive.png";
                break;
            case SERV_BIT_TERM:
                icon = @"icon_terminal_inactive.png";
                break;
            case SERV_BIT_ATM:
                icon = @"icon_atm_inactive.png";
                break;
            case SERV_BIT_WASH:
                icon = @"icon_wash_inactive.png";
                break;
            case SERV_BIT_STO:
                icon = @"icon_service_inactive.png";
                break;
            case SERV_BIT_OIL:
                icon = @"icon_oil_inactive.png";
                break;
            case SERV_BIT_WHEEL:
                icon = @"icon_wheel_inactive.png";
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
        
        NSString* icon = @"icon_visa_inactive.png";
        switch (i) {
            case CARD_BIT_VISA:
                icon = @"icon_visa_inactive.png";
                break;
            case CARD_BIT_AE:
                icon = @"icon_amer_inactive.png";
                break;
            case CARD_BIT_MC:
                icon = @"icon_master_inactive.png";
                break;
        }
        
        UIImageView* iv = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, ICON_SIZE, ICON_SIZE)];
        iv.image = [UIImage imageNamed:icon];
        iv.tag = ICON_TAG;
        [self.stationDetailView addSubview:iv];
        
        x += GAP_SIZE2;
    }
    
//    self.stationDetailView.hidden = NO;
    
}

- (void)callTel:(UIButton*)button {
    
    long i = button.tag - ICON_TAG;
    //    NSLog(@"call %ld", i);
    
    NSDictionary* dic = [[Common instance].azsjson objectAtIndex:[Common instance].stationRowSelected];
    NSArray* tels = [dic objectForKey:STATION_PHONE];
    //        NSDictionary* d = [tels objectAtIndex:i];
    //        NSString* tel = [d objectForKey:PHONE_NUMBER];
    NSString* tel = (NSString*)[tels objectAtIndex:i];
    
    NSString *phoneNumber = [@"telprompt://" stringByAppendingString:tel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self refresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
