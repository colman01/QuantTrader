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
maturityDate_3;

-(void) calculate {
    using namespace QuantLib;
    
    DmEquity *equityParameters;
    
    NSMutableArray *results = [[QuantDao instance] getEquity];
    boost::timer timer;
    std::string method;
    
    @try {
        equityParameters = results[0];
        Calendar calendar = TARGET();

        // set up dates
        NSCalendar *cal_ = [NSCalendar currentCalendar];
        [cal_ setTimeZone:[NSTimeZone localTimeZone]];
        [cal_ setLocale:[NSLocale currentLocale]];
    
        int day = [[cal_ components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:equityParameters.settlementDate_1] day];
        int month = [[cal_ components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:equityParameters.settlementDate_1] month];
        int year = [[cal_ components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:equityParameters.settlementDate_1] year];

        QuantLib::Month qlMonth =  intToQLMonth__(month);

        Date settlementDate(day, qlMonth, year);
        day = [[cal_ components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]] day];
        month = [[cal_ components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]] month];
        year = [[cal_ components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]] year];
        qlMonth =  intToQLMonth__(month);
    
        Date todaysDate(30, January, 1998);
    
        Settings::instance().evaluationDate() = todaysDate;
        
        // our options
        Option::Type type(Option::Put);

        Real underlying = [equityParameters.underlying_eq doubleValue] ;
        Real strike = [equityParameters.strike_eq doubleValue];
        Spread dividendYield = [equityParameters.dividendYield_eq floatValue];
        Rate riskFreeRate = [equityParameters.riskFreeRate_eq floatValue];
        Volatility volatility = [equityParameters.volatility_eq floatValue];
    
    
        day = [[cal_ components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:equityParameters.maturityDate_1] day];
        month = [[cal_ components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:equityParameters.maturityDate_1] month];
        year = [[cal_ components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:equityParameters.maturityDate_1] year];
        qlMonth =  intToQLMonth__(month);
    
        Date maturity(day, qlMonth, year);
    
    
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
        blackScholes_eo = europeanOption.NPV();
    
        // semi-analytic Heston for European
        method = "Heston semi-analytic";
        boost::shared_ptr<HestonProcess> hestonProcess(new HestonProcess(flatTermStructure, flatDividendTS,
                                                                         underlyingH, volatility*volatility,
                                                                         1.0, volatility*volatility, 0.001, 0.0));
        boost::shared_ptr<HestonModel> hestonModel(new HestonModel(hestonProcess));
        europeanOption.setPricingEngine(boost::shared_ptr<PricingEngine>(new AnalyticHestonEngine(hestonModel)));
        hestonSemiAnalytic_eo = europeanOption.NPV();
    
        
        // semi-analytic Bates for European
        method = "Bates semi-analytic";
        boost::shared_ptr<BatesProcess> batesProcess(new BatesProcess(flatTermStructure, flatDividendTS,
                                                                      underlyingH, volatility*volatility,
                                                                      1.0, volatility*volatility, 0.001, 0.0,
                                                                      1e-14, 1e-14, 1e-14));
        boost::shared_ptr<BatesModel> batesModel(new BatesModel(batesProcess));
        europeanOption.setPricingEngine(boost::shared_ptr<PricingEngine>(new BatesEngine(batesModel)));
        batesSemiAna_eo = europeanOption.NPV();
    
    
    
        // Barone-Adesi and Whaley approximation for American
        method = "Barone-Adesi/Whaley";
        americanOption.setPricingEngine(boost::shared_ptr<PricingEngine>(new BaroneAdesiWhaleyApproximationEngine(bsmProcess)));
        baroneAdesiWhaleySemiAna_eo = europeanOption.NPV();
    
        // Bjerksund and Stensland approximation for American
        method = "Bjerksund/Stensland";
        americanOption.setPricingEngine(boost::shared_ptr<PricingEngine>(new BjerksundStenslandApproximationEngine(bsmProcess)));
        bjerksundStenslandSemiAna_eo = europeanOption.NPV();
    
        // Integral
        method = "Integral";
        europeanOption.setPricingEngine(boost::shared_ptr<PricingEngine>(new IntegralEngine(bsmProcess)));
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
        finiteDifference_eo = europeanOption.NPV();
        finiteDifference_bo = bermudanOption.NPV();
        finiteDifference_ao = americanOption.NPV();
    
        // Binomial method: Jarrow-Rudd
        method = "Binomial Jarrow-Rudd";
        europeanOption.setPricingEngine(boost::shared_ptr<PricingEngine>(new BinomialVanillaEngine<JarrowRudd>(bsmProcess,timeSteps)));
        bermudanOption.setPricingEngine(boost::shared_ptr<PricingEngine>(new BinomialVanillaEngine<JarrowRudd>(bsmProcess,timeSteps)));
        americanOption.setPricingEngine(boost::shared_ptr<PricingEngine>(new BinomialVanillaEngine<JarrowRudd>(bsmProcess,timeSteps)));
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
        additiveEquiprobabilities_eo = europeanOption.NPV();
        additiveEquiprobabilities_bo = bermudanOption.NPV();
        additiveEquiprobabilities_ao = americanOption.NPV();
    
        // Binomial method: Binomial Trigeorgis
        method = "Binomial Trigeorgis";
        europeanOption.setPricingEngine(boost::shared_ptr<PricingEngine>(new BinomialVanillaEngine<Trigeorgis>(bsmProcess,timeSteps)));
        bermudanOption.setPricingEngine(boost::shared_ptr<PricingEngine>(new BinomialVanillaEngine<Trigeorgis>(bsmProcess,timeSteps)));
        americanOption.setPricingEngine(boost::shared_ptr<PricingEngine>(new BinomialVanillaEngine<Trigeorgis>(bsmProcess,timeSteps)));
        binomialTrigeorgis_eo = europeanOption.NPV();
        binomialTrigeorgis_bo = bermudanOption.NPV();
        binomialTrigeorgis_ao = americanOption.NPV();
    
    
        // Binomial method: Binomial Tian
        method = "Binomial Tian";
        europeanOption.setPricingEngine(boost::shared_ptr<PricingEngine>(new BinomialVanillaEngine<Tian>(bsmProcess,timeSteps)));
        bermudanOption.setPricingEngine(boost::shared_ptr<PricingEngine>(new BinomialVanillaEngine<Tian>(bsmProcess,timeSteps)));
        americanOption.setPricingEngine(boost::shared_ptr<PricingEngine>(new BinomialVanillaEngine<Tian>(bsmProcess,timeSteps)));
        binomialTian_eo = europeanOption.NPV();
        binomialTian_bo = bermudanOption.NPV();
        binomialTian_ao = americanOption.NPV();
    
        // Binomial method: Binomial Leisen-Reimer
        method = "Binomial Leisen-Reimer";
        europeanOption.setPricingEngine(boost::shared_ptr<PricingEngine>(new BinomialVanillaEngine<LeisenReimer>(bsmProcess,timeSteps)));
        bermudanOption.setPricingEngine(boost::shared_ptr<PricingEngine>(new BinomialVanillaEngine<LeisenReimer>(bsmProcess,timeSteps)));
        americanOption.setPricingEngine(boost::shared_ptr<PricingEngine>(new BinomialVanillaEngine<LeisenReimer>(bsmProcess,timeSteps)));
        binomialLeisenReimer_eo = europeanOption.NPV();
        binomialLeisenReimer_bo = bermudanOption.NPV();
        binomialLeisenReimer_ao = americanOption.NPV();

        
        // Binomial method: Binomial Joshi
        method = "Binomial Joshi";
        europeanOption.setPricingEngine(boost::shared_ptr<PricingEngine>(new BinomialVanillaEngine<Joshi4>(bsmProcess,timeSteps)));
        bermudanOption.setPricingEngine(boost::shared_ptr<PricingEngine>(new BinomialVanillaEngine<Joshi4>(bsmProcess,timeSteps)));
        americanOption.setPricingEngine(boost::shared_ptr<PricingEngine>(new BinomialVanillaEngine<Joshi4>(bsmProcess,timeSteps)));
        binomialJoshi_eo = europeanOption.NPV();
        binomialJoshi_bo = bermudanOption.NPV();
        binomialJoshi_ao = americanOption.NPV();
        
        // Monte Carlo Method: MC (crude)
        timeSteps = 1;
        method = "MC (crude)";
        int mcSeed = 42;
        boost::shared_ptr<PricingEngine> mcengine1;
        mcengine1 = MakeMCEuropeanEngine<PseudoRandom>(bsmProcess)
        .withSteps(timeSteps)
        .withAbsoluteTolerance(0.02)
        .withSeed(mcSeed);
        europeanOption.setPricingEngine(mcengine1);
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
        qmcSobol_eo = europeanOption.NPV();
    }
    @catch (NSException *exception) {
        return;
    }
    
    Real seconds = timer.elapsed();
    Integer hours = int(seconds/3600);
    seconds -= hours * 3600;
    Integer minutes = int(seconds/60);
    seconds -= minutes * 60;
    if (hours > 0)
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
