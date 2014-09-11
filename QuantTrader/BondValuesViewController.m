    //
//  BondValuesViewController.m
//  QuantTrader
//
//  Created by colman on 16/06/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import "BondValuesViewController.h"
#import "BondSetValueViewController.h"

@interface BondValuesViewController ()

@end

@implementation BondValuesViewController
@synthesize values;
@synthesize modelData;

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
    self.table.delegate = self;
    self.table.dataSource = self;
}

- (void) viewWillAppear:(BOOL)animated {
}


- (void) viewWillDisappear:(BOOL)animated   {
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UITableViewCell *cell = (UITableViewCell *) sender;
    BondSetValueViewController  * dest = [segue destinationViewController];
    dest.value = cell.textLabel.text;
    dest.datePicker.hidden = YES;
    if (![modelData isKindOfClass:[NSMutableArray class]]) {
        dest.item  = modelData;
        
        [dest onComplete:^(NSString* text) {
            
            [self.table reloadData];
            self.handler(text);
        }];
    } else {
        
        UITableViewCell *cell = (UITableViewCell *)sender;
        dest.postion = cell.tag;

        if ([[modelData objectAtIndex:0] isKindOfClass:[NSDate class]]) {
            dest.showDate = YES;
            dest.date = [modelData objectAtIndex:cell.tag];
            
            [dest onCompleteDateMany:^(NSDate *date, int position) {
                self.multiDateHandler(date, position);
                [self.table reloadData];
            }];
            
        } else {
            [dest onComplete:^(NSString* text) {
                self.multiValuehandler(text,dest.postion);
                [self.table reloadData];
            }];
            
        }
    }
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        self.removeHandler(indexPath.row);
    }
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if ([modelData isKindOfClass:[NSMutableArray class]]) {
        values = modelData;
        if ([[modelData objectAtIndex:indexPath.row] isKindOfClass:[NSDate class]]) {
            NSDate *value = [modelData objectAtIndex:indexPath.row];
            NSString *dateString = [NSDateFormatter localizedStringFromDate:value
                                                                  dateStyle:NSDateFormatterShortStyle
                                                                  timeStyle:NSDateFormatterFullStyle];
            cell.textLabel.text = dateString;
        }
        if ([[modelData objectAtIndex:indexPath.row]  isKindOfClass: [NSNumber class]])
            cell.textLabel.text = [[modelData objectAtIndex:indexPath.row] stringValue];
    }
    
    if ([modelData isKindOfClass:[NSNumber class]])
        cell.textLabel.text = [modelData stringValue];
    cell.tag = indexPath.row;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(modelData) {
        if ([modelData  isKindOfClass: [NSMutableArray class]]) {
            NSMutableArray *data = (NSMutableArray * ) modelData;
            return data.count;
        } else {
            return 1;
        }
    }
    return 1;
}

#pragma mark

- (void) onComplete:(SetCompletionHandler) handler {
    self.handler = handler;
}

- (void) onCompleteMany:(SetManyCompletionHandler) multiValueHandler {
    self.multiValuehandler = multiValueHandler;
}

- (void) onCompleteDateMany:(SetDateManyCompletionHandler) multiDateHandler {
    self.multiDateHandler = multiDateHandler;
}

- (void) onRemove:(RemoveCompletionHandler) removeHandler {
    self.removeHandler = removeHandler;
}




@end
