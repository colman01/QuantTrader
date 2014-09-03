//
//  MarketMViewController.h
//  QuantLibExample
//
//  Created by colman on 15.07.13.
//  Copyright (c) 2013 Striding Edge Technologies. All rights reserved.
//

//#import "ViewController.h"
#import "MarketModels.h"


//typedef void (^GraphCompletionHandler) ();

@interface MarketMViewController : UIViewController <CPTPlotDataSource, CPTPlotSpaceDelegate> {

}
@property (nonatomic, strong) MarketModels * market;

@property (nonatomic, strong) CPTGraphHostingView *hostView;
@property (nonatomic, strong) CPTPlotSpaceAnnotation *priceAnnotation;
//@property (strong, nonatomic) GraphCompletionHandler handler;

@property (nonatomic, strong) IBOutlet UIView *graphContainer;

-(IBAction)btnCalc:(id)sender;
-(IBAction)quitCalc:(id)sender;
//- (void) graphReady:(GraphCompletionHandler) handler;

@property float multiplierCutOff;
@property float projectionTolerance;
@property bool payer;

@end
