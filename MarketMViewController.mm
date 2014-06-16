//
//  MarketMViewController.m
//  QuantLibExample
//
//  Created by colman on 15.07.13.
//  Copyright (c) 2013 Striding Edge Technologies. All rights reserved.
//

#import "MarketMViewController.h"


@interface MarketMViewController ()

@end

@implementation MarketMViewController

@synthesize market;

@synthesize numberRates = _numberRates;
@synthesize accrual = _accrual;
@synthesize firstTime;
@synthesize fixedRate;
@synthesize receive;
@synthesize seed;
@synthesize trainingPaths;
@synthesize paths;
@synthesize vegaPaths;
@synthesize rateLevel;
@synthesize initialNumeraireValue;
@synthesize volLevel;
@synthesize gamma;
@synthesize beta;
@synthesize numberOfFactors;
@synthesize displacementLevel;
@synthesize innerPaths;
@synthesize outterPaths;
@synthesize strike;
@synthesize fixedMultiplier;
@synthesize floatingSpread;
@synthesize payer;

@synthesize graphContainer;

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
    if (!market) {
        market = [[MarketModels alloc] init];
    }
    
    [self initPlot];
    
    self.numberRates = 1;
    self.accrual = 1;
    
}

- (void) viewWillAppear:(BOOL)animated {
    NSLog(@"");
}

- (void) viewDidAppear:(BOOL)animated {
    NSLog(@"%i", innerPaths);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)btnCalc:(id)sender {
    [market calcHit];
    for (NSNumber *num in market.delta) {
        NSLog(@"calculation finished %@", num);
    }
}

-(IBAction)quitCalc:(id)sender {
//    [market setExitCalc:YES];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Cancel Computation" message:@"press to cancel" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"", nil];
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
    [self configureAxes];
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
	CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
//	[graph applyTheme:[CPTTheme themeNamed:kCPTDarkGradientTheme]];
   [graph applyTheme:[CPTTheme themeNamed:kCPTStocksTheme]];
	self.hostView.hostedGraph = graph;
	// 2 - Set graph title
//	NSString *title = @"Portfolio Prices: April 2012";
//	graph.title = title;
	// 3 - Create and set text style
	CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
	titleStyle.color = [CPTColor whiteColor];
	titleStyle.fontName = @"Helvetica-Bold";
	titleStyle.fontSize = 16.0f;
	graph.titleTextStyle = titleStyle;
	graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
	graph.titleDisplacement = CGPointMake(0.0f, 10.0f);
	// 4 - Set padding for plot area
	[graph.plotAreaFrame setPaddingLeft:1.0f];
	[graph.plotAreaFrame setPaddingBottom:1.0f];
	// 5 - Enable user interactions for plot space
	CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
	plotSpace.allowsUserInteraction = YES;
    graph.plotAreaFrame.borderLineStyle = nil;
    self.hostView.hostedGraph.borderLineStyle = nil;
//    [graph applyTheme:nil];

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
//	CPTColor *googColor = [CPTColor greenColor];
//	[graph addPlot:googPlot toPlotSpace:plotSpace];
//	CPTScatterPlot *msftPlot = [[CPTScatterPlot alloc] init];
//	msftPlot.dataSource = self;
//	CPTColor *msftColor = [CPTColor blueColor];
//	[graph addPlot:msftPlot toPlotSpace:plotSpace];
	// 3 - Set up plot space
//	[plotSpace scaleToFitPlots:[NSArray arrayWithObjects:aaplPlot, googPlot, msftPlot, nil]];
   [plotSpace scaleToFitPlots:[NSArray arrayWithObjects:aaplPlot, nil]];
	CPTMutablePlotRange *xRange = [plotSpace.xRange mutableCopy];
	[xRange expandRangeByFactor:CPTDecimalFromCGFloat(1.1f)];
	plotSpace.xRange = xRange;
	CPTMutablePlotRange *yRange = [plotSpace.yRange mutableCopy];
	[yRange expandRangeByFactor:CPTDecimalFromCGFloat(1.2f)];
	plotSpace.yRange = yRange;
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

-(void)configureAxes {
	// 1 - Create styles
	CPTMutableTextStyle *axisTitleStyle = [CPTMutableTextStyle textStyle];
	axisTitleStyle.color = [CPTColor whiteColor];
	axisTitleStyle.fontName = @"Helvetica-Bold";
	axisTitleStyle.fontSize = 12.0f;
	CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
	axisLineStyle.lineWidth = 0.5f;
	axisLineStyle.lineColor = [CPTColor whiteColor];
	CPTMutableTextStyle *axisTextStyle = [[CPTMutableTextStyle alloc] init];
	axisTextStyle.color = [CPTColor whiteColor];
	axisTextStyle.fontName = @"Helvetica-Bold";
	axisTextStyle.fontSize = 11.0f;
	CPTMutableLineStyle *tickLineStyle = [CPTMutableLineStyle lineStyle];
	tickLineStyle.lineColor = [CPTColor whiteColor];
	tickLineStyle.lineWidth = 0.5f;
	CPTMutableLineStyle *gridLineStyle = [CPTMutableLineStyle lineStyle];
	tickLineStyle.lineColor = [CPTColor blackColor];
	tickLineStyle.lineWidth = 1.0f;
	// 2 - Get axis set
	CPTXYAxisSet *axisSet = (CPTXYAxisSet *) self.hostView.hostedGraph.axisSet;
	// 3 - Configure x-axis
	CPTAxis *x = axisSet.xAxis;
	x.title = @"Index of Delta";
	x.titleTextStyle = axisTitleStyle;
	x.titleOffset = 2.0f;
	x.axisLineStyle = axisLineStyle;
	x.labelingPolicy = CPTAxisLabelingPolicyNone;
	x.labelTextStyle = axisTextStyle;
	x.majorTickLineStyle = axisLineStyle;
	x.majorTickLength = 1.0f;
	x.tickDirection = CPTSignNegative;

	// 4 - Configure y-axis
	CPTAxis *y = axisSet.yAxis;
	y.title = @"Value of Delta";
	y.titleTextStyle = axisTitleStyle;
	y.titleOffset = -18.0f;
	y.axisLineStyle = axisLineStyle;
	y.majorGridLineStyle = gridLineStyle;
	y.labelingPolicy = CPTAxisLabelingPolicyNone;
	y.labelTextStyle = axisTextStyle;
	y.labelOffset = 16.0f;
	y.majorTickLineStyle = axisLineStyle;
	y.majorTickLength = 0.5f;
	y.minorTickLength = 0.5f;
	y.tickDirection = CPTSignPositive;
//	NSInteger majorIncrement = 100;
//	NSInteger minorIncrement = 50;
    NSInteger majorIncrement = 1;
    NSInteger minorIncrement = 1;
//	CGFloat yMax = 700.0f;  // should determine dynamically based on max price
//     CGFloat yMax = 10.0f;  // should determine dynamically based on max price
    CGFloat yMax = 0.00001;  // should determine dynamically based on max price
	NSMutableSet *yLabels = [NSMutableSet set];
	NSMutableSet *yMajorLocations = [NSMutableSet set];
	NSMutableSet *yMinorLocations = [NSMutableSet set];
	for (NSInteger j = minorIncrement; j <= yMax; j += minorIncrement) {
		NSUInteger mod = j % majorIncrement;
		if (mod == 0) {
			CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%i", j] textStyle:y.labelTextStyle];
			NSDecimal location = CPTDecimalFromInteger(j);
			label.tickLocation = location;
			label.offset = -y.majorTickLength - y.labelOffset;
			if (label) {
				[yLabels addObject:label];
			}
			[yMajorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:location]];
		} else {
			[yMinorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:CPTDecimalFromInteger(j)]];
		}
	}
	y.axisLabels = yLabels;
	y.majorTickLocations = yMajorLocations;
	y.minorTickLocations = yMinorLocations;
}


#pragma mark - CPTPlotDataSource methods
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
//	return [[[CPDStockPriceStore sharedInstance] datesInMonth] count];
    return market.delta.count;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    
//	NSInteger valueCount = [[[CPDStockPriceStore sharedInstance] datesInMonth] count];
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
                    return num = [NSNumber numberWithFloat:[num floatValue]*10];
                }
                break;
	}
	return [NSDecimalNumber zero];
}


@end



































