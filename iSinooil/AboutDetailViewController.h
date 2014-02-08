//
//  AboutDetailViewController.h
//  iSinooil
//
//  Created by вадим on 2/8/14.
//  Copyright (c) 2014 Zul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class BranchesDataSource;

@interface AboutDetailViewController : UIViewController <UITableViewDelegate>

- (IBAction)back:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *centralLabel;
@property (weak, nonatomic) IBOutlet UILabel *addrLabel;
- (IBAction)callOffice:(id)sender;
@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (weak, nonatomic) IBOutlet UIButton *officeButton;
@property (weak, nonatomic) IBOutlet UIButton *branchesButton;
- (IBAction)officeButtonDown:(UIButton*)button;
- (IBAction)branchesButtonDown:(UIButton*)button;
@property (weak, nonatomic) IBOutlet UIView *branchesView;
@property (weak, nonatomic) IBOutlet UIView *centralOfficeView;
@property (weak, nonatomic) IBOutlet UITableView *branchesTableView;

@property (nonatomic, strong) BranchesDataSource* brsour;

@end
