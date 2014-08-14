//
//  BondSetValueViewController.m
//  QuantTrader
//
//  Created by colman on 16/06/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import "BondSetValueViewController.h"
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
    
//    if ([item  isKindOfClass:[double Class] ]) {
//        
//        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
//        [f setNumberStyle:NSNumberFormatterDecimalStyle];
//        item = [f numberFromString:valueField.text];
//        
//    }
    
    #define IS_OBJECT(T) _Generic( (T), id: YES, default: NO)
    if(IS_OBJECT(item)) {
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        item = [f numberFromString:valueField.text];
    }
    
    if ([item  isKindOfClass:[NSNumber class]]) {
        
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        item = [f numberFromString:valueField.text];
        
    }
    if ([item class] == [NSString class]) {
        item = valueField.text;
    }
    if ([item class] == [NSNumber class]) {

        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        item = [f numberFromString:valueField.text];

    }
    if ([item class] == [NSDate class]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"dd/mmm/yyyy"];
        item = [formatter dateFromString:valueField.text];
    }
    
    [[PersistManager instance] save];
    
    self.handler(valueField.text);
//    [popOver onComplete:^(NSString *value) {
//        dmImage.text = value;
//        [[PersistManager instance] save];
//        textView.text  = dmImage.text;
//        textView_1.text  = dmImage.text;
//        textView_2.text  = dmImage.text;
//        [self showExistingText];
//        [textView_2 resignFirstResponder];
//        [textView_1 resignFirstResponder];
//    }];
    
//    [self onComplete:^(NSString *value) {
//        
//    }];

    
    
    

    

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




@end
