//
//  SCLJSONArrayTransfomer.m
//  JSONWarpExample
//
//  Created by Konstantinos Kontos on 8/20/15.
//  Copyright (c) 2015 Saturated Colors. All rights reserved.
//

#import "SCLJSONArrayTransfomer.h"
#import "SCLJSONWarp.h"

@implementation SCLJSONArrayTransfomer

+ (Class)transformedValueClass {
    return [NSMutableArray class];
}


+ (BOOL)allowsReverseTransformation {
    return NO;
}


- (id)transformedValue:(id)value {
    NSSet *nodeSet=(NSSet *)value;
    
    NSMutableArray *nodeArr=[NSMutableArray arrayWithCapacity:nodeSet.count];
    
    for (SCLJSONNode *node in nodeSet) {
        
        if (node.nodeType.integerValue==SCLNodeTypeDict) {
            SCLJSONDictTransfomer *dictTransformer=[SCLJSONDictTransfomer new];
            
            NSMutableDictionary *nodeDict=[dictTransformer transformedValue:node.object];
            nodeDict[@"SCLJSONNode".sclKeyToObjectID]=node.objectID.URIRepresentation;
            
            [nodeArr addObject:nodeDict];
        } else if (node.nodeType.integerValue==SCLNodeTypeArray) {
            SCLJSONArrayTransfomer *arrTransformer=[SCLJSONArrayTransfomer new];
            
            [nodeArr addObject:[arrTransformer transformedValue:node.object]];
        } else return nil;
        
    }
    
    return nodeArr;
}


@end
