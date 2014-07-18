#import "PersistManager.h"

@implementation PersistManager

@synthesize managedObjectContext;
@synthesize managedObjectModel;
@synthesize persistentStoreCoordinator;

static PersistManager *instance = NULL;

+ (PersistManager *)instance {
    @synchronized(self) {
        if (instance == NULL)
            instance = [[self alloc] init];
    }
    return instance;
}

#pragma mark data
- (void) save {
	
	NSError* error;
	
	[self.managedObjectContext save:&error];
	
	if (error != nil) {
		NSLog(@" fetchError=%@,details=%@", error, error.userInfo);
	}
}

- (NSManagedObjectContext *) managedObjectContext {
	if (managedObjectContext != nil) {
		return managedObjectContext;
	}
	NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
	if (coordinator != nil) {
		managedObjectContext = [[NSManagedObjectContext alloc] init];
		[managedObjectContext setPersistentStoreCoordinator: coordinator];
	}
	
	return managedObjectContext;
}

- (NSManagedObjectModel *) managedObjectModel {
	if (managedObjectModel != nil) {
		return managedObjectModel;
	}
	managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
	
	return managedObjectModel;
}

- (NSPersistentStoreCoordinator *) persistentStoreCoordinator {
	if (persistentStoreCoordinator != nil) {
		return persistentStoreCoordinator;
	}
	NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory]
											   stringByAppendingPathComponent: @"Quiz.sqlite"]];
	NSError *error;
	
	persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
								   initWithManagedObjectModel:[self managedObjectModel]];
	
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
    						 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
    						 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
	
	[persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
																		 configuration:nil URL:storeUrl options:options error:&error];
	
	if (error != nil) {
		NSLog(@"Error = %@, details = %@", error, error.userInfo);
		NSLog(@"Try to reset persistent store");
		NSFileManager *fileManager = [NSFileManager defaultManager];
		[fileManager removeItemAtPath:[storeUrl path]  error:NULL];
		
		error = nil;

		[persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
														  configuration:nil URL:storeUrl options:options error:&error];
	}
	
	if (error != nil) {
		NSLog(@"fetchError = %@, details = %@", error, error.userInfo);
		return nil;
	}
	
	
	
	return persistentStoreCoordinator;
}

- (NSString *) applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

@end
