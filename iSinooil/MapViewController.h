//
//  MapViewController.h
//  iSinooil
//
//  Created by вадим on 12/8/13.
//  Copyright (c) 2013 Zul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class MapSource;
@class StationListDataSource;

@interface MapViewController : UIViewController <UITableViewDelegate> {
    
    long selectedRow;
}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (nonatomic, strong) MapSource* mapsour;
@property (nonatomic, strong) StationListDataSource* listsour;
@property (weak, nonatomic) IBOutlet UIView *stationDetailView;
@property (weak, nonatomic) IBOutlet UILabel *stationNumberLab;
@property (weak, nonatomic) IBOutlet UILabel *stationDescrLab;
@property (weak, nonatomic) IBOutlet UITableView *stationList;
- (IBAction)mapTouchDown:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *mapButton;
- (IBAction)listTouchDown:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *listButton;


- (void) showDetail:(int)num;

//- (IBAction) pickOne:(id)sender;

- (IBAction) menu:(id)sender;

@end
