//
//  SettingsViewController.m
//  iSinooil
//
//  Created by вадим on 2/8/14.
//  Copyright (c) 2014 Zul. All rights reserved.
//

#import "SettingsViewController.h"
#import "Common.h"
#import "SettingsDataSource.h"
#import "SettingsCell.h"

@implementation SettingsViewController

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    CGSize s = [Common currentScreenBoundsDependOnOrientation:toInterfaceOrientation];
    self.view.frame = CGRectMake(0, 0, s.width, s.height);
}

- (void) refresh {
    
    UILabel* labelPrices = (UILabel*)[self.topView viewWithTag:TITLELABEL_TAG];
    labelPrices.font = FONT_STD_TOP_MENU;
    labelPrices.text = NSLocalizedString(@"Settings", nil);
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    

    self.setsour = [[SettingsDataSource alloc] init];
    self.settTableView.dataSource = self.setsour;
    self.settTableView.delegate = self;

    selectedRow = -1;
    
    [self refresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toMenu:(id)sender {
    
//    self.view.hidden = NO;
//    
//    CGRect fr = self.view.frame;
//    BOOL b = (fr.origin.x < 1);
//    [UIView animateWithDuration:anim_delay delay:0.0 options:UIViewAnimationOptionCurveEaseIn
//                     animations:^{
//                         
//                         self.view.frame = CGRectMake(b?(fr.size.width - deltaX):0, fr.origin.y, fr.size.width, fr.size.height);
//                         
//                     }
//                     completion:^(BOOL finished) {
//                     }];
    
    [self doMenu];

}

- (void) ruSelected {
    
    [Common instance].lang = L_RU;
    [self hidePopup];
    [self.settTableView reloadData];

    [[NSUserDefaults standardUserDefaults] setInteger:L_RU forKey:@"language"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSString* path = [[NSBundle mainBundle] pathForResource:@"ru" ofType:@"lproj"];
    [Common instance].languageBundle = [NSBundle bundleWithPath:path];

    [[Common instance] loadAndParse];
   
    [[Common instance].menucontr refresh];

}

- (void) enSelected {
    
    [Common instance].lang = L_ENG;
    [self hidePopup];
    [self.settTableView reloadData];
    
    [[NSUserDefaults standardUserDefaults] setInteger:L_ENG forKey:@"language"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSString* path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
    [Common instance].languageBundle = [NSBundle bundleWithPath:path];

    [[Common instance] loadAndParse];
   
    [[Common instance].menucontr refresh];
    

}

- (void) kzSelected {
    
    [Common instance].lang = L_KZ;
    [self hidePopup];
    [self.settTableView reloadData];
    
    [[NSUserDefaults standardUserDefaults] setInteger:L_KZ forKey:@"language"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSString* path = [[NSBundle mainBundle] pathForResource:@"kk-KZ" ofType:@"lproj"];
    [Common instance].languageBundle = [NSBundle bundleWithPath:path];

    [[Common instance] loadAndParse];
   
    [[Common instance].menucontr refresh];
    

}

- (void) kmSelected {
    
    [Common instance].metrics = M_KM;
    [self hidePopup];
    [self.settTableView reloadData];
    [[Common instance].menucontr refresh];
//    [[Common instance].pricecontr refresh];

    [[NSUserDefaults standardUserDefaults] setInteger:M_KM forKey:@"km_miles"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (void) miSelected {
    
    [Common instance].metrics = M_MI;
    [self hidePopup];
    [self.settTableView reloadData];
    [[Common instance].menucontr refresh];
//    [[Common instance].pricecontr refresh];

    [[NSUserDefaults standardUserDefaults] setInteger:M_MI forKey:@"km_miles"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) meSelected {
    
    [Common instance].metrics = M_MT;
    [self hidePopup];
    [self.settTableView reloadData];
    [[Common instance].menucontr refresh];
//    [[Common instance].pricecontr refresh];
    
    [[NSUserDefaults standardUserDefaults] setInteger:M_MT forKey:@"km_miles"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (void) hidePopup {

    UIView* old = [self.view viewWithTag:POPUP_TAG];
    [old removeFromSuperview];
    selectedRow = -1;
}

- (void) fuelSelected:(UIButton*)button {
    
    [Common instance].fuelSelected = (button.tag - 1);
    [self hidePopup];
    [self.settTableView reloadData];
    [[Common instance].menucontr refresh];
}

- (void) showPopup {
    
//    NSLog(@"showPopup");
    
    UIView* old = [self.view viewWithTag:POPUP_TAG];
    [old removeFromSuperview];
    
    int cnt = 3;
    switch (selectedRow) {
        case 0:
        case 2:
            cnt = 3;
            break;
        case 1:
            cnt = [Common instance].fueljson.count;
            break;
            
    }
    
    UIView* v = [[UIView alloc] initWithFrame:CGRectMake(220, 112 + selectedRow * SETTINGSCELL_HEIGHT, POPUP_WIDTH, cnt * POPUPBUTTON_HEIGHT)];
    v.layer.cornerRadius = 5;
    v.layer.masksToBounds = YES;
    v.tag = POPUP_TAG;
    v.backgroundColor = [UIColor clearColor];
//    v.alpha = 0.5f;
    [self.view addSubview:v];

    UIView* vv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, POPUP_WIDTH, cnt * POPUPBUTTON_HEIGHT)];
    vv.layer.cornerRadius = 5;
    vv.layer.masksToBounds = YES;
    vv.backgroundColor = [UIColor grayColor];
    vv.alpha = 0.7f;
    [v addSubview:vv];
    
    switch (selectedRow) {
        case 0: {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self action:@selector(ruSelected) forControlEvents:UIControlEventTouchDown];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitle:NSLocalizedString(@"lang_ru", nil) forState:UIControlStateNormal];
            button.titleLabel.font = SETT_POPUP_FONT;
            button.frame = CGRectMake(0, 0 * POPUPBUTTON_HEIGHT, POPUP_WIDTH, POPUPBUTTON_HEIGHT);
            [v addSubview:button];
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self action:@selector(enSelected) forControlEvents:UIControlEventTouchDown];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitle:NSLocalizedString(@"lang_eng", nil) forState:UIControlStateNormal];
            button.titleLabel.font = SETT_POPUP_FONT;
            button.frame = CGRectMake(0, 1 * POPUPBUTTON_HEIGHT, POPUP_WIDTH, POPUPBUTTON_HEIGHT);
            [v addSubview:button];
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self action:@selector(kzSelected) forControlEvents:UIControlEventTouchDown];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitle:NSLocalizedString(@"lang_kz", nil) forState:UIControlStateNormal];
            button.titleLabel.font = SETT_POPUP_FONT;
            button.frame = CGRectMake(0, 2 * POPUPBUTTON_HEIGHT, POPUP_WIDTH, POPUPBUTTON_HEIGHT);
            [v addSubview:button];
            break;
        }
        case 1: {
            int i = 0;
            for (NSDictionary* d in [Common instance].fueljson) {

                NSString* type = @"..";
                NSNumber* nn = [d valueForKey:FUEL_BITS];
                switch (nn.intValue - 1) {
                    case 0://FUEL_BIT_97:
                        type = NSLocalizedString(@"AI97", nil);
                        break;
                    case 1://FUEL_BIT_96:
                        type = NSLocalizedString(@"AI96", nil);
                        break;
                    case 2://FUEL_BIT_93:
                        type = NSLocalizedString(@"AI93", nil);
                        break;
                    case 3://FUEL_BIT_92:
                        type = NSLocalizedString(@"AI92", nil);
                        break;
                    case 4://FUEL_BIT_80:
                        type = NSLocalizedString(@"AI80", nil);
                        break;
                    case 5://FUEL_BIT_DT:
                        type = NSLocalizedString(@"AIDI", nil);
                        break;
                    case 6://FUEL_BIT_GAS:
                        type = NSLocalizedString(@"AIGAS", nil);
                        break;
                    case 7://FUEL_BIT_DTW:
                        type = NSLocalizedString(@"AIDIW", nil);
                        break;
                }

                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button addTarget:self action:@selector(fuelSelected:) forControlEvents:UIControlEventTouchDown];
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [button setTitle:type forState:UIControlStateNormal];
                button.titleLabel.font = SETT_POPUP_FONT;
                button.tag = nn.intValue;
                button.frame = CGRectMake(0, POPUPBUTTON_HEIGHT * (i++), POPUP_WIDTH, POPUPBUTTON_HEIGHT);
                [v addSubview:button];

            }
            break;
        }
        case 2: {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self action:@selector(kmSelected) forControlEvents:UIControlEventTouchDown];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitle:NSLocalizedString(@"km", nil) forState:UIControlStateNormal];
            button.titleLabel.font = SETT_POPUP_FONT;
            button.frame = CGRectMake(0, 0 * POPUPBUTTON_HEIGHT, POPUP_WIDTH, POPUPBUTTON_HEIGHT);
            [v addSubview:button];
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self action:@selector(miSelected) forControlEvents:UIControlEventTouchDown];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitle:NSLocalizedString(@"miles", nil) forState:UIControlStateNormal];
            button.titleLabel.font = SETT_POPUP_FONT;
            button.frame = CGRectMake(0, 1 * POPUPBUTTON_HEIGHT, POPUP_WIDTH, POPUPBUTTON_HEIGHT);
            [v addSubview:button];
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self action:@selector(meSelected) forControlEvents:UIControlEventTouchDown];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitle:NSLocalizedString(@"metres", nil) forState:UIControlStateNormal];
            button.titleLabel.font = SETT_POPUP_FONT;
            button.frame = CGRectMake(0, 2 * POPUPBUTTON_HEIGHT, POPUP_WIDTH, POPUPBUTTON_HEIGHT);
            [v addSubview:button];
            break;
        }
    }
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return SETTINGSCELL_HEIGHT;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self hidePopup];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = (id)[tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        
        if ((selectedRow >=0) && (selectedRow == indexPath.row)) {
            
            [self hidePopup];
            selectedRow = -1;
            return;
        }

        selectedRow = indexPath.row;
        [self showPopup];
    }

}

- (IBAction)tablePressed:(id)sender {
    
    [self hidePopup];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {

    return ![NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"];
}

@end
