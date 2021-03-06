//
//  PricesDataSource.m
//  iSinooil
//
//  Created by Admin on 21.01.14.
//  Copyright (c) 2014 Zul. All rights reserved.
//

#import "PricesDataSource.h"
#import "PriceCell.h"
#import "Common.h"

@implementation PricesDataSource

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    int r = 0;
    for (int i = FUEL_BIT_97; i <= FUEL_BIT_DTW; i = (i << 1)) {
        
        r++;
    }
    
    return r;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
 
    static NSString *CellIdentifier = @"priceCell";
    PriceCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSString* icon = NSLocalizedString(@"AI97", nil);
    switch (indexPath.row) {
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
    
    cell.aiLabel.text = icon;
    cell.aiLabel.font = FONT_NAME_PRICE_LIST;
    
    for(NSDictionary* d in [Common instance].fueljson) {

        NSNumber* n = [d valueForKey:FUEL_BITS];
        if((n.intValue - 1) == indexPath.row) {
            
            NSNumber* cost = [d valueForKey:FUEL_COST];
            cell.priceLabel.text = [NSString stringWithFormat:@"%d", cost.intValue];
            cell.priceLabel.font = FONT_PRICE_LIST;
            break;
        }
    }

    cell.distLabel.text = @"...";
    cell.distLabel.font = FONT_KM_PRICE_LIST;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
        
        if(![Common instance].freeOfSems)
            dispatch_semaphore_wait([Common instance].allowSemaphore, DISPATCH_TIME_FOREVER);

        float dist = [[Common instance] distToNearestStaionWithFuelBit:(indexPath.row + 1) forCell:cell];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            PriceCell *updateCell = (id)[tableView cellForRowAtIndexPath:indexPath];
            if (updateCell) {
//                updateCell.distLabel.text = [NSString stringWithFormat:@"%.1f %@", dist, NSLocalizedString(@"km", nil)];
                switch ([Common instance].metrics) {
                    case M_KM:
                        updateCell.distLabel.text = [NSString stringWithFormat:@"%.1f %@", dist, NSLocalizedString(@"km", nil)];
                        break;
                    case M_MI:
                        updateCell.distLabel.text = [NSString stringWithFormat:@"%.1f %@", dist / KM_IN_MILE, NSLocalizedString(@"miles", nil)];
                        break;
                    case M_MT:
                        updateCell.distLabel.text = [NSString stringWithFormat:@"%.0f %@", dist * 1000, NSLocalizedString(@"metres", nil)];
                        break;
                }
 
            }
        });
        
    });

    return cell;
}

@end
