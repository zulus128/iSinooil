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
    
    return [Common instance].azsjson.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"stationCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    StationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    NSDictionary* dic = [[Common instance].azsjson objectAtIndex:indexPath.row];
    cell.kmLab.text = @"...";
    NSString* num = [dic objectForKey:STATION_TITLE];
    cell.numberLab.text = [[num componentsSeparatedByString:@"№"] objectAtIndex:1];

//    NSNumber* n = [dic valueForKey:STATION_ID];
//    float dist = [[Common instance] calculateDistToStation:n.intValue];
//    cell.kmLab.text = [NSString stringWithFormat:@"%.1f %@", dist, NSLocalizedString(@"km", nil)];
  
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {

        NSNumber* n = [dic valueForKey:STATION_ID];

        if(![Common instance].freeOfSems)
            dispatch_semaphore_wait([Common instance].allowSemaphore, DISPATCH_TIME_FOREVER);
     
        float dist = [[Common instance] calculateDistToStation:n.intValue];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            StationViewCell *updateCell = (id)[tableView cellForRowAtIndexPath:indexPath];
            if (updateCell)
                updateCell.kmLab.text = [NSString stringWithFormat:@"%.1f %@", dist, NSLocalizedString(@"km", nil)];
//            NSLog(@"%d %f", indexPath.row, dist);
//            [tableView reloadData];
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
