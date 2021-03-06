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

-(void) calculate {
    
    using namespace QuantLib;
    

    
    try {
        
        boost::timer timer;

        [self setupRedemption];
        
        DmBond *bondParameters;
        
        NSMutableArray *results = [[QuantDao instance] getBond];
        
        @try {
            bondParameters = results[0];
        }
        @catch (NSException *exception) {
        }
        
        
        NSMutableArray *data_;;
        NSNumber *num;
        
        
        /*********************
         ***  MARKET DATA  ***
         *********************/
        
        NSCalendar *cal_ = [NSCalendar currentCalendar];
        [cal_ setTimeZone:[NSTimeZone localTimeZone]];
        [cal_ setLocale:[NSLocale currentLocale]];
        
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

        data_ = [NSKeyedUnarchiver unarchiveObjectWithData:bondParameters.issueDates];
        

        
        Date issueDates[] = {
            QuantLib::Date(
                           [[cal_ components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:(NSDate *)[data_ objectAtIndex:0]] day],
                           intToMonth([[cal_ components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:(NSDate *)[data_ objectAtIndex:0]] month]),
                           [[cal_ components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:(NSDate *)[data_ objectAtIndex:0]] year]) ,
            QuantLib::Date(
                           [[cal_ components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:(NSDate *)[data_ objectAtIndex:1]] day],
                           intToMonth([[cal_ components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:(NSDate *)[data_ objectAtIndex:1]] month]),
                           [[cal_ components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:(NSDate *)[data_ objectAtIndex:1]] year]) ,
            QuantLib::Date(
                           [[cal_ components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:(NSDate *)[data_ objectAtIndex:2]] day],
                           intToMonth([[cal_ components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:(NSDate *)[data_ objectAtIndex:2]] month]),
                           [[cal_ components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:(NSDate *)[data_ objectAtIndex:2]] year]) ,
            QuantLib::Date(
                           [[cal_ components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:(NSDate *)[data_ objectAtIndex:3]] day],
                           intToMonth([[cal_ components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:(NSDate *)[data_ objectAtIndex:3]] month]),
                           [[cal_ components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:(NSDate *)[data_ objectAtIndex:3]] year]) ,
            QuantLib::Date(
                           [[cal_ components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:(NSDate *)[data_ objectAtIndex:4]] day],
                           intToMonth([[cal_ components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:(NSDate *)[data_ objectAtIndex:4]] month]),
                           [[cal_ components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:(NSDate *)[data_ objectAtIndex:4]] year])
        };
        
        

        
        data_ = [NSKeyedUnarchiver unarchiveObjectWithData:bondParameters.maturityDates];
        Date maturities[] = {
            QuantLib::Date(
                           [[cal_ components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:(NSDate *)[data_ objectAtIndex:0]] day],
                           intToMonth([[cal_ components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:(NSDate *)[data_ objectAtIndex:0]] month]),
                           [[cal_ components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:(NSDate *)[data_ objectAtIndex:0]] year]) ,
            QuantLib::Date(
                           [[cal_ components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:(NSDate *)[data_ objectAtIndex:1]] day],
                           intToMonth([[cal_ components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:(NSDate *)[data_ objectAtIndex:1]] month]),
                           [[cal_ components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:(NSDate *)[data_ objectAtIndex:1]] year]) ,
            QuantLib::Date(
                           [[cal_ components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:(NSDate *)[data_ objectAtIndex:2]] day],
                           intToMonth([[cal_ components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:(NSDate *)[data_ objectAtIndex:2]] month]),
                           [[cal_ components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:(NSDate *)[data_ objectAtIndex:2]] year]) ,
            QuantLib::Date(
                           [[cal_ components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:(NSDate *)[data_ objectAtIndex:3]] day],
                           intToMonth([[cal_ components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:(NSDate *)[data_ objectAtIndex:3]] month]),
                           [[cal_ components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:(NSDate *)[data_ objectAtIndex:3]] year]) ,
            QuantLib::Date(
                          [[cal_ components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:(NSDate *)[data_ objectAtIndex:4]] day],
                          intToMonth([[cal_ components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:(NSDate *)[data_ objectAtIndex:4]] month]),
                          [[cal_ components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:(NSDate *)[data_ objectAtIndex:4]] year])
        };
        
        
        data_ = [NSKeyedUnarchiver unarchiveObjectWithData:bondParameters.couponRates];
        num = [data_ objectAtIndex:0];
        Real couponRates[] = {
            [[data_ objectAtIndex:0] doubleValue],
            [[data_ objectAtIndex:1] doubleValue],
            [[data_ objectAtIndex:2] doubleValue],
            [[data_ objectAtIndex:3] doubleValue],
            [[data_ objectAtIndex:4] doubleValue]
        };
        
        data_ = [NSKeyedUnarchiver unarchiveObjectWithData:bondParameters.marketQuotes];
        num = [data_ objectAtIndex:0];
        Real marketQuotes[] = {
            (Real)[[data_ objectAtIndex:0] doubleValue],
            (Real)[[data_ objectAtIndex:1] doubleValue],
            (Real)[[data_ objectAtIndex:2] doubleValue],
            (Real)[[data_ objectAtIndex:3] doubleValue],
            (Real)[[data_ objectAtIndex:4] doubleValue]
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
        

        data_ = [NSKeyedUnarchiver unarchiveObjectWithData:bondParameters.depositQuotes];
        num = [data_ objectAtIndex:0];
        Rate d1wQuote=(Rate)[num doubleValue];
        
        num = [data_ objectAtIndex:1];
        Rate d1mQuote=(Rate)[num doubleValue];;
        
        num = [data_ objectAtIndex:2];
        Rate d3mQuote=(Rate)[num doubleValue];;
        
        num = [data_ objectAtIndex:3];
        Rate d6mQuote=(Rate)[num doubleValue];;
        
        num = [data_ objectAtIndex:4];
        Rate d9mQuote=(Rate)[num doubleValue];;
        
        num = [data_ objectAtIndex:5];
        Rate d1yQuote=(Rate)[num doubleValue];;
        
        data_ = [NSKeyedUnarchiver unarchiveObjectWithData:bondParameters.swapQuotes];
        num = [data_ objectAtIndex:0];
        
        Rate s2yQuote= (Rate)[num doubleValue];
        
        num = [data_ objectAtIndex:1];
        Rate s3yQuote=(Rate)[num doubleValue];
        
        num = [data_ objectAtIndex:1];
        Rate s5yQuote=(Rate)[num doubleValue];
        
        num = [data_ objectAtIndex:3];
        Rate s10yQuote=(Rate)[num doubleValue];
        
        num = [data_ objectAtIndex:4];
        Rate s15yQuote=(Rate)[num doubleValue];
        
        
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
        
//        Date date = [self changeDate:bondParameters.zeroCouponBondFirstDate];
        
        NSCalendar *cal = [NSCalendar currentCalendar];
        [cal setTimeZone:[NSTimeZone localTimeZone]];
        [cal setLocale:[NSLocale currentLocale]];
        NSDateComponents *components = [cal components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:bondParameters.zeroCouponBondFirstDate];
        int year = [components year];
        int m = [components month];
        int day = [components day];
        QuantLib::Month month = intToMonth(m);
        QuantLib::Date(day,month,year);
        
        
        components = [cal components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:bondParameters.zeroCouponBondSecondDate];
        int year_secondDate = [components year];
        int m_secondDate = [components month];
        int day_secondDate = [components day];
        
        
//        QuantLib::Month month = intToMonth(m_secondDate);
//        QuantLib::Date(day_secondDate,month,year_secondDate);
        
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
                                      Date(day,month,year),
                                      Following,
                                      Real(116.92),
                                      Date(day_secondDate,month,year_secondDate));
        
        
        zeroCouponBond.setPricingEngine(bondEngine);

        
        // Fixed 4.5% US Treasury Note
//        Schedule fixedBondSchedule(Date(15, May, 2007),
//                                   Date(15,May,2017), Period(Semiannual),
//                                   UnitedStates(UnitedStates::GovernmentBond),
//                                   Unadjusted, Unadjusted, DateGeneration::Backward, false);
        
        components = [cal components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:bondParameters.fixedBondScheduleFirstDate];
        year = [components year];
        m = [components month];
        day = [components day];
        month = intToMonth(m_secondDate);
        
        components = [cal components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:bondParameters.fixedBondScheduleSecondDate];
        year_secondDate = [components year];
        m_secondDate = [components month];
        day_secondDate = [components day];
        
        int m_second = intToMonth(m_secondDate);
        QuantLib::Month month_second = intToMonth(m);
        
        
        
        Schedule fixedBondSchedule(Date(day, month, year),
                                   Date(day_secondDate, month_second, year_secondDate), Period(Semiannual),
                                   UnitedStates(UnitedStates::GovernmentBond),
                                   Unadjusted, Unadjusted, DateGeneration::Backward, false);
        
        
        components = [cal components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:bondParameters.fixedRateBondFirstDate];
        year = [components year];
        m = [components month];
        day = [components day];
        month = intToMonth(m_secondDate);
        
        FixedRateBond fixedRateBond(
                                    settlementDays,
                                    faceAmount,
                                    fixedBondSchedule,
                                    std::vector<Rate>(1, 0.045),
                                    ActualActual(ActualActual::Bond),
                                    ModifiedFollowing,
                                    100.0, Date(day, month, year));
        
        
        fixedRateBond.setPricingEngine(bondEngine);
        
        // Floating rate bond (3M USD Libor + 0.1%)
        // Should and will be priced on another curve later...
        
        RelinkableHandle<YieldTermStructure> liborTermStructure;
        const boost::shared_ptr<IborIndex> libor3m(
                                                   new USDLibor(Period(3,Months),liborTermStructure));
        
        components = [cal components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:bondParameters.fixedRateBondFirstDate];
        year = [components year];
        m = [components month];
        day = [components day];
        month = intToMonth(m_secondDate);
        libor3m->addFixing(Date(day, month, year),0.0278625);

        components = [cal components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:bondParameters.floatingBondScheduleFirstDate];
        year = [components year];
        m = [components month];
        day = [components day];
        month = intToMonth(m_secondDate);
        
        components = [cal components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:bondParameters.floatingBondScheduleSecondDate];
        year_secondDate = [components year];
        m_secondDate = [components month];
        day_secondDate = [components day];
        
        m_second = intToMonth(m_secondDate);
        month_second = intToMonth(m);

        Schedule floatingBondSchedule(Date(day, month, year),
                                      Date(day_secondDate, month_second, year_secondDate), Period(Quarterly),
                                      UnitedStates(UnitedStates::NYSE),
                                      Unadjusted, Unadjusted, DateGeneration::Backward, true);
        

        
        components = [cal components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:bondParameters.floatingRateBondScheduleFirstDate];
        year = [components year];
        m = [components month];
        day = [components day];
        month = intToMonth(m_secondDate);
        
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
                                          Date(day, month, year));
        
//        floatingRateBondScheduleFirstDate
        
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

        

        // zeroCouponnpv
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

