//
//  SCLJSONNode.m
//
//  Created by Konstantinos Kontos on 8/19/15.
//  Copyright (c) 2015 Saturated Colors. All rights reserved.
//

#import "SCLJSONNode.h"
#import "SCLJSONNode.h"


@implementation SCLJSONNode

@dynamic key;
@dynamic value;
@dynamic nodeType;
@dynamic object;
@dynamic parent;


- (SCLJSONNode *)sclNodeForNodeKey:(NSString *)keyStr {
    for (SCLJSONNode *node in self.object) {
        
        if ([node.key isEqualToString:keyStr]) {
            return node;
        }
        
    }
    
    return nil;
}


- (id)sclValueForNodeKey:(NSString *)keyStr {
    
    for (SCLJSONNode *node in self.object) {
        
        if ([node.key isEqualToString:keyStr]) {
            return node.value;
        }
        
    }
    
    return nil;
}


@end
