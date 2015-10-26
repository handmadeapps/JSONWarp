//
//  SCLJSONDictTransfomer.m
//  JSONWarpExample
//
//  Created by Konstantinos Kontos on 8/20/15.
//  Copyright (c) 2015 Saturated Colors. All rights reserved.
//

#import "SCLJSONDictTransfomer.h"
#import "SCLJSONWarp.h"

@implementation SCLJSONDictTransfomer

+ (Class)transformedValueClass {
    return [NSMutableDictionary class];
}


+ (BOOL)allowsReverseTransformation {
    return NO;
}


- (id)transformedValue:(id)value {
    NSSet *nodeSet=(NSSet *)value;
    
    NSMutableDictionary *nodeDict=[NSMutableDictionary dictionaryWithCapacity:nodeSet.count];
    
    for (SCLJSONNode *node in nodeSet) {
        
        if (node.nodeType.integerValue==SCLNodeTypeValue) {
            nodeDict[node.key]=node.value;
            
            nodeDict[node.key.sclKeyToObjectID]=node.objectID.URIRepresentation;
        } else if (node.nodeType.integerValue==SCLNodeTypeDict) {
            SCLJSONDictTransfomer *dictTransformer=[SCLJSONDictTransfomer new];
            
            nodeDict[node.key]=[dictTransformer transformedValue:node.object];
            
            nodeDict[node.key.sclKeyToObjectID]=node.objectID.URIRepresentation;
        } else if (node.nodeType.integerValue==SCLNodeTypeArray) {
            SCLJSONArrayTransfomer *arrTransformer=[SCLJSONArrayTransfomer new];
            
            nodeDict[node.key]=[arrTransformer transformedValue:node.object];
            
            nodeDict[node.key.sclKeyToObjectID]=node.objectID.URIRepresentation;
        } else return nil;
        
    }
    
    return nodeDict;
}


@end
