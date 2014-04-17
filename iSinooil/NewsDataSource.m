//
//  NewsDataSource.m
//  iSinooil
//
//  Created by вадим on 2/2/14.
//  Copyright (c) 2014 Zul. All rights reserved.
//

#import "NewsDataSource.h"
#import "NewsCell.h"
#import "Common.h"
#import "UIImageView+WebCache.h"

@implementation NewsDataSource

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    int c = [[Common instance] getNewsCount];
//    NSLog(@"-news count = %d", c);
    return c;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *CellIdentifier = @"newsCell";
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary* news = [[Common instance] getNewsAt:indexPath.row];

    if(!indexPath.row) {
    
        cell.time.font = FONT_NEWS_TOPNEWS;
        cell.time.text = NSLocalizedString(@"daynews", nil);
        cell.time.textColor = [UIColor blackColor];
    }
    else {
        
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
        NSNumber* n = [news valueForKey:NEWS_START_DATE];
        NSDate* date = [NSDate dateWithTimeIntervalSince1970:n.longValue];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
//        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setLocale:loc];
        NSString *formattedDateString = [dateFormatter stringFromDate:date];
//        NSLog(@"date = %@   %@", formattedDateString, [[NSLocale currentLocale] localeIdentifier]);
//        NSLog(@"formattedDateString for locale %@: %@", [[dateFormatter locale] localeIdentifier], formattedDateString);

        cell.time.text = formattedDateString;
    }
    
    NSString* pic = [news valueForKey:NEWS_PIC];
    [cell.pic setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"placeholder-icon"]];

    cell.brief.font = FONT_NEWS_BRIEF;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[news valueForKey:NEWS_BRIEF]];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [[news valueForKey:NEWS_BRIEF] length])];
    cell.brief.attributedText = attributedString;
//    cell.brief.text = [news valueForKey:NEWS_BRIEF];
    
    return cell;
}


@end
