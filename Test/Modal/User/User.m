//
//  User.m
//  SignSpot
//
//  Created by Purpose Code on 10/05/16.
//  Copyright © 2016 Purpose Code. All rights reserved.
//

#import "User.h"

@implementation User

+(User*)sharedManager {
    
    static User *currentUser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        currentUser = [[self alloc] init];
    });
    return currentUser;
    
}


- (User*)init {
    if ( (self = [super init]) ) {
        // your custom initialization
        
        self.isLoggedIn = false;
        self.email = [NSString new];
         }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeBool:self.isLoggedIn forKey:@"LoggedIn"];
    [encoder encodeObject:self.email forKey:@"Email"];
    
    
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.isLoggedIn = [decoder decodeBoolForKey:@"LoggedIn"];
        self.email = [decoder decodeObjectForKey:@"Email"];
    }
    return self;
}

@end
