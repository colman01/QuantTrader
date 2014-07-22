//
//  ParameterInitializer.m
//  QuantTrader
//
//  Created by colman on 22/07/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import "ParameterInitializer.h"

@implementation ParameterInitializer



- (void) setupParameters {
    
    
//    using namespace QuantLib;
    
    
    
    
    DmBond *bondParameters;
    
    NSMutableArray *results = [[QuantDao instance] getBond];
    
    @try {
        bondParameters = results[0];
    }
    @catch (NSException *exception) {
    }
    
    
    //  15, QuantLib::March, 2005
    //  15, QuantLib::June, 2005
    //  30, QuantLib::June, 2006)
    //  15, QuantLib::November, 2002
    //  15, QuantLib::May, 1987
    
    [bondParameters addZeroCouponQuoteAsNumber:[NSNumber numberWithDouble:0.0096]];
    [bondParameters addZeroCouponQuoteAsNumber:[NSNumber numberWithDouble:0.0145]];
    [bondParameters addZeroCouponQuoteAsNumber:[NSNumber numberWithDouble:0.0194]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/mmm/yyyy"];
    
    NSString *str =@"15/03/2005";
    [bondParameters addissueDateAsDate:[formatter dateFromString:str]];
    
    str =@"15/06/2005";
    [bondParameters addissueDateAsDate:[formatter dateFromString:str]];
    
    
    str =@"30/06/2006";
    [bondParameters addissueDateAsDate:[formatter dateFromString:str]];
    
    str =@"15/11/2006";
    [bondParameters addissueDateAsDate:[formatter dateFromString:str]];
    
    str =@"15/05/1987";
    [bondParameters addissueDateAsDate:[formatter dateFromString:str]];
    
//    [[PersistManager instance] save];
    
    bondParameters.fixingDays = [NSNumber numberWithDouble:100];
    bondParameters.numberOfBonds = [NSNumber numberWithDouble:5];
    
    str =@"31/08/2010";
    [bondParameters addDate:[formatter dateFromString:str] toData:bondParameters.maturityDates];
    str =@"31/08/2011";
    [bondParameters addDate:[formatter dateFromString:str] toData:bondParameters.maturityDates];
    str =@"30/08/2013";
    [bondParameters addDate:[formatter dateFromString:str] toData:bondParameters.maturityDates];
    str =@"15/08/2018";
    [bondParameters addDate:[formatter dateFromString:str] toData:bondParameters.maturityDates];
    str =@"15/08/2038";
    [bondParameters addDate:[formatter dateFromString:str] toData:bondParameters.maturityDates];
//    [bondParameters
    
    

//    
//    Real couponRates[] = {
//        0.02375,
//        0.04625,
//        0.03125,
//        0.04000,
//        0.04500
//    };
//    
//    Real marketQuotes[] = {
//        100.390625,
//        106.21875,
//        100.59375,
//        101.6875,
//        102.140625
//    };
//    
//    //    Rate d1wQuote=0.043375;
//    //    Rate d1mQuote=0.031875;
//    //    Rate d3mQuote=0.0320375;
//    //    Rate d6mQuote=0.03385;
//    //    Rate d9mQuote=0.0338125;
//    //    Rate d1yQuote=0.0335125;
//    
//    
//    for(int i =0; i<  5; i++) {
//        QuantLib::Date &date = issueDates[i];
//        std::stringstream stream;
//        //        std::string format = "d-mmm-yyyy";
//        try {
//            stream << date.dayOfMonth() << "-" << date.month() << "-" << date.year();
//        }
//        catch (std::exception &e) {
//        }
//        
//        std::string result = stream.str() ;
//        if (!formatedIssueDates)
//            formatedIssueDates = [[NSMutableArray alloc] init];
//        [formatedIssueDates addObject:[NSString stringWithFormat:@"%s",result.c_str()]];
//        stream.str("");
//        
//        date = maturitieDates[i];
//        try {
//            stream << date.dayOfMonth() << "-" << date.month() << "-" << date.year();
//        }
//        catch (std::exception &e) {
//        }
//        
//        result = stream.str() ;
//        if (!formatedMaturiyDates)
//            formatedMaturiyDates = [[NSMutableArray alloc] init];
//        [formatedMaturiyDates addObject:[NSString stringWithFormat:@"%s",result.c_str()]];
//        
//        stream.str("");
//        
//        float rate = (float)couponRates[i];
//        if (!_bondCouponRates)
//            _bondCouponRates = [[NSMutableArray alloc] init];
//        [_bondCouponRates addObject:[NSString stringWithFormat:@"%f",rate]];
//        
//        
//        float marketQuote = (float)marketQuotes[i];
//        if(!bondMarketQuotes)
//            bondMarketQuotes = [[NSMutableArray alloc] init];
//        [bondMarketQuotes addObject:[NSString stringWithFormat:@"%f",marketQuote]];
//        
//    }
//    
//    Rate d1wQuote=0.043375;
//    Rate d1mQuote=0.031875;
//    Rate d3mQuote=0.0320375;
//    Rate d6mQuote=0.03385;
//    Rate d9mQuote=0.0338125;
//    Rate d1yQuote=0.0335125;
//    
//    
//    if(!bondLiborForcastingCurveQuotes)
//        bondLiborForcastingCurveQuotes = [[NSMutableArray alloc] init];
//    
//    [bondLiborForcastingCurveQuotes addObject:[NSString stringWithFormat:@"%f",(float)d1wQuote] ];
//    [bondLiborForcastingCurveQuotes addObject:[NSString stringWithFormat:@"%f",(float)d1mQuote]];
//    [bondLiborForcastingCurveQuotes addObject:[NSString stringWithFormat:@"%f",(float)d3mQuote]];
//    [bondLiborForcastingCurveQuotes addObject:[NSString stringWithFormat:@"%f",(float)d6mQuote]];
//    [bondLiborForcastingCurveQuotes addObject:[NSString stringWithFormat:@"%f",(float)d9mQuote]];
//    [bondLiborForcastingCurveQuotes addObject:[NSString stringWithFormat:@"%f",(float)d1yQuote]];
//    
//    Rate s2yQuote=0.0295;
//    Rate s3yQuote=0.0323;
//    Rate s5yQuote=0.0359;
//    Rate s10yQuote=0.0412;
//    Rate s15yQuote=0.0433;
//    
//    if(!bondSwapQuotes)
//        bondSwapQuotes = [[NSMutableArray alloc] init];
//    [bondSwapQuotes addObject:[NSString stringWithFormat:@"%f",(float)s2yQuote] ];
//    [bondSwapQuotes addObject:[NSString stringWithFormat:@"%f",(float)s3yQuote]];
//    [bondSwapQuotes addObject:[NSString stringWithFormat:@"%f",(float)s5yQuote]];
//    [bondSwapQuotes addObject:[NSString stringWithFormat:@"%f",(float)s10yQuote]];
//    [bondSwapQuotes addObject:[NSString stringWithFormat:@"%f",(float)s15yQuote]];
//    
//    
//    self.faceamount = 100;
//    
//    
//    //    Date zcDate1 = QuantLib::Date (21, QuantLib::October, 2005);
//    //    Date zcDate2 = QuantLib::Date (15, QuantLib::May, 2007);
//    std::stringstream stream;
//    stream.str("");
//    Date zcDate1 = QuantLib::Date (21, QuantLib::October, 2005);
//    try {
//        stream << zcDate1.dayOfMonth() << "-" << zcDate1.month() << "-" << zcDate1.year();
//    }
//    catch (std::exception &e) {
//    }
//    std::string result = stream.str() ;
//    self.zeroCouponDate1 = [NSString stringWithFormat:@"%s",result.c_str()];
//    
//    stream.str("");
//    Date zcDate2 = QuantLib::Date (15, QuantLib::May, 2007);
//    try {
//        stream << zcDate2.dayOfMonth() << "-" << zcDate2.month() << "-" << zcDate2.year();
//    }
//    catch (std::exception &e) {
//    }
//    result = stream.str() ;
//    self.zeroCouponDate2 = [NSString stringWithFormat:@"%s",result.c_str()];
    
    
    //        Date(21, October, 2005)
    //        Date(21, October, 2010)
    
}

@end
