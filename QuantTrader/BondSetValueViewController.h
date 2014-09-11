//
//  BondSetValueViewController.h
//  QuantTrader
//
//  Created by colman on 16/06/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersistManager.h"

typedef void (^SetCompletionHandler) (NSString *value);
typedef void (^SetManyCompletionHandler) (NSString *value, int position);
typedef void (^SetDateManyCompletionHandler) (NSDate *date, int position);


@interface BondSetValueViewController : UIViewController <UITextFieldDelegate>
@property int postion;
@property BOOL showDate;
@property (strong, nonatomic) NSDate *date;

@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic) id item;
@property (strong, nonatomic) NSString *value;

@property (strong, nonatomic) SetCompletionHandler handler;
@property (strong, nonatomic) SetDateManyCompletionHandler handlerDate;

- (void) onComplete:(SetCompletionHandler) handler;

@property (strong, nonatomic) SetManyCompletionHandler multiValuehandler;

- (void) onCompleteMany:(SetManyCompletionHandler) multiValueHandler;

- (void) onCompleteDateMany:(SetDateManyCompletionHandler) multiDateHandler;

@end
