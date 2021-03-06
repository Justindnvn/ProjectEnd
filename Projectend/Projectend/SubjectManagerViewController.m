//
//  SubjectManagerViewController.m
//  Projectend
//
//  Created by Ominext Mobile on 5/19/16.
//  Copyright © 2016 Ominext Mobile. All rights reserved.
//

#import "SubjectManagerViewController.h"

@interface SubjectManagerViewController (){
    NSArray *arrSubject;
    NSArray *arrScore;
}

@end

@implementation SubjectManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Subject Manager";
    [self setupUI];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self loadData];
}

- (void)setupUI{
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName: [UIFont systemFontOfSize:20 ]}];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:2.0f/255.0f green:136.0f/255.0f blue:209.0f/255.0f alpha:1];
    self.navigationController.navigationBarHidden = NO;
    UIBarButtonItem *rightbt = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"plus16w.png"] style:UIBarButtonItemStylePlain target:self action:@selector(plusSubject)];
    self.navigationItem.rightBarButtonItem = rightbt;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    SWRevealViewController *revealController = [self revealViewController];
    _tableView.tableFooterView = [[UIView alloc] init];
    if (self.isSlide) {
        SWRevealViewController *revealControllers = [self revealViewController];
        [revealControllers panGestureRecognizer];
        [revealControllers tapGestureRecognizer];
        UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu24.png"]
                                                                             style:UIBarButtonItemStylePlain target:revealControllers action:@selector(revealToggle:)];
        [revealController.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName: [UIColor colorWithRed:146.0f/255.0f green:204.0f/255.0f blue:55.0f/255.0f alpha:1],NSFontAttributeName: [UIFont systemFontOfSize:20 ]}];
        self.navigationItem.leftBarButtonItem = revealButtonItem;
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    }else{
        SWRevealViewController *reveal = self.revealViewController;
        reveal.panGestureRecognizer.enabled = NO;
        UIBarButtonItem *backbt = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(btback)];
        self.navigationItem.leftBarButtonItem = backbt;
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    }

    [self loadData];
}

- (void) loadData {
    arrSubject = [NSArray array];
    arrSubject = [Subject queryListSubject];
    [self.tableView reloadData];
}
#pragma mark Button Action
- (void)btback{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)plusSubject{
    AddAndEditSubjectViewController *addandedit = [[AddAndEditSubjectViewController alloc]initWithNibName:@"AddAndEditSubjectViewController" bundle:nil];
    addandedit.isEditing = NO;
    [self.navigationController pushViewController:addandedit animated:YES];
}

#pragma mark UITableView Datasource/Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrSubject.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellMainNibID = @"cellSubject";
    _cellSubjects = [tableView dequeueReusableCellWithIdentifier:cellMainNibID];
    if (_cellSubjects == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"SubjectCell" owner:self options:nil];
    }
    
    UILabel *subject = (UILabel *)[_cellSubjects viewWithTag:2];
    CALayer *layer = [subject layer];
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, 43.0f, subject.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    [layer addSublayer:bottomBorder];
    
    UILabel *credit = (UILabel *)[_cellSubjects viewWithTag:3];
    CALayer *layer1 = [credit layer];
    CALayer *bottomBorder1 = [CALayer layer];
    bottomBorder1.frame = CGRectMake(0.0f, 43.0f, credit.frame.size.width, 1.0f);
    bottomBorder1.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    [layer1 addSublayer:bottomBorder1];
    
    if ([arrSubject count] > 0)
    {
        Subject *subjects = (Subject*)[arrSubject objectAtIndex:indexPath.row];
        subject.text = subjects.subject;
        credit.text = [NSString stringWithFormat:@"%ld Tín chỉ",subjects.credits];
    }
    
    return _cellSubjects;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Subject *subject = (Subject*)[arrSubject objectAtIndex:indexPath.row];
    AddAndEditSubjectViewController *addEditSubject = [[AddAndEditSubjectViewController alloc]initWithNibName:@"AddAndEditSubjectViewController" bundle:nil];
    addEditSubject.isEditing = YES;
    addEditSubject.subjectClass = subject;
    [self.navigationController pushViewController:addEditSubject animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle ==UITableViewCellEditingStyleDelete){
        Subject *subject = (Subject*)[arrSubject objectAtIndex:indexPath.row];
        arrScore = [NSArray array];
        arrScore = [Scoreboad queryScoreFromIDSubject:[subject.iId integerValue]];
        for (Scoreboad *score in arrScore) {
            score.deleted = @(1);
            [score update];
        }
        subject.deleted = @(1);
        [subject update];
        [self loadData];
        NSLog(@"dfafafasfasfafd");
    }
}

@end
