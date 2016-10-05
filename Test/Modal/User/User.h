//
//  User.h
//  SignSpot
//
//  Created by Purpose Code on 10/05/16.
//  Copyright © 2016 Purpose Code. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic,assign) BOOL       isLoggedIn;
@property (nonatomic,strong) NSString * email;



+ (User*)sharedManager;

@end
