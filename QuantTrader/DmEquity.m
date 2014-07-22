//
//  DmEquity.m
//  QuantTrader
//
//  Created by colman on 22/07/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import "DmEquity.h"


@implementation DmEquity

@dynamic quote;
@dynamic strikePrice;
@dynamic dividentYieldValue;
@dynamic settlementDate_1;
@dynamic settlementDate_2;
@dynamic settlementDate_3;
@dynamic maturityDate_1;
@dynamic maturityDate_2;
@dynamic maturityDate_3;
@dynamic underlying_eq;
@dynamic strike_eq;
@dynamic dividendYield_eq;
@dynamic riskFreeRate_eq;
@dynamic volatility_eq;
@dynamic blackScholes_eo;
@dynamic hestonSemiAnalytic_eo;
@dynamic batesSemiAna_eo;
@dynamic baroneAdesiWhaleySemiAna_eo;
@dynamic bjerksundStenslandSemiAna_eo;
@dynamic integral_eo;
@dynamic finiteDifference_eo;
@dynamic finiteDifference_bo;
@dynamic finiteDifference_ao;
@dynamic binomialJarrowRudd_eo;
@dynamic binomialJarrowRudd_bo;
@dynamic binomialJarrowRudd_ao;
@dynamic binomialCoxRossRubinstein_eo;
@dynamic binomialCoxRossRubinstein_bo;
@dynamic binomialCoxRossRubinstein_ao;
@dynamic additiveEquiprobabilities_eo;
@dynamic additiveEquiprobabilities_bo;
@dynamic additiveEquiprobabilities_ao;
@dynamic binomialTrigeorgis_eo;
@dynamic binomialTrigeorgis_bo;
@dynamic binomialTrigeorgis_ao;
@dynamic binomialTian_eo;
@dynamic binomialTian_ao;
@dynamic binomialTian_bo;
@dynamic binomialLeisenReimer_eo;
@dynamic binomialLeisenReimer_bo;
@dynamic binomialLeisenReimer_ao;
@dynamic binomialJoshi_eo;
@dynamic binomialJoshi_ao;
@dynamic binomialJoshi_bo;
@dynamic mcCrude_eo;
@dynamic qmcSobol_eo;
@dynamic mcLongstaffSchwatz_ao;

@end
