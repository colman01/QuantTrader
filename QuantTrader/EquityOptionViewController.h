//
//  EquityOptionViewController.h
//  QuantLibExample
//
//  Created by colman on 28.06.13.
//  Copyright (c) 2013 Striding Edge Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EquityOption_.h"

@interface EquityOptionViewController : UIViewController {

    IBOutlet UITextField * settlementDate_1;
    IBOutlet UITextField * settlementDate_2;
    IBOutlet UITextField * settlementDate_3;
    
    IBOutlet UITextField * maturityDate_1;
    IBOutlet UITextField * maturityDate_2;
    IBOutlet UITextField * maturityDate_3;
    
    IBOutlet UITextField * underlying;
    IBOutlet UITextField * strike;
    IBOutlet UITextField * dividendYield;
    IBOutlet UITextField * riskFreeRate;
    IBOutlet UITextField * volatility;
    
    IBOutlet UILabel * blackScholes_eo;
    IBOutlet UILabel * hestonSemiAnalytic_eo;
    IBOutlet UILabel * batesSemiAna_eo;
    IBOutlet UILabel * baroneAdesiWhaleySemiAna_eo;
    IBOutlet UILabel * bjerksundStenslandSemiAna_eo;

    IBOutlet UILabel * integral_eo;
    IBOutlet UILabel * finiteDifference_eo;

    IBOutlet UILabel * finiteDifference_bo;
    IBOutlet UILabel * binomialJarrowRudd_eo;
    IBOutlet UILabel * binomialJarrowRudd_bo;
    IBOutlet UILabel * binomialJarrowRudd_ao;
    
    IBOutlet UILabel * binomialCoxRossRubinstein_eo;
    IBOutlet UILabel * binomialCoxRossRubinstein_bo;
    IBOutlet UILabel * binomialCoxRossRubinstein_ao;
    IBOutlet UILabel * additiveEquiprobabilities_eo;
    IBOutlet UILabel * additiveEquiprobabilities_bo;
    IBOutlet UILabel * additiveEquiprobabilities_ao;
    
    IBOutlet UILabel * binomialTrigeorgis_eo;
    IBOutlet UILabel * binomialTrigeorgis_bo;
    IBOutlet UILabel * binomialTrigeorgis_ao;
    IBOutlet UILabel * binomialTian_eo;
    IBOutlet UILabel * binomialTian_bo;
    IBOutlet UILabel * binomialTian_ao;
    
    IBOutlet UILabel * binomialLeisenReimer_eo;
    IBOutlet UILabel * binomialLeisenReimer_bo;
    IBOutlet UILabel * binomialLeisenReimer_ao;
    IBOutlet UILabel * binomialJoshi_eo;
    IBOutlet UILabel * binomialJoshi_bo;
    IBOutlet UILabel * binomialJoshi_ao;
    
    IBOutlet UILabel * mcCrude_eo;
    IBOutlet UILabel * qmcSobol_eo;
    IBOutlet UILabel * mcLongstaffSchwatz_ao;
    
    
    
    
    EquityOption_ * eq;
    
    
}

@property (nonatomic, retain) IBOutlet UIViewController *waiting;
@property (nonatomic, retain) IBOutlet UIViewController *results;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;



@property (nonatomic, retain) IBOutlet UITextField * settlementDate_1;
@property (nonatomic, retain) IBOutlet UITextField * settlementDate_2;
@property (nonatomic, retain) IBOutlet UITextField * settlementDate_3;

@property (nonatomic, retain) IBOutlet UITextField * maturityDate_1;
@property (nonatomic, retain) IBOutlet UITextField * maturityDate_2;
@property (nonatomic, retain) IBOutlet UITextField * maturityDate_3;

@property (nonatomic, retain) IBOutlet UITextField * underlying;
@property (nonatomic, retain) IBOutlet UITextField * strike;
@property (nonatomic, retain) IBOutlet UITextField * dividendYield;
@property (nonatomic, retain) IBOutlet UITextField * riskFreeRate;
@property (nonatomic, retain) IBOutlet UITextField * volatility;

@property (nonatomic, retain) IBOutlet UILabel * blackScholes_eo;
@property (nonatomic, retain) IBOutlet UILabel * hestonSemiAnalytic_eo;
@property (nonatomic, retain) IBOutlet UILabel * batesSemiAna_eo;
@property (nonatomic, retain) IBOutlet UILabel * baroneAdesiWhaleySemiAna_eo;
@property (nonatomic, retain) IBOutlet UILabel * bjerksundStenslandSemiAna_eo;

@property (nonatomic, retain) IBOutlet UILabel * integral_eo;
@property (nonatomic, retain) IBOutlet UILabel * finiteDifference_eo;

@property (nonatomic, retain) IBOutlet UILabel * finiteDifference_bo;
@property (nonatomic, retain) IBOutlet UILabel * binomialJarrowRudd_eo;
@property (nonatomic, retain) IBOutlet UILabel * binomialJarrowRudd_bo;
@property (nonatomic, retain) IBOutlet UILabel * binomialJarrowRudd_ao;

@property (nonatomic, retain) IBOutlet UILabel * binomialCoxRossRubinstein_eo;
@property (nonatomic, retain) IBOutlet UILabel * binomialCoxRossRubinstein_bo;
@property (nonatomic, retain) IBOutlet UILabel * binomialCoxRossRubinstein_ao;
@property (nonatomic, retain) IBOutlet UILabel * additiveEquiprobabilities_eo;
@property (nonatomic, retain) IBOutlet UILabel * additiveEquiprobabilities_bo;
@property (nonatomic, retain) IBOutlet UILabel * additiveEquiprobabilities_ao;

@property (nonatomic, retain) IBOutlet UILabel * binomialTrigeorgis_eo;
@property (nonatomic, retain) IBOutlet UILabel * binomialTrigeorgis_bo;
@property (nonatomic, retain) IBOutlet UILabel * binomialTrigeorgis_ao;
@property (nonatomic, retain) IBOutlet UILabel * binomialTian_eo;
@property (nonatomic, retain) IBOutlet UILabel * binomialTian_bo;
@property (nonatomic, retain) IBOutlet UILabel * binomialTian_ao;

@property (nonatomic, retain) IBOutlet UILabel * binomialLeisenReimer_eo;
@property (nonatomic, retain) IBOutlet UILabel * binomialLeisenReimer_bo;
@property (nonatomic, retain) IBOutlet UILabel * binomialLeisenReimer_ao;
@property (nonatomic, retain) IBOutlet UILabel * binomialJoshi_eo;
@property (nonatomic, retain) IBOutlet UILabel * binomialJoshi_bo;
@property (nonatomic, retain) IBOutlet UILabel * binomialJoshi_ao;

@property (nonatomic, retain) IBOutlet UILabel * mcCrude_eo;
@property (nonatomic, retain) IBOutlet UILabel * qmcSobol_eo;
@property (nonatomic, retain) IBOutlet UILabel * mcLongstaffSchwatz_ao;

@property (nonatomic, retain) IBOutlet UIButton * showResults;

- (IBAction)textEntered:(UITextField *)sender;

- (IBAction)calculate;

- (IBAction)hide:(id)sender;




@end






//    integral_eo,
//    finiteDifference_eo,
//    finiteDifference_bo,
//    //finiteDifference_ao,
//    binomialJarrowRudd_eo,
//    binomialJarrowRudd_bo,
//    binomialJarrowRudd_ao,
//    binomialCoxRossRubinstein_eo,
//    binomialCoxRossRubinstein_bo,
//    binomialCoxRossRubinstein_ao,
//    additiveEquiprobabilities_eo,
//    additiveEquiprobabilities_bo,
//    additiveEquiprobabilities_ao,
//    binomialTrigeorgis_eo,
//    binomialTrigeorgis_bo,
//    binomialTrigeorgis_ao,
//    binomialTian_eo,
//    binomialTian_bo,
//    binomialTian_ao,
//    binomialLeisenReimer_eo,
//    binomialLeisenReimer_bo,
//    binomialLeisenReimer_ao,
//    binomialJoshi_eo,
//    binomialJoshi_bo,
//    binomialJoshi_ao,
//    mcCrude_eo,
//    qmcSobol_eo,
//    mcLongstaffSchwatz_ao;




//    blackScholes_eo.text = [[NSNumber numberWithDouble:eq.blackScholes_eo] stringValue];
//    hestonSemiAnalytic_eo.text = [[NSNumber numberWithInt:eq.hestonSemiAnalytic_eo] stringValue];



//                                     NSArray * nibObjects = [[NSBundle mainBundle] loadNibNamed:@"EquityOptionResults" owner:self options:nil];
//                                     UIView * nibVC = [nibObjects objectAtIndex:0];
//                                     results = [[UIViewController alloc] init];
//                                     [results setView:nibVC];
//                                     [self setResultsVC];
//                                     [results setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
//                                     [self presentModalViewController:results animated:YES];
//
//                                     UIViewController *eqResults=[[UIViewController  alloc] initWithNibName:@"EquityOptionResults" bundle:nil];
//                                     [[super navigationController] pushViewController:eqResults animated:YES];
//                                     [self setResultsVC];

//                                 }];



//     [self presentModalViewController:results animated:YES];

//     UIViewController *eqResults=[[UIViewController  alloc] initWithNibName:@"EquityOptionResults" bundle:nil];
//     [[super navigationController] pushViewController:eqResults animated:YES];
//     [self setResultsVC];


//    UIViewController *eqResults=[[UIViewController  alloc] initWithNibName:@"EquityOptionResults" bundle:nil];
//    [[super navigationController] pushViewController:eqResults animated:YES];
//    [self setResultsVC];



//    [self presentViewController:waiting animated:YES completion:^{
//        [self setCalcValues];
//        [eq calculate];
//
//
//        UIViewController *eqResults=[[UIViewController  alloc] initWithNibName:@"EquityOptionResults" bundle:nil];
//        [[super navigationController] pushViewController:eqResults animated:YES];
//        [self setResultsVC];


//        [self dismissViewControllerAnimated:YES
//                                 completion:^{
//                                     NSArray * nibObjects = [[NSBundle mainBundle] loadNibNamed:@"EquityOptionResults" owner:self options:nil];
//                                      UIView * nibVC = [nibObjects objectAtIndex:0];
//                                     results = [[UIViewController alloc] init];
//                                     [results setView:nibVC];
//                                     [self setResultsVC];
//                                     [results setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
//                                     [self presentModalViewController:results animated:YES];
//
//                                     UIViewController *eqResults=[[UIViewController  alloc] initWithNibName:@"EquityOptionResults" bundle:nil];
//                                     [[super navigationController] pushViewController:eqResults animated:YES];
//                                     [self setResultsVC];
//
//                                 }];
//    }];