//
//  SettingsViewController.h
//  iSinooil
//
//  Created by вадим on 2/8/14.
//  Copyright (c) 2014 Zul. All rights reserved.
//

#import <UIKit/UIKit.h>

#define POPUP_TAG 777
#define POPUPBUTTON_HEIGHT 35
#define POPUP_WIDTH 80

@class SettingsDataSource;

@interface SettingsViewController : UIViewController <UITableViewDelegate> {
    
    int selectedRow;
}

- (IBAction)toMenu:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (nonatomic, strong) SettingsDataSource* setsour;
@property (weak, nonatomic) IBOutlet UITableView *settTableView;

@end
