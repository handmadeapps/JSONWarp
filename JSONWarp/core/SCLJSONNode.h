//
//  SCLJSONNode.h
//
//  Created by Konstantinos Kontos on 8/19/15.
//  Copyright (c) 2015 Saturated Colors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SCLJSONNode;

@interface SCLJSONNode : NSManagedObject

@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) id value;
@property (nonatomic, retain) NSNumber * nodeType;
@property (nonatomic, retain) NSSet *object;
@property (nonatomic, retain) SCLJSONNode *parent;

- (id)sclValueForNodeKey:(NSString *)keyStr;
- (SCLJSONNode *)sclNodeForNodeKey:(NSString *)keyStr;

@end

@interface SCLJSONNode (CoreDataGeneratedAccessors)

- (void)addObjectObject:(SCLJSONNode *)value;
- (void)removeObjectObject:(SCLJSONNode *)value;
- (void)addObject:(NSSet *)values;
- (void)removeObject:(NSSet *)values;

@end
