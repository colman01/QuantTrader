//
//  MarketModelParameterViewController.h
//  QuantTrader
//
//  Created by colman on 01.06.14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuantDao.h"
#import "ParameterInitializer.h"

@interface MarketModelParameterViewController : UIViewController


@property (strong, nonatomic) IBOutlet UITextField *numberRates;
@property (strong, nonatomic) IBOutlet UITextField *accrual;
@property (strong, nonatomic) IBOutlet UITextField *firstTime;
@property (strong, nonatomic) IBOutlet UITextField *fixedRate;

@property (strong, nonatomic) IBOutlet UITextField *receive;
@property (strong, nonatomic) IBOutlet UITextField *seed;
@property (strong, nonatomic) IBOutlet UITextField *trainingPaths;
@property (strong, nonatomic) IBOutlet UITextField *paths;

@property (strong, nonatomic) IBOutlet UITextField *vegaPaths;
@property (strong, nonatomic) IBOutlet UITextField *rateLevel;
@property (strong, nonatomic) IBOutlet UITextField *initialNumeraireValue;
@property (strong, nonatomic) IBOutlet UITextField *volLevel;

@property (strong, nonatomic) IBOutlet UITextField *gamma;
@property (strong, nonatomic) IBOutlet UITextField *beta;
@property (strong, nonatomic) IBOutlet UITextField *numberOfFactors;
@property (strong, nonatomic) IBOutlet UITextField *displacementLevel;

@property (strong, nonatomic) IBOutlet UITextField *innerPaths;
@property (strong, nonatomic) IBOutlet UITextField *outerPaths;

@property (strong, nonatomic) IBOutlet UITextField *strike;
@property (strong, nonatomic) IBOutlet UITextField *fixedMultiplier;

@property (strong, nonatomic) IBOutlet UITextField *floatingSpread;
@property (strong, nonatomic) IBOutlet UISegmentedControl *payer;


@end
