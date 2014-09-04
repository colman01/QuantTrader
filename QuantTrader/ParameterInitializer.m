//
//  ParameterInitializer.m
//  QuantTrader
//
//  Created by colman on 22/07/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import "ParameterInitializer.h"

@implementation ParameterInitializer

- (void) setupParameters {
    [self setupBond];
    [self setupEquity];
    [self setupMarketModel];
}

-(void) setupMarketModel {
    DmMarketModel *marketParameters;
    NSMutableArray *results = [[QuantDao instance] getMarketModel];
    
    @try {
        marketParameters = results[0];
    }
    @catch (NSException *exception) {
    }
    
    marketParameters.strike = [NSNumber numberWithDouble:200];
    marketParameters.numberRates = [NSNumber numberWithDouble:20];
    marketParameters.accrual = [NSNumber numberWithDouble:.5];

    marketParameters.firstTime = [NSNumber numberWithFloat:0.5];
    marketParameters.fixedRate = [NSNumber numberWithDouble:20];
    marketParameters.receive = [NSNumber numberWithDouble:-1.0];
    marketParameters.seed = [NSNumber numberWithDouble:12332];
    marketParameters.trainingPaths = [NSNumber numberWithDouble:13107];
    marketParameters.paths = [NSNumber numberWithDouble:13107];
    
    marketParameters.vegaPaths = [NSNumber numberWithDouble:(2*64)];
    marketParameters.rateLevel = [NSNumber numberWithDouble:0.05];
    marketParameters.initialNumeraireValue = [NSNumber numberWithDouble:.95];
    marketParameters.volLevel = [NSNumber numberWithDouble:.11];
    marketParameters.gamma = [NSNumber numberWithDouble:1.0];
    marketParameters.beta = [NSNumber numberWithDouble:0.2];
    
    marketParameters.numberOfFactors = [NSNumber numberWithDouble:5];
    marketParameters.displacementLevel = [NSNumber numberWithDouble:.02];
    marketParameters.innerPaths = [NSNumber numberWithDouble:255];
    marketParameters.outterPaths = [NSNumber numberWithDouble:256];
    marketParameters.fixedMultiplier = [NSNumber numberWithDouble:2.0];
    marketParameters.floatingSpread = [NSNumber numberWithDouble:0.0];
}




-(void) setupEquity {
    DmEquity *equityParameters;
    
    NSMutableArray *results = [[QuantDao instance] getEquity];
    
    @try {
        equityParameters = results[0];
    }
    @catch (NSException *exception) {
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/mm/yyyy"];
    NSString *str =@"15/3/2012";
    equityParameters.settlementDate_1 = [formatter dateFromString:str];
    str =@"1/1/2013";
    equityParameters.maturityDate_1 = [formatter dateFromString:str];
    equityParameters.strike_eq = [NSNumber numberWithInt:40];
    equityParameters.dividendYield_eq    = [NSNumber numberWithFloat:0.00];
    equityParameters.riskFreeRate_eq = [NSNumber numberWithFloat:0.06];
    equityParameters.volatility_eq = [NSNumber numberWithFloat:0.02];
    equityParameters.underlying_eq = [NSNumber numberWithDouble:36];
    [[PersistManager instance] save];
}


- (void) setupBond {
    DmBond *bondParameters;
    
    NSMutableArray *results = [[QuantDao instance] getBond];
    
    @try {
        bondParameters = results[0];
    }
    @catch (NSException *exception) {
    }
    
//    if ([bondParameters.zeroCouponBondAccruedAmount floatValue] >= 0) {
//        return;
//    }
    
    NSMutableArray* entries = [NSKeyedUnarchiver unarchiveObjectWithData:bondParameters.maturityDates];
    
    
    if (entries.count > 2) {
        return;
    }


    
    
    [bondParameters addZeroCouponQuoteAsNumber:[NSNumber numberWithDouble:0.0096]];
    [bondParameters addZeroCouponQuoteAsNumber:[NSNumber numberWithDouble:0.0145]];
    [bondParameters addZeroCouponQuoteAsNumber:[NSNumber numberWithDouble:0.0194]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/mmm/yyyy"];
    NSString *str =@"18/09/2008";
    bondParameters.settlementDate = [formatter dateFromString:str];
    
    str =@"15/03/2005";
    [bondParameters addissueDateAsDate:[formatter dateFromString:str]];
    
    str =@"15/06/2005";
    [bondParameters addissueDateAsDate:[formatter dateFromString:str]];
    
    
    str =@"30/06/2006";
    [bondParameters addissueDateAsDate:[formatter dateFromString:str]];
    
    str =@"15/11/2006";
    [bondParameters addissueDateAsDate:[formatter dateFromString:str]];
    
    str =@"15/05/1987";
    [bondParameters addissueDateAsDate:[formatter dateFromString:str]];
    
    bondParameters.fixingDays = [NSNumber numberWithDouble:100];
    bondParameters.numberOfBonds = [NSNumber numberWithDouble:5];
    
    str =@"31/08/2010";

    if (!bondParameters.maturityDates) {
        bondParameters.maturityDates = [[NSData alloc] init];
    }
    NSDate *date = [formatter dateFromString:str];
    [bondParameters addMaturityDateAsDate:date];
    str =@"31/08/2011";
    date = [formatter dateFromString:str];
    [bondParameters addMaturityDateAsDate:date];
    str =@"30/08/2013";
    [bondParameters addMaturityDateAsDate:[formatter dateFromString:str]];
    str =@"15/08/2018";
    [bondParameters addMaturityDateAsDate:[formatter dateFromString:str]];
    str =@"15/08/2038";
    [bondParameters addMaturityDateAsDate:[formatter dateFromString:str]];
    
    
    if (!bondParameters.couponRates)
        bondParameters.couponRates = [[NSData alloc] init];

    [bondParameters addCouponRateAsNumber:[NSNumber numberWithDouble:0.02375] ];
    [bondParameters addCouponRateAsNumber:[NSNumber numberWithDouble:0.04625] ];
    [bondParameters addCouponRateAsNumber:[NSNumber numberWithDouble:0.03125] ];
    [bondParameters addCouponRateAsNumber:[NSNumber numberWithDouble:0.04000] ];
    [bondParameters addCouponRateAsNumber:[NSNumber numberWithDouble:0.04500] ];
    
    if (!bondParameters.marketQuotes)
        bondParameters.marketQuotes = [[NSData alloc] init];
    [bondParameters addMarketQuoteAsNumber:[NSNumber numberWithDouble:100.390625]];
    [bondParameters addMarketQuoteAsNumber:[NSNumber numberWithDouble:106.21875]  ];
    [bondParameters addMarketQuoteAsNumber:[NSNumber numberWithDouble:100.59375]  ];
    [bondParameters addMarketQuoteAsNumber:[NSNumber numberWithDouble:101.6875]   ];
    [bondParameters addMarketQuoteAsNumber:[NSNumber numberWithDouble:102.140625] ];
    
    if (!bondParameters.depositQuotes)
        bondParameters.depositQuotes = [[NSData alloc] init];
    
    [bondParameters addDepositQuoteAsNumber:[NSNumber numberWithDouble:0.043375]];
    [bondParameters addDepositQuoteAsNumber:[NSNumber numberWithDouble:0.031875]];
    [bondParameters addDepositQuoteAsNumber:[NSNumber numberWithDouble:0.0320375]];
    [bondParameters addDepositQuoteAsNumber:[NSNumber numberWithDouble:0.03385]];
    [bondParameters addDepositQuoteAsNumber:[NSNumber numberWithDouble:0.0338125]];
    [bondParameters addDepositQuoteAsNumber:[NSNumber numberWithDouble:0.0338125]];    
    
    [bondParameters addSwapQuoteAsNumber:[NSNumber numberWithDouble:0.0295]];
    [bondParameters addSwapQuoteAsNumber:[NSNumber numberWithDouble:0.0323]];
    [bondParameters addSwapQuoteAsNumber:[NSNumber numberWithDouble:0.0359]];
    [bondParameters addSwapQuoteAsNumber:[NSNumber numberWithDouble:0.0412]];
    [bondParameters addSwapQuoteAsNumber:[NSNumber numberWithDouble:0.0433]];
    
//    /*********************
//     * BONDS TO BE PRICED *
//     **********************/
         bondParameters.faceAmount = [NSNumber numberWithInt:100];
    str =@"15/08/2013";
    if(!bondParameters.zeroCouponBondFirstDate)
        bondParameters.zeroCouponBondFirstDate = [[NSDate alloc] init];
    bondParameters.zeroCouponBondFirstDate  = [formatter dateFromString:str]; // date_1
    str =@"15/08/2003";
    bondParameters.zeroCouponBondSecondDate  = [formatter dateFromString:str]; // date_2

//    // Fixed 4.5% US Treasury Note
//    Schedule fixedBondSchedule(;
    
    str =@"15/05/2007";
    bondParameters.fixedBondScheduleFirstDate  = [formatter dateFromString:str]; // date_3
    str =@"15/05/2017";
    bondParameters.fixedBondScheduleSecondDate  = [formatter dateFromString:str]; // date_4
    
    str =@"15/05/2007";
    bondParameters.fixedRateBondFirstDate  = [formatter dateFromString:str]; // date_5

//    // Floating rate bond (3M USD Libor + 0.1%)
//    // Should and will be priced on another curve later...
//    RelinkableHandle<YieldTermStructure> liborTermStructure;
//    const boost::shared_ptr<IborIndex> libor3m(
//                                               new USDLibor(Period(3,Months),liborTermStructure));
//    libor3m->addFixing(Date(17, July, 2008),0.0278625);
    str =@"17/07/2008";
    bondParameters.addFixingFirstDate  = [formatter dateFromString:str]; // date_6
    str =@"21/10/2005";
    bondParameters.floatingBondScheduleFirstDate  = [formatter dateFromString:str]; // date_7
    str =@"21/10/2010";
    bondParameters.floatingBondScheduleSecondDate  = [formatter dateFromString:str]; // date_8
    
    str =@"21/10/2005";
    bondParameters.floatingRateBondScheduleFirstDate  = [formatter dateFromString:str]; // date_9
    
//    // Coupon pricers
//    boost::shared_ptr<IborCouponPricer> pricer(new BlackIborCouponPricer);
//    
//    // optionLet volatilities
//    Volatility volatility = 0.0;
//    Handle<OptionletVolatilityStructure> vol;
//    vol = Handle<OptionletVolatilityStructure>();
//    
//    pricer->setCapletVolatility(vol);
//    setCouponPricer(floatingRateBond.cashflows(),pricer);
//    
//    // Yield curve bootstrapping
//    forecastingTermStructure.linkTo(depoSwapTermStructure);
//    discountingTermStructure.linkTo(bondDiscountingTermStructure);
//    
//    // We are using the depo & swap curve to estimate the future Libor rates
//    liborTermStructure.linkTo(depoSwapTermStructure);
    
    [[PersistManager instance] save];

    
}

@end
