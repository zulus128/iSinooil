//
//  ListDataSource.h
//  iSinooil
//
//  Created by Admin on 06.01.14.
//  Copyright (c) 2014 Zul. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CELL_HEIGHT 100
#define ICON_SIZE 30
#define GAP_SIZE 23
#define GAP_SIZE1 30
#define GAP_SIZE2 40

#define ICON_TAG 775

/*
 минимаркет 1
 кафе 2
 платежный терминал 4
 банкомат 8
 мойка 16
 сто 32
 заправка масла 64
 подкачка шин 128
 */
#define SERV_BIT_MARKET 1
#define SERV_BIT_CAFE 2
#define SERV_BIT_TERM 4
#define SERV_BIT_ATM 8
#define SERV_BIT_WASH 16
#define SERV_BIT_STO 32
#define SERV_BIT_OIL 64
#define SERV_BIT_WHEEL 128

/*
visa 1
AE 2
MC 4
 */
#define CARD_BIT_VISA 1
#define CARD_BIT_AE 2
#define CARD_BIT_MC 4

@interface StationListDataSource : NSObject <UITableViewDataSource>

@end
