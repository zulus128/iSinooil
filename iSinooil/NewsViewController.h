//
//  NewsViewController.h
//  iSinooil
//
//  Created by вадим on 2/2/14.
//  Copyright (c) 2014 Zul. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewsDataSource;

@interface NewsViewController : UIViewController <UITableViewDelegate>

- (IBAction)toMenu:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *newsTable;

@property (nonatomic, strong) NewsDataSource* newssour;

@end
