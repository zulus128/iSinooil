//
//  MapViewController.h
//  iSinooil
//
//  Created by вадим on 12/8/13.
//  Copyright (c) 2013 Zul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#define GAP_SIZE3 35

#define POPUP_TAG 778
#define POPUPBUTTON_HEIGHT 25
#define POPUP_WIDTH 160

@class MapSource;
@class StationListDataSource;

@interface MapViewController : UIViewController <UITableViewDelegate> {
    
//    long selectedRow;

}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (nonatomic, strong) MapSource* mapsour;
@property (nonatomic, strong) StationListDataSource* listsour;
@property (weak, nonatomic) IBOutlet UIView *stationDetailView;
@property (weak, nonatomic) IBOutlet UILabel *stationNumberLab;
@property (weak, nonatomic) IBOutlet UILabel *stationDescrLab;
@property (weak, nonatomic) IBOutlet UITableView *stationListTable;
- (IBAction)mapTouchDown:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *mapButton;
- (IBAction)listTouchDown:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *listButton;
@property (weak, nonatomic) IBOutlet UILabel *dropdown;
- (IBAction)goPopup:(id)sender;

- (void) showDetail:(int)num;

- (void) showStationWithId:(int)sid;

//- (IBAction) pickOne:(id)sender;

- (IBAction) menu:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *filterView;

@end
