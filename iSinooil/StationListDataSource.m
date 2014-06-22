//
//  ListDataSource.m
//  iSinooil
//
//  Created by Admin on 06.01.14.
//  Copyright (c) 2014 Zul. All rights reserved.
//

#import "StationListDataSource.h"
#import "StationViewCell.h"
#import "Common.h"

@implementation StationListDataSource

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    return [Common instance].azsjson.count;
    return [Common instance].sortedazsjson.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"stationCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    StationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
//    NSDictionary* dic = [[Common instance].azsjson objectAtIndex:indexPath.row];
    NSDictionary* dic = [[Common instance].sortedazsjson objectAtIndex:indexPath.row];
    cell.kmLab.text = @"...";
    NSString* num = [dic objectForKey:STATION_TITLE];
    cell.numberLab.text = [[num componentsSeparatedByString:@"№"] objectAtIndex:1];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {

        NSNumber* n = [dic valueForKey:STATION_ID];

        if(![Common instance].freeOfSems)
            dispatch_semaphore_wait([Common instance].allowSemaphore, DISPATCH_TIME_FOREVER);
     
        float dist = [[Common instance] calculateDistToStation:n.intValue];
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(prepareToRefreshTable:) object:nil];
        [self performSelector:@selector(prepareToRefreshTable:) withObject:tableView afterDelay:4.0f];

        dispatch_async(dispatch_get_main_queue(), ^{
            
            StationViewCell *updateCell = (id)[tableView cellForRowAtIndexPath:indexPath];
            if (updateCell) {

                switch ([Common instance].metrics) {
                    case M_KM:
                        updateCell.kmLab.text = [NSString stringWithFormat:@"%.1f %@", dist, NSLocalizedString(@"km", nil)];
                        break;
                    case M_MI:
                        updateCell.kmLab.text = [NSString stringWithFormat:@"%.1f %@", dist / KM_IN_MILE, NSLocalizedString(@"miles", nil)];
                        break;
                    case M_MT:
                        updateCell.kmLab.text = [NSString stringWithFormat:@"%.0f %@", dist * 1000, NSLocalizedString(@"metres", nil)];
                        break;
                }
                
            }
        });
        
    });
    
    for (UIView* v in cell.contentView.subviews) {
        if(v.tag == ICON_TAG)
            [v removeFromSuperview];
    }
    int fuel = ((NSNumber*)[dic valueForKey:STATION_FUEL]).intValue;
    //    NSLog(@"fuel = %d", fuel);
    float x = 20;
    for (int i = FUEL_BIT_97; i <= FUEL_BIT_DTW; i = (i << 1)) {
        
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
            case FUEL_BIT_DTW:
                icon = @"icon_dieselw_inactive.png";
                break;
        }
        
        UIImageView* iv = [[UIImageView alloc] initWithFrame:CGRectMake(x, 60, ICON_SIZE, ICON_SIZE)];
        iv.image = [UIImage imageNamed:icon];
        iv.tag = ICON_TAG;
        [cell.contentView addSubview:iv];
        
        x += GAP_SIZE;
    }
    
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
        
        UIImageView* iv = [[UIImageView alloc] initWithFrame:CGRectMake(x, 60, ICON_SIZE, ICON_SIZE)];
        iv.image = [UIImage imageNamed:icon];
        iv.tag = ICON_TAG;
        [cell.contentView addSubview:iv];
        
        x += GAP_SIZE1;
    }
    
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
        
        UIImageView* iv = [[UIImageView alloc] initWithFrame:CGRectMake(x, 60, ICON_SIZE, ICON_SIZE)];
        iv.image = [UIImage imageNamed:icon];
        iv.tag = ICON_TAG;
        [cell.contentView addSubview:iv];
        
        x += GAP_SIZE1;
    }
    
    return cell;
}

- (void) prepareToRefreshTable:(UITableView*)tableView {
    
//    NSLog(@"--prepareToRefreshTable");
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[Common instance] filterOnSelectedCity];
        [tableView reloadData];
    });

}

@end
