//
//  MarketMViewController.h
//  QuantLibExample
//
//  Created by colman on 15.07.13.
//  Copyright (c) 2013 Striding Edge Technologies. All rights reserved.
//

//#import "ViewController.h"
#import "MarketModels.h"

@interface MarketMViewController : UIViewController <CPTPlotDataSource> {
    MarketModels * market;
}

@property (nonatomic, strong) CPTGraphHostingView *hostView;

-(IBAction)btnCalc:(id)sender;
-(IBAction)quitCalc:(id)sender;

#ifdef CPLUSPLUS
typedef std::vector* vecp_t
#else
typedef void* vecp_t;
#endif

@end
