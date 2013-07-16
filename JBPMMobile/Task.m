//
//  TaskPair.m
//  JBPMMobile
//
//  Created by yavuz on 7/15/13.
//  Copyright (c) 2013 redhat. All rights reserved.
//

#import "Task.h"

@implementation Task

@synthesize id = _id;
@synthesize name = _name;
@synthesize status = _status;
@synthesize priority = _priority;
@synthesize skipable = _skipable;
@synthesize actualOwner = _actualOwner;
@synthesize expirationTime = _expirationTime;
@synthesize processInstanceID = _processInstanceID;
@synthesize processSessionID = _processSessionID;
@synthesize subTaskStrategy = _subTaskStrategy;
@synthesize parentID = _parentID;

@end
