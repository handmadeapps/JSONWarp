//
//  NSDictionary+SCLUtils.m
//  JSONWarpExample
//
//  Created by Konstantinos Kontos on 8/21/15.
//  Copyright (c) 2015 Saturated Colors. All rights reserved.
//

#import "NSDictionary+SCLUtils.h"

@implementation NSDictionary (SCLUtils)

// nodeDict[@"SCLJSONNode".sclKeyToObjectID]=node.objectID.URIRepresentation;

-(SCLJSONNode *)sclNodeForKey:(NSString *)keyStr withManagedObjectContext:(NSManagedObjectContext *)moc {
    NSURL *objectIDURI;
    
    if (keyStr==nil) {
         objectIDURI=self[@"SCLJSONNode".sclKeyToObjectID];
        
        if (objectIDURI==nil) {
            return nil;
        }
        
    } else {
        
        objectIDURI=self[keyStr.sclKeyToObjectID];
        
        if (objectIDURI==nil) {
            return nil;
        }
        
    }
    
    
    NSManagedObjectID *objectID=[moc.persistentStoreCoordinator managedObjectIDForURIRepresentation:objectIDURI];
    
    SCLJSONNode *graphNode=(SCLJSONNode *)[moc objectWithID:objectID];
    
    return graphNode;
}

@end
