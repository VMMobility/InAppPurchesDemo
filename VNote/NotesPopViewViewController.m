//
//  NotesPopViewViewController.m
//  VNote
//
//  Created by Purushottam Kumar on 01/02/16.
//  Copyright © 2016 Vmoksha Technologies Pvt Ltd. All rights reserved.
//

#import "NotesPopViewViewController.h"
#import "notesPopModelData.h"
#import "NotePopTableCellTableViewCell.h"



@interface NotesPopViewViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    notesPopModelData *noteModel;
    NSMutableArray *tabArray;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation NotesPopViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    tabArray=[[NSMutableArray alloc]init];
    _myTableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    _myTableView.layer.cornerRadius=5;
    _myTableView.layer.borderWidth=1;
    [self localData];
    // Do any additional setup after loading the view.
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tabArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotePopTableCellTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"notesPopTable"];
    noteModel=[tabArray objectAtIndex:indexPath.row];
    cell.notesPopImage.image=noteModel.imageList;
    cell.notesPopNameLabel.text=noteModel.nameList;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        [self.delegate homeAction];
    }
    else if (indexPath.row==1)
    {
        [self.delegate logOutAction];
    }
}

-(void)localData
{
    noteModel=[[notesPopModelData alloc]init];
    noteModel.nameList=@"Home";
    noteModel.imageList=[UIImage imageNamed:@"house175 (1)"];
    [tabArray addObject:noteModel];
    
    noteModel=[[notesPopModelData alloc]init];
    noteModel.nameList=@"Log out";
    noteModel.imageList=[UIImage imageNamed:@"square236 (2)"];
    [tabArray addObject:noteModel];
}
@end
