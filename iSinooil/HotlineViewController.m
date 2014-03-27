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

- (void) viewDidAppear:(BOOL)animated {
    
//    CGSize s = [Common currentScreenBounds];
//    self.contentViewW.constant = s.width;
    self.contentViewH.constant = self.scroll.frame.size.height;
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {

    CGSize s = [Common currentScreenBoundsDependOnOrientation:toInterfaceOrientation];
    self.view.frame = CGRectMake(0, 0, s.width, s.height);
    self.contentViewW.constant = s.width;
//    self.contentViewH.constant = s.height;

//    [self refresh];
    [Common instance].lastMsg = 0;
    for(UIView* v in self.chatView.subviews)
        [v removeFromSuperview];
    Y = 0;
}

- (void) refresh {
    
    UILabel* labelPrices = (UILabel*)[self.topView viewWithTag:TITLELABEL_TAG];
    labelPrices.font = FONT_STD_TOP_MENU;
    labelPrices.text = NSLocalizedString(@"Hotline", nil);
    [self.callButton setTitle:NSLocalizedString(@"Call", nil) forState:UIControlStateNormal];
    self.politeLabel.text = NSLocalizedString(@"polite", nil);
    self.msgField.placeholder = NSLocalizedString(@"YourMsg", nil);
    [self.sendButton setTitle:NSLocalizedString(@"Send", nil) forState:UIControlStateNormal];
    
    CGSize s = [Common currentScreenBounds];
    self.contentViewW.constant = s.width;
//    self.contentViewH.constant = self.scroll.frame.size.height;
//    NSLog(@"h = %f", self.contentViewH.constant);


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
    
    if(b)
        [self.msgField resignFirstResponder];
    
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

//    [self sendMsg:textField.text];
    
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
    
    self.msgField.text = @"";
    
    [self recvMsg];
    
}

- (void) recvMsg {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(recvMsg) object:nil];

//    NSLog(@"recvMsg");
    NSArray* dict = [[Common instance] recvMessage];
    
    CGSize s = [Common currentScreenBounds];
    CGSize maximumLabelSize = CGSizeMake(s.width - X_GAP - X_LEFT - TEXT_GAP_X * 2, 1000);
    
    BOOL b = NO;
//    for (NSDictionary* d in dict) {
    for (long i = (dict.count - 1); i >=0; i--) {
        
        NSDictionary* d = [dict objectAtIndex:i];
        NSNumber* t = [d valueForKey:CHAT_TIME];
        NSDate* dat = [NSDate dateWithTimeIntervalSince1970:t.doubleValue / 1000];
        NSDateFormatter *formatter = [NSDateFormatter new];
        [formatter setDateFormat:@"hh:mm"];
        NSString *timeString = [formatter stringFromDate:dat];
        
        Y += Y_BETWEEN_BUBBLES;
        b = YES;
        
        NSString* message = [d valueForKey:CHAT_MESSAGE];
        CGSize expectedLabelSize = [message sizeWithFont:FONT_CHAT_MSG constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
        
        NSNumber* dir = [d valueForKey:CHAT_DIRECTION];
        if(dir.intValue) {
        
            UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, Y, s.width, expectedLabelSize.height + 2 * Y_GAP)];
            UIImageView* iv = [[UIImageView alloc] initWithFrame:CGRectMake(X_LEFT, 0, s.width - X_GAP - X_LEFT - TEXT_GAP_X * 2, expectedLabelSize.height + 2 * Y_GAP)];
            iv.image = [UIImage imageNamed:@"bubble_light.png"];
            [v addSubview:iv];
            UIImageView* iv1 = [[UIImageView alloc] initWithFrame:CGRectMake(X_LEFT - 11, v.frame.size.height - 12 - 10, 12, 12)];
            iv1.image = [UIImage imageNamed:@"bubble_ligth_tail.png"];
            [v addSubview:iv1];
            UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(X_LEFT + TEXT_GAP_X, v.frame.size.height / 2 - expectedLabelSize.height / 2, expectedLabelSize.width, expectedLabelSize.height + 2)];
            lab.font = FONT_CHAT_MSG;
            lab.textColor = [UIColor blackColor];
            lab.numberOfLines = 0;
            lab.text = message;
            [v addSubview:lab];
            UILabel* labt = [[UILabel alloc]initWithFrame:CGRectMake(s.width - X_GAP - TEXT_GAP_X * 2, v.frame.size.height / 2 - expectedLabelSize.height / 2, X_GAP + TEXT_GAP_X * 2, expectedLabelSize.height + 2)];
            labt.font = FONT_CHAT_MSG;
            labt.textAlignment = NSTextAlignmentCenter;
            labt.textColor = [UIColor grayColor];
            labt.text = timeString;
            [v addSubview:labt];
            [self.chatView addSubview:v];
        }
        else {

            UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, Y, s.width, expectedLabelSize.height + 2 * Y_GAP)];
            float w = s.width - X_GAP - X_LEFT - TEXT_GAP_X * 2;
            UIImageView* iv = [[UIImageView alloc] initWithFrame:CGRectMake(s.width - X_LEFT - w, 0, w, expectedLabelSize.height + 2 * Y_GAP)];
            iv.image = [UIImage imageNamed:@"bubble_dark.png"];
            [v addSubview:iv];
            UIImageView* iv1 = [[UIImageView alloc] initWithFrame:CGRectMake(s.width - X_LEFT - 1, v.frame.size.height - 12 - 10, 12, 12)];
            iv1.image = [UIImage imageNamed:@"bubble_dark_tail.png"];
            [v addSubview:iv1];
            UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(s.width - X_LEFT - w + TEXT_GAP_X, v.frame.size.height / 2 - expectedLabelSize.height / 2, expectedLabelSize.width, expectedLabelSize.height + 2)];
            lab.font = FONT_CHAT_MSG;
            lab.textColor = [UIColor whiteColor];
            lab.numberOfLines = 0;
            lab.text = message;
            [v addSubview:lab];
            UILabel* labt = [[UILabel alloc]initWithFrame:CGRectMake(0, v.frame.size.height / 2 - expectedLabelSize.height / 2, s.width - X_LEFT - w, expectedLabelSize.height + 2)];
            labt.font = FONT_CHAT_MSG;
            labt.textAlignment = NSTextAlignmentCenter;
            labt.textColor = [UIColor grayColor];
            labt.text = timeString;
            [v addSubview:labt];
            [self.chatView addSubview:v];

        }
        
        Y += expectedLabelSize.height + 2 * Y_GAP;
        
        self.contentViewH.constant = (Y > self.scroll.frame.size.height)?Y:self.contentViewH.constant;
//        NSLog(@"h = %f", self.contentViewH.constant);
    }
    if(b) {

        [self performSelector:@selector(scrollIt) withObject:nil afterDelay:.1f];

    }
    
    if(self.timer)
        [self performSelector:@selector(recvMsg) withObject:nil afterDelay:2.0f];
    
}

- (void) scrollIt {

    CGPoint bottomOffset = CGPointMake(0, self.scroll.contentSize.height - self.scroll.bounds.size.height);
    [self.scroll setContentOffset:bottomOffset animated:YES];

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
