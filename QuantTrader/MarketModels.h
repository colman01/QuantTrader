//
//  MarketModels.h
//  QuantLibExample
//
//  Created by colman on 15.07.13.
//  Copyright (c) 2013 Striding Edge Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MarketModels : NSObject {
    bool exitCalc;

}

@property (nonatomic, strong) CPTGraphHostingView *hostView;

@property (strong, nonatomic) NSMutableArray *delta;
@property (weak, nonatomic) NSMutableArray *vega;

@property bool exitCalc;

-(void) calcHit;
-(void) stopCalc;
-(int) newInverseFloater:(NSNumber *) rateLevel;




@property float multiplierCutOff;
@property float projectionTolerance;



//Real multiplierCutOff = 50.0;
//Real projectionTolerance = 1E-4;
//

// Bermudan

@property (nonatomic, assign) int numberRates;
@property float accrual;
@property float firstTime;
//int numberRates =20;
//Real accrual = 0.5;
//Real firstTime = 0.5;
//
@property float fixedRate;
//Real fixedRate = 0.05;
//std::vector<Real> strikes(numberRates,fixedRate);
@property float receive;
//Real receive = -1.0;
//
@property int seed;
//int seed = 12332; // for Sobol generator
@property int trainingPaths;
//int trainingPaths = 10;
//int paths = 2;
@property int paths;

@property int vegaPaths;
//int vegaPaths = 2*64;
//
//
@property float rateLevel;
//Real rateLevel =0.05;
//
//
@property float initialNumeraireValue;
//Real initialNumeraireValue = 0.95;
//
@property float volLevel;
//Real volLevel = 0.11;
@property float beta;
//Real beta = 0.2;
@property float gamma;
//Real gamma = 1.0;
@property int numberOfFactors;
//int numberOfFactors = std::min<int>(5,numberRates);
//
@property float displacementLevel;
//Spread displacementLevel =0.02;
//
//
@property int innerPaths;
//int innerPaths = 255;
@property int outterPaths;
//int outerPaths =256;

@property float strike;
@property int fixedMultiplier;


@property float floatingSpread;
@property bool payer;


@end
