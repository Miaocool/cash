//
//  UserDataViewController.m
//  yyxb
//
//  Created by 杨易 on 15/11/13.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "UserDataViewController.h"

#import "UserNameViewController.h"

#import "UserPhoneViewController.h"

#import "UserAddressViewController.h"

#import "ChooseView.h"

#import "UIImageView+WebCache.h"

#import "UserDataModel.h"
#import "MBProgressHUD.h"
#import "UIImage-Extensions.h"
#import "RequestPostUploadHelper.h"

@interface UserDataViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    
    NSString *TMP_UPLOAD_IMG_PATH;
    MBProgressHUD *waitingDialog;
    NSString *_imgURL;
}
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UserNameViewController *userNameVC;
@property (nonatomic, strong) UserPhoneViewController *userPhoneVC;
@property (nonatomic, strong) UserAddressViewController *userAddressVC;
@property (nonatomic, strong) ChooseView *chooseView;
@property (nonatomic, strong) UIImageView *headImageView; //头像
@property (nonatomic, strong) NSMutableArray *userArray;
@property (nonatomic, strong) UserDataModel *model;
@end

@implementation UserDataViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"个人资料";
    [self initData];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requeData];
    
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
}

//获取用户资料数据
- (void)requeData
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
    [MDYAFHelp AFPostHost:APPHost bindPath:UserData postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"!!!!%@",responseDic );
        if ([responseDic[@"code"] isEqualToString:@"200"])
        {
            NSDictionary *dict = responseDic[@"data"];
            self.model= [[UserDataModel alloc]initWithDictionary:dict];
            DebugLog(@"!!!!%@",self.model.username);
        }
        [self initTableView];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    }];

}

- (void)initData
{
//    self.dataArray = @[@"头像",@"ID",@"账号",@"昵称",@"手机号码",@"地址管理"];
    self.dataArray = @[@"头像",@"ID",@"昵称",@"手机号码",@"收货信息管理"];
    self.userArray = [NSMutableArray array];
    self.userNameVC = [[UserNameViewController alloc]init];
    self.userPhoneVC = [[UserPhoneViewController alloc]init];
    self.userAddressVC = [[UserAddressViewController alloc]init];
    
}

- (void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MSW,MSH) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.tableFooterView = [[UIView alloc] init];

    [self.view addSubview:self.tableView];

}


#pragma mark - 黄金三问  dataSource


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //复用的方式就未注册过的方式
    static NSString *cellName = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    //有可能会有空cell
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellName];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.textLabel.font=[UIFont systemFontOfSize:BigFont];
    cell.detailTextLabel.font=[UIFont systemFontOfSize:BigFont];
         switch (indexPath.row)
    {
        case 0:
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            self.headImageView = [[UIImageView alloc]initWithFrame:CGRectMake( MSW - 30 - 60, 70 / 2 - 30,60, 60)];
            self.headImageView.layer.masksToBounds = YES;
            self.headImageView.userInteractionEnabled = YES;
            self.headImageView.layer.cornerRadius = 30;
            self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
            [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.model.img] placeholderImage:[UIImage imageNamed:@"head"]];
//            self.headImageView.backgroundColor = [UIColor redColor];
            [cell addSubview:self.headImageView];

        }
            break;
        case 1:
        {
          
            cell.detailTextLabel.text = self.model.uid;
        }
            break;
        case 2:
        {
            
           // __weak typeof(self) weakself = self;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

            DebugLog(@"!!!!%@",self.model.username);
            cell.detailTextLabel.text = self.model.username;
        }
            break;
        case 3:
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.text = self.model.mobile;

        }
            break;
        case 4:
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }
            break;
          }
    return  cell;
}

#pragma mark - delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row)
    {
        case 0:
        {
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择",nil];
            sheet.actionSheetStyle = UIActionSheetStyleAutomatic;
            [sheet showInView:self.view];
        }
            break;
        case 2:
        {
            [self.navigationController pushViewController:self.userNameVC animated:YES];
        }
            break;
        case 3:
        {
            
            
            self.userPhoneVC.model=self.model;
            [self.navigationController pushViewController:self.userPhoneVC animated:YES];
        }
            break;
            case 4:
        {
            [self.navigationController pushViewController:self.userAddressVC animated:YES];
        }
            
            break;
            
        default:
            break;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 70;
    }
    else
        return 50;

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return (MSW / 2) + 200;
    }
    return 1;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (MSW / 2), (MSW / 2) + 50)];
    view1.backgroundColor = [UIColor whiteColor];
    
    UIImageView *erWeiImage = [[UIImageView alloc] initWithFrame:CGRectMake((MSW - (MSW / 2)) / 2, 30, (MSW / 2), (MSW / 2))];
    [erWeiImage sd_setImageWithURL:[NSURL URLWithString:_share_img] placeholderImage:[UIImage imageNamed:DefaultImage]];
    [view1 addSubview:erWeiImage];
    
    return view1;
}

#pragma mark - UIActionSheetDelegate 图片代理

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        // 判断相机能不能用
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            // 实例化 获取图片的控制器
            UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
             //从相机 获取图片
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
             //从相册 获取图片
//            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//            imagePicker.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            // 选择图片 之后 是否 可以进入编辑页面（选择 取消或者 确定）
            imagePicker.allowsEditing = YES;
            // 设置代理
            imagePicker.delegate = self;
            // 展示 选择图片界面
            [self presentViewController:imagePicker animated:YES completion:nil];
        }

    }
    else if(buttonIndex == 1)
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        
        //代理
        picker.delegate = self;
        //设置图片源
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        //可以编辑
        picker.allowsEditing = YES;
        //打开拾取器界面
        [self presentViewController:picker animated:YES completion:nil];
    
    }
    
}


#pragma mark - UIImagePickerControllerDelegate 相机代理

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    DebugLog(@"位置:%@",info);
    // 将所选择的图片 加入数组
    UIImage * img =[info objectForKey:UIImagePickerControllerOriginalImage];
    // 取出来 选择的图片
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    formatter.dateFormat = @"yyyyMMddHHmmss";
    
    NSString *str = [formatter stringFromDate:[NSDate date]];
    DebugLog(@"格式 = %@",str);
    
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
    DebugLog(@"image = %@",fileName);
    
    [self saveImage:img WithName:fileName];
    
    //[self dismissModalViewControllerAnimated:YES];
    waitingDialog = [[MBProgressHUD alloc] init];
    [self.view addSubview:waitingDialog];
    [((MBProgressHUD *)waitingDialog) show:YES];
    [self dismissViewControllerAnimated:YES completion:^(void){
        
       [self onPostData];
    }];
}

- (void)onPostData{
    
    NSMutableDictionary * dir=[NSMutableDictionary dictionaryWithCapacity:2];
    [dir setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [dir setValue:[UserDataSingleton userInformation].code forKey:@"code"];

    NSString *url= [NSString stringWithFormat:@"%@/app/home/editPhoto",APPHost];
    
    DebugLog(@"=======上传");
    
    DebugLog(@"img:%@",TMP_UPLOAD_IMG_PATH);
    NSString *str = TMP_UPLOAD_IMG_PATH;
    if([str isEqualToString:@""]){
        [RequestPostUploadHelper postRequestWithURL:[NSString stringWithFormat:@"%@",url] postParems:dir picFilePath:nil picFileName:nil];
    }else{
        DebugLog(@"有图标上传");
        NSArray *nameAry=[TMP_UPLOAD_IMG_PATH componentsSeparatedByString:@"/"];
        _imgURL = [RequestPostUploadHelper postRequestWithURL:url postParems:dir picFilePath:TMP_UPLOAD_IMG_PATH picFileName:[nameAry objectAtIndex:[nameAry count]-1]];
        DebugLog(@"imgURL1111====%@",_imgURL);
        if(_imgURL.length > 0){
            [self setImageView];
        }else{
            DebugLog(@"网络不给力，图片上传失败");
        }
        
        DebugLog(@"imgURL====%@",_imgURL);
        [(MBProgressHUD *)waitingDialog hide:YES];
    }
    
}

-(void)setImageView
{
    self.model.img = _imgURL;
    [self.tableView reloadData];

}

- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    DebugLog(@"===TMP_UPLOAD_IMG_PATH===%@",TMP_UPLOAD_IMG_PATH);
    //    NSData* imageData = UIImageJPEGRepresentation(tempImage, 0.4);
    NSData *imageData = [[NSData alloc]init];
    if(tempImage.size.width > 400){
        imageData = UIImageJPEGRepresentation([tempImage imageByScalingToSize:CGSizeMake(400, tempImage.size.height * (tempImage.size.width/400))], 0.7);
        DebugLog(@"===%f",tempImage.size.height * (tempImage.size.width/400));
    }else{
        imageData = UIImageJPEGRepresentation([tempImage imageByScalingToSize:CGSizeMake(tempImage.size.width, tempImage.size.height)], 1.0);
        DebugLog(@"%f,%f",tempImage.size.width,tempImage.size.height);
    }
    
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    NSString* documentsDirectory = [paths objectAtIndex:0];
    
    // Now we get the full path to the file
    
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    
    // and then we write it out
    
    NSArray *nameAry=[TMP_UPLOAD_IMG_PATH componentsSeparatedByString:@"/"];
    DebugLog(@"===new fullPathToFile===%@",fullPathToFile);
    DebugLog(@"===new FileName===%@",[nameAry objectAtIndex:[nameAry count]-1]);
    
    [imageData writeToFile:fullPathToFile atomically:YES];
    TMP_UPLOAD_IMG_PATH=fullPathToFile;
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    DebugLog(@"取消选择图片");
    // 让 选择图片的界面  消失
    [picker dismissViewControllerAnimated:YES completion:nil];
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
