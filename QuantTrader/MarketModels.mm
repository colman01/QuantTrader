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
@synthesize outterPaths;
@synthesize strike;
@synthesize fixedMultiplier;
@synthesize floatingSpread;
@synthesize payer;


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

- (int) NewBermudan
{
    
//    int numberRates =20;
//    Real accrual = 0.5;
//    Real firstTime = 0.5;
    
    
    std::vector<Real> rateTimes(numberRates+1);
    for (int i=0; i < rateTimes.size(); ++i)
        rateTimes[i] = firstTime + i*accrual;
    
    std::vector<Real> paymentTimes(numberRates);
    std::vector<Real> accruals(numberRates,accrual);
    for (int i=0; i < paymentTimes.size(); ++i)
        paymentTimes[i] = firstTime + (i+1)*accrual;
    
    
    
    
//    Real fixedRate = 0.05;
    std::vector<Real> strikes(numberRates,fixedRate);
    Real receive = -1.0;
    
    // 0. a payer swap
    MultiStepSwap payerSwap(rateTimes, accruals, accruals, paymentTimes,
                            fixedRate, true);
    
    // 1. the equivalent receiver swap
    MultiStepSwap receiverSwap(rateTimes, accruals, accruals, paymentTimes,
                               fixedRate, false);
    
    //exercise schedule, we can exercise on any rate time except the last one
    std::vector<Rate> exerciseTimes(rateTimes);
    exerciseTimes.pop_back();
    
    // naive exercise strategy, exercise above a trigger level
    std::vector<Rate> swapTriggers(exerciseTimes.size(), fixedRate);
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
    
    
    // parameters for models
    
    
//    int seed = 12332; // for Sobol generator
//    int trainingPaths = 65536;
//    int paths = 16384;
//    int vegaPaths = 16384*64;
    
//    int seed = 12332; // for Sobol generator
//    int trainingPaths = 10;
//    int paths = 2;
//    int vegaPaths = 2*64;
    
    
    std::cout << "training paths, " << trainingPaths << "\n";
    std::cout << "paths, " << paths << "\n";
    std::cout << "vega Paths, " << vegaPaths << "\n";
#ifdef _DEBUG
    trainingPaths = 512;
    paths = 1024;
    vegaPaths = 1024;
#endif
    
    
    // set up a calibration, this would typically be done by using a calibrator
    
    
    
//    Real rateLevel =0.05;
//    
//    
//    Real initialNumeraireValue = 0.95;
//    
//    Real volLevel = 0.11;
//    Real beta = 0.2;
//    Real gamma = 1.0;
    int numberOfFactors = std::min<int>(5,numberRates);
    
//    Spread displacementLevel =0.02;
    Spread displacementLevel =self.displacementLevel;
    
    // set up vectors
    std::vector<Rate> initialRates(numberRates,rateLevel);
    std::vector<Volatility> volatilities(numberRates, volLevel);
    std::vector<Spread> displacements(numberRates, displacementLevel);
    
    ExponentialForwardCorrelation correlations(
                                               rateTimes,volLevel, beta,gamma);
    
    
    
    
    FlatVol  calibration(
                         volatilities,
                         boost::shared_ptr<PiecewiseConstantCorrelation>(new  ExponentialForwardCorrelation(correlations)),
                         evolution,
                         numberOfFactors,
                         initialRates,
                         displacements);
    
    boost::shared_ptr<MarketModel> marketModel(new FlatVol(calibration));
    
    // we use a factory since there is data that will only be known later
    SobolBrownianGeneratorFactory generatorFactory(
                                                   SobolBrownianGenerator::Diagonal, seed);
    
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
                    trainingPaths,
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
                               initialNumeraireValue);
    
    SequenceStatisticsInc stats;
    
    accounter.multiplePathValues (stats,paths);
    
    int t3 = clock();
    
    std::vector<Real> means(stats.mean());
    
    for (int i=0; i < means.size(); ++i)
        std::cout << means[i] << "\n";
    
    std::cout << " time to build strategy, " << (t2-t1)/static_cast<Real>(CLOCKS_PER_SEC)<< ", seconds.\n";
    std::cout << " time to price, " << (t3-t2)/static_cast<Real>(CLOCKS_PER_SEC)<< ", seconds.\n";
    
    // vegas
    // do it twice once with factorwise bumping, once without
    int pathsToDoVegas = vegaPaths;
    
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
                                                     receive);
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
                              initialNumeraireValue);
        
        std::vector<Real> values,errors;
        accountingEngineVegas.multiplePathValues(values,errors,pathsToDoVegas);
        
        std::cout << "vega output \n";
        std::cout << " factorwise bumping " << allowFactorwiseBumping << "\n";
        std::cout << " doCaps " << doCaps << "\n";
        
        
        
        int r=0;
        
        std::cout << " price estimate, " << values[r++] << "\n";
        
        for (int i=0; i < numberRates; ++i, ++r) {
            std::cout << " Delta, " << i << ", " << values[r] << ", " << errors[r] << "\n";
            
            std::cout << " Delta will be added, " << i << ", " << values[r] << ", " << errors[r] << "\n";
            [self.delta addObject:[NSNumber numberWithInt:values[r] ]];
        }
        
        Real totalVega = 0.0;
        
        for (r=r;r < values.size(); ++r)
        {
            std::cout << " vega, " << r - 1 -  numberRates<< ", " << values[r] << " ," << errors[r] << "\n";
            totalVega +=  values[r];
        }
        
        std::cout << " total Vega, " << totalVega << "\n";
    }
    
    bool doUpperBound = true;
    if (doUpperBound)
    {
        // upper bound
        
        MTBrownianGeneratorFactory uFactory(seed+142);
        
        
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
                MTBrownianGeneratorFactory iFactory(seed+s);
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
                                 initialNumeraireValue);
        
        Statistics uStats;
        int innerPaths = 255;
        int outerPaths =256;
        
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
    Real rateLevel = [rateLevelParam floatValue];
    int numberRates =20;
    Real accrual = 0.5;
    Real firstTime = 0.5;
    
    Real strike =200.15;
    Real fixedMultiplier = 2.0;
    Real floatingSpread =0.0;
    bool payer = true;
    
    std::vector<Real> rateTimes(numberRates+1);
    for (int i=0; i < rateTimes.size(); ++i)
        rateTimes[i] = firstTime + i*accrual;
    
    std::vector<Real> paymentTimes(numberRates);
    std::vector<Real> accruals(numberRates,accrual);
    std::vector<Real> fixedStrikes(numberRates,strike);
    std::vector<Real> floatingSpreads(numberRates,floatingSpread);
    std::vector<Real> fixedMultipliers(numberRates,fixedMultiplier);
    
    for (int i=0; i < paymentTimes.size(); ++i)
        paymentTimes[i] = firstTime + (i+1)*accrual;
    
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
    
    
//    int seed = 12332; // for Sobol generator
//    int trainingPaths = 65536;
//    int paths = 65536;
//    int vegaPaths =16384;
    
    int seed = 12332; // for Sobol generator
    int trainingPaths = 10;
    int paths = 10;
    int vegaPaths =2;
    
#ifdef _DEBUG
    trainingPaths = 8192;
    paths = 8192;
    vegaPaths = 1024;
#endif
    
    std::cout << " inverse floater \n";
    std::cout << " fixed strikes :  "  << strike << "\n";
    std::cout << " number rates :  " << numberRates << "\n";
    
    std::cout << "training paths, " << trainingPaths << "\n";
    std::cout << "paths, " << paths << "\n";
    std::cout << "vega Paths, " << vegaPaths << "\n";
    
    
    // set up a calibration, this would typically be done by using a calibrator
    
    
    
    //Real rateLevel =0.08;
    
    std::cout << " rate level " <<  rateLevel << "\n";
    
    Real initialNumeraireValue = 0.95;
    
    Real volLevel = 0.11;
    Real beta = 0.2;
    Real gamma = 1.0;
    int numberOfFactors = std::min<int>(5,numberRates);
    
    Spread displacementLevel =0.02;
    
    // set up vectors
    std::vector<Rate> initialRates(numberRates,rateLevel);
    std::vector<Volatility> volatilities(numberRates, volLevel);
    std::vector<Spread> displacements(numberRates, displacementLevel);
    
    ExponentialForwardCorrelation correlations(
                                               rateTimes,volLevel, beta,gamma);
    
    
    
    
    FlatVol  calibration(
                         volatilities,
                         boost::shared_ptr<PiecewiseConstantCorrelation>(new  ExponentialForwardCorrelation(correlations)),
                         evolution,
                         numberOfFactors,
                         initialRates,
                         displacements);
    
    boost::shared_ptr<MarketModel> marketModel(new FlatVol(calibration));
    
    // we use a factory since there is data that will only be known later
    SobolBrownianGeneratorFactory generatorFactory(
                                                   SobolBrownianGenerator::Diagonal, seed);
    
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
                    trainingPaths,
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
                               initialNumeraireValue);
    
    SequenceStatisticsInc stats;
    
    accounter.multiplePathValues (stats,paths);
    
    int t3 = clock();
    
    std::vector<Real> means(stats.mean());
    
    for (int i=0; i < means.size(); ++i)
        std::cout << means[i] << "\n";
    
    std::cout << " time to build strategy, " << (t2-t1)/static_cast<Real>(CLOCKS_PER_SEC)<< ", seconds.\n";
    std::cout << " time to price, " << (t3-t2)/static_cast<Real>(CLOCKS_PER_SEC)<< ", seconds.\n";
    
    // vegas
    
    // do it twice once with factorwise bumping, once without
    int pathsToDoVegas = vegaPaths;
    
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
                              initialNumeraireValue);
        std::vector<Real> values,errors;
        accountingEngineVegas.multiplePathValues(values,errors,pathsToDoVegas);
        [self.hostView.hostedGraph reloadData];
        std::cout << "vega output \n";
        std::cout << " factorwise bumping " << allowFactorwiseBumping << "\n";
        std::cout << " doCaps " << doCaps << "\n";
        int r=0;
        
        std::cout << " price estimate, " << values[r++] << "\n";
        
        if(!self.delta)
            self.delta = [[NSMutableArray alloc] init];
        for (int i=0; i < numberRates; ++i, ++r) {
            [self.delta addObject:[NSNumber numberWithInt:values[r] ]];
            std::cout << "Delta, " << i << ", " << values[r] << ", " << errors[r] << "\n";
        }
        
        Real totalVega = 0.0;
        
        for (; r < values.size(); ++r)
        {
            std::cout << " vega, " << r - 1 -  numberRates<< ", " << values[r] << " ," << errors[r] << "\n";
            totalVega +=  values[r];
        }
        
        std::cout << " total Vega, " << totalVega << "\n";
    }
    
    bool doUpperBound = true;
    
    if (doUpperBound)
    {
        // upper bound
        MTBrownianGeneratorFactory uFactory(seed+142);
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
                MTBrownianGeneratorFactory iFactory(seed+s);
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
                                 initialNumeraireValue);
        
        Statistics uStats;
        int innerPaths = 255;
        int outerPaths =256;
        
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

NSThread * thread ;
-(void) calcHit {
    self.delta = [[NSMutableArray alloc] init];
    thread = [[NSThread alloc] initWithTarget:self selector:@selector(demo) object:nil];
    [thread start];
}

-(void) demo {
    while (![[NSThread currentThread]  isCancelled]) {
        [self newInverseFloater: [NSNumber numberWithInt:1]];
//        for (int i=5; i < 10; ++i) {
//            if([[NSThread currentThread]  isCancelled]) {
//                return;
//            }
//            [self newInverseFloater:[NSNumber numberWithInt:1]];
//        }
    }
}

-(void) stopCalc {  
    [thread cancel];
//    thread = nil;
    
}



@end