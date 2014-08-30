//
//  ParameterInitializer.h
//  QuantTrader
//
//  Created by colman on 22/07/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuantDao.h"
#import "DmEquity.h"

@interface ParameterInitializer : NSObject


- (void) setupParameters;
-(void) setupBond;
-(void) setupEquity;
    
@end
