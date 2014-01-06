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
@class ListDataSource;

@interface MapViewController : UIViewController 

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (nonatomic, strong) MapSource* mapsour;
@property (nonatomic, strong) ListDataSource* listsour;

@property (weak, nonatomic) IBOutlet UITableView *stationList;
- (IBAction) pickOne:(id)sender;

- (IBAction) menu:(id)sender;

@end
