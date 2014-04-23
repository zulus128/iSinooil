//
//  SettingsDataSource.m
//  iSinooil
//
//  Created by вадим on 2/8/14.
//  Copyright (c) 2014 Zul. All rights reserved.
//

#import "SettingsDataSource.h"
#import "SettingsCell.h"
#import "Common.h"

@implementation SettingsDataSource

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *CellIdentifier = @"settingsCell";
    SettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.name.font = FONT_SETTINGS_LABEL;
    cell.value.font = FONT_SETTINGS_VALUE;
    cell.arrDown.hidden = NO;
    cell.arrUp.hidden = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tag = indexPath.row;
    switch (indexPath.row) {
        case 0:
            cell.name.text = NSLocalizedString(@"settingsname", nil);
            cell.img.image = [UIImage imageNamed:@"icon_language.png"];
            switch ([Common instance].lang) {
                case L_RU:
                    cell.value.text = NSLocalizedString(@"lang_ru", nil);
                    break;
                case L_ENG:
                    cell.value.text = NSLocalizedString(@"lang_eng", nil);
                    break;
                case L_KZ:
                    cell.value.text = NSLocalizedString(@"lang_kz", nil);
                    break;
            }
            break;
        case 1:
            cell.name.text = NSLocalizedString(@"settingsfuel", nil);
            cell.img.image = [UIImage imageNamed:@"icon_fuel.png"];
            switch ([Common instance].fuelSelected) {
                case 0://FUEL_BIT_97:
                    cell.value.text = NSLocalizedString(@"AI97", nil);
                    break;
                case 1://FUEL_BIT_96:
                    cell.value.text = NSLocalizedString(@"AI96", nil);
                    break;
                case 2://FUEL_BIT_93:
                    cell.value.text = NSLocalizedString(@"AI93", nil);
                    break;
                case 3://FUEL_BIT_92:
                    cell.value.text = NSLocalizedString(@"AI92", nil);
                    break;
                case 4://FUEL_BIT_80:
                    cell.value.text = NSLocalizedString(@"AI80", nil);
                    break;
                case 5://FUEL_BIT_DT:
                    cell.value.text = NSLocalizedString(@"AIDI", nil);
                    break;
                case 6://FUEL_BIT_GAS:
                    cell.value.text = NSLocalizedString(@"AIGAS", nil);
                    break;
                case 7://FUEL_BIT_DTW:
                    cell.value.text = NSLocalizedString(@"AIDIW", nil);
                    break;

            }

            break;
        case 2:
            cell.name.text = NSLocalizedString(@"settingsmetre", nil);
            cell.img.image = [UIImage imageNamed:@"icon_metrics.png"];
            switch ([Common instance].metrics) {
                case M_KM:
                    cell.value.text = NSLocalizedString(@"km", nil);
                    break;
                case M_MI:
                    cell.value.text = NSLocalizedString(@"miles", nil);
                    break;
                case M_MT:
                    cell.value.text = NSLocalizedString(@"metres", nil);
                    break;
            break;
            }
    }
    
    return cell;
}

@end
