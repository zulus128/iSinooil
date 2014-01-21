//
//  PricesDataSource.m
//  iSinooil
//
//  Created by Admin on 21.01.14.
//  Copyright (c) 2014 Zul. All rights reserved.
//

#import "PricesDataSource.h"

@implementation PricesDataSource

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    int r = 0;
    for (int i = FUEL_BIT_97; i <= FUEL_BIT_GAS; i = (i << 1)) {
        
        r++;
    }
    
    return r;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
 
    static NSString *CellIdentifier = @"priceCell";
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    StationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    return cell;
}

@end
