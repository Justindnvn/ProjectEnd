//
//  ThemSinhVien.h
//  Projectend
//
//  Created by ThucTapiOS on 5/16/16.
//  Copyright © 2016 Ominext Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ThemSinhVien : UIViewController <UITableViewDelegate, UITableViewDataSource>

- (IBAction)checkPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UITableView *tblAddStudent;
@property (strong, nonatomic) NSArray *arrStudentNotAdd;

@end
