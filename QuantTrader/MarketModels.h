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

@property (weak, nonatomic) NSMutableArray *delta;
@property (weak, nonatomic) NSMutableArray *vega;

@property bool exitCalc;

-(void) calcualte;
-(void) calcHit;
-(void) realCalc;
-(void) stopCalc;
-(int) newInverseFloater:(NSNumber *) rateLevel;

@end
