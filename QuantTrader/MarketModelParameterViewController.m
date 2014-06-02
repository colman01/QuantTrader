//
//  MarketModelParameterViewController.m
//  QuantTrader
//
//  Created by colman on 01.06.14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import "MarketModelParameterViewController.h"

#import "MarketMViewController.h"

@interface MarketModelParameterViewController ()

@end

@implementation MarketModelParameterViewController

@synthesize numberRates;
@synthesize accrual;
@synthesize firstTime;
@synthesize fixedRate;
@synthesize receive;
@synthesize seed;
@synthesize trainingPaths;
@synthesize paths;
@synthesize vegaPaths;
@synthesize rateLevel;
@synthesize initialNumeraireValue;
@synthesize volLevel;
@synthesize gamma;
@synthesize beta;
@synthesize numberOfFactors;
@synthesize displacementLevel;
@synthesize innerPaths;
@synthesize outerPaths;
@synthesize strike;
@synthesize fixedMultiplier;
@synthesize floatingSpread;
@synthesize payer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void) awakeFromNib {

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setValues];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void) setValues{
    strike.placeholder = @"200";
    numberRates.placeholder = @"20";
    accrual.placeholder = @".5";
    firstTime.placeholder = @".5";
    fixedRate.placeholder = @"20";
    
    receive.placeholder = @"-1.0";
    seed.placeholder = @"12332";
    trainingPaths.placeholder = @"10";
    paths.placeholder = @"2";
    vegaPaths.placeholder = @"2*64";
    rateLevel.placeholder = @"0.05";
    initialNumeraireValue.placeholder = @"0.95";
    volLevel.placeholder = @"0.11";
    gamma.placeholder = @"1.0";
    beta.placeholder = @"0.2";
    numberOfFactors.placeholder = @"5";
    displacementLevel.placeholder = @"0.02";
    innerPaths.placeholder = @"255";
    outerPaths.placeholder = @"256";
}


- (void) setupMarketModelParameters:(MarketMViewController  *) market {

    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSNumber *num = [[NSNumber alloc] init];
    
    if (self.numberRates.text.length > 0) {
        num = [f numberFromString:self.numberRates.text];
        market.market.numberRates = [num intValue];
    } else {
        num = [f numberFromString:self.numberRates.placeholder];
        market.market.numberRates = [num intValue];
    }

    if (self.accrual.text.length > 0) {
        num = [f numberFromString:self.accrual.text];
        market.accrual = [num floatValue];
    } else {
        num = [f numberFromString:self.accrual.placeholder];
        market.market.accrual = [num intValue];
    }
    
    if (self.accrual.text.length > 0) {
        num = [f numberFromString:self.firstTime.text];
        market.market.firstTime = [num floatValue];
    } else {
        num = [f numberFromString:self.firstTime.placeholder];
        market.market.firstTime = [num intValue];
    }
    
    if (self.fixedRate.text.length > 0) {
        num = [f numberFromString:self.fixedRate.text];
        market.market.fixedRate = [num floatValue];
    } else {
        num = [f numberFromString:self.fixedRate.placeholder];
        market.market.fixedRate = [num intValue];
    }
    
    if (self.receive.text.length > 0) {
        num = [f numberFromString:self.receive.text];
        market.market.receive = [num floatValue];
    } else {
        num = [f numberFromString:self.receive.placeholder];
        market.market.receive = [num intValue];
    }
    
    if (self.seed.text.length > 0) {
        num = [f numberFromString:self.seed.text];
        market.market.seed = [num intValue];
    } else {
        num = [f numberFromString:self.seed.placeholder];
        market.market.seed = [num intValue];
    }
    
    if (self.paths.text.length > 0) {
        num = [f numberFromString:self.paths.text];
        market.market.paths = [num intValue];
    } else {
        num = [f numberFromString:self.paths.placeholder];
        market.market.paths = [num intValue];
    }
    
    if (self.vegaPaths.text.length > 0) {
        num = [f numberFromString:self.vegaPaths.text];
        market.market.vegaPaths = [num intValue];
    } else {
        num = [f numberFromString:self.vegaPaths.placeholder];
        market.market.vegaPaths = [num intValue];
    }
    
    if (self.rateLevel.text.length > 0) {
        num = [f numberFromString:self.rateLevel.text];
        market.market.rateLevel = [num floatValue];
    } else {
        num = [f numberFromString:self.rateLevel.placeholder];
        market.market.rateLevel = [num intValue];
    }
    
    if (self.initialNumeraireValue.text.length > 0) {
        num = [f numberFromString:self.initialNumeraireValue.text];
        market.market.initialNumeraireValue = [num floatValue];
    } else {
        num = [f numberFromString:self.initialNumeraireValue.placeholder];
        market.market.initialNumeraireValue = [num intValue];
    }
    
    if (self.volLevel.text.length > 0) {
        num = [f numberFromString:self.volLevel.text];
        market.market.volLevel = [num floatValue];
    } else {
        num = [f numberFromString:self.volLevel.placeholder];
        market.market.volLevel = [num intValue];
    }
    
    if (self.beta.text.length > 0) {
        num = [f numberFromString:self.beta.text];
        market.market.beta = [num floatValue];
    } else {
        num = [f numberFromString:self.beta.placeholder];
        market.market.beta = [num intValue];
    }
    
    if (self.gamma.text.length > 0) {
        num = [f numberFromString:self.gamma.text];
        market.market.gamma = [num floatValue];
    } else {
        num = [f numberFromString:self.gamma.placeholder];
        market.market.gamma = [num intValue];
    }
    
    if (self.numberOfFactors.text.length > 0) {
        num = [f numberFromString:self.numberOfFactors.text];
        market.market.numberOfFactors = [num intValue];
    } else {
        num = [f numberFromString:self.numberOfFactors.placeholder];
        market.market.numberOfFactors = [num intValue];
    }
    
    if (self.displacementLevel.text.length > 0) {
        num = [f numberFromString:self.displacementLevel.text];
        market.market.displacementLevel = [num floatValue];
    } else {
        num = [f numberFromString:self.displacementLevel.placeholder];
        market.market.displacementLevel = [num intValue];
    }
    
    if (self.innerPaths.text.length > 0) {
        num = [f numberFromString:self.innerPaths.text];
        market.market.innerPaths = [num intValue];
    } else {
        num = [f numberFromString:self.innerPaths.placeholder];
        market.market.innerPaths = [num intValue];
    }
    
    if (self.outerPaths.text.length > 0) {
        num = [f numberFromString:self.outerPaths.text];
        market.market.outterPaths = [num intValue];
    } else {
        num = [f numberFromString:self.outerPaths.placeholder];
        market.market.outterPaths = [num intValue];
    }
    
    if (self.strike.text.length > 0) {
        num = [f numberFromString:self.strike.text];
        market.market.strike = [num intValue];
    } else {
        num = [f numberFromString:self.strike.placeholder];
        market.market.strike = [num intValue];
    }
    
    if (self.fixedMultiplier.text.length > 0) {
        num = [f numberFromString:self.outerPaths.text];
        market.market.fixedMultiplier = [num intValue];
    } else {
        num = [f numberFromString:self.fixedMultiplier.placeholder];
        market.market.fixedMultiplier = [num intValue];
    }
    
    if (self.floatingSpread.text.length > 0) {
        num = [f numberFromString:self.floatingSpread.text];
        market.market.floatingSpread = [num intValue];
    } else {
        num = [f numberFromString:self.floatingSpread.placeholder];
        market.market.floatingSpread = [num intValue];
    }
    
    self.payer.selected = market.payer;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"MarketModelResult"]) {
        MarketMViewController *marketModel = [[MarketMViewController alloc] init];
        id dest = segue.destinationViewController;
        marketModel = dest;
        [self setupMarketModelParameters:marketModel];
        
    }
}


@end
