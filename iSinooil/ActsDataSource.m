//
//  ActsDataSource.m
//  iSinooil
//
//  Created by Admin on 05.02.14.
//  Copyright (c) 2014 Zul. All rights reserved.
//

#import "ActsDataSource.h"
#import "Common.h"
#import "ActCell.h"
#import "UIImageView+WebCache.h"

@implementation ActsDataSource

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    int c = [[Common instance] getActsCount];
    return c;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *CellIdentifier = @"actsCell";
    ActCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary* act = [[Common instance] getActAt:indexPath.row];
    
    cell.time.font = FONT_NEWS_DATE;
    cell.time.textColor = [UIColor grayColor];
    NSNumber* n = [act valueForKey:NEWS_START_DATE];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:n.longValue];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    NSString *formattedDateString = [dateFormatter stringFromDate:date];
    n = [act valueForKey:NEWS_END_DATE];
    date = [NSDate dateWithTimeIntervalSince1970:n.longValue];
    NSString *formattedDateString1 = [dateFormatter stringFromDate:date];
    cell.time.text = [NSString stringWithFormat:@"%@ - %@", formattedDateString, formattedDateString1];


    NSString* pic = [act valueForKey:NEWS_PIC];
    [cell.pic setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"placeholder-icon"]];
    
    cell.brief.font = FONT_NEWS_BRIEF;
    cell.brief.text = [act valueForKey:NEWS_BRIEF];
    
    return cell;
}

@end