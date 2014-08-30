//
//  DmEquity.h
//  QuantTrader
//
//  Created by colman on 22/07/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DmEquity : NSManagedObject

@property (nonatomic, retain) NSNumber * quote;

// Strike
@property (nonatomic, retain) NSNumber * strikePrice;
@property (nonatomic, retain) NSNumber * dividentYieldValue;

// Settlement Date 1
@property (nonatomic, retain) NSDate * settlementDate_1; // 15-3-2012

@property (nonatomic, retain) NSDate * settlementDate_2;
@property (nonatomic, retain) NSDate * settlementDate_3;

// Maturity Date 1
@property (nonatomic, retain) NSDate * maturityDate_1; // 1-1-2013

@property (nonatomic, retain) NSDate * maturityDate_2;
@property (nonatomic, retain) NSDate * maturityDate_3;
@property (nonatomic, retain) NSNumber * underlying_eq; //36

@property (nonatomic, retain) NSNumber * strike_eq; // 40

@property (nonatomic, retain) NSNumber * dividendYield_eq; // 0,00
@property (nonatomic, retain) NSNumber * riskFreeRate_eq; // 0,06
@property (nonatomic, retain) NSNumber * volatility_eq; // 0,02
@property (nonatomic, retain) NSNumber * blackScholes_eo;
@property (nonatomic, retain) NSNumber * hestonSemiAnalytic_eo;
@property (nonatomic, retain) NSNumber * batesSemiAna_eo;
@property (nonatomic, retain) NSNumber * baroneAdesiWhaleySemiAna_eo;
@property (nonatomic, retain) NSNumber * bjerksundStenslandSemiAna_eo;
@property (nonatomic, retain) NSNumber * integral_eo;
@property (nonatomic, retain) NSNumber * finiteDifference_eo;
@property (nonatomic, retain) NSNumber * finiteDifference_bo;
@property (nonatomic, retain) NSNumber * finiteDifference_ao;
@property (nonatomic, retain) NSNumber * binomialJarrowRudd_eo;
@property (nonatomic, retain) NSNumber * binomialJarrowRudd_bo;
@property (nonatomic, retain) NSNumber * binomialJarrowRudd_ao;
@property (nonatomic, retain) NSNumber * binomialCoxRossRubinstein_eo;
@property (nonatomic, retain) NSNumber * binomialCoxRossRubinstein_bo;
@property (nonatomic, retain) NSNumber * binomialCoxRossRubinstein_ao;
@property (nonatomic, retain) NSNumber * additiveEquiprobabilities_eo;
@property (nonatomic, retain) NSNumber * additiveEquiprobabilities_bo;
@property (nonatomic, retain) NSNumber * additiveEquiprobabilities_ao;
@property (nonatomic, retain) NSNumber * binomialTrigeorgis_eo;
@property (nonatomic, retain) NSNumber * binomialTrigeorgis_bo;
@property (nonatomic, retain) NSNumber * binomialTrigeorgis_ao;
@property (nonatomic, retain) NSNumber * binomialTian_eo;
@property (nonatomic, retain) NSNumber * binomialTian_ao;
@property (nonatomic, retain) NSNumber * binomialTian_bo;
@property (nonatomic, retain) NSNumber * binomialLeisenReimer_eo;
@property (nonatomic, retain) NSNumber * binomialLeisenReimer_bo;
@property (nonatomic, retain) NSNumber * binomialLeisenReimer_ao;
@property (nonatomic, retain) NSNumber * binomialJoshi_eo;
@property (nonatomic, retain) NSNumber * binomialJoshi_ao;
@property (nonatomic, retain) NSNumber * binomialJoshi_bo;
@property (nonatomic, retain) NSNumber * mcCrude_eo;
@property (nonatomic, retain) NSNumber * qmcSobol_eo;
@property (nonatomic, retain) NSNumber * mcLongstaffSchwatz_ao;

@end
