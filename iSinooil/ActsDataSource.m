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

    NSLocale *loc = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    switch ([Common instance].lang) {
        case L_ENG:
            loc = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
            break;
        case L_KZ:
            loc = [[NSLocale alloc] initWithLocaleIdentifier:@"kk_KZ"];
            break;
        case L_RU:
            loc = [[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"];
            break;
    }

    cell.time.font = FONT_NEWS_DATE;
    cell.time.textColor = [UIColor grayColor];
    cell.time1.font = FONT_NEWS_DATE;
    cell.time1.textColor = [UIColor grayColor];
    NSNumber* n = [act valueForKey:NEWS_START_DATE];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:n.longValue];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
//    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setLocale:loc];
    NSString *formattedDateString = [dateFormatter stringFromDate:date];
    n = [act valueForKey:NEWS_END_DATE];
    date = [NSDate dateWithTimeIntervalSince1970:n.longValue];
    NSString *formattedDateString1 = [dateFormatter stringFromDate:date];
//    cell.time.text = [NSString stringWithFormat:@"%@ - %@", formattedDateString, formattedDateString1];
    cell.time.text = [NSString stringWithFormat:@"%@ -", formattedDateString];
    cell.time1.text = [NSString stringWithFormat:@"%@", formattedDateString1];


    NSString* pic = [act valueForKey:NEWS_PIC];
    [cell.pic setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"placeholder-icon"]];
    
    cell.brief.font = FONT_NEWS_BRIEF;

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[act valueForKey:NEWS_BRIEF]];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [[act valueForKey:NEWS_BRIEF] length])];
    cell.brief.attributedText = attributedString;

    //    cell.brief.text = [act valueForKey:NEWS_BRIEF];
    
    return cell;
}

@end
