//
//  NotesDetailPopView.m
//  VNote
//
//  Created by Purushottam Kumar on 01/02/16.
//  Copyright © 2016 Vmoksha Technologies Pvt Ltd. All rights reserved.
//

#import "NotesDetailPopView.h"
#import "NotesDetailPopViewModelData.h"
#import "notesDetailTableViewCell.h"
#import "notesPopModelData.h"

@interface NotesDetailPopView ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *tabArray;
    NotesDetailPopViewModelData *notesDetail;
    NSMutableArray *popTableArray;
    
    
    notesPopModelData *notesModel;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation NotesDetailPopView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
   
    _myTableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    tabArray=[[NSMutableArray alloc]init];
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
    notesDetailTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"notesDetailPop"];
    notesDetail=[tabArray objectAtIndex:indexPath.row];
    cell.notesDetailImage.image=notesDetail.imageNameList;
    cell.notesDetailNameLabel.text=notesDetail.nameList;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0)
    {
        [self.delegate homeAction];
    }
    else if(indexPath.row==1)
    {
        [self.delegate logOutAction];
    }
}
-(void)localData
{
    notesDetail=[[NotesDetailPopViewModelData alloc]init];
    notesDetail.nameList=@"Home";
    notesDetail.imageNameList=[UIImage imageNamed:@"house175 (1)"];
    [tabArray addObject:notesDetail];
    
    
    notesDetail=[[NotesDetailPopViewModelData alloc]init];
    notesDetail.nameList=@"Log out";
    notesDetail.imageNameList=[UIImage imageNamed:@"square236 (2)"];
    [tabArray addObject:notesDetail];
}
@end
