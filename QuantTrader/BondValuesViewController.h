//
//  BondValuesViewController.h
//  QuantTrader
//
//  Created by colman on 16/06/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bond.h"

@interface BondValuesViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) Bond *bond;

@property (nonatomic, weak) IBOutlet UITableView *table;
@property (nonatomic, strong) NSMutableArray  *values;




@end
