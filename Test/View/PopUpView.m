//
//  PopUpView.m
//  Test
//
//  Created by Purpose Code on 05/10/16.
//  Copyright © 2016 Purpose Code. All rights reserved.
//

#import "PopUpView.h"

@interface PopUpView(){
    
    IBOutlet UIWebView *webView;
}

@end
@implementation PopUpView

-(void)showPDFView{
    
    NSURL *targetURL = [[NSBundle mainBundle] URLForResource:@"VINAYAN" withExtension:@"pdf"];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [webView loadRequest:request];
  }

-(IBAction)closePopUp:(id)sender{
    
    if ([self.delegate respondsToSelector:@selector(closePopUpView)]) {
        [self.delegate closePopUpView];
    }
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
