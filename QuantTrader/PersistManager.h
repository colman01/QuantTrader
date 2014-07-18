
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface PersistManager : NSObject

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (PersistManager *)instance;

- (void) save;

@end
