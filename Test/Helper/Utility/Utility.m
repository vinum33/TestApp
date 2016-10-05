//
//  Utility.m
//  SignSpot
//
//  Created by Purpose Code on 24/05/16.
//  Copyright © 2016 Purpose Code. All rights reserved.
//

#define kTagForNodataScreen    1111

#import "Constants.h"
#import "Utility.h"
#import <AVFoundation/AVFoundation.h>

@import GoogleMaps;

@implementation Utility



+(void)setUpGoogleMapConfiguration{
    
    [GMSServices provideAPIKey:GoogleMapAPIKey];
}
+ (void)saveUserObject:(User *)object key:(NSString *)key {
    
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:key];
    [defaults synchronize];
    
}
+(void)showNoDataScreenOnView:(UIView*)view withTitle:(NSString*)title{
    
    UIView *noDataScreen =[UIView new];
    noDataScreen.tag = kTagForNodataScreen;
    noDataScreen.backgroundColor = [UIColor whiteColor];
    noDataScreen.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:noDataScreen];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-65-[noDataScreen]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(noDataScreen)]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[noDataScreen]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(noDataScreen)]];
    
    UILabel *lblTitle = [UILabel new];
    lblTitle.text = title;
    lblTitle.translatesAutoresizingMaskIntoConstraints = NO;
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.font = [UIFont fontWithName:CommonFont size:17];
    lblTitle.textColor = [UIColor lightGrayColor];
    [noDataScreen addSubview:lblTitle];
    [noDataScreen addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[lblTitle]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(lblTitle)]];
    [noDataScreen addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[lblTitle]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(lblTitle)]];
   
}

+(void)removeNoDataScreen:(UIView*)_view{
    
    if ([_view viewWithTag:kTagForNodataScreen]) {
        
        [[_view viewWithTag:kTagForNodataScreen] removeFromSuperview];
    }
}
+(UITableViewCell *)getNoDataCustomCellWith:(UITableView*)aTableView withTitle:(NSString*)title{
    
    static NSString *MyIdentifier = @"MyIdentifier";
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:MyIdentifier];
    cell.textLabel.text = title;
    cell.textLabel.font = [UIFont fontWithName:CommonFont size:17];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = [UIColor blackColor];
    cell.backgroundColor = [UIColor getBackgroundOffWhiteColor];
    return cell;
}

+(void)removeAViewControllerFromNavStackWithType:(Class)vc from:(NSArray*)array{
    
    for(UIViewController *tempVC in array)
    {
        if([tempVC isKindOfClass:vc])
        {
            [tempVC removeFromParentViewController];
        }
    }

    
}

+(NSString*)getMediaSaveFolderPath{
    
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Media"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
    return dataPath;
    
}


+(void)saveSelectedImageFileToFolderWith:(UIImage*)image{
    
    NSData *pngData = UIImageJPEGRepresentation(image, 0.1f);
    NSString *uniqueFileName = [[NSProcessInfo processInfo] globallyUniqueString] ;
    NSString *outputFile = [NSString stringWithFormat:@"%@/%@.jpeg",[Utility getMediaSaveFolderPath],uniqueFileName];
    [pngData writeToFile:outputFile atomically:YES];
}


+(UIImage*)getThumbNailFromVideoURL:(NSString*)videoURL{
    
    NSURL *url = [NSURL fileURLWithPath:videoURL];
    AVAsset *asset = [AVAsset assetWithURL:url];
    //  Get thumbnail at the very start of the video
    CMTime thumbnailTime = [asset duration];
    thumbnailTime.value = 0;
    //  Get image from the video at the given time
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    imageGenerator.appliesPreferredTrackTransform = true;
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:thumbnailTime actualTime:NULL error:NULL];
    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return thumbnail;
}

+(NSString*)getDaysBetweenTwoDatesWith:(double)timeInSeconds{
    
    NSDate * today = [NSDate date];
    NSDate * refDate = [NSDate dateWithTimeIntervalSince1970:timeInSeconds];
    NSDate *fromDate;
    NSDate *toDate;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                 interval:NULL forDate:refDate];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                 interval:NULL forDate:today];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute
                                               fromDate:fromDate toDate:toDate options:0];
    
    NSString *msgDate;
    NSInteger days = [difference day];
    if (days > 7) {
        NSDateFormatter *dateformater = [[NSDateFormatter alloc]init];
        [dateformater setDateFormat:@"d MMM,yyyy"];
        msgDate = [dateformater stringFromDate:refDate];
    }
    else if (days <= 0) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"h:mm a"];
        NSDate *date = refDate;
        msgDate = [dateFormatter stringFromDate:date];
    }else{
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EE h:mm a"];
        msgDate = [dateFormatter stringFromDate:refDate];
    }
    
    return msgDate;
    
}

+(NSString *)getStrtingFromDate:(NSDate*)date{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"d MMM,yyyy h:mm a"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
}





@end
