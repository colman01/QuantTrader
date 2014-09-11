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

    // To clear the local store
//    for (int i=0; i< results.count; i++) {
//        DmBond *bond_ = results[i];
//        [[QuantDao instance] remove:bond_];
//    }
//    [[PersistManager instance] save];
//    exit(0);

    
    @try {
        bondParameters = results[0];
        if (!bondParameters) {
            bondParameterInit =  [[ParameterInitializer alloc] init];
            [bondParameterInit setupParameters];
        }
    }
    @catch (NSException *exception) {
        bondParameters = [NSEntityDescription insertNewObjectForEntityForName:@"Bond" inManagedObjectContext:[[PersistManager instance] managedObjectContext]];
        [[PersistManager instance] save];
    }
}

- (void) viewDidAppear:(BOOL)animated {
    NSMutableArray* entries = [NSKeyedUnarchiver unarchiveObjectWithData:bondParameters.maturityDates];
    if (entries.count < 2) {
        NSLog(@"out");
        bondParameterInit =  [[ParameterInitializer alloc] init];
        [bondParameterInit setupParameters];
    }
}

- (void) initBond {
    self.bond = [[Bond alloc] init];
}

#pragma mark Bond calculate

- (IBAction)calculate:(id)sender{
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
            {
                bondValuesViewController.modelData = [NSKeyedUnarchiver unarchiveObjectWithData:bondParameters.zeroCouponQuote];
                
                [bondValuesViewController onCompleteMany:^(NSString *text, int position) {
                    NSMutableArray* entries = [NSKeyedUnarchiver unarchiveObjectWithData:bondParameters.zeroCouponQuote];
                    entries = [self saveValue:text withAttribute:entries andPosition:position];
                    bondParameters.zeroCouponQuote = [NSKeyedArchiver archivedDataWithRootObject:entries];
                    [[PersistManager instance] save];
                    bondValuesViewController.modelData = entries;
                    [bondValuesViewController.table reloadData];
                }];
            }
                
                break;
            case 1:
            {
                bondValuesViewController.modelData = bondParameters.redemption;
                [bondValuesViewController onComplete:^(NSString *text) {
                    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
                    [f setNumberStyle:NSNumberFormatterDecimalStyle];
                    bondParameters.redemption = [f numberFromString:text];
                    bondValuesViewController.modelData = bondParameters.redemption ;
                    [bondValuesViewController.table reloadData];
                    [[PersistManager instance] save];
                    
                }];
                break;
            }
            case 2:
            {
                bondValuesViewController.modelData = bondParameters.fixingDays;
                [bondValuesViewController onComplete:^(NSString *text) {
                    id result = [self saveValue:text withAttribute:bondParameters.fixingDays];
                    bondParameters.fixingDays = result;
                    bondValuesViewController.modelData = result;
                    [bondValuesViewController.table reloadData];
                    [[PersistManager instance] save];
                }];
            }
                
                break;
            case 3:
            {
                bondValuesViewController.modelData = bondParameters.numberOfBonds;
                [bondValuesViewController onComplete:^(NSString *text) {
                    id result = [self saveValue:text withAttribute:bondParameters.numberOfBonds];
                    bondParameters.numberOfBonds = result;
                    bondValuesViewController.modelData = result;
                    [bondValuesViewController.table reloadData];
                    [[PersistManager instance] save];
                    
                }];
            }
                break;
                
            case 4:
            {
                bondValuesViewController.modelData = bondParameters.faceAmount;
                [bondValuesViewController onComplete:^(NSString *text) {
                    id result = [self saveValue:text withAttribute:bondParameters.faceAmount];
                    
                    bondParameters.faceAmount = result;
                    bondValuesViewController.modelData = result;
                    [bondValuesViewController.table reloadData];
                    [[PersistManager instance] save];
                }];
            }
                break;
                
            case 5:
            {

                bondValuesViewController.modelData = [NSKeyedUnarchiver unarchiveObjectWithData:bondParameters.maturityDates];
                
                [bondValuesViewController onRemove:^(int position) {
                    NSMutableArray* entries = [NSKeyedUnarchiver unarchiveObjectWithData:bondParameters.maturityDates];
                    [entries removeObjectAtIndex:position];
                    bondParameters.maturityDates = [NSKeyedArchiver archivedDataWithRootObject:entries];
                    [[PersistManager instance] save];
                    bondValuesViewController.modelData = entries;
                    [bondValuesViewController.table reloadData];
                }];
                [bondValuesViewController onCompleteDateMany:^(NSDate *date, int position) {
                    NSMutableArray* entries = [NSKeyedUnarchiver unarchiveObjectWithData:bondParameters.maturityDates];
                    
                    entries = [self saveDate:date withAttribute:entries andPosition:position];
                    bondParameters.maturityDates = [NSKeyedArchiver archivedDataWithRootObject:entries];
                    [[PersistManager instance] save];
                    bondValuesViewController.modelData = entries;
                    [bondValuesViewController.table reloadData];
                }];
                   break;
            }
             
            case 6:
            {
                bondValuesViewController.modelData = [NSKeyedUnarchiver unarchiveObjectWithData: bondParameters.couponRates];
                [bondValuesViewController onCompleteMany:^(NSString *text, int position) {
                    NSMutableArray* entries = [NSKeyedUnarchiver unarchiveObjectWithData:bondParameters.couponRates];
                    entries = [self saveValue:text withAttribute:entries andPosition:position];
                    bondParameters.couponRates = [NSKeyedArchiver archivedDataWithRootObject:entries];
                    [[PersistManager instance] save];
                    bondValuesViewController.modelData = entries;
                    [bondValuesViewController.table reloadData];
                }];
            }
                break;
            case 7:
            {
                bondValuesViewController.modelData = [NSKeyedUnarchiver unarchiveObjectWithData: bondParameters.marketQuotes];
                [bondValuesViewController onCompleteMany:^(NSString *text, int position) {
                    NSMutableArray* entries = [NSKeyedUnarchiver unarchiveObjectWithData:bondParameters.marketQuotes];
                    entries = [self saveValue:text withAttribute:entries andPosition:position];
                    bondParameters.marketQuotes = [NSKeyedArchiver archivedDataWithRootObject:entries];
                    [[PersistManager instance] save];
                    bondValuesViewController.modelData = entries;
                    [bondValuesViewController.table reloadData];
                }];
            }
                break;
            case 8:
            {
                bondValuesViewController.modelData = [NSKeyedUnarchiver unarchiveObjectWithData: bondParameters.liborForcastingCurveQuotes];
                [bondValuesViewController onCompleteMany:^(NSString *text, int position) {
                    NSMutableArray* entries = [NSKeyedUnarchiver unarchiveObjectWithData:bondParameters.liborForcastingCurveQuotes];
                    entries = [self saveValue:text withAttribute:entries andPosition:position];
                    bondParameters.liborForcastingCurveQuotes = [NSKeyedArchiver archivedDataWithRootObject:entries];
                    [[PersistManager instance] save];
                    bondValuesViewController.modelData = entries;
                    [bondValuesViewController.table reloadData];
                }];
            }
                break;
            case 9:
            {
                bondValuesViewController.modelData = [NSKeyedUnarchiver unarchiveObjectWithData: bondParameters.swapQuotes];
                
                [bondValuesViewController onCompleteMany:^(NSString *text, int position) {
                    NSMutableArray* entries = [NSKeyedUnarchiver unarchiveObjectWithData:bondParameters.swapQuotes];
                    entries = [self saveValue:text withAttribute:entries andPosition:position];
                    bondParameters.swapQuotes = [NSKeyedArchiver archivedDataWithRootObject:entries];
                    [[PersistManager instance] save];
                    bondValuesViewController.modelData = entries;
                    [bondValuesViewController.table reloadData];
                }];
            }
                break;
            case 10:
            {
                bondValuesViewController.modelData = [NSKeyedUnarchiver unarchiveObjectWithData:bondParameters.issueDates];
                
                 [bondValuesViewController onCompleteMany:^(NSString *text, int position) {
                     NSMutableArray* entries = [NSKeyedUnarchiver unarchiveObjectWithData:bondParameters.issueDates];
                     entries = [self saveValue:text withAttribute:entries andPosition:position];
                     bondParameters.issueDates = [NSKeyedArchiver archivedDataWithRootObject:entries];
                     [[PersistManager instance] save];
                     bondValuesViewController.modelData = entries;
                     [bondValuesViewController.table reloadData];
                 }];
                
            }
            case 11:
            {

                bondValuesViewController.modelData = [[NSMutableArray alloc] initWithObjects:bondParameters.zeroCouponBondFirstDate,bondParameters.zeroCouponBondSecondDate, nil];
                [bondValuesViewController onCompleteMany:^(NSString *text, int position) {
                    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                    [formatter setDateFormat:@"dd/mmm/yyyy"];
                    
                    switch (position) {
                        case 0:
                        {
                            bondParameters.zeroCouponBondFirstDate = [formatter dateFromString:text];
                            [[PersistManager instance] save];
                            bondValuesViewController.modelData[0] = bondParameters.zeroCouponBondFirstDate;
                            [bondValuesViewController.table reloadData];
                        }
                            break;
                            
                        case 1:
                        {
                            bondParameters.zeroCouponBondFirstDate = [formatter dateFromString:text];
                            [[PersistManager instance] save];
                            bondValuesViewController.modelData[1] = bondParameters.zeroCouponBondSecondDate;
                            [bondValuesViewController.table reloadData];
                        }
                            break;
                        default:
                            break;
                    }
                }];
                
                break;
            }
            case 12:
            {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
                [dateFormatter setDateFormat:@"dd-MM-yy"];
                bondValuesViewController.modelData = bondParameters.fixedRateBondFirstDate;
                [bondValuesViewController onComplete:^(NSString *text) {
                    [self saveValue:text withAttribute:bondParameters.fixedRateBondFirstDate];
                    
                }];
                break;
            }
            case 13:
            {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateStyle:NSDateFormatterMediumStyle];
                [formatter setDateFormat:@"dd-MM-yy"];
                bondValuesViewController.modelData = [[NSMutableArray alloc] initWithObjects:bondParameters.floatingBondScheduleFirstDate,bondParameters.floatingBondScheduleSecondDate, nil];
                
                [bondValuesViewController onCompleteMany:^(NSString *text, int position) {
                    switch (position) {
                        case 0:
                        {
                            bondParameters.floatingBondScheduleFirstDate = [formatter dateFromString:text];
                            [[PersistManager instance] save];
                            bondValuesViewController.modelData[0] = bondParameters.floatingBondScheduleFirstDate;
                            [bondValuesViewController.table reloadData];
                        }
                            break;
                            
                        case 1:
                        {
                            bondParameters.floatingBondScheduleSecondDate = [formatter dateFromString:text];
                            [[PersistManager instance] save];
                            bondValuesViewController.modelData[1] = bondParameters.floatingBondScheduleSecondDate;
                            [bondValuesViewController.table reloadData];
                        }
                            break;
                        default:
                            break;
                    }
                }];
                break;
            }
                
            default:
                if(string)
                    [bondValuesViewController.values addObject:string];
                break;
        }
        [bondValuesViewController.table reloadData];
    }
}


-(id) saveValue:(NSString *)textToSave withAttribute:(id)item {
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
#define IS_OBJECT(T) _Generic( (T), id: YES, default: NO)
    if(IS_OBJECT(item)) {
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        item = [f numberFromString:textToSave];
    }
    
    if ([item  isKindOfClass:[NSNumber class]]) {
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        [f setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
        item = [f numberFromString:textToSave];
        
    }
    if ([item class] == [NSString class]) {
        item = textToSave;
    }
    if ([item class] == [NSNumber class]) {
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        item = [f numberFromString:textToSave];
        
    }
    if ([item class] == [NSDate class]) {
        [formatter setDateFormat:@"dd/mmm/yyyy"];
        item = [formatter dateFromString:textToSave];
    }

    return item;
}


-(id) saveDate:(NSDate *)dateToSave withAttribute:(NSMutableArray *)entries andPosition:(int) position {
    [entries replaceObjectAtIndex:position withObject:dateToSave];
    return entries;
}

-(id) saveValue:(NSString *)textToSave withAttribute:(NSMutableArray *)entries andPosition:(int) position {
    id entry = [entries objectAtIndex:position];
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
#define IS_OBJECT(T) _Generic( (T), id: YES, default: NO)
    if(IS_OBJECT(entry)) {
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        [f setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
        entry = [f numberFromString:textToSave];
    }
    
    if ([entry  isKindOfClass:[NSNumber class]]) {
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        [f setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
        entry = [f numberFromString:textToSave];
        
    }
    if ([entry class] == [NSString class]) {
        entry = textToSave;
    }
    if ([entry class] == [NSNumber class]) {
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        [f setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
        entry = [f numberFromString:textToSave];
        
    }
    if ([entry class] == [NSDate class]) {
        [formatter setDateFormat:@"dd/mmm/yyyy"];
        entry = [formatter dateFromString:textToSave];
    }

    [entries replaceObjectAtIndex:position withObject:entry];
    return entries;
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
            cell.textLabel.text = @"Face Amount";
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
            cell.textLabel.text = @"Issue Dates";
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

- (IBAction) resetBond {
    NSMutableArray *results = [[QuantDao instance] getBond];
    // To clear the local store
    for (int i=0; i< results.count; i++) {
        DmBond *bond_ = results[i];
        [[QuantDao instance] remove:bond_];
    }
    [[PersistManager instance] save];
    exit(0);
    
    bondParameters = results[0];
    bondParameterInit =  [[ParameterInitializer alloc] init];
    [bondParameterInit setupParameters];
    
}

@end
