//
//  FittedBondCurve.m
//  QuantLibExample
//
//  Created by colman on 15.07.13.
//  Copyright (c) 2013 Striding Edge Technologies. All rights reserved.
//

#import "FittedBondCurve.h"

#include <ql/quantlib.hpp>


#include <boost/timer.hpp>
#include <iostream>
#include <iomanip>

@implementation FittedBondCurve

using namespace QuantLib;
using namespace std;


// par-rate approximation
Rate parRate(const YieldTermStructure& yts,
             const std::vector<Date>& dates,
             const DayCounter& resultDayCounter) {
    QL_REQUIRE(dates.size() >= 2, "at least two dates are required");
    Real sum = 0.0;
    Time dt;
    for (int i=1; i<dates.size(); ++i) {
        dt = resultDayCounter.yearFraction(dates[i-1], dates[i]);
        QL_REQUIRE(dt>0.0, "unsorted dates");
        sum += yts.discount(dates[i]) * dt;
    }
    Real result = yts.discount(dates.front()) - yts.discount(dates.back());
    return result/sum;
}

void printOutput(const std::string& tag,
                 const boost::shared_ptr<FittedBondDiscountCurve>& curve) {
    cout << tag << endl;
    cout << "reference date : "
    << curve->referenceDate()
    << endl;
    cout << "number of iterations : "
    << curve->fitResults().numberOfIterations()
    << endl
    << endl;
    
//    Date * date = curve->referenceDate();
//    NSLog(@"%@", curve->referenceDate());
//    float curve1 = curve->;
    float curve2 = curve->fitResults().numberOfIterations();
    
    NSLog(@"------------------------------------------------------------");
    NSLog(@" inside of printOut %f" , curve2);
    NSLog(@"------------------------------------------------------------");
}

-(void) calculate {
    try {
        
        boost::timer timer;
        
        const int numberOfBonds = 15;
        Real cleanPrice[numberOfBonds];
        
        for (int i=0; i<numberOfBonds; i++) {
            cleanPrice[i]=100.0;
        }
        
        std::vector< boost::shared_ptr<SimpleQuote> > quote;
        for (int i=0; i<numberOfBonds; i++) {
            boost::shared_ptr<SimpleQuote> cp(new SimpleQuote(cleanPrice[i]));
            quote.push_back(cp);
        }
        
        RelinkableHandle<Quote> quoteHandle[numberOfBonds];
        for (int i=0; i<numberOfBonds; i++) {
            quoteHandle[i].linkTo(quote[i]);
        }
        
        Integer lengths[] = { 2, 4, 6, 8, 10, 12, 14, 16,
            18, 20, 22, 24, 26, 28, 30 };
        int lengthsSize = 13;
        Real coupons[] = { 0.0200, 0.0225, 0.0250, 0.0275, 0.0300,
            0.0325, 0.0350, 0.0375, 0.0400, 0.0425,
            0.0450, 0.0475, 0.0500, 0.0525, 0.0550 };
        
        Frequency frequency = Annual;
        DayCounter dc = SimpleDayCounter();
        BusinessDayConvention accrualConvention = ModifiedFollowing;
        BusinessDayConvention convention = ModifiedFollowing;
        Real redemption = 100.0;
        
        Calendar calendar = NullCalendar();
        Date today = calendar.adjust(Date::todaysDate());
        Date origToday = today;
        Settings::instance().evaluationDate() = today;
        
        // changing bondSettlementDays=3 increases calculation
        // time of exponentialsplines fitting method
        Natural bondSettlementDays = 0;
        Natural curveSettlementDays = 0;
        
        Date bondSettlementDate = calendar.advance(today, bondSettlementDays*Days);
        
        cout << endl;
        cout << "Today's date: " << today << endl;
        cout << "Bonds' settlement date: " << bondSettlementDate << endl;
        cout << "Calculating fit for 15 bonds....." << endl << endl;
        
        std::vector<boost::shared_ptr<BondHelper> > instrumentsA;
        std::vector<boost::shared_ptr<RateHelper> > instrumentsB;
        
//        for (int j=0; j<LENGTH(lengths); j++) {
        for (int j=0; j<lengthsSize; j++) {
            
            Date maturity = calendar.advance(bondSettlementDate, lengths[j]*Years);
            
            Schedule schedule(bondSettlementDate, maturity, Period(frequency),
                              calendar, accrualConvention, accrualConvention,
                              DateGeneration::Backward, false);
            
            boost::shared_ptr<BondHelper> helperA(
                                                  new FixedRateBondHelper(quoteHandle[j],
                                                                          bondSettlementDays,
                                                                          100.0,
                                                                          schedule,
                                                                          std::vector<Rate>(1,coupons[j]),
                                                                          dc,
                                                                          convention,
                                                                          redemption));
            
            boost::shared_ptr<RateHelper> helperB(
                                                  new FixedRateBondHelper(quoteHandle[j],
                                                                          bondSettlementDays,
                                                                          100.0,
                                                                          schedule,
                                                                          std::vector<Rate>(1, coupons[j]),
                                                                          dc,
                                                                          convention,
                                                                          redemption));
            instrumentsA.push_back(helperA);
            instrumentsB.push_back(helperB);
        }
        
        
        bool constrainAtZero = true;
        Real tolerance = 1.0e-10;
        int max = 5000;
        
        boost::shared_ptr<YieldTermStructure> ts0 (
                                                   new PiecewiseYieldCurve<Discount,LogLinear>(curveSettlementDays,
                                                                                               calendar,
                                                                                               instrumentsB,
                                                                                               dc));
        
        ExponentialSplinesFitting exponentialSplines(constrainAtZero);
        
        boost::shared_ptr<FittedBondDiscountCurve> ts1 (
                                                        new FittedBondDiscountCurve(curveSettlementDays,
                                                                                    calendar,
                                                                                    instrumentsA,
                                                                                    dc,
                                                                                    exponentialSplines,
                                                                                    tolerance,
                                                                                    max));
        
        printOutput("(a) exponential splines", ts1);
        
        
        SimplePolynomialFitting simplePolynomial(3, constrainAtZero);
        
        boost::shared_ptr<FittedBondDiscountCurve> ts2 (
                                                        new FittedBondDiscountCurve(curveSettlementDays,
                                                                                    calendar,
                                                                                    instrumentsA,
                                                                                    dc,
                                                                                    simplePolynomial,
                                                                                    tolerance,
                                                                                    max));
        
        printOutput("(b) simple polynomial", ts2);
        
        
        NelsonSiegelFitting nelsonSiegel;
        
        boost::shared_ptr<FittedBondDiscountCurve> ts3 (
                                                        new FittedBondDiscountCurve(curveSettlementDays,
                                                                                    calendar,
                                                                                    instrumentsA,
                                                                                    dc,
                                                                                    nelsonSiegel,
                                                                                    tolerance,
                                                                                    max));
        
        printOutput("(c) Nelson-Siegel", ts3);
        
        
        // a cubic bspline curve with 11 knot points, implies
        // n=6 (constrained problem) basis functions
        
        Time knots[] =  { -30.0, -20.0,  0.0,  5.0, 10.0, 15.0,
            20.0,  25.0, 30.0, 40.0, 50.0 };
        
        std::vector<Time> knotVector;
//        for (int i=0; i< LENGTH(knots); i++) {
        int knotSize = 11;
        for (int i=0; i< knotSize; i++) {
            knotVector.push_back(knots[i]);
        }
        
        CubicBSplinesFitting cubicBSplines(knotVector, constrainAtZero);
        
        boost::shared_ptr<FittedBondDiscountCurve> ts4 (
                                                        new FittedBondDiscountCurve(curveSettlementDays,
                                                                                    calendar,
                                                                                    instrumentsA,
                                                                                    dc,
                                                                                    cubicBSplines,
                                                                                    tolerance,
                                                                                    max));
        
        printOutput("(d) cubic B-splines", ts4);
        
        SvenssonFitting svensson;
        
        boost::shared_ptr<FittedBondDiscountCurve> ts5 (
                                                        new FittedBondDiscountCurve(curveSettlementDays,
                                                                                    calendar,
                                                                                    instrumentsA,
                                                                                    dc,
                                                                                    svensson,
                                                                                    tolerance,
                                                                                    max));
        
        printOutput("(e) Svensson", ts5);
        
        
        cout << "Output par rates for each curve. In this case, "
        << endl
        << "par rates should equal coupons for these par bonds."
        << endl
        << endl;
        
        cout << setw(6) << "tenor" << " | "
        << setw(6) << "coupon" << " | "
        << setw(6) << "bstrap" << " | "
        << setw(6) << "(a)" << " | "
        << setw(6) << "(b)" << " | "
        << setw(6) << "(c)" << " | "
        << setw(6) << "(d)" << " | "
        << setw(6) << "(e)" << endl;
        
        for (int i=0; i<instrumentsA.size(); i++) {
            
            std::vector<boost::shared_ptr<CashFlow> > cfs =
            instrumentsA[i]->bond()->cashflows();
            
            int cfSize = instrumentsA[i]->bond()->cashflows().size();
            std::vector<Date> keyDates;
            keyDates.push_back(bondSettlementDate);
            
            for (int j=0; j<cfSize-1; j++) {
                if (!cfs[j]->hasOccurred(bondSettlementDate, false)) {
                    Date myDate =  cfs[j]->date();
                    keyDates.push_back(myDate);
                }
            }
            
            Real tenor = dc.yearFraction(today, cfs[cfSize-1]->date());
            
            cout << setw(6) << fixed << setprecision(3) << tenor << " | "
            << setw(6) << fixed << setprecision(3)
            << 100.*coupons[i] << " | "
            // piecewise bootstrap
            << setw(6) << fixed << setprecision(3)
            << 100.*parRate(*ts0,keyDates,dc) << " | "
            // exponential splines
            << setw(6) << fixed << setprecision(3)
            << 100.*parRate(*ts1,keyDates,dc) << " | "
            // simple polynomial
            << setw(6) << fixed << setprecision(3)
            << 100.*parRate(*ts2,keyDates,dc) << " | "
            // Nelson-Siegel
            << setw(6) << fixed << setprecision(3)
            << 100.*parRate(*ts3,keyDates,dc) << " | "
            // cubic bsplines
            << setw(6) << fixed << setprecision(3)
            << 100.*parRate(*ts4,keyDates,dc) << " | "
            // Svensson
            << setw(6) << fixed << setprecision(3)
            << 100.*parRate(*ts5,keyDates,dc) << endl;

            // piecewise bootstrap
            float piecewiseBootstrap = 100.*parRate(*ts0,keyDates,dc);
            // exponential splines
            float exponentialSplines = 100.*parRate(*ts1,keyDates,dc);
            // simple polynomial
            float simplePolynomial = 100.*parRate(*ts2,keyDates,dc);
            // Nelson-Siegel
            float nelsonSiegel = 100.*parRate(*ts3,keyDates,dc);
            // cubic bsplines
            float cubicBsplines = 100.*parRate(*ts4,keyDates,dc);
            // Svensson
            float svensson = 100.*parRate(*ts5,keyDates,dc);
            
            NSLog(@"------------------------------------------------------------");
            NSLog(@"------------------- even higher ----------------------------");
            NSLog(@"%f, %f, %f, %f, %f, %f", piecewiseBootstrap, exponentialSplines, simplePolynomial, nelsonSiegel, cubicBsplines, svensson);
            NSLog(@"------------------------------------------------------------");
            
        }
        
        cout << endl << endl << endl;
        cout << "Now add 23 months to today. Par rates should be "  << endl
        << "automatically recalculated because today's date "  << endl
        << "changes.  Par rates will NOT equal coupons (YTM "  << endl
        << "will, with the correct compounding), but the "     << endl
        << "piecewise yield curve par rates can be used as "   << endl
        << "a benchmark for correct par rates."
        << endl
        << endl;
        
        today = calendar.advance(origToday,23,Months,convention);
        Settings::instance().evaluationDate() = today;
        bondSettlementDate = calendar.advance(today, bondSettlementDays*Days);
        
        printOutput("(a) exponential splines", ts1);
        
        printOutput("(b) simple polynomial", ts2);
        
        printOutput("(c) Nelson-Siegel", ts3);
        
        printOutput("(d) cubic B-splines", ts4);
        
        printOutput("(e) Svensson", ts5);
        
        cout << endl
        << endl;
        
        
        cout << setw(6) << "tenor" << " | "
        << setw(6) << "coupon" << " | "
        << setw(6) << "bstrap" << " | "
        << setw(6) << "(a)" << " | "
        << setw(6) << "(b)" << " | "
        << setw(6) << "(c)" << " | "
        << setw(6) << "(d)" << endl;
        
        for (int i=0; i<instrumentsA.size(); i++) {
            
            std::vector<boost::shared_ptr<CashFlow> > cfs =
            instrumentsA[i]->bond()->cashflows();
            
            int cfSize = instrumentsA[i]->bond()->cashflows().size();
            std::vector<Date> keyDates;
            keyDates.push_back(bondSettlementDate);
            
            for (int j=0; j<cfSize-1; j++) {
                if (!cfs[j]->hasOccurred(bondSettlementDate, false)) {
                    Date myDate =  cfs[j]->date();
                    keyDates.push_back(myDate);
                }
            }
            
            Real tenor = dc.yearFraction(today, cfs[cfSize-1]->date());
            
            cout << setw(6) << fixed << setprecision(3) << tenor << " | "
            << setw(6) << fixed << setprecision(3)
            << 100.*coupons[i] << " | "
            // piecewise bootstrap
            << setw(6) << fixed << setprecision(3)
            << 100.*parRate(*ts0,keyDates,dc) << " | "
            // exponential splines
            << setw(6) << fixed << setprecision(3)
            << 100.*parRate(*ts1,keyDates,dc) << " | "
            // simple polynomial
            << setw(6) << fixed << setprecision(3)
            << 100.*parRate(*ts2,keyDates,dc) << " | "
            // Nelson-Siegel
            << setw(6) << fixed << setprecision(3)
            << 100.*parRate(*ts3,keyDates,dc) << " | "
            // cubic bsplines
            << setw(6) << fixed << setprecision(3)
            << 100.*parRate(*ts4,keyDates,dc) << " | "
            // Svensson
            << setw(6) << fixed << setprecision(3)
            << 100.*parRate(*ts5,keyDates,dc) << endl;
            
            
            // piecewise bootstrap
            float piecewiseBootstrap = 100.*parRate(*ts0,keyDates,dc);
            // exponential splines
            float exponentialSplines = 100.*parRate(*ts1,keyDates,dc);
            // simple polynomial
            float simplePolynomial = 100.*parRate(*ts2,keyDates,dc);
            // Nelson-Siegel
            float nelsonSiegel = 100.*parRate(*ts3,keyDates,dc);
            // cubic bsplines
            float cubicBsplines = 100.*parRate(*ts4,keyDates,dc);
            // Svensson
            float svensson = 100.*parRate(*ts5,keyDates,dc);
            
            NSLog(@"------------------------------------------------------------");
            NSLog(@"------------------- again somewhere ------------------------");
            NSLog(@"%f, %f, %f, %f, %f, %f", piecewiseBootstrap, exponentialSplines, simplePolynomial, nelsonSiegel, cubicBsplines, svensson);
            NSLog(@"------------------------------------------------------------");
            
        }
        
        cout << endl << endl << endl;
        cout << "Now add one more month, for a total of two years " << endl
        << "from the original date. The first instrument is "  << endl
        << "now expired and par rates should again equal "     << endl
        << "coupon values, since clean prices did not change."
        << endl
        << endl;
        
        instrumentsA.erase(instrumentsA.begin(),
                           instrumentsA.begin()+1);
        instrumentsB.erase(instrumentsB.begin(),
                           instrumentsB.begin()+1);
        
        today = calendar.advance(origToday,24,Months,convention);
        Settings::instance().evaluationDate() = today;
        bondSettlementDate = calendar.advance(today, bondSettlementDays*Days);
        
        boost::shared_ptr<YieldTermStructure> ts00 (
                                                    new PiecewiseYieldCurve<Discount,LogLinear>(curveSettlementDays,
                                                                                                calendar,
                                                                                                instrumentsB,
                                                                                                dc));
        
        boost::shared_ptr<FittedBondDiscountCurve> ts11 (
                                                         new FittedBondDiscountCurve(curveSettlementDays,
                                                                                     calendar,
                                                                                     instrumentsA,
                                                                                     dc,
                                                                                     exponentialSplines,
                                                                                     tolerance,
                                                                                     max));
        
        printOutput("(a) exponential splines", ts11);
        
        
        boost::shared_ptr<FittedBondDiscountCurve> ts22 (
                                                         new FittedBondDiscountCurve(curveSettlementDays,
                                                                                     calendar,
                                                                                     instrumentsA,
                                                                                     dc,
                                                                                     simplePolynomial,
                                                                                     tolerance,
                                                                                     max));
        
        printOutput("(b) simple polynomial", ts22);
        
        
        boost::shared_ptr<FittedBondDiscountCurve> ts33 (
                                                         new FittedBondDiscountCurve(curveSettlementDays,
                                                                                     calendar,
                                                                                     instrumentsA,
                                                                                     dc,
                                                                                     nelsonSiegel,
                                                                                     tolerance,
                                                                                     max));
        
        printOutput("(c) Nelson-Siegel", ts33);
        
        
        boost::shared_ptr<FittedBondDiscountCurve> ts44 (
                                                         new FittedBondDiscountCurve(curveSettlementDays,
                                                                                     calendar,
                                                                                     instrumentsA,
                                                                                     dc,
                                                                                     cubicBSplines,
                                                                                     tolerance,
                                                                                     max));
        
        printOutput("(d) cubic B-splines", ts44);
        
        boost::shared_ptr<FittedBondDiscountCurve> ts55 (
                                                         new FittedBondDiscountCurve(curveSettlementDays,
                                                                                     calendar,
                                                                                     instrumentsA,
                                                                                     dc,
                                                                                     svensson,
                                                                                     tolerance,
                                                                                     max));
        
        printOutput("(e) Svensson", ts55);
        
        
        cout << setw(6) << "tenor" << " | "
        << setw(6) << "coupon" << " | "
        << setw(6) << "bstrap" << " | "
        << setw(6) << "(a)" << " | "
        << setw(6) << "(b)" << " | "
        << setw(6) << "(c)" << " | "
        << setw(6) << "(d)" << " | "
        << setw(6) << "(e)" << endl;
        
        for (int i=0; i<instrumentsA.size(); i++) {
            
            std::vector<boost::shared_ptr<CashFlow> > cfs =
            instrumentsA[i]->bond()->cashflows();
            
            int cfSize = instrumentsA[i]->bond()->cashflows().size();
            std::vector<Date> keyDates;
            keyDates.push_back(bondSettlementDate);
            
            for (int j=0; j<cfSize-1; j++) {
                if (!cfs[j]->hasOccurred(bondSettlementDate, false)) {
                    Date myDate =  cfs[j]->date();
                    keyDates.push_back(myDate);
                }
            }
            
            Real tenor = dc.yearFraction(today, cfs[cfSize-1]->date());
            
            cout << setw(6) << fixed << setprecision(3) << tenor << " | "
            << setw(6) << fixed << setprecision(3)
            << 100.*coupons[i+1] << " | "
            // piecewise bootstrap
            << setw(6) << fixed << setprecision(3)
            << 100.*parRate(*ts00,keyDates,dc) << " | "
            // exponential splines
            << setw(6) << fixed << setprecision(3)
            << 100.*parRate(*ts11,keyDates,dc) << " | "
            // simple polynomial
            << setw(6) << fixed << setprecision(3)
            << 100.*parRate(*ts22,keyDates,dc) << " | "
            // Nelson-Siegel
            << setw(6) << fixed << setprecision(3)
            << 100.*parRate(*ts33,keyDates,dc) << " | "
            // cubic bsplines
            << setw(6) << fixed << setprecision(3)
            << 100.*parRate(*ts44,keyDates,dc) << " | "
            // Svensson
            << setw(6) << fixed << setprecision(3)
            << 100.*parRate(*ts55,keyDates,dc) << endl;
            
            // exponential splines
            float exponentialSplines = 100.*parRate(*ts11,keyDates,dc);
            // simple polynomial
            float simplePolynomial = 100.*parRate(*ts22,keyDates,dc);
            // Nelson-Siegel
            float simplePolynomial2 = 100.*parRate(*ts33,keyDates,dc);
            // cubic bsplines
            float simplePolynomial3 = 100.*parRate(*ts44,keyDates,dc);
            // Svensson
            float simplePolynomial4= 100.*parRate(*ts55,keyDates,dc);
            
            NSLog(@"------------------------------------------------------------");
            NSLog(@"------------------- where am i -----------------------------");
            NSLog(@" %f, %f, %f, %f",  exponentialSplines, simplePolynomial, simplePolynomial2, simplePolynomial3, simplePolynomial4   );
            NSLog(@"------------------------------------------------------------");
            NSLog(@"------------------------------------------------------------");

            
        }
        
        
        cout << endl << endl << endl;
        cout << "Now decrease prices by a small amount, corresponding"  << endl
        << "to a theoretical five basis point parallel + shift of" << endl
        << "the yield curve. Because bond quotes change, the new " << endl
        << "par rates should be recalculated automatically."
        << endl
        << endl;
        
//        for (int k=0; k<LENGTH(lengths)-1; k++) {
        for (int k=0; k<lengthsSize-1; k++) {
            Real P = instrumentsA[k]->quote()->value();
            const Bond& b = *instrumentsA[k]->bond();
            Rate ytm = BondFunctions::yield(b, P,
                                            dc, Compounded, frequency,
                                            today);
            Time dur = BondFunctions::duration(b, ytm,
                                               dc, Compounded, frequency,
                                               QuantLib::Duration::Modified,
                                               today);
            
            const Real bpsChange = 5.;
            // dP = -dur * P * dY
            Real deltaP = -dur * P * (bpsChange/10000.);
            quote[k+1]->setValue(P + deltaP);
        }
        
        
        cout << setw(6) << "tenor" << " | "
        << setw(6) << "coupon" << " | "
        << setw(6) << "bstrap" << " | "
        << setw(6) << "(a)" << " | "
        << setw(6) << "(b)" << " | "
        << setw(6) << "(c)" << " | "
        << setw(6) << "(d)" << " | "
        << setw(6) << "(e)" << endl;
        
        for (int i=0; i<instrumentsA.size(); i++) {
            
            std::vector<boost::shared_ptr<CashFlow> > cfs =
            instrumentsA[i]->bond()->cashflows();
            
            int cfSize = instrumentsA[i]->bond()->cashflows().size();
            std::vector<Date> keyDates;
            keyDates.push_back(bondSettlementDate);
            
            for (int j=0; j<cfSize-1; j++) {
                if (!cfs[j]->hasOccurred(bondSettlementDate, false)) {
                    Date myDate =  cfs[j]->date();
                    keyDates.push_back(myDate);
                }
            }
            
            Real tenor = dc.yearFraction(today, cfs[cfSize-1]->date());
            
            cout << setw(6) << fixed << setprecision(3) << tenor << " | "
            << setw(6) << fixed << setprecision(3)
            << 100.*coupons[i+1] << " | "
            // piecewise bootstrap
            << setw(6) << fixed << setprecision(3)
            << 100.*parRate(*ts00,keyDates,dc) << " | "
            // exponential splines
            << setw(6) << fixed << setprecision(3)
            << 100.*parRate(*ts11,keyDates,dc) << " | "
            // simple polynomial
            << setw(6) << fixed << setprecision(3)
            << 100.*parRate(*ts22,keyDates,dc) << " | "
            // Nelson-Siegel
            << setw(6) << fixed << setprecision(3)
            << 100.*parRate(*ts33,keyDates,dc) << " | "
            // cubic bsplines
            << setw(6) << fixed << setprecision(3)
            << 100.*parRate(*ts44,keyDates,dc) << " | "
            // Svensson
            << setw(6) << fixed << setprecision(3)
            << 100.*parRate(*ts55,keyDates,dc) << endl;
            
            // piecewise bootstrap
            float exponentialSplines = 100.*parRate(*ts00,keyDates,dc);
            // exponential splines
            float piecewiseBootstrap = 100.*parRate(*ts00,keyDates,dc);
            // exponential splines
            float exponentialSplines2 = 100.*parRate(*ts11,keyDates,dc);
            // simple polynomial
            float simplePolynomial = 100.*parRate(*ts22,keyDates,dc);
            // Nelson-Siegel
            float nelsonSiegel =  100.*parRate(*ts33,keyDates,dc);
            // cubic bsplines
            int cubicBsplines = 100.*parRate(*ts44,keyDates,dc); // problem
            // Svensson
            float Svensson = 100.*parRate(*ts55,keyDates,dc);
            
            NSLog(@"------------------------------------------------------------");
            NSLog(@"------------------- am i here -----------------------------");
            NSLog(@" %f, %f, %f, %f, %f",  exponentialSplines2, piecewiseBootstrap, simplePolynomial, nelsonSiegel, exponentialSplines, Svensson   );
            NSLog(@"------------------------------------------------------------");
            NSLog(@"------------------------------------------------------------");
        }
        
        
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
        
//        return 0;
        
    } catch (std::exception& e) {
        cerr << e.what() << endl;
//        return 1;
    } catch (...) {
        cerr << "unknown error" << endl;
//        return 1;
    }
}

@end
