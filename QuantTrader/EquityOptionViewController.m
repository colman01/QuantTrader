//
//  EquityOptionViewController.m
//  QuantLibExample
//
//  Created by colman on 28.06.13.
//  Copyright (c) 2013 Striding Edge Technologies. All rights reserved.
//

#import "EquityOptionViewController.h"

@interface EquityOptionViewController ()

@end

@implementation EquityOptionViewController
@synthesize waiting, results, showResults, scroll;
@synthesize blackScholes_eo,
hestonSemiAnalytic_eo,
batesSemiAna_eo,
baroneAdesiWhaleySemiAna_eo,
bjerksundStenslandSemiAna_eo,
integral_eo,
finiteDifference_eo,
finiteDifference_bo,
//finiteDifference_ao,
binomialJarrowRudd_eo,
binomialJarrowRudd_bo,
binomialJarrowRudd_ao,
binomialCoxRossRubinstein_eo,
binomialCoxRossRubinstein_bo,
binomialCoxRossRubinstein_ao,
additiveEquiprobabilities_eo,
additiveEquiprobabilities_bo,
additiveEquiprobabilities_ao,
binomialTrigeorgis_eo,
binomialTrigeorgis_bo,
binomialTrigeorgis_ao,
binomialTian_eo,
binomialTian_bo,
binomialTian_ao,
binomialLeisenReimer_eo,
binomialLeisenReimer_bo,
binomialLeisenReimer_ao,
binomialJoshi_eo,
binomialJoshi_bo,
binomialJoshi_ao,
mcCrude_eo,
qmcSobol_eo,
mcLongstaffSchwatz_ao;

DmEquity *equityParameters;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    showResults.titleLabel.numberOfLines = 0;
    showResults.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    showResults.titleLabel.textAlignment = NSTextAlignmentCenter;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSMutableArray *equityObjects = [[QuantDao instance] getEquity];
    
    // To clear the local store
    //    for (int i=0; i< results.count; i++) {
    //        DmBond *bond_ = results[i];
    //        [[QuantDao instance] remove:bond_];
    //    }
    //    [[PersistManager instance] save];
    //    exit(0);


    ParameterInitializer *parameterInit;
    
    parameterInit =  [[ParameterInitializer alloc] init];
    [parameterInit setupParameters];
    
    @try {
        equityParameters = equityObjects[0];
        if (!equityParameters) {
            parameterInit =  [[ParameterInitializer alloc] init];
            [parameterInit setupParameters];
        } else {

        }
    }
    @catch (NSException *exception) {
        equityParameters = [NSEntityDescription insertNewObjectForEntityForName:@"Equity" inManagedObjectContext:[[PersistManager instance] managedObjectContext]];

        [[PersistManager instance] save];
    }

    eq = [[EquityOption_ alloc] init];
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    [scroll setContentOffset:CGPointMake(0,0)];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)textEntered:(UITextField *)send {
    [send resignFirstResponder];
}

-(void) setCalcValues {
    equityParameters.underlying_eq = [NSNumber numberWithDouble:[self.underlying.text doubleValue]];
    equityParameters.strike_eq= [NSNumber numberWithDouble:[self.strike.text doubleValue]];
    equityParameters.dividendYield_eq= [NSNumber numberWithDouble:[self.dividendYield.text doubleValue]];
    equityParameters.riskFreeRate_eq= [NSNumber numberWithDouble:[self.riskFreeRate.text doubleValue]];
    equityParameters.volatility_eq= [NSNumber numberWithDouble:[self.volatility.text doubleValue]];

    [[PersistManager instance] save];
    
    
}

- (IBAction)calculate {
    
    
    [self setCalcValues];
    
    [self performSegueWithIdentifier:@"EquityResults" sender:nil];

//    
//    NSArray * nibObjects = [[NSBundle mainBundle] loadNibNamed:@"EquityOptionResults" owner:self options:nil];
//    UIView * nibVC = [nibObjects objectAtIndex:0];
//    results = [[UIViewController alloc] init];
//    [results setView:nibVC];
//    [self setResultsVC];
//    [results setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
//
//    [eq calculate];
//    [self setResultsVC];
//    [[self navigationController] pushViewController:results animated:YES ];
    
//    [self dismissViewControllerAnimated:YES
//                             completion:^{
//                                 [[super navigationController] pushViewController:results animated:YES ];
//                             }
//     ];
    
//    [[super navigationController] presentViewController:waiting animated:YES completion:^{
//        [eq calculate];
//        [self setResultsVC];
//        [self dismissViewControllerAnimated:YES
//                                 completion:^{
//                                     [[super navigationController] pushViewController:results animated:YES ];
//                                  }
//        ];
//    }];
    
    

}

- (IBAction)calculateWithSegue {
    
}


-(void) setResultsVC {
    blackScholes_eo.text =  [@"Black Scholes:\n € " stringByAppendingString:[[NSNumber numberWithDouble:eq.blackScholes_eo] stringValue]];
    hestonSemiAnalytic_eo.text = [@"Heston Semi Analytic:\n €" stringByAppendingString:[[NSNumber numberWithDouble:eq.hestonSemiAnalytic_eo]stringValue] ];
    
    NSString * value = @"";
    value = [[NSNumber numberWithDouble:eq.batesSemiAna_eo] stringValue];
    batesSemiAna_eo.text = [@"Bates Semi Analytic:\n €" stringByAppendingString:value];
    value = [[NSNumber numberWithDouble:eq.baroneAdesiWhaleySemiAna_eo] stringValue];
    baroneAdesiWhaleySemiAna_eo.text = [@"Barone Adesi Whaley Semi Analytic:\n €" stringByAppendingString:value];
    value = [[NSNumber numberWithDouble:eq.bjerksundStenslandSemiAna_eo] stringValue];
    bjerksundStenslandSemiAna_eo.text = [@"Bjerksund Stensland Semi Analytic:\n €" stringByAppendingString:value];
    integral_eo.text = [[NSNumber numberWithDouble:eq.integral_eo] stringValue];
    
    value = [[NSNumber numberWithDouble:eq.finiteDifference_eo] stringValue];
    finiteDifference_eo.text = [@"Finite Difference European Option:\n €" stringByAppendingString:value];
    value = [[NSNumber numberWithDouble:eq.finiteDifference_bo] stringValue];
    finiteDifference_bo.text = [@"Finite Difference Bermudian Option:\n €" stringByAppendingString:value];
    
    value = [[NSNumber numberWithDouble:eq.binomialJarrowRudd_eo] stringValue];
    binomialJarrowRudd_eo.text = [@"Binomial Jarrow Rudd:\n €" stringByAppendingString:value];
    value = [[NSNumber numberWithDouble:eq.binomialJarrowRudd_ao] stringValue];
    binomialJarrowRudd_ao.text = [@"Binomial Jarrow Rudd Americal Option:\n €" stringByAppendingString:value];
    value = [[NSNumber numberWithDouble:eq.binomialJarrowRudd_bo] stringValue];
    binomialJarrowRudd_bo.text = [@"Binomial Jarrow Rudd Bermudian Option:\n €" stringByAppendingString:value];
    
    value = [[NSNumber numberWithDouble:eq.binomialCoxRossRubinstein_eo] stringValue];
    binomialCoxRossRubinstein_eo.text = [@"Binomial Cox Ross Rubinstein European Option: \n €" stringByAppendingString:value];
    value = [[NSNumber numberWithDouble:eq.binomialCoxRossRubinstein_bo] stringValue];
    binomialCoxRossRubinstein_bo.text = [@"Binomial Cox Ross Rubinstein Bermudian Option: \n €" stringByAppendingString:value];
    value = [[NSNumber numberWithDouble:eq.binomialCoxRossRubinstein_ao] stringValue];
    binomialCoxRossRubinstein_ao.text = [@"Binomial Cox Ross Rubinstein Americal Option: \n €" stringByAppendingString:value];
    
    
    value = [[NSNumber numberWithDouble:eq.additiveEquiprobabilities_eo] stringValue];
    additiveEquiprobabilities_eo.text = [@"Additive Equiprobabilities European Option: \n €" stringByAppendingString:value];
    value = [[NSNumber numberWithDouble:eq.additiveEquiprobabilities_bo] stringValue];
    additiveEquiprobabilities_bo.text = [@"Additive Equiprobabilities Bermudian Option: \n €" stringByAppendingString:value];
    value = [[NSNumber numberWithDouble:eq.additiveEquiprobabilities_ao] stringValue];
    additiveEquiprobabilities_ao.text = [@"Additive Equiprobabilities American Option: \n €" stringByAppendingString:value];
    
    value = [[NSNumber numberWithDouble:eq.binomialTrigeorgis_eo] stringValue];
    binomialTrigeorgis_eo.text = [@"Binomial Trigeoris European Option: \n €" stringByAppendingString:value];
    value = [[NSNumber numberWithDouble:eq.binomialTrigeorgis_bo] stringValue];
    binomialTrigeorgis_bo.text = [@"Binomial Trigeoris European Option: \n €" stringByAppendingString:value];
    value = [[NSNumber numberWithDouble:eq.binomialTrigeorgis_ao] stringValue];
    binomialTrigeorgis_ao.text = [@"Binomial Trigeoris European Option: \n €" stringByAppendingString:value];
    
    
    value = [[NSNumber numberWithDouble:eq.binomialTian_eo] stringValue];
    binomialTian_eo.text = [@"Binomial Tian European Option: \n €" stringByAppendingString:value];
    value = [[NSNumber numberWithDouble:eq.binomialTian_bo] stringValue];
    binomialTian_bo.text = [@"Binomial Tian Bermudian Option: \n €" stringByAppendingString:value];
    value = [[NSNumber numberWithDouble:eq.binomialTian_ao] stringValue];
    binomialTian_ao.text = [@"Binomial Tian American Option: \n €" stringByAppendingString:value];
    
    value = [[NSNumber numberWithDouble:eq.binomialLeisenReimer_eo] stringValue];
    binomialLeisenReimer_eo.text = [@"Binomial Leisen Reimer European Option: \n €" stringByAppendingString:value];
    value = [[NSNumber numberWithDouble:eq.binomialLeisenReimer_bo] stringValue];
    binomialLeisenReimer_bo.text = [@"Binomial Leisen Reimer Bermudian Option: \n €" stringByAppendingString:value];
    value = [[NSNumber numberWithDouble:eq.binomialLeisenReimer_ao] stringValue];
    binomialLeisenReimer_ao.text = [@"Binomial Leisen Reimer American Option: \n €" stringByAppendingString:value];
    
    value = [[NSNumber numberWithDouble:eq.binomialJoshi_eo] stringValue];
    binomialJoshi_eo.text = [@"Binomial Joshi European Option: \n €" stringByAppendingString:value];
    value = [[NSNumber numberWithDouble:eq.binomialJoshi_bo] stringValue];
    binomialJoshi_bo.text = [@"Binomial Joshi Bermudan Option: \n €" stringByAppendingString:value];
    value = [[NSNumber numberWithDouble:eq.binomialJoshi_ao] stringValue];
    binomialJoshi_ao.text = [@"Binomial Joshi American Option: \n €" stringByAppendingString:value];
    
    value = [[NSNumber numberWithDouble:eq.mcCrude_eo] stringValue];
    mcCrude_eo.text = [@"McCrude European Option: \n €" stringByAppendingString:value];
    value = [[NSNumber numberWithDouble:eq.qmcSobol_eo] stringValue];
    qmcSobol_eo.text = [@"QmcSobol European Option: \n €" stringByAppendingString:value];
    value = [[NSNumber numberWithDouble:eq.mcLongstaffSchwatz_ao] stringValue];
    mcLongstaffSchwatz_ao.text = [@"McLongstaff Schwartz American Option: \n €" stringByAppendingString:value];
}

- (IBAction)hide:(id)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)show:(id)sender {

    if (results != nil) {
        [[super navigationController] pushViewController:results animated:YES];
    } else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Nothing Calculated" message:@"Press calculate" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        [alert show];
    }
}



@end
