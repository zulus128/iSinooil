//
//  HotlineViewController.h
//  iSinooil
//
//  Created by вадим on 3/2/14.
//  Copyright (c) 2014 Zul. All rights reserved.
//

#import <UIKit/UIKit.h>

#define anim_delay_keyb 0.3f

#define X_GAP 40
#define TEXT_GAP_X 10
#define Y_GAP 15
#define X_LEFT 25
#define Y_BETWEEN_BUBBLES 5

@interface HotlineViewController : UIViewController <UITextFieldDelegate> {
    
    float deltaY;
    float Y;
//    CGSize s;
}

- (void) recvMsg;
- (IBAction)call:(UIButton*)button;
- (IBAction)toMenu:(id)sender;
- (IBAction)sendButtonPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UILabel *politeLabel;
@property (weak, nonatomic) IBOutlet UITextField *msgField;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIView *msgView;
@property (weak, nonatomic) IBOutlet UIView *msgInnerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewW;
@property (weak, nonatomic) IBOutlet UIView *msgFrameView;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewH;
@property (assign, readwrite) BOOL timer;
@property (weak, nonatomic) IBOutlet UIView *chatView;

@end
