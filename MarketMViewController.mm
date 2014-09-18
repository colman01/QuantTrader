//
//  MarketMViewController.m
//  QuantLibExample
//
//  Created by colman on 15.07.13.
//  Copyright (c) 2013 Striding Edge Technologies. All rights reserved.
//

#import "MarketMViewController.h"
#import "CorePlot-CocoaTouch.h"

@interface MarketMViewController ()
@end

@implementation MarketMViewController
@synthesize market;
@synthesize payer;
@synthesize graphContainer;
@synthesize priceAnnotation = priceAnnotation_;
@synthesize activityIndicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.activityIndicator setHidden:YES];
    if (!market)
        market = [[MarketModels alloc] init];
    [self initPlot];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)btnCalc:(id)sender {
    [self.activityIndicator setHidden:NO];
    [self.activityIndicator startAnimating];
    [self.activityIndicator setHidesWhenStopped:YES];
    
    [market graphReady:^() {
        [self reloadGraph:nil];
        [self.activityIndicator stopAnimating];
    }];
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Calculation running" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    [alert show];
    [market calcHit];
}

-(IBAction)quitCalc:(id)sender {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Cancel Computation" message:@"Cancel" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"", nil];
    [alert show];
    [market stopCalc];
}

-(IBAction)reloadGraph:(id)sender {
    [self.hostView.hostedGraph reloadData];
}

#pragma mark - Chart behavior
-(void)initPlot {
    [self configureHost];
    [self configureGraph];
    [self configurePlots];
    [self.hostView.hostedGraph.defaultPlotSpace setAllowsUserInteraction:YES    ];
    
    
}

-(void)configureHost {
	self.hostView = [(CPTGraphHostingView *) [CPTGraphHostingView alloc] initWithFrame:graphContainer.bounds];
    self.market.hostView = self.hostView;
	self.hostView.allowPinchScaling = YES;
    self.hostView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [graphContainer addSubview:self.hostView];
}

-(void)configureGraph {
	// 1 - Create the graph
    self.hostView.hostedGraph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
    [self.hostView.hostedGraph applyTheme:[CPTTheme themeNamed:kCPTSlateTheme]];
}

-(void)configurePlots {
	// 1 - Get graph and plot space
	CPTGraph *graph = self.hostView.hostedGraph;
	CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
	// 2 - Create the three plots
	CPTScatterPlot *aaplPlot = [[CPTScatterPlot alloc] init];
	aaplPlot.dataSource = self;

	CPTColor *aaplColor = [CPTColor redColor];
	[graph addPlot:aaplPlot toPlotSpace:plotSpace];
	CPTScatterPlot *googPlot = [[CPTScatterPlot alloc] init];
	googPlot.dataSource = self;
    plotSpace.delegate = self;
	// 3 - Set up plot space
   [plotSpace scaleToFitPlots:[NSArray arrayWithObjects:aaplPlot, nil]];
//	CPTMutablePlotRange *xRange = [plotSpace.xRange mutableCopy];
//	[xRange expandRangeByFactor:CPTDecimalFromCGFloat(1.1f)];
//	plotSpace.xRange = xRange;
//	CPTMutablePlotRange *yRange = [plotSpace.yRange mutableCopy];
//	[yRange expandRangeByFactor:CPTDecimalFromCGFloat(1.2f)];
    
    //set axes ranges
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:
                        CPTDecimalFromFloat(-12) //min year minus 1
                                                    length:CPTDecimalFromFloat((40))]; //year difference plus 2
    
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:
                        CPTDecimalFromFloat(-0.2)
                                                    length:CPTDecimalFromFloat((1.9))]; // round up to next 50
    
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.hostView.hostedGraph.axisSet;
//    CPTXYAxis *x                    = axisSet.xAxis;
//    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    
    axisSet.xAxis.majorIntervalLength = CPTDecimalFromFloat(15.0f);
    axisSet.yAxis.majorIntervalLength = CPTDecimalFromFloat(0.5f);
    
    
    
    NSNumberFormatter * yformatter =  [[NSNumberFormatter alloc] init];
    [yformatter setUsesSignificantDigits:YES];
    [yformatter setMaximumSignificantDigits:4];
    [yformatter setMaximumFractionDigits:1];
    [yformatter setRoundingMode:NSNumberFormatterRoundCeiling];
    axisSet.yAxis.labelFormatter = yformatter;
    
    
    axisSet.xAxis.title = @"[Delta Index]";
    axisSet.yAxis.title = @"[Value of Delta]";
//    axisSet.xAxis.titleTextStyle = axisStyle;
//    axisSet.yAxis.titleTextStyle = axisStyle;
    axisSet.xAxis.titleOffset = 20.0f;
    axisSet.yAxis.titleOffset = 35.0f;
//    axisSet.xAxis.labelTextStyle = labelStyle;
    axisSet.xAxis.labelOffset = 5.0f;
//    axisSet.yAxis.labelTextStyle = labelStyle;
    axisSet.yAxis.labelOffset = 5.0f;
    
//    axisSet.xAxis.la

    
	// 4 - Create styles and symbols
	CPTMutableLineStyle *aaplLineStyle = [aaplPlot.dataLineStyle mutableCopy];
	aaplLineStyle.lineWidth = 2.5;
	aaplLineStyle.lineColor = aaplColor;
	aaplPlot.dataLineStyle = aaplLineStyle;
	CPTMutableLineStyle *aaplSymbolLineStyle = [CPTMutableLineStyle lineStyle];
	aaplSymbolLineStyle.lineColor = aaplColor;
	CPTPlotSymbol *aaplSymbol = [CPTPlotSymbol ellipsePlotSymbol];
	aaplSymbol.fill = [CPTFill fillWithColor:aaplColor];
	aaplSymbol.lineStyle = aaplSymbolLineStyle;
	aaplSymbol.size = CGSizeMake(6.0f, 6.0f);
	aaplPlot.plotSymbol = aaplSymbol;
}

#pragma mark - CPTPlotDataSource methods
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return market.delta.count;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    NSInteger valueCount = market.delta.count;
	switch (fieldEnum) {
		case CPTScatterPlotFieldX:
			if (index < valueCount) {
				return [NSNumber numberWithUnsignedInteger:index];
			}
			break;
			
		case CPTScatterPlotFieldY:
                if (index < valueCount) {
                    NSNumber *num = [market.delta objectAtIndex:index];
                    return num = [NSNumber numberWithFloat:[num floatValue]];
//                    return num = [NSNumber numberWithFloat:[num floatValue]*10];
                }
                break;
	}
	return [NSDecimalNumber zero];
}

-(BOOL)plotSpace:(CPTPlotSpace *)space shouldScaleBy:(CGFloat)interactionScale aboutPoint:(CGPoint)interactionPoint {
    
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) self.hostView.hostedGraph.defaultPlotSpace;
    double lenX = plotSpace.xRange.lengthDouble;
    
    if (lenX > 100 && interactionScale < 1.0)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

@end