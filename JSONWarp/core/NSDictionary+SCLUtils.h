//
//  NSDictionary+SCLUtils.h
//  JSONWarpExample
//
//  Created by Konstantinos Kontos on 8/21/15.
//  Copyright (c) 2015 Saturated Colors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCLJSONWarp.h"

@interface NSDictionary (SCLUtils)

-(SCLJSONNode *)sclNodeForKey:(NSString *)keyStr withManagedObjectContext:(NSManagedObjectContext *)moc;

@end
