//
//  StationDetailViewController.h
//  iSinooil
//
//  Created by Admin on 19.02.14.
//  Copyright (c) 2014 Zul. All rights reserved.
//

#import <UIKit/UIKit.h>

#define GAP_SIZE2 40

@interface StationDetailViewController : UIViewController

- (IBAction)back:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailViewW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailViewH;
@property (weak, nonatomic) IBOutlet UILabel *stationNumberLab;
@property (weak, nonatomic) IBOutlet UILabel *stationDescrLab;
@property (weak, nonatomic) IBOutlet UIView *stationDetailView;

@end
