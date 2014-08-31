//
//  MarketModels.h
//  QuantLibExample
//
//  Created by colman on 15.07.13.
//  Copyright (c) 2013 Striding Edge Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuantDao.h"


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



// Bermudan

@property (nonatomic, assign) int numberRates;
@property float accrual;
@property float firstTime;


@property float fixedRate;
@property float receive;
@property int seed;
//int seed = 12332; // for Sobol generator
@property int trainingPaths;
@property int paths;

@property int vegaPaths;
@property float rateLevel;
@property float initialNumeraireValue;
@property float volLevel;
@property float beta;
@property float gamma;
@property int numberOfFactors;
@property float displacementLevel;
@property int innerPaths;
@property int outterPaths;

@property float strike;
@property int fixedMultiplier;

@property float floatingSpread;
@property bool payer;


@end
