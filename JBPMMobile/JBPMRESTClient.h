//
//  JBPMRESTClient.h
//  JBPMMobile
//
//  Created by yavuz on 7/12/13.
//  Copyright (c) 2013 redhat. All rights reserved.
//

#import "AFHTTPClient.h"

@interface JBPMRESTClient : AFHTTPClient

+ (JBPMRESTClient *)sharedClient;

@property NSString *username; // my client (when authenticated) has a username, but not sure if this should be here (or one level up)

@end
