//
//  DmRepo.h
//  QuantTrader
//
//  Created by colman on 22/07/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DmRepo : NSManagedObject

@property (nonatomic, retain) NSDate * repoSettlementDate;
@property (nonatomic, retain) NSDate * repoDeliveryDate;
@property (nonatomic, retain) NSNumber * repoRate;
@property (nonatomic, retain) NSNumber * repoSettlementDays;
@property (nonatomic, retain) NSDate * bondIssueDate;
@property (nonatomic, retain) NSDate * bondDatedDate;
@property (nonatomic, retain) NSNumber * bondCoupon;
@property (nonatomic, retain) NSNumber * bondSettlementDays;
@property (nonatomic, retain) NSNumber * bondCleanPrice;
@property (nonatomic, retain) NSNumber * bondRedemption;
@property (nonatomic, retain) NSNumber * faceAmount;
@property (nonatomic, retain) NSNumber * dummyStrike;
@property (nonatomic, retain) NSData * fwdType;

@end
