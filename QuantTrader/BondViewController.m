//
//  BondViewController.m
//  QuantTrader
//
//  Created by colman on 16/06/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import "BondViewController.h"
#import "BondValuesViewController.h"
#import "Bond.h"

@interface BondViewController ()

@end

@implementation BondViewController

@synthesize table;


@synthesize bond;
@synthesize bondParameterInit;


DmBond *bondParameters;

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
    [self initBond];
    

    
    NSMutableArray *results = [[QuantDao instance] getBond];
    
    if (!bondParameterInit) {
        bondParameterInit =  [[ParameterInitializer alloc] init];
        [bondParameterInit setupParameters];
    }
    

    // To clear the local store
    //    results = nil;
    //    [[PersistManager instance] save ];
    //    exit(0);
    //    for (int i=0; i< results.count; i++) {
    //        DmBond *bond_ = results[i];
    //        [[QuantDao instance] remove:user];
    //    }
    //    [[PersistManager instance] save];
    //    exit(0);
    

//    for (int i=0; i< results.count; i++) {
//        DmBond *bond_ = results[i];
//        [[QuantDao instance] remove:bond_];
//    }
//    [[PersistManager instance] save];
//    exit(0);
    
    @try {
        bondParameters = results[0];
    }
    @catch (NSException *exception) {
        bondParameters = [NSEntityDescription insertNewObjectForEntityForName:@"Bond" inManagedObjectContext:[[PersistManager instance] managedObjectContext]];
        bondParameters.fixingDays = [[NSNumber alloc ] initWithDouble:100]  ;
        [[PersistManager instance] save];
    }
    
    
}

- (void) viewDidAppear:(BOOL)animated {
    if (!bondParameterInit) {
        bondParameterInit =  [[ParameterInitializer alloc] init];
        [bondParameterInit setupParameters];
    }
}

- (void) initBond {
    self.bond = [[Bond alloc] init];
    
}

#pragma mark Bond calculate

- (IBAction)calculate:(id)sender{
//    [self.bond calculate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SetBond"]) {
        id destination = segue.destinationViewController;
        
        //                @try {
        //
        //
        //                }
        //                @catch (NSException *exception) {
        //                    return;
        //                }
        //                @finally {
        //                    return;
        //                }

        
        BondValuesViewController *bondValuesViewController = (BondValuesViewController *) destination;
        
        bondValuesViewController.bond = self.bond;
        if (!bondValuesViewController.values )
            bondValuesViewController.values = [[NSMutableArray alloc] init];
        
        UITableViewCell *cell = (UITableViewCell *) sender;
        NSString *string = [NSString stringWithFormat:@"%i", cell.tag];
        switch (cell.tag) {
            case 0:
                bondValuesViewController.modelData = [NSKeyedUnarchiver unarchiveObjectWithData:bondParameters.zeroCouponQuote];
                break;
            case 1:
//                _redemption_ = [bond.redemp intValue];
//                string = [NSString stringWithFormat:@"%i", _redemption_];
//                [bondValuesViewController.values addObject:string];
                
                bondValuesViewController.modelData = bondParameters.redemption;
                break;
            case 2:
//                string = [NSString stringWithFormat:@"%i", _fiXingDays];
//                [bondValuesViewController.values addObject:string];
                bondValuesViewController.modelData = bondParameters.fixingDays;
                break;
            case 3:
//                string = [NSString stringWithFormat:@"%i", bondValuesViewController.bond.numBonds];
                bondValuesViewController.modelData = bondParameters.numberOfBonds;
//                [bondValuesViewController.values addObject:string];
                break;
            case 4:
            {
                bondValuesViewController.modelData = [NSKeyedUnarchiver unarchiveObjectWithData:bondParameters.maturityDates];

            }
                break;
            case 5:
            {

                bondValuesViewController.modelData = [NSKeyedUnarchiver unarchiveObjectWithData:bondParameters.maturityDates];
                   break;
            }
             
            case 6:
//                bondValuesViewController.values = bond.bondCouponRates;
                bondValuesViewController.modelData = bondParameters.couponRates;
                break;
            case 7:
//                bondValuesViewController.values = bond.bondMarketQuotes;
                bondValuesViewController.modelData = bondParameters.marketQuotes;
                break;
            case 8:
                bondValuesViewController.modelData = bondParameters.liborForcastingCurveQuotes;
//                bondValuesViewController.values = bond.bondLiborForcastingCurveQuotes;
//                for (NSString *var in _liborForcastingCurveQuotes) {
//                    string = var;
//                    if(string)
//                        [bondValuesViewController.values addObject:string];
//                }
                break;
            case 9:
                bondValuesViewController.modelData = bondParameters.swapQuotes;
//                bondValuesViewController.values = bond.bondSwapQuotes;
//                for (NSString *var in _swapQuotes) {
//                    string = var;
//                    if(string)
//                        [bondValuesViewController.values addObject:string];
//                }
                break;
            case 10:
                bondValuesViewController.modelData = bondParameters.faceAmount;
//                string = [NSString stringWithFormat:@"%f", bond.faceamount];
//                if(string)
//                    [bondValuesViewController.values addObject:string];
                break;
            case 11:
            {

                bondValuesViewController.modelData = [[NSMutableArray alloc] initWithObjects:bondParameters.zeroCouponBondFirstDate,bondParameters.zeroCouponBondSecondDate, nil];
//                [bondValuesViewController.values addObject:bond.zeroCouponDate1];
//                [bondValuesViewController.values addObject:bond.zeroCouponDate2];
                break;
            }
            case 12:
            {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
                [dateFormatter setDateFormat:@"dd-MM-yy"];
                bondValuesViewController.modelData = bondParameters.fixedRateBondFirstDate;
                
                break;
            }
            case 13:
            {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
                [dateFormatter setDateFormat:@"dd-MM-yy"];
                bondValuesViewController.modelData = [[NSMutableArray alloc] initWithObjects:bondParameters.floatingBondScheduleFirstDate,bondParameters.floatingBondScheduleSecondDate, nil];
                
//                string = [dateFormatter stringFromDate:_floatingBondScheduleDate_1];
//                if(string)
//                    [bondValuesViewController.values addObject:string];
//                string = [dateFormatter stringFromDate:_floatingBondScheduleDate_2];
//                if(string)
//                    [bondValuesViewController.values addObject:string];
                break;
            }
            case 14:
                string = [NSString stringWithFormat:@"%f", _zeroCouponBondDirtyPrice];
                if(string)
                    [bondValuesViewController.values addObject:string];
                string = [NSString stringWithFormat:@"%f", _fixedRateBondDirtyPrice];
                if(string)
                    [bondValuesViewController.values addObject:string];
                string = [NSString stringWithFormat:@"%f", _floatingRateBondDirtyPrice];
                if(string)
                    [bondValuesViewController.values addObject:string];
                
//                bondValuesViewController.modelData = [[NSMutableArray alloc] initWithObjects:bondParameters.zeroCouponQuote,bondParameters.fix, nil];
                
                break;
            case 15:
                string = [NSString stringWithFormat:@"%f", _zeroCouponBondAccruedAmount];
                if(string)
                    [bondValuesViewController.values addObject:string];
                string = [NSString stringWithFormat:@"%f", _fixedRateBondAccruedAmount];
                if(string)
                    [bondValuesViewController.values addObject:string];
                string = [NSString stringWithFormat:@"%f", _floatingRateBondAccruedAmount];
                if(string)
                    [bondValuesViewController.values addObject:string];
                break;
            case 16:
                string = [NSString stringWithFormat:@"%f", _fixedrateBondPreviousCouponRate];
                if(string)
                    [bondValuesViewController.values addObject:string];
                string = [NSString stringWithFormat:@"%f", _floatingRateBontPreviousCouponRate];
                if(string)
                    [bondValuesViewController.values addObject:string];
                break;
            case 17:
                string = [NSString stringWithFormat:@"%f", _fixedRateBondNextCouponRate];
                if(string)
                    [bondValuesViewController.values addObject:string];
                string = [NSString stringWithFormat:@"%f", _floatingRateBoneNextCouponRate];
                if(string)
                    [bondValuesViewController.values addObject:string];
                break;
            case 18:
                string = [NSString stringWithFormat:@"%f", _zeroCouponBondYieldActual360CompoundedAnnual];
                if(string)
                    [bondValuesViewController.values addObject:string];
                string = [NSString stringWithFormat:@"%f", _fixedRateBondYieldActual360CompoundedAnnual];
                if(string)
                    [bondValuesViewController.values addObject:string];
                string = [NSString stringWithFormat:@"%f", _floatingRateBondYieldActual360CompoundedAnnual];
                if(string)
                    [bondValuesViewController.values addObject:string];
                break;
            case 19:
                string = [NSString stringWithFormat:@"%f", _zeroCoupon3mQuote];
                if(string)
                    [bondValuesViewController.values addObject:string];
                string = [NSString stringWithFormat:@"%f", _zeroCoupon6mQuote];
                if(string)
                    [bondValuesViewController.values addObject:string];
                string = [NSString stringWithFormat:@"%f", _zeroCoupon1yQuote];
                if(string)
                    [bondValuesViewController.values addObject:string];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}



@end
