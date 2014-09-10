//
//  BondValuesViewController.h
//  QuantTrader
//
//  Created by colman on 16/06/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bond.h"
#import "ParameterInitializer.h"

typedef void (^SetCompletionHandler) (NSString *value);
typedef void (^SetManyCompletionHandler) (NSString *value, int position);
typedef void (^SetDateManyCompletionHandler) (NSDate *value, int position);
typedef void (^RemoveCompletionHandler) (int position);


@interface BondValuesViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) Bond *bond;
@property (nonatomic, weak) IBOutlet UITableView *table;
@property (nonatomic, strong) NSMutableArray  *values;
@property (nonatomic) id modelData;

@property (strong, nonatomic) SetCompletionHandler handler;
@property (strong, nonatomic) SetManyCompletionHandler multiValuehandler;
@property (strong, nonatomic) SetDateManyCompletionHandler multiDateHandler;
@property (strong, nonatomic) RemoveCompletionHandler removeHandler;


- (void) onComplete:(SetCompletionHandler) handler;
- (void) onCompleteMany:(SetManyCompletionHandler) multiValueHandler;
- (void) onCompleteDateMany:(SetDateManyCompletionHandler) multiDateHandler;
- (void) onRemove:(RemoveCompletionHandler) removeHandler;

@end