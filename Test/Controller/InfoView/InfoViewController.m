//
//  InfoViewController.m
//  Test
//
//  Created by Purpose Code on 05/10/16.
//  Copyright © 2016 Purpose Code. All rights reserved.
//

#import "InfoViewController.h"
#import "PopUpView.h"

@interface InfoViewController () <PopUpViewDelegate>{
    
    PopUpView *vwPopUp;
}

@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - PopUp & Deleagtes

-(IBAction)logout:(id)sender{
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Confirm Logout"
                                  message:@"Logout from the app ?"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             [self clearUserSession];
                             AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
                             [app showLoginScreen];
                             
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

-(IBAction)showPopUpWithResume:(id)sender{
    
    if (!vwPopUp) {
        vwPopUp = [[[NSBundle mainBundle] loadNibNamed:@"PopUpView" owner:self options:nil] objectAtIndex:0];
        vwPopUp.delegate = self;
    }
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    UIView *vwPopUP = vwPopUp;
    [app.window.rootViewController.view addSubview:vwPopUP];
    vwPopUP.translatesAutoresizingMaskIntoConstraints = NO;
    [app.window.rootViewController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[vwPopUP]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(vwPopUP)]];
    [app.window.rootViewController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[vwPopUP]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(vwPopUP)]];
    vwPopUP.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        // animate it to the identity transform (100% scale)
        vwPopUP.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        [vwPopUp showPDFView];
        // if you want to do something once the animation finishes, put it here
    }];

}

-(void)closePopUpView{
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        // animate it to the identity transform (100% scale)
        vwPopUp.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished){
        // if you want to do something once the animation finishes, put it here
        [vwPopUp removeFromSuperview];
        vwPopUp = nil;
    }];
}

-(void)clearUserSession{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (defaults && [defaults objectForKey:@"USER"])
        [defaults removeObjectForKey:@"USER"];
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
