//
//  Bomd.mm
//  QuantLibExample
//
//  Created by colman on 10.07.13.
//  Copyright (c) 2013 Striding Edge Technologies. All rights reserved.
//

#import "Bond.h"
#include <ql/quantlib.hpp>

#include <boost/timer.hpp>
#include <iostream>
#include <iomanip>

#import "DateCategory.h"



@implementation Bond

@synthesize
fixedRateBondDirtyPrice,
floatingRateBondDirtyPrice,
zeroCouponBondAccruedAmount,
fixedRateBondNextCoupon,
floatingRateBondNextCoupon,
zeroCouponBondYieldActual360CompoundedAnnual,
fixedRateBondYieldActual360CompoundedAnnual,
floatingRateBondYieldActual360CompoundedAnnual,
formatedIssueDates,
formatedMaturiyDates,
bondMarketQuotes,
bondLiborForcastingCurveQuotes,
bondSwapQuotes,
faceamount,
zeroCouponDate1,
zeroCouponDate2,
fixedBondScheduleDate_1,
fixedBondScheduleDate_2,
floatingBondScheduleDate_1,
floatingBondScheduleDate_2;

@synthesize zeroCoupon3mQuote, zeroCoupon6mQuote, zeroCoupon1yQuote;
@synthesize redemp;



@synthesize fiXingDays;



std::string dateToString(const QuantLib::Date d, const std::string format)
{
    std::stringstream stream;
    
    if( format == "d-mmm-yyyy") // for example: 7-May-2015
    {
        stream << d.dayOfMonth() << "-" << d.month() << "-" << d.year();
    }
    else // could extend this function to deal with date formats other than d-mmm-yyyy
    {
        QL_FAIL("Unsupported format: " << format << ", could try d-mmm-yyyy.");
    }
    return stream.str();
}



- (void) setupRedemption {

    if (!self.redemp)
        self.redemp = [[NSNumber alloc] init];
    
    self.redemp = [NSNumber numberWithDouble:100.0];
}


- (void) setupParameters {
    
    using namespace QuantLib;
    
    
    
    
    DmBond *bondParameters;
    
    NSMutableArray *results = [[QuantDao instance] getBond];

    @try {
        bondParameters = results[0];
    }
    @catch (NSException *exception) {
    }
    
    
    
//    [bondParameters addZeroCouponQuotes:<#(NSSet *)#>];
    [bondParameters addZeroCouponQuoteAsNumber:[NSNumber numberWithDouble:0.0096]];
    [bondParameters addZeroCouponQuoteAsNumber:[NSNumber numberWithDouble:0.0145]];
    [bondParameters addZeroCouponQuoteAsNumber:[NSNumber numberWithDouble:0.0194]];
    [[PersistManager instance] save];
    
    
//    DmBond * bond_    = [NSEntityDescription insertNewObjectForEntityForName:@"Bond" inManagedObjectContext:[[PersistManager instance] managedObjectContext]];
    DmIssueDates *dmIssueDates = [NSEntityDescription insertNewObjectForEntityForName:@"IssueDates" inManagedObjectContext:[[PersistManager instance] managedObjectContext]];
    
//    dmIssueDates.date = [[NSDate dateW]
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/mmm/yyyy"];
    
    NSString *str =@"15/03/2005";
    dmIssueDates.date = [formatter dateFromString:str];
    [bondParameters addIssueDatesObject:dmIssueDates];
    
    str =@"15/06/2005";
    dmIssueDates.date = [formatter dateFromString:str];
    [bondParameters addIssueDatesObject:dmIssueDates];
    
    str =@"30/06/2006";
    dmIssueDates.date = [formatter dateFromString:str];
    [bondParameters addIssueDatesObject:dmIssueDates];
    
    str =@"15/11/2006";
    dmIssueDates.date = [formatter dateFromString:str];
    [bondParameters addIssueDatesObject:dmIssueDates];
    
    str =@"15/05/1987";
    dmIssueDates.date = [formatter dateFromString:str];
    [bondParameters addIssueDatesObject:dmIssueDates];
    
    [[PersistManager instance] save];
    
    
    
  
//  15, QuantLib::March, 2005
//  15, QuantLib::June, 2005
//  30, QuantLib::June, 2006)
//  15, QuantLib::November, 2002
//  15, QuantLib::May, 1987
  
  
    

    
//    - (void)addIssueDatesOject:(DmIssueDates *)value;
    
    self.zeroCoupon3mQuote=0.0096;
    self.zeroCoupon6mQuote=0.0145;
    self.zeroCoupon1yQuote=0.0194;
    

    
    self.fiXingDays = 100;
    
    _numBonds = 5;
    
    QuantLib::Date issueDates[] = {
        QuantLib::Date (15, QuantLib::March, 2005),
        QuantLib::Date (15, QuantLib::June, 2005),
        QuantLib::Date (30, QuantLib::June, 2006),
        QuantLib::Date (15, QuantLib::November, 2002),
        QuantLib::Date (15, QuantLib::May, 1987)
    };
    
    QuantLib::Date maturitieDates[] = {
        QuantLib::Date (31, QuantLib::August, 2010),
        QuantLib::Date (31, QuantLib::August, 2011),
        QuantLib::Date (30, QuantLib::August, 2013),
        QuantLib::Date (15, QuantLib::August, 2018),
        QuantLib::Date (15, QuantLib::August, 2038)
    };
    
    Real couponRates[] = {
        0.02375,
        0.04625,
        0.03125,
        0.04000,
        0.04500
    };
    
    Real marketQuotes[] = {
        100.390625,
        106.21875,
        100.59375,
        101.6875,
        102.140625
    };
    
//    Rate d1wQuote=0.043375;
//    Rate d1mQuote=0.031875;
//    Rate d3mQuote=0.0320375;
//    Rate d6mQuote=0.03385;
//    Rate d9mQuote=0.0338125;
//    Rate d1yQuote=0.0335125;

    
    

    
//    int size = sizeof(issueDates); // 20 issueDates showing in debug?
//    for(int i =0; i<  sizeof(issueDates) - 1; i++) {
    for(int i =0; i<  5; i++) {
        QuantLib::Date &date = issueDates[i];
        std::stringstream stream;
//        std::string format = "d-mmm-yyyy";
        try {
            stream << date.dayOfMonth() << "-" << date.month() << "-" << date.year();
        }
        catch (std::exception &e) {
        }
        
        std::string result = stream.str() ;
        if (!formatedIssueDates)
            formatedIssueDates = [[NSMutableArray alloc] init];
        [formatedIssueDates addObject:[NSString stringWithFormat:@"%s",result.c_str()]];
        stream.str("");
        
        date = maturitieDates[i];
        try {
            stream << date.dayOfMonth() << "-" << date.month() << "-" << date.year();
        }
        catch (std::exception &e) {
        }

        result = stream.str() ;
        if (!formatedMaturiyDates)
            formatedMaturiyDates = [[NSMutableArray alloc] init];
        [formatedMaturiyDates addObject:[NSString stringWithFormat:@"%s",result.c_str()]];
        
        stream.str("");
        
        float rate = (float)couponRates[i];
        if (!_bondCouponRates)
            _bondCouponRates = [[NSMutableArray alloc] init];
        [_bondCouponRates addObject:[NSString stringWithFormat:@"%f",rate]];

        
        float marketQuote = (float)marketQuotes[i];
        if(!bondMarketQuotes)
            bondMarketQuotes = [[NSMutableArray alloc] init];
        [bondMarketQuotes addObject:[NSString stringWithFormat:@"%f",marketQuote]];
        
    }
    
    Rate d1wQuote=0.043375;
    Rate d1mQuote=0.031875;
    Rate d3mQuote=0.0320375;
    Rate d6mQuote=0.03385;
    Rate d9mQuote=0.0338125;
    Rate d1yQuote=0.0335125;
    
    
    if(!bondLiborForcastingCurveQuotes)
        bondLiborForcastingCurveQuotes = [[NSMutableArray alloc] init];
    
    [bondLiborForcastingCurveQuotes addObject:[NSString stringWithFormat:@"%f",(float)d1wQuote] ];
    [bondLiborForcastingCurveQuotes addObject:[NSString stringWithFormat:@"%f",(float)d1mQuote]];
    [bondLiborForcastingCurveQuotes addObject:[NSString stringWithFormat:@"%f",(float)d3mQuote]];
    [bondLiborForcastingCurveQuotes addObject:[NSString stringWithFormat:@"%f",(float)d6mQuote]];
    [bondLiborForcastingCurveQuotes addObject:[NSString stringWithFormat:@"%f",(float)d9mQuote]];
    [bondLiborForcastingCurveQuotes addObject:[NSString stringWithFormat:@"%f",(float)d1yQuote]];
    
    Rate s2yQuote=0.0295;
    Rate s3yQuote=0.0323;
    Rate s5yQuote=0.0359;
    Rate s10yQuote=0.0412;
    Rate s15yQuote=0.0433;
    
    if(!bondSwapQuotes)
        bondSwapQuotes = [[NSMutableArray alloc] init];
    [bondSwapQuotes addObject:[NSString stringWithFormat:@"%f",(float)s2yQuote] ];
    [bondSwapQuotes addObject:[NSString stringWithFormat:@"%f",(float)s3yQuote]];
    [bondSwapQuotes addObject:[NSString stringWithFormat:@"%f",(float)s5yQuote]];
    [bondSwapQuotes addObject:[NSString stringWithFormat:@"%f",(float)s10yQuote]];
    [bondSwapQuotes addObject:[NSString stringWithFormat:@"%f",(float)s15yQuote]];
    
    
    self.faceamount = 100;
    

//    Date zcDate1 = QuantLib::Date (21, QuantLib::October, 2005);
//    Date zcDate2 = QuantLib::Date (15, QuantLib::May, 2007);
    std::stringstream stream;
    stream.str("");
    Date zcDate1 = QuantLib::Date (21, QuantLib::October, 2005);
    try {
        stream << zcDate1.dayOfMonth() << "-" << zcDate1.month() << "-" << zcDate1.year();
    }
    catch (std::exception &e) {
    }
    std::string result = stream.str() ;
    self.zeroCouponDate1 = [NSString stringWithFormat:@"%s",result.c_str()];
    
    stream.str("");
    Date zcDate2 = QuantLib::Date (15, QuantLib::May, 2007);
    try {
        stream << zcDate2.dayOfMonth() << "-" << zcDate2.month() << "-" << zcDate2.year();
    }
    catch (std::exception &e) {
    }
    result = stream.str() ;
    self.zeroCouponDate2 = [NSString stringWithFormat:@"%s",result.c_str()];
    
    
    //        Date(21, October, 2005)
    //        Date(21, October, 2010)
    
    
    
}

-(void) calculate {
    
    using namespace QuantLib;
    
    try {
        
        boost::timer timer;

        [self setupRedemption];
        
        
        /*********************
         ***  MARKET DATA  ***
         *********************/
        
        Calendar calendar = TARGET();
        
        Date settlementDate(18, September, 2008);
        // must be a business day
        settlementDate = calendar.adjust(settlementDate);
        
        Integer fixingDays = fiXingDays;
        Natural settlementDays = settleMentDays;
        
        Date todaysDate = calendar.advance(settlementDate, -fiXingDays, Days);
        Settings::instance().evaluationDate() = todaysDate;
        
        std::cout << "Today: " << todaysDate.weekday()
        << ", " << todaysDate << std::endl;
        
        std::cout << "Settlement date: " << settlementDate.weekday()
        << ", " << settlementDate << std::endl;
        
        /*********************
         ***  RATE HELPERS ***
         *********************/
        
//        Rate zc3mQuote=0.0096;
//        Rate zc6mQuote=0.0145;
//        Rate zc1yQuote=0.0194;
        
        Rate zc3mQuote = self.zeroCoupon3mQuote;
        Rate zc6mQuote = self.zeroCoupon6mQuote;
        Rate zc1yQuote = self.zeroCoupon1yQuote;
        
        boost::shared_ptr<Quote> zc3mRate(new SimpleQuote(zc3mQuote));
        boost::shared_ptr<Quote> zc6mRate(new SimpleQuote(zc6mQuote));
        boost::shared_ptr<Quote> zc1yRate(new SimpleQuote(zc1yQuote));
        
        DayCounter zcBondsDayCounter = Actual365Fixed();
        
        boost::shared_ptr<RateHelper> zc3m(new DepositRateHelper(
                                                                 Handle<Quote>(zc3mRate),
                                                                 3*Months, fixingDays,
                                                                 calendar, ModifiedFollowing,
                                                                 true, zcBondsDayCounter));
        boost::shared_ptr<RateHelper> zc6m(new DepositRateHelper(
                                                                 Handle<Quote>(zc6mRate),
                                                                 6*Months, fixingDays,
                                                                 calendar, ModifiedFollowing,
                                                                 true, zcBondsDayCounter));
        boost::shared_ptr<RateHelper> zc1y(new DepositRateHelper(
                                                                 Handle<Quote>(zc1yRate),
                                                                 1*Years, fixingDays,
                                                                 calendar, ModifiedFollowing,
                                                                 true, zcBondsDayCounter));
        
//        Real redemption = 100.0;

        Real redemption = [self.redemp doubleValue];
        
        QuantLib::Size numberOfBonds = 5;
        
        Date issueDates[] = {
            Date (15, March, 2005),
            Date (15, June, 2005),
            Date (30, June, 2006),
            Date (15, November, 2002),
            Date (15, May, 1987)
        };
        
        Date maturities[] = {
            Date (31, August, 2010),
            Date (31, August, 2011),
            Date (31, August, 2013),
            Date (15, August, 2018),
            Date (15, May, 2038)
        };
        
        Real couponRates[] = {
            0.02375,
            0.04625,
            0.03125,
            0.04000,
            0.04500
        };
        
        Real marketQuotes[] = {
            100.390625,
            106.21875,
            100.59375,
            101.6875,
            102.140625
        };
        
        std::vector< boost::shared_ptr<SimpleQuote> > quote;
        for (int i=0; i<numberOfBonds; i++) {
            boost::shared_ptr<SimpleQuote> cp(new SimpleQuote(marketQuotes[i]));
            quote.push_back(cp);
        }

        
        //        RelinkableHandle<Quote> quoteHandle[numberOfBonds];
        //        int * test = new int[val];
        RelinkableHandle<Quote> * quoteHandle = new RelinkableHandle<Quote>[numberOfBonds];
        //        for (Size i=0; i<numberOfBonds; i++) {
        for (int i=0; i<numberOfBonds; i++) {
            quoteHandle[i].linkTo(quote[i]);
        }

        
        std::vector<boost::shared_ptr<FixedRateBondHelper> > bondsHelpers;
        
        for (QuantLib::Size i=0; i<numberOfBonds; i++) {
            
            Schedule schedule(issueDates[i], maturities[i], Period(Semiannual), UnitedStates(UnitedStates::GovernmentBond),
                              Unadjusted, Unadjusted, DateGeneration::Backward, false);
            
            boost::shared_ptr<FixedRateBondHelper> bondHelper(new FixedRateBondHelper(
                                                                                      quoteHandle[i],
                                                                                      settlementDays,
                                                                                      100.0,
                                                                                      schedule,
                                                                                      std::vector<Rate>(1,couponRates[i]),
                                                                                      ActualActual(ActualActual::Bond),
                                                                                      Unadjusted,
                                                                                      redemption,
                                                                                      issueDates[i]));
            
            bondsHelpers.push_back(bondHelper);
        }
        
        /*********************
         **  CURVE BUILDING **
         *********************/
        DayCounter termStructureDayCounter =
        ActualActual(ActualActual::ISDA);
        
        double tolerance = 1.0e-15;
        std::vector<boost::shared_ptr<RateHelper> > bondInstruments;
        
        bondInstruments.push_back(zc3m);
        bondInstruments.push_back(zc6m);
        bondInstruments.push_back(zc1y);
        
        for (QuantLib::Size i=0; i<numberOfBonds; i++) {
            bondInstruments.push_back(bondsHelpers[i]);
        }
        
        boost::shared_ptr<YieldTermStructure> bondDiscountingTermStructure(
                                                                           new PiecewiseYieldCurve<Discount,LogLinear>(
                                                                                                                       settlementDate, bondInstruments,
                                                                                                                       termStructureDayCounter,
                                                                                                                       tolerance));
        
        Rate d1wQuote=0.043375;
        Rate d1mQuote=0.031875;
        Rate d3mQuote=0.0320375;
        Rate d6mQuote=0.03385;
        Rate d9mQuote=0.0338125;
        Rate d1yQuote=0.0335125;
        
        Rate s2yQuote=0.0295;
        Rate s3yQuote=0.0323;
        Rate s5yQuote=0.0359;
        Rate s10yQuote=0.0412;
        Rate s15yQuote=0.0433;
        
        
        /********************
         ***    QUOTES    ***
         ********************/
        
        // deposits
        boost::shared_ptr<Quote> d1wRate(new SimpleQuote(d1wQuote));
        boost::shared_ptr<Quote> d1mRate(new SimpleQuote(d1mQuote));
        boost::shared_ptr<Quote> d3mRate(new SimpleQuote(d3mQuote));
        boost::shared_ptr<Quote> d6mRate(new SimpleQuote(d6mQuote));
        boost::shared_ptr<Quote> d9mRate(new SimpleQuote(d9mQuote));
        boost::shared_ptr<Quote> d1yRate(new SimpleQuote(d1yQuote));
        // swaps
        boost::shared_ptr<Quote> s2yRate(new SimpleQuote(s2yQuote));
        boost::shared_ptr<Quote> s3yRate(new SimpleQuote(s3yQuote));
        boost::shared_ptr<Quote> s5yRate(new SimpleQuote(s5yQuote));
        boost::shared_ptr<Quote> s10yRate(new SimpleQuote(s10yQuote));
        boost::shared_ptr<Quote> s15yRate(new SimpleQuote(s15yQuote));
        
        /*********************
         ***  RATE HELPERS ***
         *********************/
        
        
        // deposits
        DayCounter depositDayCounter = Actual360();
        
        boost::shared_ptr<RateHelper> d1w(new DepositRateHelper(
                                                                Handle<Quote>(d1wRate),
                                                                1*Weeks, fixingDays,
                                                                calendar, ModifiedFollowing,
                                                                true, depositDayCounter));
        boost::shared_ptr<RateHelper> d1m(new DepositRateHelper(
                                                                Handle<Quote>(d1mRate),
                                                                1*Months, fixingDays,
                                                                calendar, ModifiedFollowing,
                                                                true, depositDayCounter));
        boost::shared_ptr<RateHelper> d3m(new DepositRateHelper(
                                                                Handle<Quote>(d3mRate),
                                                                3*Months, fixingDays,
                                                                calendar, ModifiedFollowing,
                                                                true, depositDayCounter));
        boost::shared_ptr<RateHelper> d6m(new DepositRateHelper(
                                                                Handle<Quote>(d6mRate),
                                                                6*Months, fixingDays,
                                                                calendar, ModifiedFollowing,
                                                                true, depositDayCounter));
        boost::shared_ptr<RateHelper> d9m(new DepositRateHelper(
                                                                Handle<Quote>(d9mRate),
                                                                9*Months, fixingDays,
                                                                calendar, ModifiedFollowing,
                                                                true, depositDayCounter));
        boost::shared_ptr<RateHelper> d1y(new DepositRateHelper(
                                                                Handle<Quote>(d1yRate),
                                                                1*Years, fixingDays,
                                                                calendar, ModifiedFollowing,
                                                                true, depositDayCounter));
        
        // setup swaps
        Frequency swFixedLegFrequency = Annual;
        BusinessDayConvention swFixedLegConvention = Unadjusted;
        DayCounter swFixedLegDayCounter = Thirty360(Thirty360::European);
        boost::shared_ptr<IborIndex> swFloatingLegIndex(new Euribor6M);
        
        const Period forwardStart(1*Days);
        
        boost::shared_ptr<RateHelper> s2y(new SwapRateHelper(
                                                             Handle<Quote>(s2yRate), 2*Years,
                                                             calendar, swFixedLegFrequency,
                                                             swFixedLegConvention, swFixedLegDayCounter,
                                                             swFloatingLegIndex, Handle<Quote>(),forwardStart));
        boost::shared_ptr<RateHelper> s3y(new SwapRateHelper(
                                                             Handle<Quote>(s3yRate), 3*Years,
                                                             calendar, swFixedLegFrequency,
                                                             swFixedLegConvention, swFixedLegDayCounter,
                                                             swFloatingLegIndex, Handle<Quote>(),forwardStart));
        boost::shared_ptr<RateHelper> s5y(new SwapRateHelper(
                                                             Handle<Quote>(s5yRate), 5*Years,
                                                             calendar, swFixedLegFrequency,
                                                             swFixedLegConvention, swFixedLegDayCounter,
                                                             swFloatingLegIndex, Handle<Quote>(),forwardStart));
        boost::shared_ptr<RateHelper> s10y(new SwapRateHelper(
                                                              Handle<Quote>(s10yRate), 10*Years,
                                                              calendar, swFixedLegFrequency,
                                                              swFixedLegConvention, swFixedLegDayCounter,
                                                              swFloatingLegIndex, Handle<Quote>(),forwardStart));
        boost::shared_ptr<RateHelper> s15y(new SwapRateHelper(
                                                              Handle<Quote>(s15yRate), 15*Years,
                                                              calendar, swFixedLegFrequency,
                                                              swFixedLegConvention, swFixedLegDayCounter,
                                                              swFloatingLegIndex, Handle<Quote>(),forwardStart));
        
        
        /*********************
         **  CURVE BUILDING **
         *********************/
        
        // Any DayCounter would be fine.
        // ActualActual::ISDA ensures that 30 years is 30.0
        
        // A depo-swap curve
        std::vector<boost::shared_ptr<RateHelper> > depoSwapInstruments;
        depoSwapInstruments.push_back(d1w);
        depoSwapInstruments.push_back(d1m);
        depoSwapInstruments.push_back(d3m);
        depoSwapInstruments.push_back(d6m);
        depoSwapInstruments.push_back(d9m);
        depoSwapInstruments.push_back(d1y);
        depoSwapInstruments.push_back(s2y);
        depoSwapInstruments.push_back(s3y);
        depoSwapInstruments.push_back(s5y);
        depoSwapInstruments.push_back(s10y);
        depoSwapInstruments.push_back(s15y);
        boost::shared_ptr<YieldTermStructure> depoSwapTermStructure(
                                                                    new PiecewiseYieldCurve<Discount,LogLinear>(
                                                                                                                settlementDate, depoSwapInstruments,
                                                                                                                termStructureDayCounter,
                                                                                                                tolerance));
        
        // Term structures that will be used for pricing:
        // the one used for discounting cash flows
        RelinkableHandle<YieldTermStructure> discountingTermStructure;
        // the one used for forward rate forecasting
        RelinkableHandle<YieldTermStructure> forecastingTermStructure;
        
        /*********************
         * BONDS TO BE PRICED *
         **********************/
        
        // Common data
        Real faceAmount = 100;
        
        // Pricing engine
        boost::shared_ptr<PricingEngine> bondEngine(
                                                    new DiscountingBondEngine(discountingTermStructure));
        
        // Zero coupon bond
        ZeroCouponBond zeroCouponBond(
                                      settlementDays,
                                      UnitedStates(UnitedStates::GovernmentBond),
                                      faceAmount,
                                      Date(15,August,2013),
                                      Following,
                                      Real(116.92),
                                      Date(15,August,2003));
        
        zeroCouponBond.setPricingEngine(bondEngine);
        
        // Fixed 4.5% US Treasury Note
        Schedule fixedBondSchedule(Date(15, May, 2007),
                                   Date(15,May,2017), Period(Semiannual),
                                   UnitedStates(UnitedStates::GovernmentBond),
                                   Unadjusted, Unadjusted, DateGeneration::Backward, false);
        
        FixedRateBond fixedRateBond(
                                    settlementDays,
                                    faceAmount,
                                    fixedBondSchedule,
                                    std::vector<Rate>(1, 0.045),
                                    ActualActual(ActualActual::Bond),
                                    ModifiedFollowing,
                                    100.0, Date(15, May, 2007));
        
        fixedRateBond.setPricingEngine(bondEngine);
        
        // Floating rate bond (3M USD Libor + 0.1%)
        // Should and will be priced on another curve later...
        
        RelinkableHandle<YieldTermStructure> liborTermStructure;
        const boost::shared_ptr<IborIndex> libor3m(
                                                   new USDLibor(Period(3,Months),liborTermStructure));
        libor3m->addFixing(Date(17, July, 2008),0.0278625);
        
        Schedule floatingBondSchedule(Date(21, October, 2005),
                                      Date(21, October, 2010), Period(Quarterly),
                                      UnitedStates(UnitedStates::NYSE),
                                      Unadjusted, Unadjusted, DateGeneration::Backward, true);
        
        FloatingRateBond floatingRateBond(
                                          settlementDays,
                                          faceAmount,
                                          floatingBondSchedule,
                                          libor3m,
                                          Actual360(),
                                          ModifiedFollowing,
                                          Natural(2),
                                          // Gearings
                                          std::vector<Real>(1, 1.0),
                                          // Spreads
                                          std::vector<Rate>(1, 0.001),
                                          // Caps
                                          std::vector<Rate>(),
                                          // Floors
                                          std::vector<Rate>(),
                                          // Fixing in arrears
                                          true,
                                          Real(100.0),
                                          Date(21, October, 2005));
        
        floatingRateBond.setPricingEngine(bondEngine);
        
        // Coupon pricers
        boost::shared_ptr<IborCouponPricer> pricer(new BlackIborCouponPricer);
        
        // optionLet volatilities
        Volatility volatility = 0.0;
        Handle<OptionletVolatilityStructure> vol;
        vol = Handle<OptionletVolatilityStructure>(
                                                   boost::shared_ptr<OptionletVolatilityStructure>(new
                                                                                                   ConstantOptionletVolatility(
                                                                                                                               settlementDays,
                                                                                                                               calendar,
                                                                                                                               ModifiedFollowing,
                                                                                                                               volatility,
                                                                                                                               Actual365Fixed())));
        
        pricer->setCapletVolatility(vol);
        setCouponPricer(floatingRateBond.cashflows(),pricer);
        
        // Yield curve bootstrapping
        forecastingTermStructure.linkTo(depoSwapTermStructure);
        discountingTermStructure.linkTo(bondDiscountingTermStructure);
        
        // We are using the depo & swap curve to estimate the future Libor rates
        liborTermStructure.linkTo(depoSwapTermStructure);
        
        /***************
         * BOND PRICING *
         ****************/
        
        std::cout << std::endl;
        
        // write column headings
        QuantLib::Size widths[] = { 18, 10, 10, 10 };

        

        self.zeroCouponBondNPV = [[NSNumber alloc] initWithDouble:zeroCouponBond.NPV()];
        self.fixedRateBondNPV =[[NSNumber alloc] initWithDouble:fixedRateBond.NPV()];
        self.floatingRateBondNPV = [[NSNumber alloc] initWithDouble:floatingRateBond.NPV()];
        
        self.zeroCouponBondCleanPrice = [[NSNumber alloc] initWithDouble:zeroCouponBond.cleanPrice()];
        self.fixedRateBondCleanPrice =[[NSNumber alloc] initWithDouble:fixedRateBond.cleanPrice()];
        self.floatingRateBondCleanPrice = [[NSNumber alloc] initWithDouble:floatingRateBond.cleanPrice()];
        
        self.zeroCouponBondDirtyPrice = [[NSNumber alloc] initWithDouble:zeroCouponBond.dirtyPrice()];
        self.fixedRateBondDirtyPrice =[[NSNumber alloc] initWithDouble:fixedRateBond.cleanPrice()];
        self.floatingRateBondDirtyPrice = [[NSNumber alloc] initWithDouble:floatingRateBond.cleanPrice()];
        
        
        self.zeroCouponBondAccruedAmount = [[NSNumber alloc] initWithDouble:zeroCouponBond.accruedAmount()];
        self.fixedRateBondAccruedAmount =[[NSNumber alloc] initWithDouble:fixedRateBond.accruedAmount()];
        self.floatingRateBondAccruedAmount = [[NSNumber alloc] initWithDouble:floatingRateBond.accruedAmount()];
        
//        self.zeroCouponBondPreviousCoupon = [[NSNumber alloc] initWithDouble:zeroCouponBond.accruedAmount()];
        self.fixedRateBondPreviousCoupon =[[NSNumber alloc] initWithDouble:fixedRateBond.previousCouponRate()];
        self.floatingRateBondPreviousCoupon = [[NSNumber alloc] initWithDouble:floatingRateBond.previousCouponRate()];
        
        
        self.fixedRateBondNextCoupon =[[NSNumber alloc] initWithDouble:fixedRateBond.nextCouponRate()];
        self.floatingRateBondNextCoupon = [[NSNumber alloc] initWithDouble:floatingRateBond.nextCouponRate()];
        
        self.zeroCouponBondYield = [[NSNumber alloc] initWithDouble:zeroCouponBond.yield(Actual360(),Compounded,Annual)];
        self.fixedRateBondYield = [[NSNumber alloc] initWithDouble:fixedRateBond.yield(Actual360(),Compounded,Annual)];
        self.floatingRateBondYield = [[NSNumber alloc] initWithDouble:floatingRateBond.yield(Actual360(),Compounded,Annual)];
        
        
        
        
        std::string separator = " | ";
        QuantLib::Size width = widths[0]
        + widths[1]
        + widths[2]
        + widths[3];
        std::string rule(width, '-'), dblrule(width, '=');
        std::string tab(8, ' ');
        
        std::cout << rule << std::endl;
        
        std::cout << std::fixed;
        std::cout << std::setprecision(2);
        
        std::cout << std::setw(widths[0]) << "Net present value"
        << std::setw(widths[1]) << zeroCouponBond.NPV()
        << std::setw(widths[2]) << fixedRateBond.NPV()
        << std::setw(widths[3]) << floatingRateBond.NPV()
        << std::endl;
        
        std::cout << std::setw(widths[0]) << "Clean price"
        << std::setw(widths[1]) << zeroCouponBond.cleanPrice()
        << std::setw(widths[2]) << fixedRateBond.cleanPrice()
        << std::setw(widths[3]) << floatingRateBond.cleanPrice()
        << std::endl;
        
        std::cout << std::setw(widths[0]) << "Dirty price"
        << std::setw(widths[1]) << zeroCouponBond.dirtyPrice()
        << std::setw(widths[2]) << fixedRateBond.dirtyPrice()
        << std::setw(widths[3]) << floatingRateBond.dirtyPrice()
        << std::endl;
        
        std::cout << std::setw(widths[0]) << "Accrued coupon"
        << std::setw(widths[1]) << zeroCouponBond.accruedAmount()
        << std::setw(widths[2]) << fixedRateBond.accruedAmount()
        << std::setw(widths[3]) << floatingRateBond.accruedAmount()
        << std::endl;
        
        std::cout << std::setw(widths[0]) << "Previous coupon"
        << std::setw(widths[1]) << "N/A" // zeroCouponBond
        << std::setw(widths[2]) << io::rate(fixedRateBond.previousCouponRate())
        << std::setw(widths[3]) << io::rate(floatingRateBond.previousCouponRate())
        << std::endl;
        
        std::cout << std::setw(widths[0]) << "Next coupon"
        << std::setw(widths[1]) << "N/A" // zeroCouponBond
        << std::setw(widths[2]) << io::rate(fixedRateBond.nextCouponRate())
        << std::setw(widths[3]) << io::rate(floatingRateBond.nextCouponRate())
        << std::endl;
        
        std::cout << std::setw(widths[0]) << "Yield"
        << std::setw(widths[1])
        << io::rate(zeroCouponBond.yield(Actual360(),Compounded,Annual))
        << std::setw(widths[2])
        << io::rate(fixedRateBond.yield(Actual360(),Compounded,Annual))
        << std::setw(widths[3])
        << io::rate(floatingRateBond.yield(Actual360(),Compounded,Annual))
        << std::endl;
        
        std::cout << std::endl;
        
        // Other computations
        std::cout << "Sample indirect computations (for the floating rate bond): " << std::endl;
        std::cout << rule << std::endl;
        
        std::cout << "Yield to Clean Price: "
        << floatingRateBond.cleanPrice(floatingRateBond.yield(Actual360(),Compounded,Annual),Actual360(),Compounded,Annual,settlementDate) << std::endl;
        
        std::cout << "Clean Price to Yield: "
        << io::rate(floatingRateBond.yield(floatingRateBond.cleanPrice(),Actual360(),Compounded,Annual,settlementDate)) << std::endl;
        
        /* "Yield to Price"
         "Price to Yield" */
        
        Real seconds = timer.elapsed();
        Integer hours = int(seconds/3600);
        seconds -= hours * 3600;
        Integer minutes = int(seconds/60);
        seconds -= minutes * 60;
        std::cout << " \nRun completed in ";
        if (hours > 0)
            std::cout << hours << " h ";
        if (hours > 0 || minutes > 0)
            std::cout << minutes << " m ";
        std::cout << std::fixed << std::setprecision(0)
        << seconds << " s\n" << std::endl;
        
    } catch (std::exception& e) {
        std::cerr << e.what() << std::endl;
    } catch (...) {
        std::cerr << "unknown error" << std::endl;
    }
    
}




-(QuantLib::Date) changeDate:(NSDate * ) date {
    NSCalendar *cal = [NSCalendar currentCalendar];
    [cal setTimeZone:[NSTimeZone localTimeZone]];
    [cal setLocale:[NSLocale currentLocale]];
    NSDateComponents *components = [cal components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    int year = [components year];
    int m = [components month];
    int day = [components day];
    QuantLib::Month month = intToMonth(m);
    return QuantLib::Date(day,month,year);
}

QuantLib::Month intToMonth(int monthAsInteger)
{
    using namespace QuantLib;
    QuantLib::Month month = January;
    
    switch (monthAsInteger) {
        case 1:
            month = January;
            break;
        case 2:
            month = February;
            break;
        case 3:
            month = March;
            break;
        case 4:
            month = April;
            break;
        case 5:
            month = May;
            break;
        case 6:
            month = June;
            break;
        case 7:
            month = July;
            break;
        case 8:
            month = August;
            break;
        case 9:
            month = September;
            break;
        case 10:
            month = October;
            break;
        case 11:
            month = November;
            break;
        case 12:
            month = December;
            break;
            
        default:
            break;
    }
    
    return (month);
}

@end

