//
//  TaskPair.h
//  JBPMMobile
//
//  Created by yavuz on 7/15/13.
//  Copyright (c) 2013 redhat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Task : NSObject

@property NSInteger id;
@property NSString *name;
@property NSString *status;
@property NSString *priority;
@property NSString *skipable;
@property NSString *actualOwner;
@property NSString *expirationTime;
@property NSString *processInstanceID;
@property NSString *processSessionID;
@property NSString *subTaskStrategy;
@property NSString *parentID;

@end
