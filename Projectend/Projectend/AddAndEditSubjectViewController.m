//
//  AddAndEditSubjectViewController.m
//  Projectend
//
//  Created by Ominext Mobile on 5/19/16.
//  Copyright © 2016 Ominext Mobile. All rights reserved.
//

#import "AddAndEditSubjectViewController.h"
#import "SWRevealViewController.h"

@interface AddAndEditSubjectViewController (){
    UIBarButtonItem *btsave;
    UIBarButtonItem *btedit;
    NSArray *arrSubjectExit;
}

@end

@implementation AddAndEditSubjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Add/Edit Subject";
    [self setupUI];
    // Do any additional setup after loading the view from its nib.
}
- (void)setupUI{
    SWRevealViewController *reveal = self.revealViewController;
    reveal.panGestureRecognizer.enabled = NO;
    btsave = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveStudent)];
    [btsave setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName: [UIFont systemFontOfSize:15 ]} forState:UIControlStateNormal];
    btedit = [[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editSubjet)];
    [btedit setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName: [UIFont systemFontOfSize:15 ]} forState:UIControlStateNormal];
    self.navigationController.navigationBarHidden = NO;
    UIBarButtonItem *backbt = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(btBack)];
    self.navigationItem.leftBarButtonItem = backbt;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    if (self.isEditing) {
        [self tfAnableOrDissable:YES];
        self.navigationItem.rightBarButtonItem = btedit;
    }else{
        self.navigationItem.rightBarButtonItem = btsave;
    }
    
    [self loadDataInView];
}
- (void) loadDataInView {
    if (!self.isEditing) {
        self.subjectClass = [Subject new];
    }
    else {
        self.tfSubject.text = self.subjectClass.subject;
        self.tfDescription.text = self.subjectClass.descriptions;
        self.tfCredits.text = [NSString stringWithFormat:@"%li",self.subjectClass.credits];
    }
}
#pragma mark - Check
-(BOOL) checkSubjectExist{
    if (self.isEditing) {
        return NO;
    }
    arrSubjectExit = [NSArray array];
    arrSubjectExit = [Subject querySubject:self.tfSubject.text];
    if (arrSubjectExit.count>0) {
        return YES;
    } else {
        return NO;
    }
}

-(BOOL)checkAllComponent{
    NSMutableString *waringcheck = [[NSMutableString alloc]initWithString:@"Warring : "];
    if (self.tfSubject.text.length>0&&self.tfDescription.text.length>0&&[self validateCredit:self.tfCredits.text warring:waringcheck]&&![self checkSubjectExist]) {
        return YES;
    }else{
        if (self.tfDescription.text.length==0||self.tfCredits.text.length==0) {
            [waringcheck appendString:@"in put all infomation, "];
        }
        if ([self checkSubjectExist]) {
            [waringcheck appendString:@"Subject is Exist, "];
        }
        _lbWaring.text = waringcheck;
        return NO;
    }
}

- (BOOL)validateCredit:(NSString *)credit warring:(NSMutableString*)waring
{
    NSInteger tflength = self.tfCredits.text.length;
    if(tflength >0 && tflength < 2){
        NSString *creditRegex = @"^[0-9]{1,2}$";
        NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", creditRegex];
        if ([test evaluateWithObject:credit]) {
            return YES;
        }else{
            [waring appendString:@"Credit not Validate"];
            return NO;
        }
        return [test evaluateWithObject:credit];
    }else{
        [waring appendString:@" Credit not Validate"];
        return NO;
    }
}

#pragma mark Action
- (void)tfAnableOrDissable:(BOOL)values{
    if (values) {
        self.tfSubject.enabled = NO;
        self.tfDescription.enabled = NO;
        self.tfCredits.enabled = NO;
    }else{
//        self.tfSubject.enabled = YES;
        self.tfDescription.enabled = YES;
        self.tfCredits.enabled = YES;
    }
}

- (void)btBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)editSubjet{
    [self tfAnableOrDissable:NO];
    [btedit setTitle:@"Save"];
    self.navigationItem.rightBarButtonItem = btsave;
}

- (void)saveStudent{
    if ([self checkAllComponent]) {
        self.subjectClass.subject = self.tfSubject.text;
        self.subjectClass.descriptions = self.tfDescription.text;
        self.subjectClass.credits = [self.tfCredits.text intValue];
        [self.subjectClass update];
        NSLog(@"save Success");
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
