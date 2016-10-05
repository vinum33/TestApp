//
//  GalleryViewController.m
//  Test
//
//  Created by Purpose Code on 05/10/16.
//  Copyright © 2016 Purpose Code. All rights reserved.
//

#define kTagForImage                1
#define kTagForTitle                2
#define kCellHeight                 70
#define kCellHeightForStatus        130
#define kHeightForHeader            300
#define kEmptyHeaderAndFooter       001
#define kSuccessCode                200

#import "GalleryViewController.h"
#import "PhotoBrowser.h"

@interface GalleryViewController () <PhotoBrowserDelegate>{
    
     NSMutableArray *arrImages;
     PhotoBrowser *photoBrowser;
     IBOutlet UITableView *tableView;
}

@end

@implementation GalleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    
    [self showLoadingScreen];
    [self setUp];
    [self loadAllGalleryImages];
}

-(void)setUp{
    
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.automaticallyAdjustsScrollViewInsets=NO;
}

-(void)loadAllGalleryImages{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
        NSString *dataPath = [Utility getMediaSaveFolderPath];
        NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dataPath error:NULL];
        NSError* error = nil;
        // sort by creation date
        arrImages = [NSMutableArray arrayWithCapacity:[directoryContent count]];
        for(NSString* file in directoryContent) {
            if (![file isEqualToString:@".DS_Store"]) {
                NSString* filePath = [dataPath stringByAppendingPathComponent:file];
                NSDictionary* properties = [[NSFileManager defaultManager]
                                            attributesOfItemAtPath:filePath
                                            error:&error];
                NSDate* modDate = [properties objectForKey:NSFileCreationDate];
                
                [arrImages addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                      file, @"path",
                                      modDate, @"lastModDate",
                                      nil]];
                
            }
        }
        dispatch_sync(dispatch_get_main_queue(), ^(void) {
            [tableView reloadData];
            [self hideLoadingScreen];

        });
    });
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return arrImages.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    cell = (UITableViewCell *)[aTableView dequeueReusableCellWithIdentifier:@"TableCell"];
    [self configureCellWithCell:cell indexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger tag = indexPath.row;
    if (tag < arrImages.count) {
        [self presentGalleryWithImages:arrImages andIndex:indexPath.row];
    }
}

-(void)configureCellWithCell:(UITableViewCell*)cell indexPath:(NSIndexPath*)indexPath{
    
    if (indexPath.row < arrImages.count) {
        NSDictionary *imageInfo = arrImages[[indexPath row]];
        if ([[cell contentView]viewWithTag:kTagForImage] && [[[cell contentView]viewWithTag:kTagForImage] isKindOfClass:[UIImageView class]]){
            UIImageView *imageView = (UIImageView*)[[cell contentView]viewWithTag:kTagForImage];
            imageView.layer.cornerRadius = 25;
            NSString *filePath = [Utility getMediaSaveFolderPath];
            NSString *imagePath = [[filePath stringByAppendingString:@"/"] stringByAppendingString:[imageInfo objectForKey:@"path"]];
            if (imagePath.length) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
                    NSData *data = [[NSFileManager defaultManager] contentsAtPath:imagePath];
                    UIImage *image = [UIImage imageWithData:data];
                    dispatch_sync(dispatch_get_main_queue(), ^(void) {
                        imageView.image = image;
                    });
                });
            }
        }
        if ([[cell contentView]viewWithTag:kTagForTitle] && [[[cell contentView]viewWithTag:kTagForTitle] isKindOfClass:[UILabel class]]){
            UILabel *lblName = (UILabel*)[[cell contentView]viewWithTag:kTagForTitle];
            lblName.text = [Utility getStrtingFromDate:[imageInfo objectForKey:@"lastModDate"]];
            
        }
        
    }
    
}
#pragma mark - Photo Browser & Deleagtes

- (void)presentGalleryWithImages:(NSArray*)images andIndex:(NSInteger)index
{
    if (!photoBrowser) {
        photoBrowser = [[[NSBundle mainBundle] loadNibNamed:@"PhotoBrowser" owner:self options:nil] objectAtIndex:0];
        photoBrowser.delegate = self;
    }
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    UIView *vwPopUP = photoBrowser;
    [app.window.rootViewController.view addSubview:vwPopUP];
    vwPopUP.translatesAutoresizingMaskIntoConstraints = NO;
    [app.window.rootViewController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[vwPopUP]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(vwPopUP)]];
    [app.window.rootViewController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[vwPopUP]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(vwPopUP)]];
    vwPopUP.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        // animate it to the identity transform (100% scale)
        vwPopUP.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        // if you want to do something once the animation finishes, put it here
        [photoBrowser setUpWithImages:images withSelectedIndex:index];
    }];
    
}

-(void)closePhotoBrowserView{
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        // animate it to the identity transform (100% scale)
        photoBrowser.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished){
        // if you want to do something once the animation finishes, put it here
        [photoBrowser removeFromSuperview];
        photoBrowser = nil;
    }];
}



-(void)showLoadingScreen{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES;
    hud.detailsLabelText = @"Loading...";
    hud.removeFromSuperViewOnHide = YES;
    
}
-(void)hideLoadingScreen{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
