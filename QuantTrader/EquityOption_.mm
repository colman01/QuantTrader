//
//  EquityOption_.m
//  QuantLibExample
//
//  Created by colman on 28.06.13.
//  Copyright (c) 2013 Striding Edge Technologies. All rights reserved.
//

#import "EquityOption_.h"
#include <ql/quantlib.hpp>

#include <boost/timer.hpp>
#include <iostream>
#include <iomanip>

@implementation EquityOption_
@synthesize quote, strikePrice, dividentYieldValue, riskFreeRateValue, volatilityValue, underlying_eq, dividendYield_eq, riskFreeRate_eq, volatility_eq,
blackScholes_eo,
hestonSemiAnalytic_eo,
batesSemiAna_eo,
baroneAdesiWhaleySemiAna_eo,
bjerksundStenslandSemiAna_eo,
integral_eo,
finiteDifference_eo,
finiteDifference_bo,
finiteDifference_ao,
binomialJarrowRudd_eo,
binomialJarrowRudd_bo,
binomialJarrowRudd_ao,
binomialCoxRossRubinstein_eo,
binomialCoxRossRubinstein_bo,
binomialCoxRossRubinstein_ao,
additiveEquiprobabilities_eo,
additiveEquiprobabilities_bo,
additiveEquiprobabilities_ao,
binomialTrigeorgis_eo,
binomialTrigeorgis_bo,
binomialTrigeorgis_ao,
binomialTian_eo,
binomialTian_bo,
binomialTian_ao,
binomialLeisenReimer_eo,
binomialLeisenReimer_bo,
binomialLeisenReimer_ao,
binomialJoshi_eo,
binomialJoshi_bo,
binomialJoshi_ao,
mcCrude_eo,
qmcSobol_eo,
mcLongstaffSchwatz_ao,

settlementDate_1,
settlementDate_2,
settlementDate_3,

maturityDate_1,
maturityDate_2,
maturityDate_3


;

-(void) calculate {
        using namespace QuantLib;
        //    try {
        
        boost::timer timer;
//        std::cout << std::endl;
        std::string method;

    
    
        // set up dates
    
//        NSDate *currentDate = [NSDate date];
//        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
//    
//        NSInteger day = [components day];
//        NSInteger month = [components month];
//        NSInteger year = [components year];
//    
//        int s_day = settlementDate_1;
//        Month s_month = intToQLMonth__(settlementDate_2);
//        Year s_year = settlementDate_3;
//    
//        int m_day = maturityDate_1;
//        Month m_month = intToQLMonth__(maturityDate_2);
//        Year m_year = maturityDate_3;
    
    
        Calendar calendar = TARGET();
        Date todaysDate(15, May, 1998);
//        QuantLib::Month thisMonth = intToQLMonth__(month);
//        Date todaysDate((int)day, thisMonth, (int)year);
        Date settlementDate(17, May, 1998);
//        Date settlementDate(s_day, s_month, s_year);
        Settings::instance().evaluationDate() = todaysDate;
        
        // our options
        Option::Type type(Option::Put);
    
    
        Real underlying = underlying_eq;
        Real strike = strikePrice;
        Spread dividendYield = dividendYield_eq;
        Rate riskFreeRate = riskFreeRate_eq;  
        Volatility volatility = volatility_eq;
    
        Date maturity(17, May, 1999);
//        Date maturity(m_day, m_month, m_year);
        DayCounter dayCounter = Actual365Fixed();
        
        std::vector<Date> exerciseDates;
        for (Integer i=1; i<=4; i++)
            exerciseDates.push_back(settlementDate + 3*i*Months);
        
        boost::shared_ptr<Exercise> europeanExercise(new EuropeanExercise(maturity));
        boost::shared_ptr<Exercise> bermudanExercise(new BermudanExercise(exerciseDates));
        boost::shared_ptr<Exercise> americanExercise(new AmericanExercise(settlementDate,
                                                                          maturity));
        
        Handle<Quote> underlyingH(boost::shared_ptr<Quote>(new SimpleQuote(underlying)));
        
        // bootstrap the yield/dividend/vol curves
        Handle<YieldTermStructure> flatTermStructure(boost::shared_ptr<YieldTermStructure>(new FlatForward(settlementDate, riskFreeRate, dayCounter)));
        Handle<YieldTermStructure> flatDividendTS(boost::shared_ptr<YieldTermStructure>(new FlatForward(settlementDate, dividendYield, dayCounter)));
        Handle<BlackVolTermStructure> flatVolTS(boost::shared_ptr<BlackVolTermStructure>(new BlackConstantVol(settlementDate, calendar, volatility,
                                                                                                              dayCounter)));
        boost::shared_ptr<StrikedTypePayoff> payoff(new PlainVanillaPayoff(type, strike));
        boost::shared_ptr<BlackScholesMertonProcess> bsmProcess(new BlackScholesMertonProcess(underlyingH, flatDividendTS,
                                                                                              flatTermStructure, flatVolTS));
        
        // options
        VanillaOption europeanOption(payoff, europeanExercise);
        VanillaOption bermudanOption(payoff, bermudanExercise);
        VanillaOption americanOption(payoff, americanExercise);
    
        // Analytic formulas:
        
        // Black-Scholes for European
        method = "Black-Scholes";
        europeanOption.setPricingEngine(boost::shared_ptr<PricingEngine>(new AnalyticEuropeanEngine(bsmProcess)));
//        NSLog(@"Black-Scholes Euro option %f" , europeanOption.NPV());
        blackScholes_eo = europeanOption.NPV();
    
        // semi-analytic Heston for European
        method = "Heston semi-analytic";
        boost::shared_ptr<HestonProcess> hestonProcess(new HestonProcess(flatTermStructure, flatDividendTS,
                                                                         underlyingH, volatility*volatility,
                                                                         1.0, volatility*volatility, 0.001, 0.0));
        boost::shared_ptr<HestonModel> hestonModel(new HestonModel(hestonProcess));
        europeanOption.setPricingEngine(boost::shared_ptr<PricingEngine>(new AnalyticHestonEngine(hestonModel)));
//        NSLog(@"Heston semi-analytic Euro option %f" , europeanOption.NPV());
        hestonSemiAnalytic_eo = europeanOption.NPV();
    
        
        // semi-analytic Bates for European
        method = "Bates semi-analytic";
        boost::shared_ptr<BatesProcess> batesProcess(new BatesProcess(flatTermStructure, flatDividendTS,
                                                                      underlyingH, volatility*volatility,
                                                                      1.0, volatility*volatility, 0.001, 0.0,
                                                                      1e-14, 1e-14, 1e-14));
        boost::shared_ptr<BatesModel> batesModel(new BatesModel(batesProcess));
        europeanOption.setPricingEngine(boost::shared_ptr<PricingEngine>(new BatesEngine(batesModel)));
//        NSLog(@"Bates semi-analytic Euro option %f" , europeanOption.NPV());
        batesSemiAna_eo = europeanOption.NPV();
    
    
    
        // Barone-Adesi and Whaley approximation for American
        method = "Barone-Adesi/Whaley";
        americanOption.setPricingEngine(boost::shared_ptr<PricingEngine>(new BaroneAdesiWhaleyApproximationEngine(bsmProcess)));
//        NSLog(@"Barone-Adesi/Whaley semi-analytic Euro option %f" , europeanOption.NPV());
        baroneAdesiWhaleySemiAna_eo = europeanOption.NPV();
    
        // Bjerksund and Stensland approximation for American
        method = "Bjerksund/Stensland";
        americanOption.setPricingEngine(boost::shared_ptr<PricingEngine>(new BjerksundStenslandApproximationEngine(bsmProcess)));
//        NSLog(@"Bjerksund/Stensland semi-analytic Euro option %f" , europeanOption.NPV());
        bjerksundStenslandSemiAna_eo = europeanOption.NPV();
    
        // Integral
        method = "Integral";
        europeanOption.setPricingEngine(boost::shared_ptr<PricingEngine>(new IntegralEngine(bsmProcess)));
//        NSLog(@"Integral Euro option %f" , europeanOption.NPV());
        integral_eo = europeanOption.NPV();
    
        // Finite differences
        //        Size timeSteps = 801;
        int timeSteps = 801;
        method = "Finite differences";
        europeanOption.setPricingEngine(boost::shared_ptr<PricingEngine>(new FDEuropeanEngine<CrankNicolson>(bsmProcess,
                                                                                                             timeSteps,timeSteps-1)));
        bermudanOption.setPricingEngine(boost::shared_ptr<PricingEngine>(new FDBermudanEngine<CrankNicolson>(bsmProcess,
                                                                                                             timeSteps,timeSteps-1)));
        americanOption.setPricingEngine(boost::shared_ptr<PricingEngine>(new FDAmericanEngine<CrankNicolson>(bsmProcess,
                                                                                                             timeSteps,timeSteps-1)));
//        NSLog(@"Finite differences %f %f %f" , europeanOption.NPV(), bermudanOption.NPV(), americanOption.NPV());
        finiteDifference_eo = europeanOption.NPV();
        finiteDifference_bo = bermudanOption.NPV();
        finiteDifference_ao = americanOption.NPV();
    
        // Binomial method: Jarrow-Rudd
        method = "Binomial Jarrow-Rudd";
        europeanOption.setPricingEngine(boost::shared_ptr<PricingEngine>(new BinomialVanillaEngine<JarrowRudd>(bsmProcess,timeSteps)));
        bermudanOption.setPricingEngine(boost::shared_ptr<PricingEngine>(new BinomialVanillaEngine<JarrowRudd>(bsmProcess,timeSteps)));
        americanOption.setPricingEngine(boost::shared_ptr<PricingEngine>(new BinomialVanillaEngine<JarrowRudd>(bsmProcess,timeSteps)));
//        NSLog(@"Binomial Jarrow-Rudd %f %f %f" , europeanOption.NPV(), bermudanOption.NPV(), americanOption.NPV());
        binomialJarrowRudd_eo = europeanOption.NPV();
        binomialJarrowRudd_bo = bermudanOption.NPV();
        binomialJarrowRudd_ao = americanOption.NPV();
    
        method = "Binomial Cox-Ross-Rubinstein";
        europeanOption.setPricingEngine(boost::shared_ptr<PricingEngine>(new BinomialVanillaEngine<CoxRossRubinstein>(bsmProcess,
                                                                                                                      timeSteps)));
        bermudanOption.setPricingEngine(boost::shared_ptr<PricingEngine>(new BinomialVanillaEngine<CoxRossRubinstein>(bsmProcess,
                                                                                                                      timeSteps)));
        americanOption.setPricingEngine(boost::shared_ptr<PricingEngine>(new BinomialVanillaEngine<CoxRossRubinstein>(bsmProcess,
                                                                                                                      timeSteps)));
//        NSLog(@"Binomial Cox-Ross-Rubinstein %f %f %f" , europeanOption.NPV(), bermudanOption.NPV(), americanOption.NPV());
        binomialCoxRossRubinstein_eo = europeanOption.NPV();
        binomialCoxRossRubinstein_bo = bermudanOption.NPV();
        binomialCoxRossRubinstein_ao = americanOption.NPV();
    
        // Binomial method: Additive equiprobabilities
        method = "Additive equiprobabilities";
        europeanOption.setPricingEngine(boost::shared_ptr<PricingEngine>(new BinomialVanillaEngine<AdditiveEQPBinomialTree>(bsmProcess,
                                                                                                                            timeSteps)));
        bermudanOption.setPricingEngine(boost::shared_ptr<PricingEngine>(new BinomialVanillaEngine<AdditiveEQPBinomialTree>(bsmProcess,
                                                                                                                            timeSteps)));
        americanOption.setPricingEngine(boost::shared_ptr<PricingEngine>(new BinomialVanillaEngine<AdditiveEQPBinomialTree>(bsmProcess,
                                                                                                                            timeSteps)));
//        NSLog(@"Additive equiprobabilities %f %f %f" , europeanOption.NPV(), bermudanOption.NPV(), americanOption.NPV());
        additiveEquiprobabilities_eo = europeanOption.NPV();
        additiveEquiprobabilities_bo = bermudanOption.NPV();
        additiveEquiprobabilities_ao = americanOption.NPV();
    
        // Binomial method: Binomial Trigeorgis
        method = "Binomial Trigeorgis";
        europeanOption.setPricingEngine(boost::shared_ptr<PricingEngine>(new BinomialVanillaEngine<Trigeorgis>(bsmProcess,timeSteps)));
        bermudanOption.setPricingEngine(boost::shared_ptr<PricingEngine>(new BinomialVanillaEngine<Trigeorgis>(bsmProcess,timeSteps)));
        americanOption.setPricingEngine(boost::shared_ptr<PricingEngine>(new BinomialVanillaEngine<Trigeorgis>(bsmProcess,timeSteps)));
//        NSLog(@"Binomial Trigeorgis %f %f %f" , europeanOption.NPV(), bermudanOption.NPV(), americanOption.NPV());
        binomialTrigeorgis_eo = europeanOption.NPV();
        binomialTrigeorgis_bo = bermudanOption.NPV();
        binomialTrigeorgis_ao = americanOption.NPV();
    
    
        // Binomial method: Binomial Tian
        method = "Binomial Tian";
        europeanOption.setPricingEngine(boost::shared_ptr<PricingEngine>(new BinomialVanillaEngine<Tian>(bsmProcess,timeSteps)));
        bermudanOption.setPricingEngine(boost::shared_ptr<PricingEngine>(new BinomialVanillaEngine<Tian>(bsmProcess,timeSteps)));
        americanOption.setPricingEngine(boost::shared_ptr<PricingEngine>(new BinomialVanillaEngine<Tian>(bsmProcess,timeSteps)));
//        NSLog(@"Binomial Tian %f %f %f" , europeanOption.NPV(), bermudanOption.NPV(), americanOption.NPV());
        binomialTian_eo = europeanOption.NPV();
        binomialTian_bo = bermudanOption.NPV();
        binomialTian_ao = americanOption.NPV();
    
        // Binomial method: Binomial Leisen-Reimer
        method = "Binomial Leisen-Reimer";
        europeanOption.setPricingEngine(boost::shared_ptr<PricingEngine>(new BinomialVanillaEngine<LeisenReimer>(bsmProcess,timeSteps)));
        bermudanOption.setPricingEngine(boost::shared_ptr<PricingEngine>(new BinomialVanillaEngine<LeisenReimer>(bsmProcess,timeSteps)));
        americanOption.setPricingEngine(boost::shared_ptr<PricingEngine>(new BinomialVanillaEngine<LeisenReimer>(bsmProcess,timeSteps)));
//        NSLog(@"Binomial Leisen-Reimer %f %f %f" , europeanOption.NPV(), bermudanOption.NPV(), americanOption.NPV());
        binomialLeisenReimer_eo = europeanOption.NPV();
        binomialLeisenReimer_bo = bermudanOption.NPV();
        binomialLeisenReimer_ao = americanOption.NPV();

        
        // Binomial method: Binomial Joshi
        method = "Binomial Joshi";
        europeanOption.setPricingEngine(boost::shared_ptr<PricingEngine>(new BinomialVanillaEngine<Joshi4>(bsmProcess,timeSteps)));
        bermudanOption.setPricingEngine(boost::shared_ptr<PricingEngine>(new BinomialVanillaEngine<Joshi4>(bsmProcess,timeSteps)));
        americanOption.setPricingEngine(boost::shared_ptr<PricingEngine>(new BinomialVanillaEngine<Joshi4>(bsmProcess,timeSteps)));
//        NSLog(@"Binomial Joshi %f %f %f" , europeanOption.NPV(), bermudanOption.NPV(), americanOption.NPV());
        binomialJoshi_eo = europeanOption.NPV();
        binomialJoshi_bo = bermudanOption.NPV();
        binomialJoshi_ao = americanOption.NPV();
        
        // Monte Carlo Method: MC (crude)
        timeSteps = 1;
        method = "MC (crude)";
        //        Size mcSeed = 42;
        int mcSeed = 42;
        boost::shared_ptr<PricingEngine> mcengine1;
        mcengine1 = MakeMCEuropeanEngine<PseudoRandom>(bsmProcess)
        .withSteps(timeSteps)
        .withAbsoluteTolerance(0.02)
        .withSeed(mcSeed);
        europeanOption.setPricingEngine(mcengine1);
//        NSLog(@"MC (crude) %f " , europeanOption.NPV());
        mcCrude_eo = europeanOption.NPV();
    
        // Monte Carlo Method: QMC (Sobol)
        method = "QMC (Sobol)";
        //        Size nSamples = 32768;  // 2^15
        int nSamples = 32768;  // 2^15
        
        boost::shared_ptr<PricingEngine> mcengine2;
        mcengine2 = MakeMCEuropeanEngine<LowDiscrepancy>(bsmProcess)
        .withSteps(timeSteps)
        .withSamples(nSamples);
        europeanOption.setPricingEngine(mcengine2);
//        NSLog(@"QMC (Sobol) %f " , europeanOption.NPV());
        qmcSobol_eo = europeanOption.NPV();
    
        // Monte Carlo Method: MC (Longstaff Schwartz)
//        method = "MC (Longstaff Schwartz)";
//        boost::shared_ptr<PricingEngine> mcengine3;
//        mcengine3 = MakeMCAmericanEngine<PseudoRandom>(bsmProcess)
//        .withSteps(100)
//        .withAntitheticVariate()
//        .withCalibrationSamples(4096)
//        .withAbsoluteTolerance(0.02)
//        .withSeed(mcSeed);
//        americanOption.setPricingEngine(mcengine3);
//         NSLog(@"MC (Longstaff Schwartz) %f " , americanOption.NPV());
//        mcLongstaffSchwatz_ao = americanOption.NPV();
    
        // End test
        Real seconds = timer.elapsed();
        Integer hours = int(seconds/3600);
        seconds -= hours * 3600;
        Integer minutes = int(seconds/60);
        seconds -= minutes * 60;
//        std::cout << " \nRun completed in ";
        if (hours > 0)
            //            std::cout << hours << " h ";
            NSLog(@"hours %i", hours);
        if (hours > 0 || minutes > 0)
            NSLog(@"minutes %i", minutes);
    }

QuantLib::Month intToQLMonth__(int monthAsInteger)
{
    using namespace QuantLib;
    NSLog(@"intToQLMonth month = %i", monthAsInteger);
    
    QuantLib::Month month = QuantLib::January;
    
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
