//
//  MarketModelParameterViewController.m
//  QuantTrader
//
//  Created by colman on 01.06.14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import "MarketModelParameterViewController.h"

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

    DmMarketModel *marketParameters;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void) awakeFromNib {

}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupParameters];
    [self setValues];
    
    for (UIView *view in self.view.subviews) {
        if ([view class] == [UITextView class]) {
            UITextField *textField = (UITextField *) view;
            textField.keyboardType = UIKeyboardTypeDecimalPad;
        }
    }
    
    numberRates.keyboardType = UIKeyboardTypeDecimalPad;
    accrual.keyboardType = UIKeyboardTypeDecimalPad;
    firstTime.keyboardType = UIKeyboardTypeDecimalPad;
    fixedRate.keyboardType = UIKeyboardTypeDecimalPad;
    receive.keyboardType = UIKeyboardTypeDecimalPad;
    
    seed.keyboardType = UIKeyboardTypeDecimalPad;
    trainingPaths.keyboardType = UIKeyboardTypeDecimalPad;
    paths.keyboardType = UIKeyboardTypeDecimalPad;
    vegaPaths.keyboardType = UIKeyboardTypeDecimalPad;
    rateLevel.keyboardType = UIKeyboardTypeDecimalPad;
    
    initialNumeraireValue.keyboardType = UIKeyboardTypeDecimalPad;
    volLevel.keyboardType = UIKeyboardTypeDecimalPad;
    gamma.keyboardType = UIKeyboardTypeDecimalPad;
    beta.keyboardType = UIKeyboardTypeDecimalPad;
    numberOfFactors.keyboardType = UIKeyboardTypeDecimalPad;
    
    displacementLevel.keyboardType = UIKeyboardTypeDecimalPad;
    innerPaths.keyboardType = UIKeyboardTypeDecimalPad;
    outerPaths.keyboardType = UIKeyboardTypeDecimalPad;
    strike.keyboardType = UIKeyboardTypeDecimalPad;
    fixedMultiplier.keyboardType = UIKeyboardTypeDecimalPad;
    
    floatingSpread.keyboardType = UIKeyboardTypeDecimalPad;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



- (void) setupParameters {
    
    NSMutableArray *equityObjects = [[QuantDao instance] getMarketModel];
    
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
        marketParameters = equityObjects[0];
        if (!marketParameters) {
            parameterInit =  [[ParameterInitializer alloc] init];
            [parameterInit setupParameters];
        } else {
            
        }
    }
    @catch (NSException *exception) {
        marketParameters = [NSEntityDescription insertNewObjectForEntityForName:@"MarketModel" inManagedObjectContext:[[PersistManager instance] managedObjectContext]];
        
        [[PersistManager instance] save];
    }
}

- (void) setValues{
//    strike.placeholder          = [marketParameters.strike stringValue];
//    numberRates.placeholder     = [marketParameters.numberRates stringValue];
//    accrual.placeholder         = [marketParameters.accrual stringValue];
//    firstTime.placeholder       = [marketParameters.firstTime stringValue];
//    fixedRate.placeholder       = [marketParameters.fixedRate stringValue];
//    receive.placeholder         = [marketParameters.receive stringValue];
//    seed.placeholder            = [marketParameters.seed stringValue];
//    trainingPaths.placeholder   = [marketParameters.trainingPaths stringValue];
//    paths.placeholder           = [marketParameters.paths stringValue];
//    vegaPaths.placeholder       = [marketParameters.vegaPaths stringValue];
//    rateLevel.placeholder       = [marketParameters.rateLevel stringValue];
//    initialNumeraireValue.placeholder = [marketParameters.initialNumeraireValue stringValue];
//    volLevel.placeholder        = [marketParameters.volLevel stringValue];
//    gamma.placeholder           = [marketParameters.gamma stringValue];
//    beta.placeholder            = [marketParameters.beta stringValue];
//    numberOfFactors.placeholder = [marketParameters.numberOfFactors stringValue];
//    displacementLevel.placeholder = [marketParameters.displacementLevel stringValue];
//    innerPaths.placeholder      = [marketParameters.innerPaths stringValue];
//    outerPaths.placeholder      = [marketParameters.outterPaths stringValue];
//    fixedMultiplier.placeholder = [marketParameters.fixedMultiplier stringValue];
//    floatingSpread.placeholder = [marketParameters.floatingSpread stringValue];
    strike.text          = [marketParameters.strike stringValue];
    numberRates.text     = [marketParameters.numberRates stringValue];
    accrual.text         = [marketParameters.accrual stringValue];
    firstTime.text       = [marketParameters.firstTime stringValue];
    fixedRate.text       = [marketParameters.fixedRate stringValue];
    receive.text         = [marketParameters.receive stringValue];
    seed.text            = [marketParameters.seed stringValue];
    trainingPaths.text   = [marketParameters.trainingPaths stringValue];
    paths.text           = [marketParameters.paths stringValue];
    vegaPaths.text       = [marketParameters.vegaPaths stringValue];
    rateLevel.text       = [marketParameters.rateLevel stringValue];
    initialNumeraireValue.text = [marketParameters.initialNumeraireValue stringValue];
    volLevel.text        = [marketParameters.volLevel stringValue];
    gamma.text           = [marketParameters.gamma stringValue];
    beta.text            = [marketParameters.beta stringValue];
    numberOfFactors.text = [marketParameters.numberOfFactors stringValue];
    displacementLevel.text = [marketParameters.displacementLevel stringValue];
    innerPaths.text      = [marketParameters.innerPaths stringValue];
    outerPaths.text      = [marketParameters.outterPaths stringValue];
    fixedMultiplier.text = [marketParameters.fixedMultiplier stringValue];
    floatingSpread.text = [marketParameters.floatingSpread stringValue];
}


- (void) setupMarketModelParameters:(MarketMViewController  *) market {
    if (!market.market)
        market.market = [[MarketModels alloc] init];

    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    [f setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
    
    if (self.numberRates.text.length > 0) {
        marketParameters.numberRates = [f numberFromString:self.numberRates.text];
    } else {
        marketParameters.numberRates = [f numberFromString:self.numberRates.placeholder];
    }
    
    if (self.accrual.text.length > 0) {
        marketParameters.accrual = [f numberFromString:self.accrual.text];
    } else {
        marketParameters.accrual = [f numberFromString:self.accrual.placeholder];
    }
    
    if (self.firstTime.text.length > 0) {
        marketParameters.firstTime = [f numberFromString:self.firstTime.text];
    } else {
        marketParameters.firstTime = [f numberFromString:self.firstTime.placeholder];
    }
    if (self.fixedRate.text.length > 0) {
        marketParameters.fixedRate = [f numberFromString:self.fixedRate.text];
    } else {
        marketParameters.fixedRate = [f numberFromString:self.fixedRate.placeholder];
    }
    
    if (self.receive.text.length > 0) {
        marketParameters.receive = [f numberFromString:self.receive.text];
    } else {
        marketParameters.receive = [f numberFromString:self.receive.placeholder];
    }
    if (self.seed.text.length > 0) {
        marketParameters.seed = [f numberFromString:self.seed.text];
    } else {
        marketParameters.seed = [f numberFromString:self.seed.placeholder];
    }
    if (self.paths.text.length > 0) {
        marketParameters.paths = [f numberFromString:self.paths.text];
    } else {
        marketParameters.paths = [f numberFromString:self.paths.placeholder];
    }
    
    if (self.vegaPaths.text.length > 0) {
        marketParameters.vegaPaths = [f numberFromString:self.vegaPaths.text];
    } else {
        marketParameters.vegaPaths = [f numberFromString:self.vegaPaths.placeholder];
    }
    
    if (self.rateLevel.text.length > 0) {
        marketParameters.rateLevel = [f numberFromString:self.rateLevel.text];
    } else {
        marketParameters.rateLevel = [f numberFromString:self.rateLevel.placeholder];
    }
    if (self.initialNumeraireValue.text.length > 0) {
        marketParameters.initialNumeraireValue = [f numberFromString:self.initialNumeraireValue.text];
    } else {
        marketParameters.initialNumeraireValue = [f numberFromString:self.initialNumeraireValue.placeholder];
    }
    if (self.volLevel.text.length > 0) {
        marketParameters.volLevel = [f numberFromString:self.volLevel.text];
    } else {
        marketParameters.volLevel = [f numberFromString:self.volLevel.placeholder];
    }
    
    if (self.beta.text.length > 0) {
        marketParameters.beta = [f numberFromString:self.beta.text];
    } else {
        marketParameters.beta = [f numberFromString:self.beta.placeholder];
    }
    
    if (self.gamma.text.length > 0) {
        marketParameters.gamma = [f numberFromString:self.gamma.text];
    } else {
        marketParameters.gamma = [f numberFromString:self.gamma.placeholder];
    }
    
    if (self.numberOfFactors.text.length > 0) {
        marketParameters.numberOfFactors = [f numberFromString:self.numberOfFactors.text];
    } else {
        marketParameters.numberOfFactors = [f numberFromString:self.numberOfFactors.placeholder];
    }
    if (self.displacementLevel.text.length > 0) {
        marketParameters.displacementLevel = [f numberFromString:self.displacementLevel.text];
    } else {
        marketParameters.displacementLevel = [f numberFromString:self.displacementLevel.placeholder];
    }
    
    if (self.innerPaths.text.length > 0) {
        marketParameters.innerPaths = [f numberFromString:self.innerPaths.text];
    } else {
        marketParameters.innerPaths = [f numberFromString:self.innerPaths.placeholder];
    }
    
    if (self.outerPaths.text.length > 0) {
        marketParameters.outterPaths = [f numberFromString:self.outerPaths.text];
    } else {
        marketParameters.outterPaths = [f numberFromString:self.outerPaths.placeholder];
    }
    
    if (self.strike.text.length > 0) {
        marketParameters.strike  = [f numberFromString:self.strike.text];
    } else {
        marketParameters.strike  = [f numberFromString:self.strike.placeholder];
    }
    
    if (self.fixedMultiplier.text.length > 0) {
        marketParameters.fixedMultiplier =  [f numberFromString:self.outerPaths.text];
    } else {
        marketParameters.fixedMultiplier =  [f numberFromString:self.outerPaths.placeholder];
    }
    
    if (self.floatingSpread.text.length > 0) {
        marketParameters.floatingSpread = [f numberFromString:self.floatingSpread.text];
    } else {
        [f numberFromString:self.floatingSpread.placeholder];
    }
    
    if (self.trainingPaths.text.length > 0) {
        marketParameters.trainingPaths = [f numberFromString:self.trainingPaths.text];
    } else {
        [f numberFromString:self.trainingPaths.placeholder];
    }


//    if (self.numberRates.text.length > 0) {
//        marketParameters.numberRates = [f numberFromString:self.numberRates.text];
//    } else {
//        marketParameters.numberRates = [f numberFromString:self.numberRates.placeholder];
//    }
//
//    if (self.accrual.text.length > 0) {
//        marketParameters.accrual = [f numberFromString:self.accrual.text];
//    } else {
//        marketParameters.accrual = [f numberFromString:self.accrual.placeholder];
//    }
//    
//    if (self.firstTime.text.length > 0) {
//        marketParameters.firstTime = [f numberFromString:self.firstTime.text];
//    } else {
//        marketParameters.firstTime = [f numberFromString:self.firstTime.placeholder];
//    }
//    if (self.fixedRate.text.length > 0) {
//        marketParameters.fixedRate = [f numberFromString:self.fixedRate.text];
//    } else {
//        marketParameters.fixedRate = [f numberFromString:self.fixedRate.placeholder];
//    }
//    
//    if (self.receive.text.length > 0) {
//        marketParameters.receive = [f numberFromString:self.receive.text];
//    } else {
//        marketParameters.receive = [f numberFromString:self.receive.placeholder];
//    }
//    if (self.seed.text.length > 0) {
//        marketParameters.seed = [f numberFromString:self.seed.text];
//    } else {
//        marketParameters.seed = [f numberFromString:self.seed.placeholder];
//    }
//    if (self.paths.text.length > 0) {
//        marketParameters.paths = [f numberFromString:self.paths.text];
//    } else {
//        marketParameters.paths = [f numberFromString:self.paths.placeholder];
//    }
//    
//    if (self.vegaPaths.text.length > 0) {
//        marketParameters.vegaPaths = [f numberFromString:self.vegaPaths.text];
//    } else {
//        marketParameters.vegaPaths = [f numberFromString:self.vegaPaths.placeholder];
//    }
//    
//    if (self.rateLevel.text.length > 0) {
//        marketParameters.rateLevel = [f numberFromString:self.rateLevel.text];
//    } else {
//        marketParameters.rateLevel = [f numberFromString:self.rateLevel.placeholder];
//    }
//    if (self.initialNumeraireValue.text.length > 0) {
//        marketParameters.initialNumeraireValue = [f numberFromString:self.initialNumeraireValue.text];
//    } else {
//        marketParameters.initialNumeraireValue = [f numberFromString:self.initialNumeraireValue.placeholder];
//    }
//    if (self.volLevel.text.length > 0) {
//        marketParameters.volLevel = [f numberFromString:self.volLevel.text];
//    } else {
//        marketParameters.volLevel = [f numberFromString:self.volLevel.placeholder];
//    }
//    
//    if (self.beta.text.length > 0) {
//        marketParameters.beta = [f numberFromString:self.beta.text];
//    } else {
//        marketParameters.beta = [f numberFromString:self.beta.placeholder];
//    }
//    
//    if (self.gamma.text.length > 0) {
//        marketParameters.gamma = [f numberFromString:self.gamma.text];
//    } else {
//        marketParameters.gamma = [f numberFromString:self.gamma.placeholder];
//    }
//    
//    if (self.numberOfFactors.text.length > 0) {
//        marketParameters.numberOfFactors = [f numberFromString:self.numberOfFactors.text];
//    } else {
//        marketParameters.numberOfFactors = [f numberFromString:self.numberOfFactors.placeholder];
//    }
//    if (self.displacementLevel.text.length > 0) {
//        marketParameters.displacementLevel = [f numberFromString:self.displacementLevel.text];
//    } else {
//        marketParameters.displacementLevel = [f numberFromString:self.displacementLevel.placeholder];
//    }
//    
//    if (self.innerPaths.text.length > 0) {
//        marketParameters.innerPaths = [f numberFromString:self.innerPaths.text];
//    } else {
//        marketParameters.innerPaths = [f numberFromString:self.innerPaths.placeholder];
//    }
//    
//    if (self.outerPaths.text.length > 0) {
//        marketParameters.outterPaths = [f numberFromString:self.outerPaths.text];
//    } else {
//        marketParameters.outterPaths = [f numberFromString:self.outerPaths.placeholder];
//    }
//    
//    if (self.strike.text.length > 0) {
//        marketParameters.strike  = [f numberFromString:self.strike.text];
//    } else {
//        marketParameters.strike  = [f numberFromString:self.strike.placeholder];
//    }
//    
//    if (self.fixedMultiplier.text.length > 0) {
//        marketParameters.fixedMultiplier =  [f numberFromString:self.outerPaths.text];
//    } else {
//        marketParameters.fixedMultiplier =  [f numberFromString:self.outerPaths.placeholder];
//    }
//    
//    if (self.floatingSpread.text.length > 0) {
//        marketParameters.floatingSpread = [f numberFromString:self.floatingSpread.text];
//    } else {
//        [f numberFromString:self.floatingSpread.placeholder];
//    }
//    
//    if (self.trainingPaths.text.length > 0) {
//        marketParameters.trainingPaths = [f numberFromString:self.trainingPaths.text];
//    } else {
//        [f numberFromString:self.trainingPaths.placeholder];
//    }
    
    
    [[PersistManager instance] save];
    
    self.payer.selected = market.payer;
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"MarketModelResult"]) {
        
        [self setupMarketModelParameters:self.marketModelResults];
        
        MarketMViewController * dest = (MarketMViewController *)segue.destinationViewController;
        self.marketModelResults = segue.destinationViewController;
        
        dest.market              = self.marketModelResults.market;
        dest.market.delta        = self.marketModelResults.market.delta;
        dest.hostView            = self.marketModelResults.hostView;
        dest.priceAnnotation     = self.marketModelResults.priceAnnotation;
        dest.graphContainer      = self.marketModelResults.graphContainer;
        dest.multiplierCutOff    = self.marketModelResults.multiplierCutOff;
        dest.projectionTolerance = self.marketModelResults.projectionTolerance;
        dest.payer               = self.marketModelResults.payer;
    }
}


@end
