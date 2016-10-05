//
//  AppDelegate.m
//  Test
//
//  Created by Purpose Code on 04/10/16.
//  Copyright © 2016 Purpose Code. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "Constants.h"
#import "MapDisplayViewController.h"
#import "CameraViewController.h"
#import "GalleryViewController.h"
#import "InfoViewController.h"


@interface AppDelegate () <LoginDelegate>{
    
    UITabBarController *tabBarController;
}



@end

@import GoogleMaps;

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
      [Utility setUpGoogleMapConfiguration];
      [self checkUserStatus];
    return YES;
}

-(void)checkUserStatus{
    
    BOOL userExists = [self loadUserObjectWithKey:@"USER"];
    if (userExists) [self loadHomePage];
    else            [self showLoginScreen];
    
}
/*!.........Check Availability of User !...........*/

- (BOOL )loadUserObjectWithKey:(NSString *)key {
    BOOL isUserExists = false;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:key];
    if (encodedObject) {
        User *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
        if (object)isUserExists = true;
        [self createUserObject:object];
        
    }
    return isUserExists;
}

-(void)createUserObject:(User*)user{
    
    // Creating singleton user object with Decoded data from NSUserDefaults
    
    [User sharedManager].email = user.email;
    
}

-(void)showLoginScreen{
    
    // Show login page for a  user.
    
    LoginViewController *loginPage =  [UIStoryboard get_ViewControllerFromStoryboardWithStoryBoardName:MainStoryBoard Identifier:StoryBoardIdentifierForLoginPage];
    loginPage.delegate = self;
    UINavigationController *logginVC = [[UINavigationController alloc] initWithRootViewController:loginPage];
    logginVC.navigationBarHidden = true;
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.rootViewController = logginVC;
    [self.window makeKeyAndVisible];
    
    
}

// Success call back from login after successful attempt

-(void)loadHomePage{
    
    UINavigationController *navForMap = [[UINavigationController alloc] init];
    MapDisplayViewController *mapView =  [UIStoryboard get_ViewControllerFromStoryboardWithStoryBoardName:MainStoryBoard Identifier:StoryBoardIdentifierMap];
    navForMap.viewControllers = [NSArray arrayWithObjects:mapView, nil];
    navForMap.navigationBarHidden = true;
    
    UINavigationController *navForCamera = [[UINavigationController alloc] init];
    CameraViewController *cameraView =  [UIStoryboard get_ViewControllerFromStoryboardWithStoryBoardName:MainStoryBoard Identifier:StoryBoardIdentifierCamera];
    navForCamera.viewControllers = [NSArray arrayWithObjects:cameraView, nil];
    navForCamera.navigationBarHidden = true;
    
    UINavigationController *navForGallery = [[UINavigationController alloc] init];
    GalleryViewController *galleryView =  [UIStoryboard get_ViewControllerFromStoryboardWithStoryBoardName:MainStoryBoard Identifier:StoryBoardIdentifierGallery];
    navForGallery.viewControllers = [NSArray arrayWithObjects:galleryView, nil];
    navForGallery.navigationBarHidden = true;
    
    UINavigationController *navForInfo = [[UINavigationController alloc] init];
    InfoViewController *infoView =  [UIStoryboard get_ViewControllerFromStoryboardWithStoryBoardName:MainStoryBoard Identifier:StoryBoardIdentifierInfoPage];
    navForInfo.viewControllers = [NSArray arrayWithObjects:infoView, nil];
    navForInfo.navigationBarHidden = true;
    
    tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = [NSArray arrayWithObjects:navForMap,navForCamera,navForGallery,navForInfo,nil];
    [[tabBarController.tabBar.items objectAtIndex:0] setTitle:@"HOME"];
    [[tabBarController.tabBar.items objectAtIndex:1] setTitle:@"CAMERA"];
    [[tabBarController.tabBar.items objectAtIndex:2] setTitle:@"GALLERY"];
    [[tabBarController.tabBar.items objectAtIndex:3] setTitle:@"INFO"];
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];

}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.sample.Test" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Test" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Test.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
