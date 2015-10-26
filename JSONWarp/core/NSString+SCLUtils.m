//
//  NSString+SCLUtils.m
//  JSONWarpExample
//
//  Created by Konstantinos Kontos on 8/21/15.
//  Copyright (c) 2015 Saturated Colors. All rights reserved.
//

#import "NSString+SCLUtils.h"

@implementation NSString (SCLUtils)

-(NSString *)sclKeyToObjectID {
    return [self stringByAppendingString:@"-SCLObjectID"];
}

@end
