//
//  ViewController.m
//  SignSpot
//
//  Created by Purpose Code on 09/05/16.
//  Copyright © 2016 Purpose Code. All rights reserved.
//

typedef enum{
    
    eUserName = 0,
    ePasword = 1,
    
}eLogInfo;

#define StatusSucess            200
#define kSectionCount           1
#define kCellHeight             75;
#define kHeightForFooter        125;

#import "LoginViewController.h"
#import "CustomCellForLogin.h"
#import "Constants.h"

@interface LoginViewController (){
    
    IBOutlet UITableView *tableView;
    
    UIView *inputAccView;
    NSInteger indexForTextFieldNavigation;
    NSString *password;
    NSString *userName;
    NSInteger totalRequiredFieldCount;
   
    
   
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
   
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
}
-(void)setUp{
    
    totalRequiredFieldCount = 2;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    tableView.allowsSelection = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}

#pragma mark - TableView Delegates


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kSectionCount;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return totalRequiredFieldCount;
}



- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"reuseIdentifier";
    CustomCellForLogin *cell = (CustomCellForLogin *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.txtField.keyboardType = UIKeyboardTypeDefault;
    cell.txtField.tag = indexPath.row;
    cell.backgroundColor = [UIColor whiteColor];
    cell = [self configureCellWithCaseValue:indexPath.row cell:cell];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return kCellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return  kHeightForFooter;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *vwFooter = [UIView new];
    vwFooter.backgroundColor = [UIColor whiteColor];
    
    UIButton* btnLogin = [UIButton new];
    btnLogin.backgroundColor = [UIColor getThemeColor];
    btnLogin.translatesAutoresizingMaskIntoConstraints = NO;
    [btnLogin setTitle:@"LOGIN" forState:UIControlStateNormal];
    [btnLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnLogin.titleLabel.font = [UIFont fontWithName:CommonFont size:14];
    [btnLogin addTarget:self action:@selector(tapToLogin:) forControlEvents:UIControlEventTouchUpInside];
    [vwFooter addSubview:btnLogin];
    
    [btnLogin addConstraint:[NSLayoutConstraint constraintWithItem:btnLogin
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeHeight
                                                       multiplier:1.0
                                                         constant:45]];
    [vwFooter addConstraint:[NSLayoutConstraint constraintWithItem:btnLogin
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:vwFooter
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.0
                                                          constant:25]];
    
     NSArray *horizontalConstraints =[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[btnLogin]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(btnLogin)];
    [vwFooter addConstraints:horizontalConstraints];
    
    
    return vwFooter;
}


#pragma mark - UITextfield delegate methods


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if ([textField.superview.superview isKindOfClass:[UITableViewCell class]])
    {
        CGPoint buttonPosition = [textField convertPoint:CGPointZero toView: tableView];
        NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:buttonPosition];
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:TRUE];
    }
    
}


-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    if ([textField.superview.superview isKindOfClass:[UITableViewCell class]])
    {
        CGPoint buttonPosition = [textField convertPoint:CGPointZero toView: tableView];
        NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:buttonPosition];
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:TRUE];
        [self getTextFromField:textField];
    }
    
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    [self createInputAccessoryView];
    [textField setInputAccessoryView:inputAccView];
    NSIndexPath *indexPath;
    if ([textField.superview.superview isKindOfClass:[UITableViewCell class]])
    {
        CGPoint buttonPosition = [textField convertPoint:CGPointZero toView: tableView];
        indexPath = [tableView indexPathForRowAtPoint:buttonPosition];
        indexForTextFieldNavigation = indexPath.row;
    }
    CGPoint pointInTable = [textField.superview convertPoint:textField.frame.origin toView:tableView];
    CGPoint contentOffset = tableView.contentOffset;
    contentOffset.y = (pointInTable.y - textField.inputAccessoryView.frame.size.height );
    [tableView setContentOffset:contentOffset animated:YES];
    
    return YES;
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    CGPoint pointInTable = [textField.superview convertPoint:textField.frame.origin toView:tableView];
    CGPoint contentOffset = tableView.contentOffset;
    contentOffset.y = (pointInTable.y - textField.inputAccessoryView.frame.size.height);
    [tableView setContentOffset:contentOffset animated:YES];
    
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField{
    
    [textField resignFirstResponder];
    return YES;
}

-(CustomCellForLogin*)configureCellWithCaseValue:(NSInteger)position cell:(CustomCellForLogin*)cell{
    cell.txtField.secureTextEntry = YES;
    cell.txtField.placeholder = @"Password";
    cell.imgIcon.image = [UIImage imageNamed:@"PasswordIcon.png"];
    if(position == eUserName){
        cell.txtField.secureTextEntry = NO;
        cell.imgIcon.image = [UIImage imageNamed:@"UserIcon.png"];
        cell.txtField.placeholder = @"Email";
    }
    return cell;
    
}

#pragma mark - Login Actions

-(IBAction)tapToLogin:(id)sender{
    
    [self checkAllFieldsAreValidOnSuccess:^{
        
        [self createUserWithInfo:userName];
        
        
    }failure:^(NSString *errorMsg) {
        
        [self showAlertWithMessage:errorMsg title:@"Login"];
        
    }];
    
}

-(void)checkAllFieldsAreValidOnSuccess:(void (^)())success failure:(void (^)(NSString *errorMsg))failure{
    
    BOOL isValid = false;
    NSString *errorMsg;
    if ((userName.length) && (password.length) > 0) {
        isValid = true;
        if (![userName isValidEmail]) {
            
            errorMsg = @"Enter a valid Email address.";
            isValid = false;
        }
    }else{
        
          errorMsg = @"Enter a Email and Password.";
    }
    if (isValid)success();
    else failure(errorMsg);
    
}

-(void)showAlertWithMessage:(NSString*)alertMessage title:(NSString*)alertTitle{
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:alertTitle
                                          message:alertMessage
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                               }];
    
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}



#pragma mark - Generic Actions

-(void)createUserWithInfo:(NSString*)email{
    
    if (email) {
        
        [User sharedManager].email  = email;
        /*............ Saving user to NSUserDefaults.............!*/
        
        [Utility saveUserObject:[User sharedManager] key:@"USER"];
        if ([self.delegate respondsToSelector:@selector(loadHomePage)]) {
            [self.delegate loadHomePage];
        }
    }
    
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


-(void)createInputAccessoryView{
    
    inputAccView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 40.0)];
    [inputAccView setBackgroundColor:[UIColor lightGrayColor]];
    [inputAccView setAlpha: 1];
    
    UIButton *btnPrev = [UIButton buttonWithType: UIButtonTypeCustom];
    [btnPrev setFrame: CGRectMake(0.0, 1.0, 80.0, 38.0)];
    [btnPrev setTitle: @"Previous" forState: UIControlStateNormal];
    [btnPrev setBackgroundColor: [UIColor blueColor]];
    btnPrev.titleLabel.font = [UIFont fontWithName:CommonFont size:14];
    btnPrev.layer.cornerRadius = 5.f;
    btnPrev.layer.borderWidth = 1.f;
    btnPrev.layer.borderColor = [UIColor clearColor].CGColor;
    [btnPrev addTarget: self action: @selector(gotoPrevTextfield) forControlEvents: UIControlEventTouchUpInside];
    
    UIButton *btnNext = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnNext setFrame:CGRectMake(85.0f, 1.0f, 80.0f, 38.0f)];
    [btnNext setTitle:@"Next" forState:UIControlStateNormal];
    [btnNext setBackgroundColor:[UIColor blueColor]];
    btnNext.layer.cornerRadius = 5.f;
    btnNext.layer.borderWidth = 1.f;
    btnNext.layer.borderColor = [UIColor clearColor].CGColor;
    btnNext.titleLabel.font = [UIFont fontWithName:CommonFont size:14];
    [btnNext addTarget:self action:@selector(gotoNextTextfield) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnDone setFrame:CGRectMake(inputAccView.frame.size.width - 85, 1.0f, 85.0f, 38.0f)];
    [btnDone setTitle:@"Done" forState:UIControlStateNormal];
    [btnDone setBackgroundColor:[UIColor getThemeColor]];
    [btnDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnDone.layer.cornerRadius = 5.f;
    btnDone.layer.borderWidth = 1.f;
    btnDone.layer.borderColor = [UIColor clearColor].CGColor;
    btnDone.titleLabel.font = [UIFont fontWithName:CommonFont size:14];
    [btnDone addTarget:self action:@selector(doneTyping) forControlEvents:UIControlEventTouchUpInside];
    
    [inputAccView addSubview:btnPrev];
    [inputAccView addSubview:btnNext];
    [inputAccView addSubview:btnDone];
}

-(void)gotoPrevTextfield{
    
    if (indexForTextFieldNavigation - 1 < 0) indexForTextFieldNavigation = 0;
    else indexForTextFieldNavigation -= 1;
    
    [self gotoTextField];
    
}

-(void)gotoNextTextfield{
    
    if (indexForTextFieldNavigation + 1 < totalRequiredFieldCount) indexForTextFieldNavigation += 1;
    [self gotoTextField];
}

-(void)gotoTextField{
    
    CustomCellForLogin *nextCell = (CustomCellForLogin *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexForTextFieldNavigation inSection:0]];
    if (!nextCell) {
        [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexForTextFieldNavigation inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        nextCell = (CustomCellForLogin *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexForTextFieldNavigation inSection:0]];
        
    }
    [nextCell.txtField becomeFirstResponder];
    
}

-(void)doneTyping{
    [self.view endEditing:YES];
    
}

-(void)getTextFromField:(UITextField*)textField{
    
    NSString *string = textField.text;
    NSInteger tag = textField.tag;
    switch (tag) {
        case eUserName:
            userName = string;
            break;
        case ePasword:
            password = string;
            break;
            
        default:
            break;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}




@end
