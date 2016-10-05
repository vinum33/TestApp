//
//  PopUpView.h
//  Test
//
//  Created by Purpose Code on 05/10/16.
//  Copyright © 2016 Purpose Code. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PopUpViewDelegate <NSObject>


/*!
 *This method is invoked when user close the audio player view.
 */

-(void)closePopUpView;

@end

@interface PopUpView : UIView

@property (nonatomic,weak)  id<PopUpViewDelegate>delegate;

-(void)showPDFView;

@end
