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
    // not to setcon to values view con
    if ([segue.identifier isEqualToString:@"SetBond"]) {
        id destination = segue.destinationViewController;
        
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
                bondValuesViewController.modelData = bondParameters.redemption;
                break;
            case 2:
                bondValuesViewController.modelData = bondParameters.fixingDays;
                break;
            case 3:
                bondValuesViewController.modelData = bondParameters.numberOfBonds;
                break;
            case 4:
            {
                bondValuesViewController.modelData = [NSKeyedUnarchiver unarchiveObjectWithData:bondParameters.issueDates];

            }
                break;
            case 5:
            {

                bondValuesViewController.modelData = [NSKeyedUnarchiver unarchiveObjectWithData:bondParameters.maturityDates];
                   break;
            }
             
            case 6:
                bondValuesViewController.modelData = [NSKeyedUnarchiver unarchiveObjectWithData: bondParameters.couponRates];
                break;
            case 7:
                bondValuesViewController.modelData = [NSKeyedUnarchiver unarchiveObjectWithData: bondParameters.marketQuotes];
                break;
            case 8:
                bondValuesViewController.modelData = [NSKeyedUnarchiver unarchiveObjectWithData: bondParameters.liborForcastingCurveQuotes];
                break;
            case 9:
                bondValuesViewController.modelData = [NSKeyedUnarchiver unarchiveObjectWithData: bondParameters.swapQuotes];
                break;
            case 10:
                bondValuesViewController.modelData = bondParameters.faceAmount;
                break;
            case 11:
            {

                bondValuesViewController.modelData = [[NSMutableArray alloc] initWithObjects:bondParameters.zeroCouponBondFirstDate,bondParameters.zeroCouponBondSecondDate, nil];
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
                break;
            }
                
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
    return 14;
}



@end
