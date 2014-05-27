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

@property bool exitCalc;

-(void) calcualte;
-(void) calcHit;
-(void) realCalc;
-(void) stopCalc;

@end
