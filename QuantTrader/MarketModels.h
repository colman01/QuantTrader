//
//  MarketModels.h
//  QuantLibExample
//
//  Created by colman on 15.07.13.
//  Copyright (c) 2013 Striding Edge Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuantDao.h"

typedef void (^GraphCompletionHandler) ();

@interface MarketModels : NSObject {
    bool exitCalc;

}

@property (nonatomic, strong) CPTGraphHostingView *hostView;

@property  NSMutableArray *delta;
@property  NSMutableArray *vega;
@property bool exitCalc;
@property (strong, nonatomic) GraphCompletionHandler handler;

-(void) calcHit;
-(void) stopCalc;
-(int) newInverseFloater:(NSNumber *) rateLevel;
- (void) graphReady:(GraphCompletionHandler) handler;

@property float multiplierCutOff;
@property float projectionTolerance;

@end
