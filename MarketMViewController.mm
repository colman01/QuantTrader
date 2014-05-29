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
    market = [[MarketModels alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)btnCalc:(id)sender {
    [market calcHit];


//    market.delta.pu
    for (NSNumber *num in market.delta) {
        NSLog(@"calculation finished %@", num);
    }
    

    
//    NSArray *myArray = [NSArray arrayWithObjects:&results[0] count:results.size()];
    
//    - (void)stitchGroundVectsWithVector:(std::vector<b2Vec2>)vec;

}

-(IBAction)quitCalc:(id)sender {
//    [market setExitCalc:YES];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"myAlert" message:@"pressed" delegate:self cancelButtonTitle:@"can cel" otherButtonTitles:@"", nil];
    [alert show];
    [market stopCalc];
}
//
//#pragma mark - CPTPlotDataSource methods
//-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
//	return [[[CPDStockPriceStore sharedInstance] tickerSymbols] count];
//}
//
//-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
//	if (CPTPieChartFieldSliceWidth == fieldEnum) {
//		return [[[CPDStockPriceStore sharedInstance] dailyPortfolioPrices] objectAtIndex:index];
//	}
//	return [NSDecimalNumber zero];
//}
//
//-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index {
//	// 1 - Define label text style
//	static CPTMutableTextStyle *labelText = nil;
//	if (!labelText) {
//		labelText= [[CPTMutableTextStyle alloc] init];
//		labelText.color = [CPTColor grayColor];
//	}
//	// 2 - Calculate portfolio total value
//	NSDecimalNumber *portfolioSum = [NSDecimalNumber zero];
//	for (NSDecimalNumber *price in [[CPDStockPriceStore sharedInstance] dailyPortfolioPrices]) {
//		portfolioSum = [portfolioSum decimalNumberByAdding:price];
//	}
//	// 3 - Calculate percentage value
//	NSDecimalNumber *price = [[[CPDStockPriceStore sharedInstance] dailyPortfolioPrices] objectAtIndex:index];
//	NSDecimalNumber *percent = [price decimalNumberByDividingBy:portfolioSum];
//	// 4 - Set up display label
//	NSString *labelValue = [NSString stringWithFormat:@"$%0.2f USD (%0.1f %%)", [price floatValue], ([percent floatValue] * 100.0f)];
//	// 5 - Create and return layer with label text
//	return [[CPTTextLayer alloc] initWithText:labelValue style:labelText];
//}
//
//-(NSString *)legendTitleForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index {
//	if (index < [[[CPDStockPriceStore sharedInstance] tickerSymbols] count]) {
//		return [[[CPDStockPriceStore sharedInstance] tickerSymbols] objectAtIndex:index];
//	}
//	return @"N/A";
//}


@end
