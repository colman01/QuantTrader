//
//  EquityResultsViewController.h
//  QuantTrader
//
//  Created by colman on 03/09/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EquityOption_.h"

@interface EquityResultsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>


@property(strong, nonatomic)  IBOutlet UITableView *tableView;
@property IBOutlet UIActivityIndicatorView *activity;

@property (strong)  NSNumber *num;

@property EquityOption_ * eq;

- (void) doCalcInBackground;

@end
