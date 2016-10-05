//
//  Utility.h
//  SignSpot
//
//  Created by Purpose Code on 24/05/16.
//  Copyright © 2016 Purpose Code. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Utility : NSObject

+ (void)setUpGoogleMapConfiguration;

+ (void)saveUserObject:(User *)object key:(NSString *)key;

+(void)showNoDataScreenOnView:(UIView*)view withTitle:(NSString*)title;

+(void)removeNoDataScreen:(UIView*)_view;

+(UITableViewCell *)getNoDataCustomCellWith:(UITableView*)table withTitle:(NSString*)title;

+(void)removeAViewControllerFromNavStackWithType:(Class)vc from:(NSArray*)array;

+(NSString*)getMediaSaveFolderPath;

+(void)saveSelectedImageFileToFolderWith:(UIImage*)image;

+(NSString *)getStrtingFromDate:(NSDate*)date;



@end
