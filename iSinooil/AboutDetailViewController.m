//
//  AboutDetailViewController.m
//  iSinooil
//
//  Created by вадим on 2/8/14.
//  Copyright (c) 2014 Zul. All rights reserved.
//

#import "AboutDetailViewController.h"
#import "MapPoint.h"
#import "BranchesDataSource.h"

@implementation AboutDetailViewController

- (void) refresh {
    
    NSDictionary* branch = [[Common instance] getBranchWithId:self.selectedBrunch];

    UILabel* labelPrices = (UILabel*)[self.topView viewWithTag:TITLELABEL_TAG];
    labelPrices.font = FONT_STD_TOP_MENU;
    labelPrices.text = NSLocalizedString(@"Contacts", nil);
//    self.centralLabel.text = NSLocalizedString(@"centraloffice", nil);
    self.centralLabel.text = [branch valueForKey:ABOUT_TTL];
//    self.addrLabel.text = NSLocalizedString(@"officeaddr", nil);
    self.addrLabel.text = [branch valueForKey:ABOUT_ADDRESS];

    [self.callButton setTitle:[branch valueForKey:ABOUT_PHONE] forState:UIControlStateNormal];

    [self.labout setTitle:NSLocalizedString(@"About", nil) forState:UIControlStateNormal];
    [self.officeButton setTitle:NSLocalizedString(@"OfficeButton", nil) forState:UIControlStateNormal];
    [self.branchesButton setTitle:NSLocalizedString(@"Branches", nil) forState:UIControlStateNormal];

    NSNumber* n = [branch valueForKey:ABOUT_LAT];
    CLLocationDegrees lat = n.doubleValue;
    n = [branch valueForKey:ABOUT_LON];
    CLLocationDegrees lon = n.doubleValue;
    CLLocationCoordinate2D officeLoc = { lat, lon };
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(officeLoc, 1500, 1500);
    MKCoordinateRegion adjustedRegion = [self.map regionThatFits:viewRegion];
    [self.map setRegion:adjustedRegion animated:YES];

    [self.map removeAnnotations:[self.map annotations]];
    MapPoint *mp = [[MapPoint alloc] initWithCoordinate:officeLoc title:@"SINOOIL" subTitle:[branch valueForKey:ABOUT_TTL]];
	[self.map addAnnotation:mp];

}

- (void) viewWillAppear:(BOOL)animated {
    
    [self refresh];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.centralLabel.font = FONT_ABOUT_CENTRALOFFICE;
    self.addrLabel.font = FONT_ABOUT_ADDR;
    [self.centralLabel setTextColor:COLOR_ABOUT_CENTRALOFFICE];
    [[self.callButton titleLabel] setFont:FONT_ABOUT_CALLOFFICE];
    [[self.officeButton titleLabel] setFont:FONT_ABOUT_TOGGLE_BUTTONS];
    [[self.branchesButton titleLabel] setFont:FONT_ABOUT_TOGGLE_BUTTONS];

    self.map.userTrackingMode = MKUserTrackingModeNone;
//    CLLocationCoordinate2D officeLoc = { 43.27143, 76.95885 };
//    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(officeLoc, 1500, 1500);
//    MKCoordinateRegion adjustedRegion = [self.map regionThatFits:viewRegion];
//    [self.map setRegion:adjustedRegion animated:YES];
//    
//    MapPoint *mp = [[MapPoint alloc] initWithCoordinate:officeLoc title:@"SINOOIL" subTitle:NSLocalizedString(@"centraloffice", nil)];
//	[self.map addAnnotation:mp];

    [self officeButtonDown:self.officeButton];

    self.brsour = [[BranchesDataSource alloc] init];
    self.branchesTableView.dataSource = self.brsour;
    self.branchesTableView.delegate = self;

    [self refresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)callOffice:(id)sender {
    
    NSDictionary* branch = [[Common instance] getBranchWithId:self.selectedBrunch];
    NSString* tel1 = [branch valueForKey:ABOUT_PHONE];
    NSCharacterSet *notAllowedChars = [NSCharacterSet characterSetWithCharactersInString:@" ()-"];
    NSArray* arr = [tel1 componentsSeparatedByCharactersInSet:notAllowedChars];
    NSString *tel = [arr componentsJoinedByString:@""];
//    NSLog(@"%@, %@", tel1, tel);
    NSString *phoneNumber = [@"telprompt://" stringByAppendingString:tel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];

}

- (IBAction)officeButtonDown:(UIButton*)button {

    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setBackgroundImage: [UIImage imageNamed:@"tab_left_pressed.png"] forState:UIControlStateNormal];
    
    [self.branchesButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.branchesButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [self.branchesButton setBackgroundImage: [UIImage imageNamed:@"tab_right.png"] forState:UIControlStateNormal];
    
    self.centralOfficeView.hidden = NO;
    self.branchesView.hidden = YES;
    
    self.selectedBrunch = 1;
    [self refresh];
}

- (IBAction)branchesButtonDown:(UIButton*)button{
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setBackgroundImage: [UIImage imageNamed:@"tab_right_pressed.png"] forState:UIControlStateNormal];
    
    [self.officeButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.officeButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [self.officeButton setBackgroundImage: [UIImage imageNamed:@"tab_left.png"] forState:UIControlStateNormal];

    self.centralOfficeView.hidden = YES;
    self.branchesView.hidden = NO;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return BRANCHCELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary* branch = [[Common instance] getBranchAt:indexPath.row];
    NSNumber* n = [branch valueForKey:ABOUT_ID];
    self.selectedBrunch = n.intValue;
//    [self officeButtonDown:self.officeButton];
    
    self.centralOfficeView.hidden = NO;
    self.branchesView.hidden = YES;
    
    [self refresh];
}

@end
