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


- (void) viewWillDisappear:(BOOL)animated   {
    modelData = nil;
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
    if (![modelData isKindOfClass:[NSMutableArray class]]) {
        dest.item  = modelData;
    }
    [dest onComplete:^(NSString* text) {
        self.handler(text);
//        [self onComplete:^(NSString *text_) {
//        }];
    
    }];

}

// Override to support conditional editing of the table view.
// This only needs to be implemented if you are going to be returning NO
// for some items. By default, all items are editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
    }
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    if ([modelData isKindOfClass:[NSMutableArray class]]  ) {
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


@end
