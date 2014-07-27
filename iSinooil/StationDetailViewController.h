//
//  StationDetailViewController.h
//  iSinooil
//
//  Created by Admin on 19.02.14.
//  Copyright (c) 2014 Zul. All rights reserved.
//

#import <UIKit/UIKit.h>

#define GAP_SIZE2 25
#define GAP_SIZE2_1 29

#define TEXTVIEW_HEIGHT 100

#define anim_delay_keyb1 0.3f

@interface StationDetailViewController : UIViewController <UITextViewDelegate> {
    
    float deltaY;

}

- (IBAction)back:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailViewW;
@property (weak, nonatomic) IBOutlet UILabel *seeOnMapLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailViewH;
@property (weak, nonatomic) IBOutlet UILabel *stationNumberLab;
@property (weak, nonatomic) IBOutlet UILabel *stationDescrLab;
@property (weak, nonatomic) IBOutlet UIView *stationDetailView;
@property (weak, nonatomic) IBOutlet UIButton *backlab;
@property (weak, nonatomic) IBOutlet UILabel *st_name;
@property (weak, nonatomic) IBOutlet UITextView *stationDescrText;
@property (weak, nonatomic) IBOutlet UILabel *st_name1;
@property (weak, nonatomic) IBOutlet UIImageView *pic;
- (IBAction)goMap:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
