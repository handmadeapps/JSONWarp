//
//  SCLJSONWarpModel.m
//
//  Created by Konstantinos Kontos on 8/13/15.
//  Copyright (c) 2015 Saturated Colors. All rights reserved.
//

#import "SCLJSONWarp.h"

@interface SCLJSONWarp ()

@property (weak,nonatomic) NSManagedObjectContext *moc;

@end


@implementation SCLJSONWarp


+(NSManagedObjectModel *)sclAugmentedModelUsingBaseModel:(NSManagedObjectModel *)originalModel {
    NSManagedObjectModel *model = [NSManagedObjectModel new];
    
    // JSON Node
    NSEntityDescription *jsonNodeEntity=[NSEntityDescription new];
    [jsonNodeEntity setName:@"SCLJSONNode"];
    [jsonNodeEntity setManagedObjectClassName:@"SCLJSONNode"];
    
    
    NSAttributeDescription *keyAttribute=[NSAttributeDescription new];
    [keyAttribute setName:@"key"];
    [keyAttribute setAttributeType:NSStringAttributeType];
    [keyAttribute setOptional:YES];
    
    NSAttributeDescription *valueAttribute=[NSAttributeDescription new];
    [valueAttribute setName:@"value"];
    [valueAttribute setAttributeType:NSTransformableAttributeType];
    [valueAttribute setOptional:YES];
    
    NSAttributeDescription *typeAttribute=[NSAttributeDescription new];
    [typeAttribute setName:@"nodeType"];
    [typeAttribute setAttributeType:NSInteger16AttributeType];
    [typeAttribute setOptional:NO];
    
    
    NSRelationshipDescription *parentRelationship=[NSRelationshipDescription new];
    [parentRelationship setName:@"parent"];
    [parentRelationship setOptional:YES];
    [parentRelationship setDeleteRule:NSNullifyDeleteRule];
    [parentRelationship setDestinationEntity:jsonNodeEntity];
    [parentRelationship setMinCount:1];
    [parentRelationship setMaxCount:1];
    
    
    NSRelationshipDescription *objectRelationship=[NSRelationshipDescription new];
    [objectRelationship setName:@"object"];
    [objectRelationship setOptional:YES];
    [objectRelationship setDeleteRule:NSCascadeDeleteRule];
    [objectRelationship setDestinationEntity:jsonNodeEntity];
    [objectRelationship setMinCount:1];
    [objectRelationship setMaxCount:NSUIntegerMax];
    [objectRelationship setInverseRelationship:parentRelationship];
    
    
    // Add properties to entity
    [jsonNodeEntity setProperties:@[keyAttribute,valueAttribute,typeAttribute,objectRelationship,parentRelationship]];
    
    // Add entities to model
    [model setEntities:@[jsonNodeEntity]];
    
    return [NSManagedObjectModel modelByMergingModels:@[originalModel,model]];
}

+(id)wrapJSON:(id)jsonObject {
    NSDictionary *wrappedDict=@{kSCLRootNodeID:jsonObject};
    
    return wrappedDict;
}


-(id)initWithManagedObjectContext:(NSManagedObjectContext *)context {
    
    if ((self = [super init])) {
        /* class-specific initialization goes here */
		
		//...
        self.moc=context;
        
        NSValueTransformer *nodeTransformer=[SCLJSONNodeTransfomer new];
        [NSValueTransformer setValueTransformer:nodeTransformer forName:@"SCLJSONNodeTransfomer"];
	}
	
    return self;
}


-(SCLJSONNode *)sclJSONNodeFromJSON:(id)jsonDict {
    jsonDict=[SCLJSONWarp wrapJSON:jsonDict];
    
    SCLJSONNode *coreDataGraphObject=[self serializedSCLJSONNodeFromJSONObject:jsonDict withParentObject:nil];
    
    return coreDataGraphObject;
}


-(SCLJSONNode *)sclJSONNodeFromJSONURL:(NSURL *)jsonURL {
    NSError *error;
    
    id jsonObject=[NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:jsonURL]
                                                  options:NSJSONReadingAllowFragments
                                                    error:&error
                   ];
    
    if (error!=nil) {
        return nil;
    }
    
    jsonObject=[SCLJSONWarp wrapJSON:jsonObject];
    
    SCLJSONNode *coreDataGraphObject=[self serializedSCLJSONNodeFromJSONObject:jsonObject withParentObject:nil];
    
    return coreDataGraphObject;
}



-(SCLJSONNode *)serializedSCLJSONNodeFromJSONObject:(id)jsonObject withParentObject:(SCLJSONNode *)parentObject {
    DebugLog(@"JSON Object Class: %@",NSStringFromClass([jsonObject class]));

    SCLJSONNode *coreDataJSONObject=nil;
    
    // Root object is a dictionary
    if ([jsonObject isKindOfClass:[NSDictionary class]])
    
    {
        NSDictionary *dict=(NSDictionary *)jsonObject;
        NSArray *keysArr=[dict allKeys];
        
        for (NSString *keyStr in keysArr) {
            
            coreDataJSONObject=[NSEntityDescription insertNewObjectForEntityForName:@"SCLJSONNode" inManagedObjectContext:self.moc];
            coreDataJSONObject.key=[keyStr copy];
            
            if (parentObject!=nil) {
                NSMutableSet *objectsSet=(NSMutableSet *)[parentObject mutableSetValueForKeyPath:@"object"];
                [objectsSet addObject:coreDataJSONObject];
            }
            
            id value=jsonObject[keyStr];
            
            if ([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSArray class]]) {
                
                if ([value isKindOfClass:[NSDictionary class]]) {
                    coreDataJSONObject.nodeType=[NSNumber numberWithInt:SCLNodeTypeDict];
                } else {
                    coreDataJSONObject.nodeType=[NSNumber numberWithInt:SCLNodeTypeArray];
                }
                
                NSMutableSet *objectsSet=(NSMutableSet *)[coreDataJSONObject mutableSetValueForKeyPath:@"object"];
                [objectsSet addObject:[self serializedSCLJSONNodeFromJSONObject:value withParentObject:coreDataJSONObject]];
            } else {
                coreDataJSONObject.nodeType=[NSNumber numberWithInt:SCLNodeTypeValue];
                coreDataJSONObject.value=value;
            }
            
        } // end for
        
        
        // Save Core Data Graph
        NSError *error;
        [self.moc save:&error];
        
        NSString *assertionError=[NSString stringWithFormat:@"error while serializing JSON into Core Data: moc save operation: %@",error.description];
        NSAssert(error==nil, assertionError);
        
        return coreDataJSONObject;
    }
    
    // Root object is an array
    else if ([jsonObject isKindOfClass:[NSArray class]])
    
    {
        NSArray *objectsArr=(NSArray *)jsonObject;
        
        for (id value in objectsArr) {
            
            coreDataJSONObject=[NSEntityDescription insertNewObjectForEntityForName:@"SCLJSONNode" inManagedObjectContext:self.moc];
            
            if (parentObject!=nil) {
                NSMutableSet *objectsSet=(NSMutableSet *)[parentObject mutableSetValueForKeyPath:@"object"];
                [objectsSet addObject:coreDataJSONObject];
            }
            
            
            if ([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSArray class]]) {
                
                if ([value isKindOfClass:[NSDictionary class]]) {
                    coreDataJSONObject.nodeType=[NSNumber numberWithInt:SCLNodeTypeDict];
                } else {
                    coreDataJSONObject.nodeType=[NSNumber numberWithInt:SCLNodeTypeArray];
                }
                
                NSMutableSet *objectsSet=(NSMutableSet *)[coreDataJSONObject mutableSetValueForKeyPath:@"object"];
                [objectsSet addObject:[self serializedSCLJSONNodeFromJSONObject:value withParentObject:coreDataJSONObject]];
            } 
        
        } // end for
        
        
        // Save Core Data Graph
        NSError *error;
        [self.moc save:&error];
        
        NSString *assertionError=[NSString stringWithFormat:@"error while serializing JSON into Core Data: moc save operation: %@",error.description];
        NSAssert(error==nil, assertionError);
        
        return coreDataJSONObject;
    }
    
    else return nil;
}


-(NSMutableDictionary *)sclJSONNodeValueForKey:(NSString *)keyStr usingRootJSONObject:(SCLJSONNode *)rootObject {
    NSValueTransformer *nodeTransformer=[NSValueTransformer valueTransformerForName:NSStringFromClass([SCLJSONNodeTransfomer class])];

    return [nodeTransformer transformedValue:rootObject];
}


@end
