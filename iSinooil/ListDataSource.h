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

/*
ГАЗ 64
ДТ 32
АИ-80 16
АИ-92 8
АИ-93 4
АИ-96 2
АИ-97 1
 */
#define FUEL_BIT_97 1
#define FUEL_BIT_96 2
#define FUEL_BIT_93 4
#define FUEL_BIT_92 8
#define FUEL_BIT_80 16
#define FUEL_BIT_DT 32
#define FUEL_BIT_GAS 64

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

@interface ListDataSource : NSObject <UITableViewDelegate, UITableViewDataSource>

@end
