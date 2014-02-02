//
//  NewsCell.h
//  iSinooil
//
//  Created by вадим on 2/2/14.
//  Copyright (c) 2014 Zul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *brief;

@end
