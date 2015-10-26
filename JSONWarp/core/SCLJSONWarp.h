//
//  SCLJSONWarpModel.h
//
//  Created by Konstantinos Kontos on 8/13/15.
//  Copyright (c) 2015 Saturated Colors. All rights reserved.
//

@import CoreData;
@import Foundation;

#import "SCLJSONNode.h"
#import "SCLJSONNodeTransfomer.h"

#import "NSString+SCLUtils.h"
#import "NSDictionary+SCLUtils.h"

#define kSCLRootNodeID  @"Root"

typedef NS_ENUM(NSUInteger, SCLNodeType) {
    SCLNodeTypeDict,
    SCLNodeTypeArray,
    SCLNodeTypeValue
};

@interface SCLJSONWarp : NSObject

+(NSManagedObjectModel *)sclAugmentedModelUsingBaseModel:(NSManagedObjectModel *)originalModel;

-(id)initWithManagedObjectContext:(NSManagedObjectContext *)context;

-(SCLJSONNode *)sclJSONNodeFromJSONURL:(NSURL *)jsonURL;
-(SCLJSONNode *)sclJSONNodeFromJSON:(id)jsonDict;

-(NSMutableDictionary *)sclJSONNodeValueForKey:(NSString *)keyStr usingRootJSONObject:(NSManagedObject *)rootObject;

@end
