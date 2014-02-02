//
//  NewsDetailViewController.h
//  iSinooil
//
//  Created by вадим on 2/2/14.
//  Copyright (c) 2014 Zul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsDetailViewController : UIViewController

@property (nonatomic, strong) NSDictionary* news;

- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *date;

@end
