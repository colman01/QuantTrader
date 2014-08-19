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

@synthesize value, valueField, item;

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
    

    UIBarButtonItem *saveBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveAction)];
    
    self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects: saveBarButtonItem, nil];
    
}


- (void) saveAction {
    self.handler(valueField.text);
//    id parent = [self parentViewController];
//    NSArray *cons = [parent childViewControllers];
//    for (UIViewController *vc in cons) {
//        if ([vc isKindOfClass:[BondValuesViewController class]]) {
//            
//            BondValuesViewController *con = (BondValuesViewController *)vc;
//            
//            
//            if ([con.modelData isKindOfClass:[NSMutableArray class]]) {
//                self.multiValuehandler(valueField.text, self.postion);
//            } else {
//                self.handler(valueField.text);
//            }
//        }
//    }
    
//    BondValuesViewController *con = (BondValuesViewController *)parent;
//    if ([con.modelData isKindOfClass:[NSMutableArray class]]) {
//        self.multiValuehandler(valueField.text, self.postion);
//    } else {
//        self.handler(valueField.text);
//    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark

- (void) onComplete:(SetCompletionHandler) handler {
    self.handler = handler;
}

- (void) onCompleteMany:(SetManyCompletionHandler) multiValueHandler {
    self.multiValuehandler  = multiValueHandler;
}




@end
