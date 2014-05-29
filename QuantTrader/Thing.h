//
//  Thing.h
//  QuantTrader
//
//  Created by colman on 29.05.14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import <Foundation/Foundation.h>
#ifdef __cplusplus
#include <vector>
#endif
@interface Thing : NSObject {

    // declare my vector
    

}

#ifdef __cplusplus
@property std::vector<__weak Thing*> myThings;

@property (nonatomic, assign) std::vector<float> delta;
#endif

@end
