//
//  BondViewController.h
//  QuantTrader
//
//  Created by colman on 16/06/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bond.h"
#import "QuantDao.h"
#import "ParameterInitializer.h"

typedef void (^SetCompletionHandler) (NSString *value);

@interface BondViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) Bond *bond;
@property (nonatomic, strong) ParameterInitializer *bondParameterInit;
@property (nonatomic, weak) IBOutlet UITableView *table;

-(id) saveValue:(NSString *)textToSave withAttribute:(id)item ;

@end
