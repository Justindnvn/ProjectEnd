//
//  ChiTietLopHoc.m
//  Projectend
//
//  Created by ThucTapiOS on 5/16/16.
//  Copyright © 2016 Ominext Mobile. All rights reserved.
//

#import "ChiTietLopHoc.h"
#import "SWRevealViewController.h"
#import "UIViewController+PresentViewControllerOverCurrentContext.h"
#import "ClassedTableViewCell.h"

@interface ChiTietLopHoc (){
    IBOutlet UIButton *btnPlus;
    IBOutlet UIView *vTitle;
    
    BOOL ischange;
}

@end

@implementation ChiTietLopHoc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupUI];
}
-(void)setupUI{
    [_tableViewStudent registerNib:[UINib nibWithNibName:@"ClassedTableViewCell" bundle:nil] forCellReuseIdentifier:@"ClassedTableViewCell"];
    
    SWRevealViewController *reveal = self.revealViewController;
    reveal.panGestureRecognizer.enabled = NO;
    
    ischange = NO;
    
    [self.navigationController setNavigationBarHidden:YES];
    [_btnSave setHidden:YES];
    [btnPlus setHidden:YES];
    
    _tableViewStudent.tableFooterView = [[UIView alloc] init];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self loadData];
}
-(void)loadData{
    _edited = NO;
    vTitle.layer.borderWidth = 1.0f;
    
    _arrStudent = [Student queryStudentWithIDClass:[NSString stringWithFormat:@"%@", _thisClass.iId]];
    _arrMaskStudent = [NSMutableArray array];
    [_arrMaskStudent addObjectsFromArray:_arrStudent];
    _lblLop.text = [NSString stringWithFormat:@"Lớp: %@", _thisClass.name];
    _lblSoSv.text = [NSString stringWithFormat:@"Số sinh viên: %ld", [_arrMaskStudent count]];
    
    [_tableViewStudent reloadData];
    
}
#pragma mark - UITableView Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrMaskStudent.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     ClassedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClassedTableViewCell"];
    
    if (!cell) {
        cell = [[ClassedTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ClassedTableViewCell"];
    }
    
    Student *thisStudent = (Student*)[_arrMaskStudent objectAtIndex:indexPath.row];
    cell.layer.borderWidth = 1.0f;
    cell.lblName.text = [NSString stringWithFormat:@"  %@", thisStudent.name];
    cell.lblDetail.text = [NSString stringWithFormat:@"Ngày sinh: %@", thisStudent.dateofbirth];
//    cell.textLabel.text = [NSString stringWithFormat:@"%@ \t - \t Ngày sinh: %@", thisStudent.name, thisStudent.dateofbirth];
    
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_edited == YES) {
        return YES;
    }else{
        return NO;
    }
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Student *thisStudent = [_arrMaskStudent objectAtIndex:indexPath.row];
        [_arrMaskStudent removeObject:thisStudent];
        ischange = YES;
        [_btnSave setHidden:NO];
        [_btnExit setHidden:YES];
        [_tableViewStudent reloadData];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)editPressed:(id)sender {
    _edited = YES;
    [btnPlus setHidden:NO];
//    [_btnExit setHidden:YES];
//    [_btnSave setHidden:NO];
}

- (IBAction)savePressed:(id)sender {
    [self saveData];
    [_btnSave setHidden:YES];
    [_btnExit setHidden:NO];
    [btnPlus setHidden:YES];
    [self showAlertWithTitle:nil andMessage:@"Lưu thành công!"];
}

- (IBAction)backPressed:(id)sender {
    if (_edited == YES && ischange == YES) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Lưu dữ liệu" message:@"Bạn chưa lưu dữ liệu \n Bạn có muốn lưu không?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actOk = [UIAlertAction actionWithTitle:@"Lưu" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self saveData];
            [self.navigationController popViewControllerAnimated:YES];
//            [self showAlertWithTitle:nil andMessage:@"Lưu thành công!"];

        }];
        UIAlertAction *actCancel = [UIAlertAction actionWithTitle:@"Không" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert addAction:actCancel];
        [alert addAction:actOk];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)saveData{
    _edited = NO;
    if (ischange == NO) {
        return;
    }
    for (Student *thisStudent in _arrStudent) {
        if ([_arrMaskStudent indexOfObject:thisStudent] == NSNotFound) {
            NSArray *arrScore = [Scoreboad queryScoreFromIDStudent:[thisStudent.iId integerValue]];
            for (Scoreboad *thisScore in arrScore) {
                thisScore.idclass = 0;
                [thisScore update];
            }
            thisStudent.idclass = 0;
            [thisStudent update];
        }
    }
    for (Student *thisStudent in _arrMaskStudent) {
        if ([_arrStudent indexOfObject:thisStudent] == NSNotFound) {
            NSArray *arrScore = [Scoreboad queryScoreFromIDStudent:[thisStudent.iId integerValue]];
            for (Scoreboad *thisScore in arrScore) {
                thisScore.idclass = [_thisClass.iId integerValue];
                [thisScore update];
            }
            thisStudent.idclass = [_thisClass.iId integerValue];
            [thisStudent update];
        }
    }
    [self loadData];
}

- (IBAction)addPressed:(id)sender {
    ThemSinhVien *themSv = [[ThemSinhVien alloc] initWithNibName:@"ThemSinhVien" bundle:nil];
    themSv.thisClass = _thisClass;
    themSv.delegate = self;
    [self presentViewControllerOverCurrentContext:themSv animated:YES completion:nil];
}

-(void)showAlertWithTitle:(NSString*)title andMessage:(NSString*)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:YES completion:nil];
    });
}

-(void)sendArrMaskStudent:(NSArray *)arrMask{
    if (arrMask.count<1) {
        return;
    }
    ischange = YES;
    [_btnExit setHidden:YES];
    [_btnSave setHidden:NO];
    [_arrMaskStudent addObjectsFromArray:arrMask];
    [_tableViewStudent reloadData];
}
@end
