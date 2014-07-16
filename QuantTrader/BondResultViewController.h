//
//  BondResultViewController.h
//  QuantTrader
//
//  Created by colman on 16/06/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bond.h"

@interface BondResultViewController : UIViewController<UITableViewDelegate>

@property (strong, nonatomic) Bond *bond;

@property (strong, nonatomic) IBOutlet UITableView *table;

@end
