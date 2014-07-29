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
//    using namespace QuantLib;
    DmBond *bondParameters;
    
    NSMutableArray *results = [[QuantDao instance] getBond];
    
    @try {
        bondParameters = results[0];
    }
    @catch (NSException *exception) {
    }
    
    [bondParameters addZeroCouponQuoteAsNumber:[NSNumber numberWithDouble:0.0096]];
    [bondParameters addZeroCouponQuoteAsNumber:[NSNumber numberWithDouble:0.0145]];
    [bondParameters addZeroCouponQuoteAsNumber:[NSNumber numberWithDouble:0.0194]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/mmm/yyyy"];
    
    NSString *str =@"15/03/2005";
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
    [bondParameters addDate:[formatter dateFromString:str] toData:bondParameters.maturityDates];
    str =@"31/08/2011";
    [bondParameters addDate:[formatter dateFromString:str] toData:bondParameters.maturityDates];
    str =@"30/08/2013";
    [bondParameters addDate:[formatter dateFromString:str] toData:bondParameters.maturityDates];
    str =@"15/08/2018";
    [bondParameters addDate:[formatter dateFromString:str] toData:bondParameters.maturityDates];
    str =@"15/08/2038";
    [bondParameters addDate:[formatter dateFromString:str] toData:bondParameters.maturityDates];
    
    
    [bondParameters addValue:[NSNumber numberWithDouble:0.02375] toData:bondParameters.couponRates];
    [bondParameters addValue:[NSNumber numberWithDouble:0.04625] toData:bondParameters.couponRates];
    [bondParameters addValue:[NSNumber numberWithDouble:0.03125] toData:bondParameters.couponRates];
    [bondParameters addValue:[NSNumber numberWithDouble:0.04000] toData:bondParameters.couponRates];
    [bondParameters addValue:[NSNumber numberWithDouble:0.04500] toData:bondParameters.couponRates];
    
    [bondParameters addValue:[NSNumber numberWithDouble:100.390625] toData:bondParameters.marketQuotes];
    [bondParameters addValue:[NSNumber numberWithDouble:106.21875]  toData:bondParameters.marketQuotes];
    [bondParameters addValue:[NSNumber numberWithDouble:100.59375]  toData:bondParameters.marketQuotes];
    [bondParameters addValue:[NSNumber numberWithDouble:101.6875]   toData:bondParameters.marketQuotes];
    [bondParameters addValue:[NSNumber numberWithDouble:102.140625] toData:bondParameters.marketQuotes];

    [bondParameters addValue:[NSNumber numberWithDouble:0.043375]   toData:bondParameters.depositQuotes];
    [bondParameters addValue:[NSNumber numberWithDouble:0.031875]   toData:bondParameters.depositQuotes];
    [bondParameters addValue:[NSNumber numberWithDouble:0.0320375]  toData:bondParameters.depositQuotes];
    [bondParameters addValue:[NSNumber numberWithDouble:0.03385]    toData:bondParameters.depositQuotes];
    [bondParameters addValue:[NSNumber numberWithDouble:0.0338125]  toData:bondParameters.depositQuotes];
    [bondParameters addValue:[NSNumber numberWithDouble:0.0335125]  toData:bondParameters.depositQuotes];

//    NSMutableArray *data_;
//    data_ = [NSKeyedUnarchiver unarchiveObjectWithData:bondParameters.swapQuotes];
    
//    if (!bondParameters.swapQuotes) {
//        bondParameters.swapQuotes = [[NSData alloc] init];
//        [[PersistManager instance ] save];
//    }
//        bondParameters.swapQuotes = [NSKeyedArchiver archivedDataWithRootObject:@""];
    

    
//    [bondParameters addValue:[NSNumber numberWithDouble:0.0295] toData:bondParameters.swapQuotes];
//    [bondParameters addValue:[NSNumber numberWithDouble:0.0323] toData:bondParameters.swapQuotes];
//    [bondParameters addValue:[NSNumber numberWithDouble:0.0359] toData:bondParameters.swapQuotes];
//    [bondParameters addValue:[NSNumber numberWithDouble:0.0412] toData:bondParameters.swapQuotes];
//    [bondParameters addValue:[NSNumber numberWithDouble:0.0433] toData:bondParameters.swapQuotes];
    
//    - (void)addSwapQuoteAsNumber:(NSNumber *)value{
    [bondParameters addSwapQuoteAsNumber:[NSNumber numberWithDouble:0.0295]];
    [bondParameters addSwapQuoteAsNumber:[NSNumber numberWithDouble:0.0323]];
    [bondParameters addSwapQuoteAsNumber:[NSNumber numberWithDouble:0.0359]];
    [bondParameters addSwapQuoteAsNumber:[NSNumber numberWithDouble:0.0412]];
    [bondParameters addSwapQuoteAsNumber:[NSNumber numberWithDouble:0.0433]];
    
//    /*********************
//     * BONDS TO BE PRICED *
//     **********************/
         bondParameters.faceAmount = [NSNumber numberWithInt:100];
//    
//    // Pricing engine
//    boost::shared_ptr<PricingEngine> bondEngine(
//                                                new DiscountingBondEngine(discountingTermStructure));
// Zero coupon bond
//    ZeroCouponBond zeroCouponBond();
    
    
    str =@"15/08/2013";
    if(!bondParameters.zeroCouponBondFirstDate)
        bondParameters.zeroCouponBondFirstDate = [[NSDate alloc] init];
    bondParameters.zeroCouponBondFirstDate  = [formatter dateFromString:str]; // date_1
    str =@"15/08/2003";
    bondParameters.zeroCouponBondSecondDate  = [formatter dateFromString:str]; // date_2

    
//    zeroCouponBond.setPricingEngine(bondEngine);
//    // Fixed 4.5% US Treasury Note
//    Schedule fixedBondSchedule(;
    
    str =@"15/05/2007";
    bondParameters.fixedBondScheduleFirstDate  = [formatter dateFromString:str]; // date_3
    str =@"15/05/2017";
    bondParameters.fixedBondScheduleSecondDate  = [formatter dateFromString:str]; // date_4
//    FixedRateBond fixedRateBond(;
    
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
//
//    Schedule floatingBondSchedule();
    str =@"21/10/2005";
    bondParameters.floatingBondScheduleFirstDate  = [formatter dateFromString:str]; // date_7
    str =@"21/10/2010";
    bondParameters.floatingBondScheduleSecondDate  = [formatter dateFromString:str]; // date_8
//
//    FloatingRateBond floatingRateBond();
    
    str =@"21/10/2005";
    bondParameters.floatingRateBondScheduleFirstDate  = [formatter dateFromString:str]; // date_9
    
//    
//    floatingRateBond.setPricingEngine(bondEngine);
//    
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
