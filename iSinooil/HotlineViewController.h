//
//  HotlineViewController.h
//  iSinooil
//
//  Created by вадим on 3/2/14.
//  Copyright (c) 2014 Zul. All rights reserved.
//

#import <UIKit/UIKit.h>

#define anim_delay_keyb 0.3f

@interface HotlineViewController : UIViewController <UITextFieldDelegate> {
    
    float deltaY;
}

- (IBAction)call:(UIButton*)button;

@property (weak, nonatomic) IBOutlet UIView *topView;
- (IBAction)toMenu:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *callButton;

@property (weak, nonatomic) IBOutlet UILabel *politeLabel;
@property (weak, nonatomic) IBOutlet UITextField *msgField;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIView *msgView;
@property (weak, nonatomic) IBOutlet UIView *msgInnerView;
@property (weak, nonatomic) IBOutlet UIView *msgFrameView;
@end
