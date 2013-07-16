//
//  JBPMRESTClient.m
//  JBPMMobile
//
//  Created by yavuz on 7/12/13.
//  Copyright (c) 2013 redhat. All rights reserved.
//

#import "JBPMRESTClient.h"

static NSString * const kJBPMRESTAPIBaseURLString = @"BASE_URL";

@implementation JBPMRESTClient

@synthesize username;

+ (JBPMRESTClient *)sharedClient {
    static JBPMRESTClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[JBPMRESTClient alloc] initWithBaseURL:[NSURL URLWithString:kJBPMRESTAPIBaseURLString]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    [self setDefaultHeader:@"Accept" value:@"application/xml"];
    
    return self;
}

@end
