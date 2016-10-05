//
//  Utility.h
//  SignSpot
//
//  Created by Purpose Code on 09/05/16.
//  Copyright © 2016 Purpose Code. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })

extern NSString * const MainStoryBoard;

extern NSString * const NETWORK_ERROR_MESSAGE;

extern NSString * const CommonFont;
extern NSString * const CommonFontBold;


extern NSString * const GoogleMapAPIKey;

extern NSString * const StoryBoardIdentifierForLoginPage;
extern NSString * const StoryBoardIdentifierMap ;
extern NSString * const StoryBoardIdentifierCamera ;
extern NSString * const StoryBoardIdentifierGallery ;
extern NSString * const StoryBoardIdentifierInfoPage ;

extern NSString * const StaticImageURL;
