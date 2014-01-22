//
//  PriceCell.h
//  iSinooil
//
//  Created by Admin on 21.01.14.
//  Copyright (c) 2014 Zul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface PriceCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *aiLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *distLabel;

@property (assign, readwrite) int stationId;

@end
