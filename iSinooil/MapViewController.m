//
//  MapViewController.m
//  iSinooil
//
//  Created by вадим on 12/8/13.
//  Copyright (c) 2013 Zul. All rights reserved.
//

#import "MapViewController.h"
#import "MenuViewController.h"
#import "Common.h"
#import "MapSource.h"
#import "StationListDataSource.h"
#import "MapPoint.h"
#import "StationDetailViewController.h"

@implementation MapViewController

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
//    NSLog(@"will rotate map");
    
    CGSize s = [Common currentScreenBoundsDependOnOrientation:toInterfaceOrientation];
    self.topView.frame = CGRectMake(0, 0, s.width, s.height);
    
//    self.detailViewH.constant = s.height;
//    self.detailViewW.constant = s.width;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    CLLocationCoordinate2D noLocation;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(noLocation, 500, 500);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];

    self.mapsour = [[MapSource alloc] initWithType:MAPTYPE_FULLWINDOW];
    self.mapView.delegate = self.mapsour;
    self.mapsour.mapcontr = self;
    
    self.listsour = [[StationListDataSource alloc] init];
//    self.stationList.delegate = self.listsour;
    self.stationListTable.delegate = self;
    self.stationListTable.dataSource = self.listsour;
    
    [Common instance].mymapview = self.mapView;
    
    UILabel* labelAZS = (UILabel*)[self.topView viewWithTag:TITLELABEL_TAG];
    labelAZS.font = FONT_STD_TOP_MENU;
    
    [[self.listButton titleLabel] setFont:FONT_ABOUT_TOGGLE_BUTTONS];
    [[self.mapButton titleLabel] setFont:FONT_ABOUT_TOGGLE_BUTTONS];

    [self mapTouchDown:self.mapButton];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    NSLog(@"!!! MapViewController didReceiveMemoryWarning");
}

- (IBAction) menu:(id)sender {

    self.view.hidden = NO;
   
    CGRect fr = self.view.frame;
    BOOL b = (fr.origin.x < 1);
    [UIView animateWithDuration:anim_delay delay:0.0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{

                         self.view.frame = CGRectMake(b?(fr.size.width - deltaX):0, fr.origin.y, fr.size.width, fr.size.height);
                         
                     }
                     completion:^(BOOL finished) {
                     }];
    
}

//- (IBAction) pickOne:(id)sender {
//    
//    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
////    NSLog(@"index = %d", segmentedControl.selectedSegmentIndex);
//    
//    switch (segmentedControl.selectedSegmentIndex) {
//        case 0:
//            self.mapView.hidden = NO;
//            self.stationList.hidden = YES;
//            break;
//        case 1:
//            self.mapView.hidden = YES;
//            [self.stationList reloadData];
//            self.stationList.hidden = NO;
//            break;
//    }
//}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(!self.stationDetailView.hidden)
        self.stationDetailView.hidden = YES;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return STATIONCELL_HEIGHT;
}

- (void) showStationDetails {

    StationDetailViewController* detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"stationDetailController"];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (IBAction)mapTouchDown:(UIButton*)button {
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setBackgroundImage: [UIImage imageNamed:@"tab_left_pressed.png"] forState:UIControlStateNormal];

    [self.listButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.listButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [self.listButton setBackgroundImage: [UIImage imageNamed:@"tab_right.png"] forState:UIControlStateNormal];
    
    self.mapView.hidden = NO;
    self.stationListTable.hidden = YES;
}

- (IBAction)listTouchDown:(UIButton*)button {
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setBackgroundImage: [UIImage imageNamed:@"tab_right_pressed.png"] forState:UIControlStateNormal];

    [self.mapButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.mapButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [self.mapButton setBackgroundImage: [UIImage imageNamed:@"tab_left.png"] forState:UIControlStateNormal];

    self.mapView.hidden = YES;
    [self.stationListTable reloadData];
    self.stationListTable.hidden = NO;
}

- (void) showStationWithId:(int)sid {
    
    [self mapTouchDown:self.mapButton];
    for(id<MKAnnotation> mp in self.mapView.annotations) {
        
        if ([mp isKindOfClass:[MapPoint class]])
            if (sid == ((MapPoint*)mp).stationId) {
            
                [self.mapView selectAnnotation:mp animated:YES];
                break;
            }
        }
}

- (void) showDetail:(int)num {

//    selectedRow = num;
    [Common instance].stationRowSelected = num;
    [self showStationDetails];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    selectedRow = indexPath.row;
    [Common instance].stationRowSelected = indexPath.row;
    [self showStationDetails];
}

@end
