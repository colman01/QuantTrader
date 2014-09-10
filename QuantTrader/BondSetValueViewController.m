//
//  BondSetValueViewController.m
//  QuantTrader
//
//  Created by colman on 16/06/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import "BondSetValueViewController.h"
#import "BondValuesViewController.h"
#import "QuantDao.h"
#import "DmBond.h"

@interface BondSetValueViewController ()

@end

@implementation BondSetValueViewController

@synthesize value, valueField, item, datePicker, showDate, date;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [valueField setText:value];
    valueField.delegate = self;
    valueField.keyboardType = UIKeyboardTypeDecimalPad;
    UIBarButtonItem *saveBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveAction)];
    self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects: saveBarButtonItem, nil];
    
    if (showDate) {
        datePicker.hidden = NO;
        valueField.hidden = YES;
    } else {
        datePicker.hidden = YES;
        valueField.hidden = NO;
    }

}


- (void) saveAction {
    
    if (!datePicker.hidden) {
        NSDate *l_date = self.datePicker.date;
        self.handlerDate(l_date, self.postion);
    } else {
        self.handler(valueField.text);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
}
*/

#pragma mark

- (void) onComplete:(SetCompletionHandler) handler {
    self.handler = handler;
}

- (void) onCompleteMany:(SetManyCompletionHandler) multiValueHandler {
    self.multiValuehandler  = multiValueHandler;
}

- (void) onCompleteDateMany:(SetDateManyCompletionHandler) multiDateHandler_ {
    self.handlerDate  = multiDateHandler_;
}


@end
