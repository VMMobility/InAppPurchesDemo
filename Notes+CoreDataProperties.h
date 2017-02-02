//
//  Notes+CoreDataProperties.h
//  
//
//  Created by vmoksha mobility on 8/3/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Notes.h"

NS_ASSUME_NONNULL_BEGIN

@interface Notes (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *filename;
@property (nullable, nonatomic, retain) NSString *foldername;
@property (nullable, nonatomic, retain) NSString *info;

@end

NS_ASSUME_NONNULL_END
