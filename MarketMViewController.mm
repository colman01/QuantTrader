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

- (void) viewWillAppear:(BOOL)animated {
}

- (void) viewDidAppear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)btnCalc:(id)sender {
    
    [[UIDevice currentDevice].systemVersion floatValue];
    #define _kisiOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    
    if (_kisiOS8) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"iOS 8+" message:@"Sorry this tool is not yet supported" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"Ok", nil];
        [alert show];
        
    }
    else {
        NSLog(@"Less than iOS8");
        [market graphReady:^() {
            [self reloadGraph:nil];
        }];
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Calculation running" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        [alert show];
        [market calcHit];
        for (NSNumber *num in market.delta) {
            NSLog(@"calculation finished %@", num);
        }
    }
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
    self.hostView.hostedGraph.delegate = self;
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
    
    plotSpace.delegate = self;
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

#pragma mark - Touch

-(BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceUpEvent:(id)event atPoint:(CGPoint)point {
    return YES;
}

-(BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceCancelledEvent:(id)event{
    return YES;
}

-(BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceDownEvent:(id)event atPoint:(CGPoint)point{
    NSLog(@"point down");
    //    NSNumber * theValue = [[self.graphDataSource.timeSeries objectAtIndex:index] observationValue];
    //
    //    // if the annotations already exist, remove them
    //    if ( self.valueTextAnnotation ) {
    //        [self.graph.plotAreaFrame.plotArea removeAnnotation:self.valueTextAnnotation];
    //        self.valueTextAnnotation = nil;
    //    }
    //
    //    // Setup a style for the annotation
    //    CPTMutableTextStyle *annotationTextStyle = [CPTMutableTextStyle textStyle];
    //    annotationTextStyle.color = [CPTColor whiteColor];
    //    annotationTextStyle.fontSize = 14.0f;
    //    annotationTextStyle.fontName = @"Helvetica-Bold";
    //
    //    // Add annotation
    //    // First make a string for the y value
    //    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    //    [formatter setMaximumFractionDigits:2];
    //    NSString *currentValue = [formatter stringFromNumber:theValue];
    //
    //    NSNumber *x            = [NSNumber numberWithDouble:[theDate timeIntervalSince1970]];
    //    NSNumber *y            = [NSNumber numberWithFloat:self.graphDataSource.maxValue];
    //    NSArray *anchorPoint = [NSArray arrayWithObjects:x, y, nil];
    //
    //    // Then add the value annotation to the plot area
    //    float valueLayerWidth = 50.0f;
    //    float valueLayerHeight = 20.0f;
    //    CPTTextLayer *valueLayer = [[CPTTextLayer alloc] initWithFrame:CGRectMake(0,0,valueLayerWidth,valueLayerHeight)];
    //
    //    valueLayer.text = currentValue;
    //    valueLayer.textStyle = annotationTextStyle;
    //    valueLayer.backgroundColor = [UIColor blueColor].CGColor;
    //
    //    self.valueTextAnnotation  = [[CPTPlotSpaceAnnotation alloc] initWithPlotSpace:self.graph.defaultPlotSpace anchorPlotPoint:anchorPoint];
    //
    //    self.valueTextAnnotation.contentLayer = valueLayer;
    //
    //    // modify the displacement if we are close to either edge
    //    float xDisplacement = 0.0;
    //    ...
    //    self.valueTextAnnotation.displacement = CGPointMake(xDisplacement, 8.0f);
    //
    //    [self.graph.plotAreaFrame.plotArea addAnnotation:self.valueTextAnnotation]
    //    CPTGraph *graph = self.hostView.hostedGraph;
    //    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    //
    //
    //    // 2 - Create style, if necessary
    //    static CPTMutableTextStyle *style = nil;
    //    if (!style) {
    //        style = [CPTMutableTextStyle textStyle];
    //        style.color= [CPTColor yellowColor];
    //        style.fontSize = 16.0f;
    //        style.fontName = @"Helvetica-Bold";
    //    }
    //    // 3 - Create annotation, if necessary
    //    NSNumber *price = [NSNumber numberWithDouble:100];
    //
    //    if (!self.priceAnnotation) {
    //        NSNumber *x = [NSNumber numberWithInt:0];
    //        NSNumber *y = [NSNumber numberWithInt:0];
    //        NSArray *anchorPoint = [NSArray arrayWithObjects:x, y, nil];
    //        self.priceAnnotation = [[CPTPlotSpaceAnnotation alloc] initWithPlotSpace:plotSpace anchorPlotPoint:anchorPoint];
    //    }
    //    // 4 - Create number formatter, if needed
    //    static NSNumberFormatter *formatter = nil;
    //    if (!formatter) {
    //        formatter = [[NSNumberFormatter alloc] init];
    //        [formatter setMaximumFractionDigits:2];
    //    }
    //    // 5 - Create text layer for annotation
    //    NSString *priceValue = [formatter stringFromNumber:price];
    //    CPTTextLayer *textLayer = [[CPTTextLayer alloc] initWithText:priceValue style:style];
    //    textLayer.text = @"some data";
    //    self.priceAnnotation.contentLayer = textLayer;
    //
    //    // 6 - Get plot index based on identifier
    ////    NSInteger plotIndex = 0;
    ////    if ([plot.identifier isEqual:CPDTickerSymbolAAPL] == YES) {
    ////        plotIndex = 0;
    ////    } else if ([plot.identifier isEqual:CPDTickerSymbolGOOG] == YES) {
    ////        plotIndex = 1;
    ////    } else if ([plot.identifier isEqual:CPDTickerSymbolMSFT] == YES) {
    ////        plotIndex = 2;
    ////    }
    //    // 7 - Get the anchor point for annotation
    ////    CGFloat x = index + CPDBarInitialX + (plotIndex * CPDBarWidth);
    ////    NSNumber *anchorX = [NSNumber numberWithFloat:x];
    ////    CGFloat y = [price floatValue] + 40.0f;
    ////    NSNumber *anchorY = [NSNumber numberWithFloat:y];
    //
    //    CGFloat x ;
    //    NSNumber *anchorX = [NSNumber numberWithFloat:point.x];
    //    CGFloat y = point.y;
    //    NSNumber *anchorY = [NSNumber numberWithFloat:y];
    //
    //
    //    self.priceAnnotation.anchorPlotPoint = [NSArray arrayWithObjects:anchorX, anchorY, nil];
    //    // 8 - Add the annotation
    //    [self.hostView.hostedGraph.plotAreaFrame.plotArea addAnnotation:self.priceAnnotation];
    return YES;
}

-(BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceDraggedEvent:(id)event atPoint:(CGPoint)point {
    NSLog(@"point dragged");
    return YES;
}


-(void)plot:(CPTPlot *)plot dataLabelWasSelectedAtRecordIndex:(NSUInteger)idx {
    CPTLayerAnnotation *annot = [[CPTLayerAnnotation alloc]initWithAnchorLayer:self.hostView.hostedGraph];
    CPTBorderedLayer * logoLayer = [(CPTBorderedLayer *) [CPTBorderedLayer alloc] initWithFrame:CGRectMake(10,10,100,50)] ;
    //    CPTFill *fillImage = [CPTFill fillWithImage:[CPTImage imageForPNGFile:@"whatEver!"]];
    //    logoLayer.fill = fillImage;
    annot.contentLayer = logoLayer;
    annot.rectAnchor=CPTRectAnchorTop;
    [self.hostView.hostedGraph addAnnotation:annot];
}

- (void)scatterPlot:(CPTScatterPlot *)plot plotSymbolWasSelectedAtRecordIndex:(NSUInteger)index
{
    CPTLayerAnnotation *annot = [[CPTLayerAnnotation alloc]initWithAnchorLayer:self.hostView.hostedGraph];
    CPTBorderedLayer * logoLayer = [(CPTBorderedLayer *) [CPTBorderedLayer alloc] initWithFrame:CGRectMake(10,10,100,50)] ;
    //    CPTFill *fillImage = [CPTFill fillWithImage:[CPTImage imageForPNGFile:@"whatEver!"]];
    //    logoLayer.fill = fillImage;
    annot.contentLayer = logoLayer;
    annot.rectAnchor=CPTRectAnchorTop;
    [self.hostView.hostedGraph addAnnotation:annot];
}

@end



































