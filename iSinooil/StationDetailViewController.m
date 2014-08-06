//
//  StationDetailViewController.m
//  iSinooil
//
//  Created by Admin on 19.02.14.
//  Copyright (c) 2014 Zul. All rights reserved.
//

#import "StationDetailViewController.h"
#import "UIImageView+WebCache.h"
#import <MessageUI/MessageUI.h>

@implementation StationDetailViewController

- (void) viewWillAppear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void) viewDidDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    [self refresh];
}

- (void) refresh {

    NSDictionary* dic = [[Common instance].azsjson objectAtIndex:[Common instance].stationRowSelected];
//    NSDictionary* dic = [[Common instance].sortedazsjson objectAtIndex:[Common instance].stationRowSelected];
    NSString* ppic = [dic objectForKey:STATION_PIC];
    
//    NSLog(@"dic = %@", dic);
    
    [self.pic setImageWithURL:[NSURL URLWithString:ppic] placeholderImage:[UIImage imageNamed:@"placeholder-icon"]];

    [self.backlab setTitle:NSLocalizedString(@"StationList", nil) forState:UIControlStateNormal];

    CGSize s = [Common currentScreenBounds];
    self.detailViewW.constant = s.width;

//    NSDictionary* dic = [[Common instance].azsjson objectAtIndex:[Common instance].stationRowSelected];
    NSString* num = [[NSLocalizedString(@"AZS", nil) stringByAppendingString:@" "] stringByAppendingString:[dic objectForKey:STATION_TITLE]];
    NSString* num1 = [dic objectForKey:STATION_TITLE];
    self.stationNumberLab.text = num1;//[[num componentsSeparatedByString:@"№"] objectAtIndex:1];
//    self.stationDescrLab.text = [dic objectForKey:STATION_DESCR];

//    self.stationDescrLab.text = [dic objectForKey:STATION_ADDR];
    self.stationDescrText.text = [dic objectForKey:STATION_ADDR];
    
    self.seeOnMapLab.text = NSLocalizedString(@"SeeOnMap", nil);

    self.st_name1.text = NSLocalizedString(@"AZS", nil);//[[num componentsSeparatedByString:@"№"] objectAtIndex:0];
    self.st_name.text = num;
    
//    NSLog(@"station = %@", dic);
    
    for (UIView* v in self.stationDetailView.subviews) {
        if(v.tag >= ICON_TAG)
            [v removeFromSuperview];
    }
    
    float y = 160;
    
    int fuel = ((NSNumber*)[dic valueForKey:STATION_FUEL]).intValue;
    //    NSLog(@"fuel = %d", fuel);
    float x = 12;
    y += 10;
    
    for (int i = FUEL_BIT_97; i <= FUEL_BIT_DTW; i = (i << 1)) {
        
        if (!(fuel & i))
            continue;
        
        NSString* icon = @"icon_97_inactive.png";
        switch (i) {
            case FUEL_BIT_97:
                icon = @"icon_97_inactive.png";
                break;
            case FUEL_BIT_96:
                icon = @"icon_96_inactive.png";
                break;
            case FUEL_BIT_93:
                icon = @"icon_93_inactive.png";
                break;
            case FUEL_BIT_92:
                icon = @"icon_92_inactive.png";
                break;
            case FUEL_BIT_80:
                icon = @"icon_80_inactive.png";
                break;
            case FUEL_BIT_DT:
                icon = @"icon_diesel_inactive.png";
                break;
            case FUEL_BIT_GAS:
                icon = @"icon_dieselw_inactive.png";
                break;
            case FUEL_BIT_DTW:
                icon = @"icon_dieselw_inactive.png";
                break;
        }
        
        UIImageView* iv = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, ICON_SIZE, ICON_SIZE)];
        iv.image = [UIImage imageNamed:icon];
        iv.tag = ICON_TAG;
        [self.stationDetailView addSubview:iv];
        
        x += GAP_SIZE2;
        if(x >= (s.width - 20)) {
            x = 20;
            y += 40;
        }

    }
    
//    x = 20;
//    y += 40;
    int serv = ((NSNumber*)[dic valueForKey:STATION_SERV]).intValue;
    //    NSLog(@"serv = %d", serv);
    for (int i = SERV_BIT_MARKET; i <= SERV_BIT_WHEEL; i = (i << 1)) {
        
        if (!(serv & i))
            continue;
        
        NSString* icon = @"icon_market_inactive.png";
        switch (i) {
            case SERV_BIT_MARKET:
                icon = @"icon_market_inactive.png";
                break;
            case SERV_BIT_CAFE:
                icon = @"icon_cafe_inactive.png";
                break;
            case SERV_BIT_TERM:
                icon = @"icon_terminal_inactive.png";
                break;
            case SERV_BIT_ATM:
                icon = @"icon_atm_inactive.png";
                break;
            case SERV_BIT_WASH:
                icon = @"icon_wash_inactive.png";
                break;
            case SERV_BIT_STO:
                icon = @"icon_service_inactive.png";
                break;
            case SERV_BIT_OIL:
                icon = @"icon_oil_inactive.png";
                break;
            case SERV_BIT_WHEEL:
                icon = @"icon_wheel_inactive.png";
                break;
        }
        
        UIImageView* iv = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, ICON_SIZE, ICON_SIZE)];
        iv.image = [UIImage imageNamed:icon];
        iv.tag = ICON_TAG;
        [self.stationDetailView addSubview:iv];
        
        x += GAP_SIZE2_1;
        if(x >= (s.width - 20)) {
            x = 20;
            y += 40;
        }
    }
    
//    x = 20;
//    y += 40;
    int card = ((NSNumber*)[dic valueForKey:STATION_CARD]).intValue;
    //    NSLog(@"card = %d", card);
    for (int i = CARD_BIT_VISA; i <= CARD_BIT_MC; i = (i << 1)) {
        
        if (!(card & i))
            continue;
        
        NSString* icon = @"icon_visa_inactive.png";
        switch (i) {
            case CARD_BIT_VISA:
                icon = @"icon_visa_inactive.png";
                break;
            case CARD_BIT_AE:
                icon = @"icon_amer_inactive.png";
                break;
            case CARD_BIT_MC:
                icon = @"icon_master_inactive.png";
                break;
        }
        
        UIImageView* iv = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, ICON_SIZE, ICON_SIZE)];
        iv.image = [UIImage imageNamed:icon];
        iv.tag = ICON_TAG;
        [self.stationDetailView addSubview:iv];
        
        x += GAP_SIZE2_1;
        if(x >= (s.width - 20)) {
            x = 20;
            y += 40;
        }
    }

    y += 80;

    NSArray* tels = [dic objectForKey:STATION_PHONE];
    for (int i = 0; i < tels.count; i++) {

        //        NSDictionary* d = [tels objectAtIndex:i];
        //        NSString* tel = [d objectForKey:PHONE_NUMBER];

        NSString* tel = (NSString*)[tels objectAtIndex:i];
//        UILabel* number = [[UILabel alloc] initWithFrame:CGRectMake(20, y, 150, 40)];
//        number.text = tel;
//        number.tag = ICON_TAG;
//        [self.stationDetailView addSubview:number];

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(callTel:) forControlEvents:UIControlEventTouchDown];
        [button setTitle:tel forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.frame = CGRectMake(20, y, 281, 60);
        button.tag = ICON_TAG + i;
        [button setImage:[UIImage imageNamed:@"icon_call.png"] forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -50, 0, 0);
        [button setBackgroundImage:[UIImage imageNamed:@"button2.png"] forState:UIControlStateNormal];
        [self.stationDetailView addSubview:button];
        
        y += 70;
    }

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(callBack:) forControlEvents:UIControlEventTouchDown];
    [button setTitle:NSLocalizedString(@"Feedback", nil) forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(20, y, 281, 60);
    button.tag = ICON_TAG;
    [button setImage:[UIImage imageNamed:@"icon_feedback.png"] forState:UIControlStateNormal];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, ([Common instance].lang == L_KZ)?-25:-50, 0, 0);
    [button setBackgroundImage:[UIImage imageNamed:@"button1.png"] forState:UIControlStateNormal];
    [self.stationDetailView addSubview:button];

    y += 60;
    
    self.detailViewH.constant = y;
}

- (void)callBack:(UIButton*)button {
    
//    if ([MFMailComposeViewController canSendMail]){
//        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
//        controller.mailComposeDelegate = self;
//        [controller setToRecipients:[NSArray arrayWithObject:CALLBACK_EMAIL]];
//        [self presentViewController:controller animated:YES completion:nil];
//    }
//    else{
//        UIAlertView *anAlert = [[UIAlertView alloc] initWithTitle:@"error" message:@"No mail account setup on device" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
//        [anAlert addButtonWithTitle:@"Cancel"];
//        [anAlert show];
//    }
    
    UITextView *myTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, button.frame.origin.y + 70, 281, TEXTVIEW_HEIGHT)];
//    myTextView.text = @"";
    myTextView.editable = YES;
    myTextView.tag = TAG_TO_DEL;
    myTextView.delegate = self;
    myTextView.userInteractionEnabled = YES;
    myTextView.backgroundColor = [UIColor lightGrayColor];
    myTextView.layer.cornerRadius = CORNER_RADIUS;
    myTextView.layer.masksToBounds = YES;

    //some other setup like setting the font for the UITextView...
    [self.stationDetailView addSubview:myTextView];
//    [myTextView sizeToFit];
    [myTextView becomeFirstResponder];
    
//    CGRect f = self.stationDetailView.frame;
//    self.stationDetailView.frame = CGRectMake(f.origin.x, f.origin.y + 70 + TEXTVIEW_HEIGHT, f.size.width, f.size.height);

    self.detailViewH.constant = self.detailViewH.constant + 70 + TEXTVIEW_HEIGHT;

    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

//- (void)mailComposeController:(MFMailComposeViewController*)controller    didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
//{
//    switch (result)
//    {
//        case MFMailComposeResultCancelled:
//            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
//            break;
//        case MFMailComposeResultSaved:
//            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
//            break;
//        case MFMailComposeResultSent:
//            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
//            break;
//        case MFMailComposeResultFailed:
//            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
//            break;
//        default:
//            NSLog(@"Mail not sent.");
//            break;
//    }
//    
//    // Remove the mail view
//    [self dismissModalViewControllerAnimated:YES];
//}

- (void)callTel:(UIButton*)button {
    
    long i = button.tag - ICON_TAG;
    //    NSLog(@"call %ld", i);
    
    NSDictionary* dic = [[Common instance].azsjson objectAtIndex:[Common instance].stationRowSelected];
    NSArray* tels = [dic objectForKey:STATION_PHONE];
    //        NSDictionary* d = [tels objectAtIndex:i];
    //        NSString* tel = [d objectForKey:PHONE_NUMBER];
    NSString* tel = (NSString*)[tels objectAtIndex:i];
    NSString* tel1 = [tel stringByReplacingOccurrencesOfString:@" " withString:@""];

    NSString *phoneNumber = [@"telprompt://" stringByAppendingString:tel1];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.

//    self.stationDescrLab.font = FONT_STATION_DESCR;
    self.stationDescrText.font = FONT_STATION_DESCR;

    [self refresh];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goMap:(id)sender {

//    NSLog(@"goMap");
   
    [[Common instance].mapcontr showMap];

    [self.navigationController popViewControllerAnimated:YES];

    [self performSelector:@selector(goMap1) withObject:nil afterDelay:0.0f];

}

- (void) goMap1 {

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
    
        NSDictionary* dic = [[Common instance].azsjson objectAtIndex:[Common instance].stationRowSelected];
        NSNumber* n = [dic objectForKey:STATION_ID];
        [[Common instance].menucontr showStationWithId:n.intValue];
    });

}

- (void) keyboardHide:(NSNotification*)notification {
    
    NSString* s = [[[Common instance] getCurrentCityName] stringByAppendingString:self.stationNumberLab.text];
    UITextView* tv = (UITextView*)[self.stationDetailView viewWithTag:TAG_TO_DEL];
    [[Common instance]sendStationFeedback:tv.text forStation:s];
    [tv removeFromSuperview];
    self.detailViewH.constant = self.detailViewH.constant - 70 - deltaY - TEXTVIEW_HEIGHT;
}

- (void) keyboardShow:(NSNotification*)notification {
    
    CGRect keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //    NSLog(@"keyboard frame raw %@", NSStringFromCGRect(keyboardFrame));
    
    UIWindow *window = [[[UIApplication sharedApplication] windows]objectAtIndex:0];
    UIView *mainSubviewOfWindow = window.rootViewController.view;
    CGRect keyboardFrameConverted = [mainSubviewOfWindow convertRect:keyboardFrame fromView:window];
    //    NSLog(@"keyboard frame converted %@", NSStringFromCGRect(keyboardFrameConverted));
    deltaY = keyboardFrameConverted.size.height;
    

    self.detailViewH.constant = self.detailViewH.constant + deltaY;
    
    CGPoint p = self.scrollView.contentOffset;
    
    [self.scrollView setContentOffset:CGPointMake(p.x, p.y + deltaY + TEXTVIEW_HEIGHT) animated:NO];
}


@end
