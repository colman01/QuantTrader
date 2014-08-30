//
//  QuantDao.m
//  QuantTrader
//
//  Created by colman on 18/07/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import "QuantDao.h"

@implementation QuantDao

@synthesize bond;

static QuantDao *instance = NULL;

+(QuantDao *)instance {
    @synchronized(self) {
        if (instance == NULL)
            instance = [[self alloc] init];
    }
    return instance;
}



- (void)remove:(DmBond *)bond {
    [[[PersistManager instance] managedObjectContext] deleteObject:bond];
}

- (NSMutableArray *) getBond {
    // initializing NSFetchRequest
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Bond"
                                              inManagedObjectContext:[[PersistManager instance] managedObjectContext]];
    [fetchRequest setEntity:entity];
    NSError* error;
    
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [[[PersistManager instance] managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    // Returning Fetched Records
    return [[NSMutableArray alloc] initWithArray:fetchedRecords];
}




- (DmBond *) loadById:(NSNumber *) identifier {
    @try {
        // initializing NSFetchRequest
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        PersistManager *pc = [PersistManager instance];
        
        //Setting Entity to be Queried
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Bond" inManagedObjectContext:[pc managedObjectContext]];
        [fetchRequest setEntity:entity];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat: @"identifier = %@", identifier];
        
        [fetchRequest setPredicate:predicate];
        
        NSError* error;
        
        NSLog(@"");
        // Query on managedObjectContext With Generated fetchRequest
        NSManagedObjectContext *context = [pc managedObjectContext];
        NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
        NSLog(@"");
        if (error != nil) {
            NSLog(@"fetchError = %@, details = %@", error, error.userInfo);
            return nil;
        }
        
        if (result.count > 0)
            return  result[0];
        
        DmBond * bond_    = [NSEntityDescription insertNewObjectForEntityForName:@"Bond" inManagedObjectContext:[[PersistManager instance] managedObjectContext]];
        return bond_;
    }
    @catch (NSException *exception) {
        DmBond * bond_    = [NSEntityDescription insertNewObjectForEntityForName:@"Bond" inManagedObjectContext:[[PersistManager instance] managedObjectContext]];
        return bond_;
    }
    
    
}

- (NSMutableArray *) getEquity {
    // initializing NSFetchRequest
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Equity"
                                              inManagedObjectContext:[[PersistManager instance] managedObjectContext]];
    [fetchRequest setEntity:entity];
    NSError* error;
    
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [[[PersistManager instance] managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    // Returning Fetched Records
    return [[NSMutableArray alloc] initWithArray:fetchedRecords];
}




@end
