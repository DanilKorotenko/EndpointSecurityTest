//
//  AppDelegate.h
//  EndpointSecurityTestApp
//
//  Created by Danil Korotenko on 5/25/20.
//  Copyright © 2020 Timm Kandziora. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#include <EndpointSecurity/EndpointSecurity.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    es_client_t *_client;

}

@end

