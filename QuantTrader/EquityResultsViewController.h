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


@property IBOutlet UITableView *tableView;
@property IBOutlet UIActivityIndicatorView *activity;


@property EquityOption_ * eq;

@end
