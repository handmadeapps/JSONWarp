//
//  SCLJSONNodeTransfomer.m
//
//  Created by Konstantinos Kontos on 8/19/15.
//  Copyright (c) 2015 Saturated Colors. All rights reserved.
//

#import "SCLJSONNodeTransfomer.h"
#import "SCLJSONWarp.h"

@implementation SCLJSONNodeTransfomer

+ (Class)transformedValueClass {
    return [NSMutableDictionary class];
}


+ (BOOL)allowsReverseTransformation {
    return NO;
}


- (id)transformedValue:(id)value {
    SCLJSONNode *rootNode=(SCLJSONNode *)value;
    
    NSMutableDictionary *transformedValueDict=[NSMutableDictionary dictionaryWithCapacity:rootNode.object.count];
    
    for (SCLJSONNode *keyValueNode in rootNode.object) {
        
        if (keyValueNode.nodeType.integerValue==SCLNodeTypeValue) {
            transformedValueDict[keyValueNode.key]=keyValueNode.value;
            
            transformedValueDict[keyValueNode.key.sclKeyToObjectID]=keyValueNode.objectID.URIRepresentation;
        } else if (keyValueNode.nodeType.integerValue==SCLNodeTypeDict) {
            SCLJSONDictTransfomer *dictTransformer=[SCLJSONDictTransfomer new];
            
            transformedValueDict[keyValueNode.key]=[dictTransformer transformedValue:keyValueNode.object];
            
            transformedValueDict[keyValueNode.key.sclKeyToObjectID]=keyValueNode.objectID.URIRepresentation;
        } else if (keyValueNode.nodeType.integerValue==SCLNodeTypeArray) {
            SCLJSONArrayTransfomer *arrTransformer=[SCLJSONArrayTransfomer new];
            
            transformedValueDict[keyValueNode.key]=[arrTransformer transformedValue:keyValueNode.object];
            
            transformedValueDict[keyValueNode.key.sclKeyToObjectID]=keyValueNode.objectID.URIRepresentation;
        } 
        
    } // end for
    
    return transformedValueDict;
}


@end
