//
//  Repo.m
//  QuantLibExample
//
//  Created by colman on 15.07.13.
//  Copyright (c) 2013 Striding Edge Technologies. All rights reserved.
//

#import "Repo.h"

#include <ql/quantlib.hpp>
#include <boost/timer.hpp>
#include <iostream>


//#if defined(QL_ENABLE_SESSIONS)
//namespace QuantLib {
//    
//    Integer sessionId() { return 0; }
//    
//}
//#endif


@implementation Repo


using namespace std;
using namespace QuantLib;


-(void) calculate {
    try {
        
        boost::timer timer;
        std::cout << std::endl;
        
        Date repoSettlementDate(14,February,2000);;
        Date repoDeliveryDate(15,August,2000);
        Rate repoRate = 0.05;
        DayCounter repoDayCountConvention = Actual360();
        Integer repoSettlementDays = 0;
        Compounding repoCompounding = Simple;
        Frequency repoCompoundFreq = Annual;
        
        // assume a ten year bond- this is irrelevant
        Date bondIssueDate(15,September,1995);
        Date bondDatedDate(15,September,1995);
        Date bondMaturityDate(15,September,2005);
        Real bondCoupon = 0.08;
        Frequency bondCouponFrequency = Semiannual;
        // unknown what calendar fincad is using
        Calendar bondCalendar = NullCalendar();
        DayCounter bondDayCountConvention = Thirty360(Thirty360::BondBasis);
        // unknown what fincad is using. this may affect accrued calculation
        Integer bondSettlementDays = 0;
        BusinessDayConvention bondBusinessDayConvention = Unadjusted;
        Real bondCleanPrice = 89.97693786;
        Real bondRedemption = 100.0;
        Real faceAmount = 100.0;
        
        
        Settings::instance().evaluationDate() = repoSettlementDate;
        
        RelinkableHandle<YieldTermStructure> bondCurve;
        bondCurve.linkTo(boost::shared_ptr<YieldTermStructure>(
                                                               new FlatForward(repoSettlementDate,
                                                                               .01, // dummy rate
                                                                               bondDayCountConvention,
                                                                               Compounded,
                                                                               bondCouponFrequency)));
        
        /*
         boost::shared_ptr<FixedRateBond> bond(
         new FixedRateBond(faceAmount,
         bondIssueDate,
         bondDatedDate,
         bondMaturityDate,
         bondSettlementDays,
         std::vector<Rate>(1,bondCoupon),
         bondCouponFrequency,
         bondCalendar,
         bondDayCountConvention,
         bondBusinessDayConvention,
         bondBusinessDayConvention,
         bondRedemption,
         bondCurve));
         */
        
        Schedule bondSchedule(bondDatedDate, bondMaturityDate,
                              Period(bondCouponFrequency),
                              bondCalendar,bondBusinessDayConvention,
                              bondBusinessDayConvention,
                              DateGeneration::Backward,false);
        boost::shared_ptr<FixedRateBond> bond(
                                              new FixedRateBond(bondSettlementDays,
                                                                faceAmount,
                                                                bondSchedule,
                                                                std::vector<Rate>(1,bondCoupon),
                                                                bondDayCountConvention,
                                                                bondBusinessDayConvention,
                                                                bondRedemption,
                                                                bondIssueDate));
        bond->setPricingEngine(boost::shared_ptr<PricingEngine>(
                                                                new DiscountingBondEngine(bondCurve)));
        
        bondCurve.linkTo(boost::shared_ptr<YieldTermStructure> (
                                                                new FlatForward(repoSettlementDate,
                                                                                bond->yield(bondCleanPrice,
                                                                                            bondDayCountConvention,
                                                                                            Compounded,
                                                                                            bondCouponFrequency),
                                                                                bondDayCountConvention,
                                                                                Compounded,
                                                                                bondCouponFrequency)));
        
        Position::Type fwdType = Position::Long;
        double dummyStrike = 91.5745;
        
        RelinkableHandle<YieldTermStructure> repoCurve;
        repoCurve.linkTo(boost::shared_ptr<YieldTermStructure> (
                                                                new FlatForward(repoSettlementDate,
                                                                                repoRate,
                                                                                repoDayCountConvention,
                                                                                repoCompounding,
                                                                                repoCompoundFreq)));
        
        
        FixedRateBondForward bondFwd(repoSettlementDate,
                                     repoDeliveryDate,
                                     fwdType,
                                     dummyStrike,
                                     repoSettlementDays,
                                     repoDayCountConvention,
                                     bondCalendar,
                                     bondBusinessDayConvention,
                                     bond,
                                     repoCurve,
                                     repoCurve);
        
        
        cout << "Underlying bond clean price: "
        << bond->cleanPrice()
        << endl;
        cout << "Underlying bond dirty price: "
        << bond->dirtyPrice()
        << endl;
        cout << "Underlying bond accrued at settlement: "
        << bond->accruedAmount(repoSettlementDate)
        << endl;
        cout << "Underlying bond accrued at delivery:   "
        << bond->accruedAmount(repoDeliveryDate)
        << endl;
        cout << "Underlying bond spot income: "
        << bondFwd.spotIncome(repoCurve)
        << endl;
        cout << "Underlying bond fwd income:  "
        << bondFwd.spotIncome(repoCurve)/
        repoCurve->discount(repoDeliveryDate)
        << endl;
        cout << "Repo strike: "
        << dummyStrike
        << endl;
        cout << "Repo NPV:    "
        << bondFwd.NPV()
        << endl;
        cout << "Repo clean forward price: "
        << bondFwd.cleanForwardPrice()
        << endl;
        cout << "Repo dirty forward price: "
        << bondFwd.forwardPrice()
        << endl;
        cout << "Repo implied yield: "
        << bondFwd.impliedYield(bond->dirtyPrice(),
                                dummyStrike,
                                repoSettlementDate,
                                repoCompounding,
                                repoDayCountConvention)
        << endl;
        cout << "Market repo rate:   "
        << repoCurve->zeroRate(repoDeliveryDate,
                               repoDayCountConvention,
                               repoCompounding,
                               repoCompoundFreq)
        << endl
        << endl;
        
        cout << "Compare with example given at \n"
        << "http://www.fincad.com/support/developerFunc/mathref/BFWD.htm"
        <<  endl;
        cout << "Clean forward price = 88.2408"
        <<  endl
        <<  endl;
        cout << "In that example, it is unknown what bond calendar they are\n"
        << "using, as well as settlement Days. For that reason, I have\n"
        << "made the simplest possible assumptions here: NullCalendar\n"
        << "and 0 settlement days."
        << endl;
        
        
        Real seconds = timer.elapsed();
        Integer hours = int(seconds/3600);
        seconds -= hours * 3600;
        Integer minutes = int(seconds/60);
        seconds -= minutes * 60;
        cout << " \nRun completed in ";
        if (hours > 0)
            cout << hours << " h ";
        if (hours > 0 || minutes > 0)
            cout << minutes << " m ";
        cout << fixed << setprecision(0)
        << seconds << " s\n" << endl;
        
        
        double res1 = bondFwd.impliedYield(bond->dirtyPrice(),
                                          dummyStrike,
                                          repoSettlementDate,
                                          repoCompounding,
                                          repoDayCountConvention);
        
        double res2 =               repoCurve->zeroRate(repoDeliveryDate,
                                                       repoDayCountConvention,
                                                       repoCompounding,
                                                       repoCompoundFreq);
        NSLog(@"results : %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %d, %d ",
              bond->cleanPrice(),
              bond->dirtyPrice(),
              bond->accruedAmount(repoSettlementDate),
              bond->accruedAmount(repoDeliveryDate),
              bondFwd.spotIncome(repoCurve),
              bondFwd.spotIncome(repoCurve),
              repoCurve->discount(repoDeliveryDate),
              dummyStrike,
              bondFwd.NPV(),
              bondFwd.cleanForwardPrice(),
              bondFwd.forwardPrice(),
              res1,
              res2
              ) ;
        

        
//        return 0;
        
    } catch (exception& e) {
        cerr << e.what() << endl;
//        return 1;
    } catch (...) {
        cerr << "unknown error" << endl;
//        return 1;
    }

}

@end
