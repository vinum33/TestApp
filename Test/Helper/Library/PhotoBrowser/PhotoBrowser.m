//
//  PhotoBrowser.m
//  PurposeColor
//
//  Created by Purpose Code on 08/09/16.
//  Copyright © 2016 Purpose Code. All rights reserved.
//

#import "PhotoBrowser.h"
#import "PhotoBrowserCell.h"

@interface PhotoBrowser(){
    
    IBOutlet UICollectionView *collectionView;
    IBOutlet UILabel *lblTitle;
    NSArray *arrDataSource;
    NSInteger selectedIndex;
}

@end

@implementation PhotoBrowser

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setUpWithImages:(NSArray*)images withSelectedIndex:(NSInteger)_selectedIndex{
    
    selectedIndex = _selectedIndex;
    arrDataSource = images;
    [collectionView registerNib:[UINib nibWithNibName:@"PhotoBrowserCell" bundle:nil] forCellWithReuseIdentifier:@"PhotoBrowserCell"];
    collectionView.backgroundColor = [UIColor clearColor];
    [collectionView reloadData];
    [collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    lblTitle.text = [NSString stringWithFormat:@"%d/%lu",_selectedIndex + 1,(unsigned long)arrDataSource.count];

    
}



#pragma mark - UICollectionViewDataSource Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
     return  1;
}

-(NSInteger)collectionView:(UICollectionView *)_collectionView numberOfItemsInSection:(NSInteger)section
{
    lblTitle.text = [NSString stringWithFormat:@"%d/%lu",1,(unsigned long)arrDataSource.count];
    return  arrDataSource.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)_collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoBrowserCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoBrowserCell" forIndexPath:indexPath];
    if (indexPath.row < arrDataSource.count) {
        [cell.indicator stopAnimating];
        [cell resetCell];
        NSDictionary *imageInfo = arrDataSource[indexPath.row];
        NSString *fileName = [imageInfo objectForKey:@"path"];
        NSString *filePath = [Utility getMediaSaveFolderPath];
        NSString *imagePath = [[filePath stringByAppendingString:@"/"] stringByAppendingString:fileName];
        if (imagePath.length) {
            [cell.indicator startAnimating];
            cell.image = [UIImage imageNamed:@"NoImage.png"];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
                NSData *data = [[NSFileManager defaultManager] contentsAtPath:imagePath];
                UIImage *image = [UIImage imageWithData:data];
                dispatch_sync(dispatch_get_main_queue(), ^(void) {
                    cell.image = image;
                    [cell setup];
                    [cell.indicator stopAnimating];
                });
            });
                
        }
    }
    
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)_collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    float width = _collectionView.bounds.size.width;
    float height = _collectionView.bounds.size.height;
    
    return CGSizeMake(width, height);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([collectionView visibleCells].count) {
        for (UICollectionViewCell *cell in [collectionView visibleCells]) {
            NSIndexPath *indexPath = [collectionView indexPathForCell:cell];
             lblTitle.text = [NSString stringWithFormat:@"%ld/%lu",(long)indexPath.row + 1,(unsigned long)arrDataSource.count];
        }
    }
   
}

-(IBAction)closePopUp:(id)sender{
    
    if ([self.delegate respondsToSelector:@selector(closePhotoBrowserView)]) {
        [self.delegate closePhotoBrowserView];
    }
    
}

-(void)dealloc{
    
}

@end
