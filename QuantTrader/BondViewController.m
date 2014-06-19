//
//  BondViewController.m
//  QuantTrader
//
//  Created by colman on 16/06/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import "BondViewController.h"
#import "BondValuesViewController.h"

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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SetBond"]) {
        id destination = segue.destinationViewController;
        BondValuesViewController *bondValuesViewController = (BondValuesViewController *) destination;
        bondValuesViewController.values = [[NSMutableArray alloc] init];
        UITableViewCell *cell = (UITableViewCell *) sender;
        NSString *string = [NSString stringWithFormat:@"%i", cell.tag];
        switch (cell.tag) {
            case 0:
                string = [NSString stringWithFormat:@"%f", _ZeroC3mQuote];
                [bondValuesViewController.values addObject:string];
                string = [NSString stringWithFormat:@"%f", _ZeroC6mQuote];
                [bondValuesViewController.values addObject:string];
                string = [NSString stringWithFormat:@"%f", _ZeroC1yQuote];
                [bondValuesViewController.values addObject:string];
                break;
            case 1:
                string = [NSString stringWithFormat:@"%i", _redemption_];
                [bondValuesViewController.values addObject:string];
                break;
            case 2:
                string = [NSString stringWithFormat:@"%i", _fiXingDays];
                [bondValuesViewController.values addObject:string];
                break;
            case 3:
                string = [NSString stringWithFormat:@"%i", _numBonds];
                [bondValuesViewController.values addObject:string];
                break;
            case 4:
                for (NSString *var in _issueDates) {
                    string = var;
                    [bondValuesViewController.values addObject:string];
                }
                break;
            case 5:
                for (NSString *var in _maturityDates) {
                    string = var;
                    [bondValuesViewController.values addObject:string];
                }
                break;
            case 6:
                string = [NSString stringWithFormat:@"%f", _zeroCoupon3mQuote];
                if(string)
                    [bondValuesViewController.values addObject:string];
                string = [NSString stringWithFormat:@"%f", _zeroCoupon3mQuote];
                if(string)
                    [bondValuesViewController.values addObject:string];
                string = [NSString stringWithFormat:@"%f", _zeroCoupon1yQuote];
                if(string)
                    [bondValuesViewController.values addObject:string];
                break;
            case 7:
                for (NSString *var in _marketQuotes) {
                    string = var;
                    [bondValuesViewController.values addObject:string];
                }
                break;
            case 8:
                for (NSString *var in _liborForcastingCurveQuotes) {
                    string = var;
                    if(string)
                        [bondValuesViewController.values addObject:string];
                }
                break;
            case 9:
                for (NSString *var in _swapQuotes) {
                    string = var;
                    if(string)
                        [bondValuesViewController.values addObject:string];
                }
                break;
            case 10:
                string = [NSString stringWithFormat:@"%f", _faceamount];
                if(string)
                    [bondValuesViewController.values addObject:string];
                break;
            case 11:
            {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                
                [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
                [dateFormatter setDateFormat:@"dd-MM-yy"];
                string = [dateFormatter stringFromDate:_zeroCouponDate1];
                if(string)
                    [bondValuesViewController.values addObject:string];
            }
            case 12:
            {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
                [dateFormatter setDateFormat:@"dd-MM-yy"];
                string = [dateFormatter stringFromDate:_fixedRateBondDate];
                if(string)
                    [bondValuesViewController.values addObject:string];
            }
                
            case 99:
                string = [NSString stringWithFormat:@"%i", _settleMentDays];
                if(string)
                    [bondValuesViewController.values addObject:string];
                break;
            
            case 9999:
                string = [NSString stringWithFormat:@"%f", _redemp];
                if(string)
                    [bondValuesViewController.values addObject:string];
                break;



            case 101:
                for (NSString *var in _couponRates) {
                    string = var;
                    if(string)
                        [bondValuesViewController.values addObject:string];
                }
                break;
            



            case 15:
                break;
            case 16:
                break;
            case 17:
                break;
            case 18:
                break;
            case 19:
                break;

            default:
                if(string)
                    [bondValuesViewController.values addObject:string];
                break;
        }
        
        
        
    }
}


#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.tag = indexPath.row;
    
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
