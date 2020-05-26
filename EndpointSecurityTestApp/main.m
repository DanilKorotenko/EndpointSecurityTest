//
//  main.m
//  EndpointSecurityTestApp
//
//  Created by Danil Korotenko on 5/26/20.
//  Copyright © 2020 com.GTB. All rights reserved.
//

#import <Cocoa/Cocoa.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool
    {
        SecCodeRef me;
        OSStatus err = SecCodeCopySelf(kSecCSDefaultFlags, &me);
        assert(err == errSecSuccess);
        CFDictionaryRef infoCF;
        err = SecCodeCopySigningInformation(me, kSecCSDefaultFlags, &infoCF);
        assert(err == errSecSuccess);
        NSDictionary * info = CFBridgingRelease(infoCF);
        NSDictionary * entitlements = info[(__bridge NSString *) kSecCodeInfoEntitlementsDict];
        NSLog(@"entitlements: %@", entitlements);
    }
    return 0;
}
