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
    if (!market)
        market = [[MarketModels alloc] init];
    [self initPlot];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)btnCalc:(id)sender {
//    [[UIDevice currentDevice].systemVersion floatValue];
//    #define _kisiOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
//    
//    if (_kisiOS8) {
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"iOS 8+" message:@"Sorry this tool is not yet supported" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"Ok", nil];
//        [alert show];
//        
//    }
//    else {
//        NSLog(@"Less than iOS8");
//
//        for (NSNumber *num in market.delta) {
//            NSLog(@"calculation finished %@", num);
//        }
//    }
    
    [market graphReady:^() {
        [self reloadGraph:nil];
    }];
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Calculation running" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    [alert show];
    [market calcHit];
}

-(IBAction)quitCalc:(id)sender {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Cancel Computation" message:@"press to cancel" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"", nil];
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
	CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
    
//    graph.paddingLeft = 20.0;
//    graph.paddingTop = 20.0;
//    graph.paddingRight = 20.0;
//    graph.paddingBottom = 20.0;
//    
//    graph.plotAreaFrame.paddingTop    = 20.0;
//    graph.plotAreaFrame.paddingBottom = 50.0;
//    graph.plotAreaFrame.paddingLeft   = 50.0;
//    graph.plotAreaFrame.paddingRight  = 50.0;
//    
//    graph.plotAreaFrame.masksToBorder = NO;
//    
//    //Create graph from theme
//    graph                               = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
//    [graph applyTheme:[CPTTheme themeNamed:kCPTStocksTheme]];
//    graph.plotAreaFrame.masksToBorder   = NO;
//    graph.paddingLeft                   = 0.0f;
//    graph.paddingTop                    = 0.0f;
//    graph.paddingRight                  = 0.0f;
//    graph.paddingBottom                 = 0.0f;
//    
//    CPTMutableLineStyle *borderLineStyle    = [CPTMutableLineStyle lineStyle];
//    borderLineStyle.lineColor               = [CPTColor whiteColor];
//    borderLineStyle.lineWidth               = 2.0f;
//    graph.plotAreaFrame.borderLineStyle     = borderLineStyle;
//    graph.plotAreaFrame.paddingTop          = 10.0;
//    graph.plotAreaFrame.paddingRight        = 10.0;
//    graph.plotAreaFrame.paddingBottom       = 80.0;
//    graph.plotAreaFrame.paddingLeft         = 70.0;
//    
//
//    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.hostView.hostedGraph.axisSet;
////    CPTLineStyle *lineStyle = [CPTLineStyle lineStyle];
//
//    CPTMutableLineStyle *lineStyleThick = [CPTMutableLineStyle lineStyle];
//    lineStyleThick.lineColor = [CPTColor whiteColor];
//    lineStyleThick.lineWidth = 2.0f;
//    
//    CPTMutableLineStyle *lineStyleThin = [CPTMutableLineStyle lineStyle];
//    lineStyleThin.lineColor = [CPTColor whiteColor];
//    lineStyleThin.lineWidth = 1.0f;
//    
//    //Grid line styles
//    CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
//    majorGridLineStyle.lineWidth            = 0.75;
//    majorGridLineStyle.lineColor            = [[CPTColor whiteColor] colorWithAlphaComponent:0.1];
//    CPTMutableLineStyle *minorGridLineStyle = [CPTMutableLineStyle lineStyle];
//    minorGridLineStyle.lineWidth            = 0.25;
//    minorGridLineStyle.lineColor            = [[CPTColor whiteColor] colorWithAlphaComponent:0.1];
//    
//    //Axises
//    
//    //X axis
//    CPTXYAxis *x                    = axisSet.xAxis;
//    x.orthogonalCoordinateDecimal   = CPTDecimalFromInt(0);
//    x.majorIntervalLength           = CPTDecimalFromInt(1);
//    x.minorTicksPerInterval         = 0;
//    x.labelingPolicy                = CPTAxisLabelingPolicyNone;
//    x.majorGridLineStyle            = majorGridLineStyle;
//    x.axisConstraints               = [CPTConstraints constraintWithLowerOffset:0.0];
//    
//    //Y axis
//    CPTXYAxis *y            = axisSet.yAxis;
//    y.title                 = @"Value";
//    y.titleOffset           = 50.0f;
//    y.labelingPolicy        = CPTAxisLabelingPolicyAutomatic;
//    y.majorGridLineStyle    = majorGridLineStyle;
//    y.minorGridLineStyle    = minorGridLineStyle;
//    y.axisConstraints       = [CPTConstraints constraintWithLowerOffset:0.0];
//    
//
//    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) self.hostView.hostedGraph.defaultPlotSpace;
//    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-6)
//                                                    length:CPTDecimalFromFloat(12)];
//    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-0.9)
//                                                    length:CPTDecimalFromFloat(0.9)];
//    
//    
//    //Grid line styles
//    CPTMutableLineStyle *majorGridLineStyle_ = [CPTMutableLineStyle lineStyle];
//    majorGridLineStyle_.lineWidth            = 0.75;
//    majorGridLineStyle_.lineColor            = [[CPTColor whiteColor] colorWithAlphaComponent:0.1];
//    CPTMutableLineStyle *minorGridLineStyle_ = [CPTMutableLineStyle lineStyle];
//    minorGridLineStyle_.lineWidth            = 0.25;
//    minorGridLineStyle_.lineColor            = [[CPTColor whiteColor] colorWithAlphaComponent:0.1];
//    
//    //X axis
////    CPTXYAxis *x                    = axisSet.xAxis;
//    x.orthogonalCoordinateDecimal   = CPTDecimalFromInt(0);
//    x.majorIntervalLength           = CPTDecimalFromInt(1);
//    x.minorTicksPerInterval         = 0;
//    x.labelingPolicy                = CPTAxisLabelingPolicyNone;
//    x.majorGridLineStyle            = majorGridLineStyle;
//    x.axisConstraints               = [CPTConstraints constraintWithLowerOffset:0.0];
//    
//    //Y axis
////    CPTXYAxis *y            = axisSet.yAxis;
//    y.title                 = @"Value";
//    y.titleOffset           = 50.0f;
//    y.labelingPolicy        = CPTAxisLabelingPolicyAutomatic;
//    y.majorGridLineStyle    = majorGridLineStyle_;
//    y.minorGridLineStyle    = minorGridLineStyle_;
//    y.axisConstraints       = [CPTConstraints constraintWithLowerOffset:0.0];
//    
//    [self.hostView.hostedGraph applyTheme:[CPTTheme themeNamed:kCPTSlateTheme]];
//    
//	// 2 - Set graph title
//	NSString *title = @"Market Models - Delta Computation";
//	graph.title = title;
//	// 3 - Create and set text style
//	CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
//	titleStyle.color = [CPTColor whiteColor];
//	titleStyle.fontName = @"Helvetica-Bold";
//	titleStyle.fontSize = 16.0f;
//	self.hostView.hostedGraph.titleTextStyle = titleStyle;
//	self.hostView.hostedGraph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
//	self.hostView.hostedGraph.titleDisplacement = CGPointMake(0.0f, 10.0f);
//	// 4 - Set padding for plot area
//	[self.hostView.hostedGraph.plotAreaFrame setPaddingLeft:1.0f];
//	[self.hostView.hostedGraph.plotAreaFrame setPaddingBottom:1.0f];
//	// 5 - Enable user interactions for plot space
//	plotSpace.allowsUserInteraction = YES;
//    self.hostView.hostedGraph.plotAreaFrame.borderLineStyle = nil;
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
//	// 1 - Create styles
//	CPTMutableTextStyle *axisTitleStyle = [CPTMutableTextStyle textStyle];
//	axisTitleStyle.color = [CPTColor whiteColor];
//	axisTitleStyle.fontName = @"Helvetica-Bold";
//	axisTitleStyle.fontSize = 12.0f;
//	CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
//	axisLineStyle.lineWidth = 0.5f;
//	axisLineStyle.lineColor = [CPTColor whiteColor];
//	CPTMutableTextStyle *axisTextStyle = [[CPTMutableTextStyle alloc] init];
//	axisTextStyle.color = [CPTColor whiteColor];
//	axisTextStyle.fontName = @"Helvetica-Bold";
//	axisTextStyle.fontSize = 11.0f;
//	CPTMutableLineStyle *tickLineStyle = [CPTMutableLineStyle lineStyle];
//	tickLineStyle.lineColor = [CPTColor whiteColor];
//	tickLineStyle.lineWidth = 0.5f;
//	CPTMutableLineStyle *gridLineStyle = [CPTMutableLineStyle lineStyle];
//	tickLineStyle.lineColor = [CPTColor blackColor];
//	tickLineStyle.lineWidth = 1.0f;
//	// 2 - Get axis set
//	CPTXYAxisSet *axisSet = (CPTXYAxisSet *) self.hostView.hostedGraph.axisSet;
//	// 3 - Configure x-axis
//	CPTAxis *x = axisSet.xAxis;
//	x.title = @"Index of Delta";
//	x.titleTextStyle = axisTitleStyle;
//	x.titleOffset = 2.0f;
//	x.axisLineStyle = axisLineStyle;
//	x.labelingPolicy = CPTAxisLabelingPolicyNone;
//	x.labelTextStyle = axisTextStyle;
//	x.majorTickLineStyle = axisLineStyle;
//	x.majorTickLength = 1.0f;
//	x.tickDirection = CPTSignNegative;
//
//	// 4 - Configure y-axis
//	CPTAxis *y = axisSet.yAxis;
//	y.title = @"Value of Delta";
//	y.titleTextStyle = axisTitleStyle;
//	y.titleOffset = -18.0f;
//	y.axisLineStyle = axisLineStyle;
//	y.majorGridLineStyle = gridLineStyle;
//	y.labelingPolicy = CPTAxisLabelingPolicyNone;
//	y.labelTextStyle = axisTextStyle;
//	y.labelOffset = 16.0f;
//	y.majorTickLineStyle = axisLineStyle;
//	y.majorTickLength = 0.5f;
//	y.minorTickLength = 0.5f;
//	y.tickDirection = CPTSignPositive;
//
//    NSInteger majorIncrement = 1;
//    NSInteger minorIncrement = 1;
//    CGFloat yMax = 0.00001;  // should determine dynamically based on max price
//	NSMutableSet *yLabels = [NSMutableSet set];
//	NSMutableSet *yMajorLocations = [NSMutableSet set];
//	NSMutableSet *yMinorLocations = [NSMutableSet set];
//	for (NSInteger j = minorIncrement; j <= yMax; j += minorIncrement) {
//		NSUInteger mod = j % majorIncrement;
//		if (mod == 0) {
//			CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%i", j] textStyle:y.labelTextStyle];
//			NSDecimal location = CPTDecimalFromInteger(j);
//			label.tickLocation = location;
//			label.offset = -y.majorTickLength - y.labelOffset;
//			if (label) {
//				[yLabels addObject:label];
//			}
//			[yMajorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:location]];
//		} else {
//			[yMinorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:CPTDecimalFromInteger(j)]];
//		}
//	}
//	y.axisLabels = yLabels;
//	y.majorTickLocations = yMajorLocations;
//	y.minorTickLocations = yMinorLocations;
}


//- (void)generateLayout
//{
//    //Create graph from theme
//    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
//    
//    
//    graph                               = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
//    [graph applyTheme:[CPTTheme themeNamed:kCPTStocksTheme]];
//    graph.plotAreaFrame.masksToBorder   = NO;
//    graph.paddingLeft                   = 0.0f;
//    graph.paddingTop                    = 0.0f;
//    graph.paddingRight                  = 0.0f;
//    graph.paddingBottom                 = 0.0f;
//    
//    CPTMutableLineStyle *borderLineStyle    = [CPTMutableLineStyle lineStyle];
//    borderLineStyle.lineColor               = [CPTColor whiteColor];
//    borderLineStyle.lineWidth               = 2.0f;
//    graph.plotAreaFrame.borderLineStyle     = borderLineStyle;
//    graph.plotAreaFrame.paddingTop          = 10.0;
//    graph.plotAreaFrame.paddingRight        = 10.0;
//    graph.plotAreaFrame.paddingBottom       = 80.0;
//    graph.plotAreaFrame.paddingLeft         = 70.0;
//    
//    //Add plot space
//    CPTXYPlotSpace *plotSpace       = (CPTXYPlotSpace *)graph.defaultPlotSpace;
//    plotSpace.delegate              = self;
//    plotSpace.yRange                = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(0)
//                                                                   length:CPTDecimalFromInt(10 * 2)];
//    plotSpace.xRange                = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(-1)
//                                                                   length:CPTDecimalFromInt(8)];
//    
//    //Grid line styles
//    CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
//    majorGridLineStyle.lineWidth            = 0.75;
//    majorGridLineStyle.lineColor            = [[CPTColor whiteColor] colorWithAlphaComponent:0.1];
//    CPTMutableLineStyle *minorGridLineStyle = [CPTMutableLineStyle lineStyle];
//    minorGridLineStyle.lineWidth            = 0.25;
//    minorGridLineStyle.lineColor            = [[CPTColor whiteColor] colorWithAlphaComponent:0.1];
//    
//    //Axes
//    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
//    
//    //X axis
//    CPTXYAxis *x                    = axisSet.xAxis;
//    x.orthogonalCoordinateDecimal   = CPTDecimalFromInt(0);
//    x.majorIntervalLength           = CPTDecimalFromInt(1);
//    x.minorTicksPerInterval         = 0;
//    x.labelingPolicy                = CPTAxisLabelingPolicyNone;
//    x.majorGridLineStyle            = majorGridLineStyle;
//    x.axisConstraints               = [CPTConstraints constraintWithLowerOffset:0.0];
//    
//    //X labels
//    NSMutableArray *customXLabels = [NSMutableArray array];
//    x.axisLabels                    = [NSSet setWithArray:customXLabels];
//    
//    //Y axis
//    CPTXYAxis *y            = axisSet.yAxis;
//    y.title                 = @"Value";
//    y.titleOffset           = 50.0f;
//    y.labelingPolicy        = CPTAxisLabelingPolicyAutomatic;
//    y.majorGridLineStyle    = majorGridLineStyle;
//    y.minorGridLineStyle    = minorGridLineStyle;
//    y.axisConstraints       = [CPTConstraints constraintWithLowerOffset:0.0];
//    
//    //Create a bar line style
//    CPTMutableLineStyle *barLineStyle   = [[CPTMutableLineStyle alloc] init] ;
//    barLineStyle.lineWidth              = 1.0;
//    barLineStyle.lineColor              = [CPTColor whiteColor];
//    CPTMutableTextStyle *whiteTextStyle = [CPTMutableTextStyle textStyle];
//    whiteTextStyle.color                = [CPTColor whiteColor];
//    
//    //Plot
//    
//    //Add legend
//    CPTLegend *theLegend      = [CPTLegend legendWithGraph:graph];
//    //    theLegend.numberOfRows	  = sets.count;
//    theLegend.fill			  = [CPTFill fillWithColor:[CPTColor colorWithGenericGray:0.15]];
//    theLegend.borderLineStyle = barLineStyle;
//    theLegend.cornerRadius	  = 10.0;
//    theLegend.swatchSize	  = CGSizeMake(15.0, 15.0);
//    whiteTextStyle.fontSize	  = 13.0;
//    theLegend.textStyle		  = whiteTextStyle;
//    theLegend.rowMargin		  = 5.0;
//    theLegend.paddingLeft	  = 10.0;
//    theLegend.paddingTop	  = 10.0;
//    theLegend.paddingRight	  = 10.0;
//    theLegend.paddingBottom	  = 10.0;
//    graph.legend              = theLegend;
//    graph.legendAnchor        = CPTRectAnchorTopLeft;
//    graph.legendDisplacement  = CGPointMake(80.0, -10.0);
//}


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
                    return num = [NSNumber numberWithFloat:[num floatValue]*10];
                }
                break;
	}
	return [NSDecimalNumber zero];
}

@end



































