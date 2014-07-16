//
//  BondResultViewController.m
//  QuantTrader
//
//  Created by colman on 16/06/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import "BondResultViewController.h"



@interface BondResultViewController ()

@end

@implementation BondResultViewController
@synthesize bond;
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
    if (!bond)
        bond = [[Bond alloc] init];
    [bond calculate];
    NSLog(@"calc running");
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
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:4];
    UILabel *res1 = (UILabel *)[cell viewWithTag:1];
    UILabel *res2 = (UILabel *)[cell viewWithTag:2];
    UILabel *res3 = (UILabel *)[cell viewWithTag:3];
    
    [titleLabel setText:@""];
    [res1 setText:@""];
    [res2 setText:@""];
    [res3 setText:@""];
    
    switch (indexPath.row) {
        case 0:
            [titleLabel setText:@"Net present value"];
            
            break;
        case 1:
            [titleLabel setText:@"Clean price"];
            [res1 setText:[NSString stringWithFormat:@"%.2f", [bond.zeroCouponBondCleanPrice floatValue]]];
            [res2 setText:[NSString stringWithFormat:@"%.2f", [bond.fixedRateBondCleanPrice floatValue]]];
            [res3 setText:[NSString stringWithFormat:@"%.2f", [bond.floatingRateBondCleanPrice floatValue]]];
            break;
        case 2:
            [titleLabel setText:@"Dirty price"];
            
            [res1 setText:[NSString stringWithFormat:@"%.2f", [bond.zeroCouponBondDirtyPrice floatValue]]];
            [res2 setText:[NSString stringWithFormat:@"%.2f", [bond.fixedRateBondDirtyPrice floatValue]]];
            [res3 setText:[NSString stringWithFormat:@"%.2f", [bond.floatingRateBondDirtyPrice floatValue]]];
            break;
        case 3:
            [titleLabel setText:@"Accrued coupon"];
            
            [res1 setText:[NSString stringWithFormat:@"%.2f", [bond.zeroCouponBondAccruedAmount floatValue]]];
            [res2 setText:[NSString stringWithFormat:@"%.2f", [bond.flxedRateBondAccruedAmount floatValue]]];
            [res3 setText:[NSString stringWithFormat:@"%.2f", [bond.floatingRateBondAccruedAmount floatValue]]];
            break;
        case 4:
            [titleLabel setText:@"Previous coupon"];
            
            [res1 setText:[NSString stringWithFormat:@"%.2f", [bond.zeroCouponBondPreviousCoupon floatValue]]];
            [res2 setText:[NSString stringWithFormat:@"%.2f", [bond.fixedRateBondPreviousCoupon floatValue]]];
            [res3 setText:[NSString stringWithFormat:@"%.2f", [bond.floatingRateBondPreviousCoupon floatValue]]];
            
            break;
        case 5:
            [titleLabel setText:@"Next coupon"];
            break;
        case 6:
            [titleLabel setText:@"Yield"];
            break;
            
        default:
            break;
    }
    
//    NSString *value = [values objectAtIndex:indexPath.row];

//    NSString *value = @"tbf";
//    cell.textLabel.text = value;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

@end
