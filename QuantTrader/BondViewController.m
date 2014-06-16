//
//  BondViewController.m
//  QuantTrader
//
//  Created by colman on 16/06/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import "BondViewController.h"

@interface BondViewController ()

@end

@implementation BondViewController

@synthesize table;

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

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // Configure the cell...
//    cell.textLabel.text = [NSString stringWithFormat:@"data %i", indexPath.row];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Zero Coupon Quote";
            break;
        case 1:
            cell.textLabel.text = @"Redemption";
            break;
        case 2:
            cell.textLabel.text = @"Fixing Days";
            break;
        case 3:
            cell.textLabel.text = @"Number of Bonds";
            break;
        case 4:
            cell.textLabel.text = @"Issue Dates";
            break;
        case 5:
            cell.textLabel.text = @"Maturity Dates";
            break;
        case 6:
            cell.textLabel.text = @"Coupon Rates";
            break;
        case 7:
            cell.textLabel.text = @"Market Quotes";
            break;
        case 8:
            cell.textLabel.text = @"Libor Forcasting Curve Quotes";
            break;
        case 9:
            cell.textLabel.text = @"Swap Quotes";
            break;
        case 10:
            cell.textLabel.text = @"Face Amount";
            break;
        case 11:
            cell.textLabel.text = @"Zero Data Coupon";
            break;
        case 12:
            cell.textLabel.text = @"Fixed Bond Schedule Rate and Dates";
            break;
        case 13:
            cell.textLabel.text = @"Floating Bond Schedule Rate and Dates";
            break;
        case 14:
            cell.textLabel.text = @"Dirty Price";
            break;
        case 15:
            cell.textLabel.text = @"Acured Amount";
            break;
        case 16:
            cell.textLabel.text = @"Previous Coupon";
            break;
        case 17:
            cell.textLabel.text = @"Next Coupon";
            break;
        case 18:
            cell.textLabel.text = @"Yield";
            break;
        case 19:
            cell.textLabel.text = @"Zero Coupon Quote";
            break;
            
            
        default:
            break;
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 20;
}



@end
