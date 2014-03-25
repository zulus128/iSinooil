//
//  HotlineViewController.m
//  iSinooil
//
//  Created by вадим on 3/2/14.
//  Copyright (c) 2014 Zul. All rights reserved.
//

#import "HotlineViewController.h"

@implementation HotlineViewController

- (void) viewWillAppear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
//    timer = YES;
    [self recvMsg];
}

- (void) viewDidDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.timer = NO;
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    CGSize s = [Common currentScreenBoundsDependOnOrientation:toInterfaceOrientation];
    self.view.frame = CGRectMake(0, 0, s.width, s.height);
    
    self.contentViewW.constant = s.width;

}

- (void) refresh {
    
    UILabel* labelPrices = (UILabel*)[self.topView viewWithTag:TITLELABEL_TAG];
    labelPrices.font = FONT_STD_TOP_MENU;
    labelPrices.text = NSLocalizedString(@"Hotline", nil);
    [self.callButton setTitle:NSLocalizedString(@"Call", nil) forState:UIControlStateNormal];
    self.politeLabel.text = NSLocalizedString(@"polite", nil);
    self.msgField.placeholder = NSLocalizedString(@"YourMsg", nil);
    [self.sendButton setTitle:NSLocalizedString(@"Send", nil) forState:UIControlStateNormal];
}

- (IBAction)toMenu:(id)sender {
    
    self.view.hidden = NO;
    
    CGRect fr = self.view.frame;
    BOOL b = (fr.origin.x < 1);
    [UIView animateWithDuration:anim_delay delay:0.0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         self.view.frame = CGRectMake(b?(fr.size.width - deltaX):0, fr.origin.y, fr.size.width, fr.size.height);
                         
                     }
                     completion:^(BOOL finished) {
                     }];
    self.timer = !b;
    [self recvMsg];

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.msgView.layer.cornerRadius = 5;
    self.msgView.layer.masksToBounds = YES;
    self.msgInnerView.layer.cornerRadius = 5;
    self.msgInnerView.layer.masksToBounds = YES;
    self.sendButton.layer.cornerRadius = 5;
    self.sendButton.layer.masksToBounds = YES;
    self.politeLabel.font = FONT_HOTLINE_LABEL;
    [[self.sendButton titleLabel] setFont:FONT_HOTLINE_LABEL];
    [[self.callButton titleLabel] setFont:FONT_HOTLINE_LABEL];
    self.msgField.font = FONT_HOTLINE_LABEL;

    [self refresh];

}

- (IBAction)call:(UIButton*)button {

    NSString *phoneNumber = [@"telprompt://" stringByAppendingString:@"+7 800 0700180"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//
//    CGRect f = self.msgFrameView.frame;
//    [UIView animateWithDuration:anim_delay delay:0.0 options:UIViewAnimationOptionCurveEaseOut
//                     animations:^{
//                         
//                         self.msgFrameView.frame = CGRectMake(f.origin.x, f.origin.y - 215, f.size.width, f.size.height);
//                         
//                     }
//                     completion:^(BOOL finished) {
//                     }];
//    return YES;
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [self sendMsg:textField.text];
    
    [textField resignFirstResponder];
    return YES;
}

- (void) keyboardHide:(NSNotification*)notification {

    CGRect f = self.msgFrameView.frame;
    [UIView animateWithDuration:anim_delay_keyb delay:0.0 options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         self.msgFrameView.frame = CGRectMake(f.origin.x, f.origin.y + deltaY, f.size.width, f.size.height);
                         
                     }
                     completion:^(BOOL finished) {
                     }];
}

- (void) keyboardShow:(NSNotification*)notification {
    
    CGRect keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    NSLog(@"keyboard frame raw %@", NSStringFromCGRect(keyboardFrame));
    
    UIWindow *window = [[[UIApplication sharedApplication] windows]objectAtIndex:0];
    UIView *mainSubviewOfWindow = window.rootViewController.view;
    CGRect keyboardFrameConverted = [mainSubviewOfWindow convertRect:keyboardFrame fromView:window];
//    NSLog(@"keyboard frame converted %@", NSStringFromCGRect(keyboardFrameConverted));
    deltaY = keyboardFrameConverted.size.height;
    
    CGRect f = self.msgFrameView.frame;
    [UIView animateWithDuration:anim_delay_keyb delay:0.0 options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         self.msgFrameView.frame = CGRectMake(f.origin.x, f.origin.y - deltaY, f.size.width, f.size.height);
                         
                     }
                     completion:^(BOOL finished) {
                     }];

}

- (void) sendMsg:(NSString*) msg {
    
    if(!msg)
        return;
    if(!msg.length)
        return;
    
    [[Common instance] sendMessage:msg];
    
    [self recvMsg];
    
}

- (void) recvMsg {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(recvMsg) object:nil];

    NSLog(@"recvMsg");
    NSDictionary* dict = [[Common instance] recvMessage];
    
    if(self.timer)
        [self performSelector:@selector(recvMsg) withObject:nil afterDelay:2.0f];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendButtonPressed:(id)sender {

    [self sendMsg:self.msgField.text];
    [self.msgField resignFirstResponder];

}

@end
