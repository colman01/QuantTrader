//
//  EquityOption_.h
//  QuantLibExample
//
//  Created by colman on 28.06.13.
//  Copyright (c) 2013 Striding Edge Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EquityOption_ : NSObject {
    
//    double underlying;
//    double strike;
//    double dividendYield;
//    double riskFreeRate;
//    double volatility;
}


@property (nonatomic) double quote;
@property (nonatomic) double strikePrice;
@property (nonatomic) double dividentYieldValue;
@property (nonatomic) double riskFreeRateValue;
@property (nonatomic) double volatilityValue;

@property (nonatomic) int settlementDate_1;
@property (nonatomic) int settlementDate_2;
@property (nonatomic) int settlementDate_3;

@property (nonatomic) int maturityDate_1;
@property (nonatomic) int maturityDate_2;
@property (nonatomic) int maturityDate_3;

@property (nonatomic) double underlying_eq;
@property (nonatomic) double strike_eq;
@property (nonatomic) double dividendYield_eq;
@property (nonatomic) double riskFreeRate_eq;
@property (nonatomic) double volatility_eq;

@property (nonatomic) double blackScholes_eo;
@property (nonatomic) double hestonSemiAnalytic_eo;
@property (nonatomic) double batesSemiAna_eo;
@property (nonatomic) double baroneAdesiWhaleySemiAna_eo;
@property (nonatomic) double bjerksundStenslandSemiAna_eo;
@property (nonatomic) double integral_eo;

@property (nonatomic) double finiteDifference_eo;
@property (nonatomic) double finiteDifference_bo;
@property (nonatomic) double finiteDifference_ao;

@property (nonatomic) double binomialJarrowRudd_eo;
@property (nonatomic) double binomialJarrowRudd_bo;
@property (nonatomic) double binomialJarrowRudd_ao;

@property (nonatomic) double binomialCoxRossRubinstein_eo;
@property (nonatomic) double binomialCoxRossRubinstein_bo;
@property (nonatomic) double binomialCoxRossRubinstein_ao;

@property (nonatomic) double additiveEquiprobabilities_eo;
@property (nonatomic) double additiveEquiprobabilities_bo;
@property (nonatomic) double additiveEquiprobabilities_ao;

@property (nonatomic) double binomialTrigeorgis_eo;
@property (nonatomic) double binomialTrigeorgis_bo;
@property (nonatomic) double binomialTrigeorgis_ao;

@property (nonatomic) double binomialTian_eo;
@property (nonatomic) double binomialTian_bo;
@property (nonatomic) double binomialTian_ao;

@property (nonatomic) double binomialLeisenReimer_eo;
@property (nonatomic) double binomialLeisenReimer_bo;
@property (nonatomic) double binomialLeisenReimer_ao;

@property (nonatomic) double binomialJoshi_eo;
@property (nonatomic) double binomialJoshi_bo;
@property (nonatomic) double binomialJoshi_ao;

@property (nonatomic) double mcCrude_eo;
@property (nonatomic) double qmcSobol_eo;
@property (nonatomic) double mcLongstaffSchwatz_ao;





-(void) calculate;
//QuantLib::Month intToQLMonth(int monthAsInteger);

@end



//        std::cout << "Option type = "  << type << std::endl;
//        std::cout << "Maturity = "        << maturity << std::endl;
//        std::cout << "Underlying price = "        << underlying << std::endl;
//        std::cout << "Strike = "                  << strike << std::endl;
//        std::cout << "Risk-free interest rate = " << io::rate(riskFreeRate)
//        << std::endl;
//        std::cout << "Dividend yield = " << io::rate(dividendYield)
//        << std::endl;
//        std::cout << "Volatility = " << io::volatility(volatility)
//        << std::endl;
//        std::cout << std::endl;
//        std::string method;
//        std::cout << std::endl ;