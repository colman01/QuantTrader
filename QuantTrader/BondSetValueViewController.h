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


@interface BondSetValueViewController : UIViewController <UITextFieldDelegate>
@property int postion;

@property (strong, nonatomic) IBOutlet UITextField *valueField;
@property (nonatomic) id item;
@property (strong, nonatomic) NSString *value;
@property (strong, nonatomic) SetCompletionHandler handler;

- (void) onComplete:(SetCompletionHandler) handler;

@property (strong, nonatomic) SetManyCompletionHandler multiValuehandler;

- (void) onCompleteMany:(SetManyCompletionHandler) multiValueHandler;

@end
