//
//  MarketModels.m
//  QuantLibExample
//
//  Created by colman on 15.07.13.
//  Copyright (c) 2013 Striding Edge Technologies. All rights reserved.
//

#import "MarketModels.h"

#include <ql/qldefines.hpp>
#include <ql/version.hpp>
#ifdef BOOST_MSVC
#  include <ql/auto_link.hpp>
#endif
#include <ql/models/marketmodels/all.hpp>
#include <ql/methods/montecarlo/genericlsregression.hpp>
#include <ql/legacy/libormarketmodels/lmlinexpcorrmodel.hpp>
#include <ql/legacy/libormarketmodels/lmextlinexpvolmodel.hpp>
#include <ql/time/schedule.hpp>
#include <ql/time/calendars/nullcalendar.hpp>
#include <ql/time/daycounters/simpledaycounter.hpp>
#include <ql/pricingengines/blackformula.hpp>
#include <ql/pricingengines/blackcalculator.hpp>
#include <ql/utilities/dataformatters.hpp>
#include <ql/math/integrals/segmentintegral.hpp>
#include <ql/math/statistics/convergencestatistics.hpp>
#include <ql/termstructures/volatility/abcd.hpp>
#include <ql/termstructures/volatility/abcdcalibration.hpp>
#include <ql/math/functional.hpp>
#include <ql/math/optimization/simplex.hpp>
#include <ql/quotes/simplequote.hpp>
#include <sstream>
#include <iostream>
#include <ctime>
#include <ql/types.hpp>



using namespace QuantLib;
using namespace std;

#if defined(QL_ENABLE_SESSIONS)
namespace QuantLib {
    
    Integer sessionId() { return 0; }
    
}
#endif


@implementation MarketModels

@synthesize hostView;
@synthesize exitCalc;
@synthesize delta;
@synthesize handler;


- (void) graphReady:(GraphCompletionHandler)handler_ {
    self.handler = handler_;
}

std::vector<std::vector<Matrix> > theVegaBumps(bool factorwiseBumping,
                                               boost::shared_ptr<MarketModel> marketModel,
                                               bool doCaps)
{
    Real multiplierCutOff = 50.0;
    Real projectionTolerance = 1E-4;
    int numberRates= marketModel->numberOfRates();
    
    std::vector<VolatilityBumpInstrumentJacobian::Cap> caps;
    if (doCaps)
    {
        Rate capStrike = marketModel->initialRates()[0];
        for (int i=0; i< numberRates-1; i=i+1)
        {
            VolatilityBumpInstrumentJacobian::Cap nextCap;
            nextCap.startIndex_ = i;
            nextCap.endIndex_ = i+1;
            nextCap.strike_ = capStrike;
            caps.push_back(nextCap);
        }
    }

    std::vector<VolatilityBumpInstrumentJacobian::Swaption> swaptions(numberRates);
    
    for (int i=0; i < numberRates; ++i)
    {
        swaptions[i].startIndex_ = i;
        swaptions[i].endIndex_ = numberRates;
        
    }
    
    VegaBumpCollection possibleBumps(marketModel,
                                     factorwiseBumping);
    
    OrthogonalizedBumpFinder  bumpFinder(possibleBumps,
                                         swaptions,
                                         caps,
                                         multiplierCutOff, // if vector length grows by more than this discard
                                         projectionTolerance);      // if vector projection before scaling less than this discard
    
    std::vector<std::vector<Matrix> > theBumps;
    
    bumpFinder.GetVegaBumps(theBumps);
    
    return theBumps;
    
}


#pragma mark Objective C convertion

- (int) newBermudan
{
    DmMarketModel *marketParameters;
    NSMutableArray *results = [[QuantDao instance] getMarketModel];
    @try {
        marketParameters = results[0];
    }
    @catch(NSException *exception) {
    }
    
    std::vector<Real> rateTimes([marketParameters.numberRates doubleValue]+1);
    for (int i=0; i < rateTimes.size(); ++i)
        rateTimes[i] = [marketParameters.firstTime doubleValue] + i*[marketParameters.accrual doubleValue];
    
    std::vector<Real> paymentTimes([marketParameters.numberRates doubleValue]);
    std::vector<Real> accruals([marketParameters.numberRates intValue],[marketParameters.accrual intValue]);
    for (int i=0; i < paymentTimes.size(); ++i)
        paymentTimes[i] = [marketParameters.firstTime doubleValue] + (i+1)*[marketParameters.accrual doubleValue];
    
    std::vector<Real> strikes([marketParameters.numberRates intValue],[marketParameters.fixedRate intValue]);
    
    
    // 0. a payer swap
    MultiStepSwap payerSwap(rateTimes, accruals, accruals, paymentTimes,
                            [marketParameters.fixedRate doubleValue], true);

    
    // 1. the equivalent receiver swap
    MultiStepSwap receiverSwap(rateTimes, accruals, accruals, paymentTimes,
                               [marketParameters.fixedRate intValue], false);
    
    //exercise schedule, we can exercise on any rate time except the last one
    std::vector<Rate> exerciseTimes(rateTimes);
    exerciseTimes.pop_back();
    
    // naive exercise strategy, exercise above a trigger level
    std::vector<Rate> swapTriggers(exerciseTimes.size(), [marketParameters.fixedRate intValue]);
    SwapRateTrigger naifStrategy(rateTimes, swapTriggers, exerciseTimes);
    
    // Longstaff-Schwartz exercise strategy
    std::vector<std::vector<NodeData> > collectedData;
    std::vector<std::vector<Real> > basisCoefficients;
    
    // control that does nothing, need it because some control is expected
    NothingExerciseValue control(rateTimes);
    
    //    SwapForwardBasisSystem basisSystem(rateTimes,exerciseTimes);
    SwapBasisSystem basisSystem(rateTimes,exerciseTimes);
    
    
    
    // rebate that does nothing, need it because some rebate is expected
    // when you break a swap nothing happens.
    NothingExerciseValue nullRebate(rateTimes);
    
    CallSpecifiedMultiProduct dummyProduct =
    CallSpecifiedMultiProduct(receiverSwap, naifStrategy,
                              ExerciseAdapter(nullRebate));
    EvolutionDescription evolution = dummyProduct.evolution();

    std::cout << "training paths, " << [marketParameters.trainingPaths intValue] << "\n";
    std::cout << "paths, " << [marketParameters.paths intValue] << "\n";
    std::cout << "vega Paths, " << [marketParameters.vegaPaths intValue] << "\n";
#ifdef _DEBUG
    trainingPaths = 512;
    paths = 1024;
    vegaPaths = 1024;
#endif
    // set up a calibration, this would typically be done by using a calibrator
    int numberOfFactors_ = std::min<int>(5,[marketParameters.numberRates intValue]);
    Spread displacementLevel =[marketParameters.displacementLevel doubleValue];
    
    // set up vectors
    std::vector<Rate> initialRates([marketParameters.numberRates intValue],[marketParameters.rateLevel intValue]);
    std::vector<Volatility> volatilities([marketParameters.numberRates intValue], [marketParameters.volLevel intValue]);
    std::vector<Spread> displacements([marketParameters.numberRates intValue], [marketParameters.displacementLevel intValue]);
    
    ExponentialForwardCorrelation correlations(
                                               rateTimes,[marketParameters.volLevel doubleValue], [marketParameters.beta doubleValue],[marketParameters.gamma doubleValue]);
    
    FlatVol  calibration(
                         volatilities,
                         boost::shared_ptr<PiecewiseConstantCorrelation>(new  ExponentialForwardCorrelation(correlations)),
                         evolution,
                         numberOfFactors_,
                         initialRates,
                         displacements);
    
    boost::shared_ptr<MarketModel> marketModel(new FlatVol(calibration));
    
    // we use a factory since there is data that will only be known later
    SobolBrownianGeneratorFactory generatorFactory(
                                                   SobolBrownianGenerator::Diagonal, [marketParameters.seed intValue]);
    
    std::vector<std::size_t> numeraires( moneyMarketMeasure(evolution));
    
    // the evolver will actually evolve the rates
    LogNormalFwdRatePc  evolver(marketModel,
                                generatorFactory,
                                numeraires   // numeraires for each step
                                );
    
    boost::shared_ptr<MarketModelEvolver> evolverPtr(new LogNormalFwdRatePc(evolver));
    
    int t1= clock();
    
    // gather data before computing exercise strategy
    collectNodeData(evolver,
                    receiverSwap,
                    basisSystem,
                    nullRebate,
                    control,
                    [marketParameters.trainingPaths intValue],
                    collectedData);
    
    int t2 = clock();
    
    
    // calculate the exercise strategy's coefficients
    genericLongstaffSchwartzRegression(collectedData,
                                       basisCoefficients);
    
    
    // turn the coefficients into an exercise strategy
    LongstaffSchwartzExerciseStrategy exerciseStrategy(
                                                       basisSystem, basisCoefficients,
                                                       evolution, numeraires,
                                                       nullRebate, control);
    
    //  bermudan swaption to enter into the payer swap
    CallSpecifiedMultiProduct bermudanProduct =
    CallSpecifiedMultiProduct(
                              MultiStepNothing(evolution),
                              exerciseStrategy, payerSwap);
    
    //  callable receiver swap
    CallSpecifiedMultiProduct callableProduct =
    CallSpecifiedMultiProduct(
                              receiverSwap, exerciseStrategy,
                              ExerciseAdapter(nullRebate));
    
    // lower bound: evolve all 4 products togheter
    MultiProductComposite allProducts;
    allProducts.add(payerSwap);
    allProducts.add(receiverSwap);
    allProducts.add(bermudanProduct);
    allProducts.add(callableProduct);
    allProducts.finalize();

    AccountingEngine accounter(evolverPtr,
                               Clone<MarketModelMultiProduct>(allProducts),
                               [marketParameters.initialNumeraireValue doubleValue]);
    
    SequenceStatisticsInc stats;
    
    accounter.multiplePathValues (stats,[marketParameters.paths intValue]);
    
    int t3 = clock();
    
    std::vector<Real> means(stats.mean());
    
    for (int i=0; i < means.size(); ++i)
        std::cout << means[i] << "\n";
    
    std::cout << " time to build strategy, " << (t2-t1)/static_cast<Real>(CLOCKS_PER_SEC)<< ", seconds.\n";
    std::cout << " time to price, " << (t3-t2)/static_cast<Real>(CLOCKS_PER_SEC)<< ", seconds.\n";
    
    // vegas
    // do it twice once with factorwise bumping, once without
    int pathsToDoVegas = [marketParameters.vegaPaths intValue];
    
    for (int i=0; i < 4; ++i)
    {
        
        bool allowFactorwiseBumping = i % 2 > 0 ;
        
        bool doCaps = i / 2 > 0 ;
        
        LogNormalFwdRateEuler evolverEuler(marketModel,
                                           generatorFactory,
                                           numeraires
                                           ) ;
        
        MarketModelPathwiseSwap receiverPathwiseSwap(  rateTimes,
                                                     accruals,
                                                     strikes,
                                                     [marketParameters.receive doubleValue]);
        Clone<MarketModelPathwiseMultiProduct> receiverPathwiseSwapPtr(receiverPathwiseSwap.clone());
        
        //  callable receiver swap
        CallSpecifiedPathwiseMultiProduct callableProductPathwise(receiverPathwiseSwapPtr,
                                                                  exerciseStrategy);
        
        Clone<MarketModelPathwiseMultiProduct> callableProductPathwisePtr(callableProductPathwise.clone());
        
        
        std::vector<std::vector<Matrix> > theBumps(theVegaBumps(allowFactorwiseBumping,
                                                                marketModel,
                                                                doCaps));
        
        PathwiseVegasOuterAccountingEngine
        accountingEngineVegas(boost::shared_ptr<LogNormalFwdRateEuler>(new LogNormalFwdRateEuler(evolverEuler)),
                              callableProductPathwisePtr,
                              marketModel,
                              theBumps,
                              [marketParameters.initialNumeraireValue doubleValue]);
        
        std::vector<Real> values,errors;
        accountingEngineVegas.multiplePathValues(values,errors,pathsToDoVegas);
        
        std::cout << "vega output \n";
        std::cout << " factorwise bumping " << allowFactorwiseBumping << "\n";
        std::cout << " doCaps " << doCaps << "\n";
        
        
        
        int r=0;
        
        std::cout << " price estimate, " << values[r++] << "\n";
        
        for (int i=0; i < [marketParameters.numberRates intValue]; ++i, ++r) {
            std::cout << " Delta, " << i << ", " << values[r] << ", " << errors[r] << "\n";
            
            std::cout << " Delta will be added, " << i << ", " << values[r] << ", " << errors[r] << "\n";
            [self.delta addObject:[NSNumber numberWithInt:values[r] ]];
        }
        
        Real totalVega = 0.0;
        
        for (r=r;r < values.size(); ++r)
        {
            std::cout << " vega, " << r - 1 -  [marketParameters.numberRates intValue]<< ", " << values[r] << " ," << errors[r] << "\n";
            totalVega +=  values[r];
        }
        
        std::cout << " total Vega, " << totalVega << "\n";
    }
    
    bool doUpperBound = true;
    if (doUpperBound)
    {
        // upper bound
        
        MTBrownianGeneratorFactory uFactory([marketParameters.seed intValue]+142);
        
        
        boost::shared_ptr<MarketModelEvolver> upperEvolver(new LogNormalFwdRatePc( boost::shared_ptr<MarketModel>(new FlatVol(calibration)),
                                                                                  uFactory,
                                                                                  numeraires   // numeraires for each step
                                                                                  ));
        
        std::vector<boost::shared_ptr<MarketModelEvolver> > innerEvolvers;
        std::valarray<bool> isExerciseTime =   isInSubset(evolution.evolutionTimes(),    exerciseStrategy.exerciseTimes());
        for (int s=0; s < isExerciseTime.size(); ++s)
        {
            if (isExerciseTime[s])
            {
                MTBrownianGeneratorFactory iFactory([marketParameters.seed intValue]+s);
                boost::shared_ptr<MarketModelEvolver> e =boost::shared_ptr<MarketModelEvolver> (static_cast<MarketModelEvolver*>(new   LogNormalFwdRatePc(boost::shared_ptr<MarketModel>(new FlatVol(calibration)),
                                                                                                                                                          uFactory,
                                                                                                                                                          numeraires ,  // numeraires for each step
                                                                                                                                                          s)));
                
                innerEvolvers.push_back(e);
            }
        }
        
        UpperBoundEngine uEngine(upperEvolver,  // does outer paths
                                 innerEvolvers, // for sub-simulations that do continuation values
                                 receiverSwap,
                                 nullRebate,
                                 receiverSwap,
                                 nullRebate,
                                 exerciseStrategy,
                                 [marketParameters.initialNumeraireValue doubleValue]);
        
        Statistics uStats;
        int innerPaths = [marketParameters.innerPaths intValue];
        int outerPaths =[marketParameters.outterPaths intValue];
        
        int t4 = clock();
        
        uEngine.multiplePathValues(uStats,outerPaths,innerPaths);
        Real upperBound = uStats.mean();
        Real upperSE = uStats.errorEstimate();
        
        int t5=clock();
        
        std::cout << " Upper - lower is, " << upperBound << ", with standard error " << upperSE << "\n";
        std::cout << " time to compute upper bound is,  " << (t5-t4)/static_cast<Real>(CLOCKS_PER_SEC) << ", seconds.\n";
        
    }
    
    return 0;
}

-(int) newInverseFloater:(NSNumber *) rateLevelParam
{
    
    
    DmMarketModel *marketParameters;
    NSMutableArray *results = [[QuantDao instance] getMarketModel];
    @try {
        marketParameters = results[0];
    }
    @catch(NSException *exception) {
    }
    
    bool payer = true;
    
    
    std::vector<Real> rateTimes([marketParameters.numberRates integerValue]+1);
    for (int i=0; i < rateTimes.size(); ++i)
            rateTimes[i] = [marketParameters.firstTime doubleValue] + i*[marketParameters.accrual doubleValue];
    std::vector<Real> paymentTimes([marketParameters.numberRates doubleValue]);
    std::vector<Real> accruals([marketParameters.numberRates intValue],[marketParameters.accrual doubleValue]);
    std::vector<Real> fixedStrikes([marketParameters.numberRates intValue],[marketParameters.strike doubleValue]);
    std::vector<Real> floatingSpreads([marketParameters.numberRates intValue],[marketParameters.floatingSpread doubleValue]);
    std::vector<Real> fixedMultipliers([marketParameters.numberRates intValue],[marketParameters.fixedMultiplier doubleValue]);
    
    for (int i=0; i < paymentTimes.size(); ++i)
        paymentTimes[i] = [marketParameters.firstTime doubleValue] + (i+1)*[marketParameters.accrual doubleValue];
    
    MultiStepInverseFloater inverseFloater(
                                           rateTimes,
                                           accruals,
                                           accruals,
                                           fixedStrikes,
                                           fixedMultipliers,
                                           floatingSpreads,
                                           paymentTimes,
                                           payer);
    
    //exercise schedule, we can exercise on any rate time except the last one
    std::vector<Rate> exerciseTimes(rateTimes);
    exerciseTimes.pop_back();
    
    // naive exercise strategy, exercise above a trigger level
    Real trigger =0.05;
    std::vector<Rate> swapTriggers(exerciseTimes.size(), trigger);
    SwapRateTrigger naifStrategy(rateTimes, swapTriggers, exerciseTimes);
    
    // Longstaff-Schwartz exercise strategy
    std::vector<std::vector<NodeData> > collectedData;
    std::vector<std::vector<Real> > basisCoefficients;
    
    // control that does nothing, need it because some control is expected
    NothingExerciseValue control(rateTimes);
    
    SwapForwardBasisSystem basisSystem(rateTimes,exerciseTimes);
    //    SwapBasisSystem basisSystem(rateTimes,exerciseTimes);
    
    // rebate that does nothing, need it because some rebate is expected
    // when you break a swap nothing happens.
    NothingExerciseValue nullRebate(rateTimes);
    
    CallSpecifiedMultiProduct dummyProduct =
    CallSpecifiedMultiProduct(inverseFloater, naifStrategy,
                              ExerciseAdapter(nullRebate));
    EvolutionDescription evolution = dummyProduct.evolution();
    
    // parameters for models

    
#ifdef _DEBUG
    trainingPaths = 8192;
    paths = 8192;
    vegaPaths = 1024;
#endif
    
    std::cout << " inverse floater \n";
    std::cout << " fixed strikes :  "  << [marketParameters.strike doubleValue] << "\n";
    std::cout << " number rates :  " << [marketParameters.numberRates doubleValue] << "\n";
    
    std::cout << "training paths, " << [marketParameters.trainingPaths doubleValue] << "\n";
    std::cout << "paths, " << [marketParameters.paths doubleValue] << "\n";
    std::cout << "vega Paths, " << [marketParameters.vegaPaths doubleValue] << "\n";
    
    
    // set up a calibration, this would typically be done by using a calibrator
    std::cout << " rate level " <<  [marketParameters.rateLevel doubleValue]<< "\n";
    int numberOfFactorsLocal = std::min<int>(5,[marketParameters.numberRates intValue]);
    
    // set up vectors
    std::vector<Rate> initialRates([marketParameters.numberRates intValue],[marketParameters.rateLevel doubleValue]);
    std::vector<Volatility> volatilities([marketParameters.numberRates intValue], [marketParameters.volLevel doubleValue]);
    std::vector<Spread> displacements([marketParameters.numberRates intValue], [marketParameters.displacementLevel doubleValue]);
    
    ExponentialForwardCorrelation correlations(
                                               rateTimes,[marketParameters.volLevel doubleValue], [marketParameters.beta doubleValue],[marketParameters.gamma doubleValue]);
    
    FlatVol  calibration(
                         volatilities,
                         boost::shared_ptr<PiecewiseConstantCorrelation>(new  ExponentialForwardCorrelation(correlations)),
                         evolution,
                         numberOfFactorsLocal,
                         initialRates,
                         displacements);
    
    boost::shared_ptr<MarketModel> marketModel(new FlatVol(calibration));
    
    // we use a factory since there is data that will only be known later
    SobolBrownianGeneratorFactory generatorFactory(
                                                   SobolBrownianGenerator::Diagonal, [marketParameters.seed doubleValue]);
    
    std::vector<std::size_t> numeraires( moneyMarketMeasure(evolution));
    
    // the evolver will actually evolve the rates
    LogNormalFwdRatePc  evolver(marketModel,
                                generatorFactory,
                                numeraires   // numeraires for each step
                                );
    
    boost::shared_ptr<MarketModelEvolver> evolverPtr(new LogNormalFwdRatePc(evolver));
    
    int t1= clock();
    // gather data before computing exercise strategy
    collectNodeData(evolver,
                    inverseFloater,
                    basisSystem,
                    nullRebate,
                    control,
                    [marketParameters.trainingPaths intValue],
                    collectedData);
    
    int t2 = clock();
    
    
    // calculate the exercise strategy's coefficients
    genericLongstaffSchwartzRegression(collectedData,
                                       basisCoefficients);
    
    
    // turn the coefficients into an exercise strategy
    LongstaffSchwartzExerciseStrategy exerciseStrategy(
                                                       basisSystem, basisCoefficients,
                                                       evolution, numeraires,
                                                       nullRebate, control);
    
    
    //  callable receiver swap
    CallSpecifiedMultiProduct callableProduct =
    CallSpecifiedMultiProduct(
                              inverseFloater, exerciseStrategy,
                              ExerciseAdapter(nullRebate));
    
    MultiProductComposite allProducts;
    allProducts.add(inverseFloater);
    allProducts.add(callableProduct);
    allProducts.finalize();
    
    AccountingEngine accounter(evolverPtr,
                               Clone<MarketModelMultiProduct>(allProducts),
                               [marketParameters.initialNumeraireValue doubleValue]);
    
    SequenceStatisticsInc stats;
    
    accounter.multiplePathValues (stats,[marketParameters.paths intValue]);
    
    int t3 = clock();
    
    std::vector<Real> means(stats.mean());
    
    for (int i=0; i < means.size(); ++i)
        std::cout << means[i] << "\n";
    
    std::cout << " time to build strategy, " << (t2-t1)/static_cast<Real>(CLOCKS_PER_SEC)<< ", seconds.\n";
    std::cout << " time to price, " << (t3-t2)/static_cast<Real>(CLOCKS_PER_SEC)<< ", seconds.\n";
    
    // vegas
    // do it twice once with factorwise bumping, once without
    int pathsToDoVegas = [marketParameters.vegaPaths intValue];
    
    for (int i=0; i < 4; ++i)
    {
        
        bool allowFactorwiseBumping = i % 2 > 0 ;
        
        bool doCaps = i / 2 > 0 ;
        
        
        LogNormalFwdRateEuler evolverEuler(marketModel,
                                           generatorFactory,
                                           numeraires
                                           ) ;
        
        MarketModelPathwiseInverseFloater pathwiseInverseFloater(
                                                                 rateTimes,
                                                                 accruals,
                                                                 accruals,
                                                                 fixedStrikes,
                                                                 fixedMultipliers,
                                                                 floatingSpreads,
                                                                 paymentTimes,
                                                                 payer);
        
        Clone<MarketModelPathwiseMultiProduct> pathwiseInverseFloaterPtr(pathwiseInverseFloater.clone());
        
        //  callable inverse floater
        CallSpecifiedPathwiseMultiProduct callableProductPathwise(pathwiseInverseFloaterPtr,
                                                                  exerciseStrategy);
        
        Clone<MarketModelPathwiseMultiProduct> callableProductPathwisePtr(callableProductPathwise.clone());
        
        
        std::vector<std::vector<Matrix> > theBumps(theVegaBumps(allowFactorwiseBumping,
                                                                marketModel,
                                                                doCaps));
        
        PathwiseVegasOuterAccountingEngine
        accountingEngineVegas(boost::shared_ptr<LogNormalFwdRateEuler>(new LogNormalFwdRateEuler(evolverEuler)),
                              //         pathwiseInverseFloaterPtr,
                              callableProductPathwisePtr,
                              marketModel,
                              theBumps,
                              [marketParameters.initialNumeraireValue doubleValue]);
        std::vector<Real> values,errors;
        accountingEngineVegas.multiplePathValues(values,errors,pathsToDoVegas);
        [self.hostView.hostedGraph reloadData];
        self.handler();
        std::cout << "vega output \n";
        std::cout << " factorwise bumping " << allowFactorwiseBumping << "\n";
        std::cout << " doCaps " << doCaps << "\n";
        int r=0;
        
        std::cout << " price estimate, " << values[r++] << "\n";
        
        if(!self.delta)
            self.delta = [[NSMutableArray alloc] init];
        for (int i=0; i < [marketParameters.numberRates intValue]; ++i, ++r) {
            [self.delta addObject:[NSNumber numberWithFloat:values[r] ]];
            std::cout << "Delta, " << i << ", " << values[r] << ", " << errors[r] << "\n";
        }
        
        Real totalVega = 0.0;
        
        for (; r < values.size(); ++r)
        {
            std::cout << " vega, " << r - 1 -  [marketParameters.numberRates intValue]<< ", " << values[r] << " ," << errors[r] << "\n";
            totalVega +=  values[r];
        }
        
        std::cout << " total Vega, " << totalVega << "\n";
    }
    
    bool doUpperBound = true;
    
    if (doUpperBound)
    {
        // upper bound
        MTBrownianGeneratorFactory uFactory([marketParameters.seed intValue]+142);
        boost::shared_ptr<MarketModelEvolver> upperEvolver(new LogNormalFwdRatePc( boost::shared_ptr<MarketModel>(new FlatVol(calibration)),
                                                                                  uFactory,
                                                                                  numeraires   // numeraires for each step
                                                                                  ));
        
        std::vector<boost::shared_ptr<MarketModelEvolver> > innerEvolvers;
        
        std::valarray<bool> isExerciseTime =   isInSubset(evolution.evolutionTimes(),    exerciseStrategy.exerciseTimes());
        
        for (int s=0; s < isExerciseTime.size(); ++s)
        {
            if (isExerciseTime[s])
            {
                MTBrownianGeneratorFactory iFactory([marketParameters.seed intValue]+s);
                boost::shared_ptr<MarketModelEvolver> e =boost::shared_ptr<MarketModelEvolver> (static_cast<MarketModelEvolver*>(new   LogNormalFwdRatePc(boost::shared_ptr<MarketModel>(new FlatVol(calibration)),
                                                                                                                                                          uFactory,
                                                                                                                                                          numeraires ,  // numeraires for each step
                                                                                                                                                          s)));
                
                innerEvolvers.push_back(e);
            }
        }
        UpperBoundEngine uEngine(upperEvolver,  // does outer paths
                                 innerEvolvers, // for sub-simulations that do continuation values
                                 inverseFloater,
                                 nullRebate,
                                 inverseFloater,
                                 nullRebate,
                                 exerciseStrategy,
                                 [marketParameters.initialNumeraireValue doubleValue]);
        
        Statistics uStats;
        int t4 = clock();
        
        uEngine.multiplePathValues(uStats,[marketParameters.outterPaths intValue],[marketParameters.innerPaths intValue]);
        Real upperBound = uStats.mean();
        Real upperSE = uStats.errorEstimate();
        
        int t5=clock();
        std::cout << " Upper - lower is, " << upperBound << ", with standard error " << upperSE << "\n";
        std::cout << " time to compute upper bound is,  " << (t5-t4)/static_cast<Real>(CLOCKS_PER_SEC) << ", seconds.\n";
    }
    return 0;
}

NSThread * thread ;
-(void) calcHit {
    self.delta = [[NSMutableArray alloc] init];
    thread = [[NSThread alloc] initWithTarget:self selector:@selector(demo) object:nil];
    [thread start];
}

-(void) demo {
    while (![[NSThread currentThread]  isCancelled]) {
        for (int i=5; i < 10; ++i) {
            if([[NSThread currentThread]  isCancelled]) {
                return;
            }
            [self newInverseFloater:[NSNumber numberWithInt:i]];
        }
    }
}

-(void) stopCalc {  
    [thread cancel];
}



@end