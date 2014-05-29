//
//  Thing.m
//  QuantTrader
//
//  Created by colman on 29.05.14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import "Thing.h"

@implementation Thing

@synthesize myThings, delta;

// declare my vector
//std::vector<__weak Thing*> myThings;
//
//
-(void) setThings {
    Thing* t = [Thing new];
    myThings.push_back(t);

}
//
//// store a weak reference in it
//Thing* t = [Thing new];
//myThings.push_back(t);

// ... some time later ...

//for(auto weak : myThings) {
//    Thing* strong = weak; // safely lock the weak pointer
//    if (strong) {
//        // use the locked pointer
//    }
//}

@end
