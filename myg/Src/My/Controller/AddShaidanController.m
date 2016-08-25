//
//  AddShaidanController.m
//  yyxb
//
//  Created by lili on 15/12/4.
//  Copyright © 2015年 杨易. All rights reserved.
//
#import "RequestPostUploadHelper.h"
#import "AddShaidanController.h"
#import "MBProgressHUD.h"

#import "UIImage-Extensions.h"
@interface AddShaidanController ()<UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>


{
    long mytag;
    MBProgressHUD *waitingDialog;
    NSString *TMP_UPLOAD_IMG_PATH;

    UIButton *updata;

    UILabel*lable;

}

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong)  UITextView*textview;

@property (nonatomic, strong)NSString*imgurlstr;//上传图片路径
@property (nonatomic)UIScrollView    *imgScrollView;
@property (nonatomic)NSMutableArray  *itemArray;

@property (nonatomic)UIScrollView    *mainScrollView;

@end

@implementation AddShaidanController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"提交晒单";
    [self initData];
    [self createview];

}

#pragma mark - 创建数据
- (void)initData
{
    
    _itemArray = [NSMutableArray array];
    
    
}
-(void)createview{

    
    _mainScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width, MSH)];
    _mainScrollView.backgroundColor = [UIColor whiteColor];
    _mainScrollView.showsHorizontalScrollIndicator=NO;
    _mainScrollView.showsVerticalScrollIndicator=NO;
    
    _mainScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 590);
    [self.view addSubview:_mainScrollView];
    
    
    UILabel*lbtitle=[[UILabel alloc]initWithFrame:CGRectMake(20, 5, 45, 30)];
    lbtitle.text=@"标题";
    [_mainScrollView addSubview:lbtitle];
    
    
    self.textField = [[UITextField alloc]initWithFrame:CGRectMake(70, 5,[UIScreen mainScreen].bounds.size.width-70, 30)];
    self.textField.placeholder = @"请输入标题";
    self.textField.delegate = self;
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_mainScrollView addSubview:self.textField];
    UILabel*line1=[[UILabel alloc]initWithFrame:CGRectMake(0, 80-40, [UIScreen mainScreen].bounds.size.width, 2)];
    line1.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [_mainScrollView addSubview:line1];
    
    lable=[[UILabel alloc]initWithFrame:CGRectMake(25, 40, [UIScreen mainScreen].bounds.size.width-40, 30)];
    lable.text=@"在这里输入您的晒单心情，与我们分享";
    lable.textColor=[UIColor grayColor];
    lable.font=[UIFont systemFontOfSize:BigFont];
    lable.backgroundColor=[UIColor clearColor];
    [_mainScrollView addSubview:lable];
    
    UILabel*line2=[[UILabel alloc]initWithFrame:CGRectMake(0, 270, [UIScreen mainScreen].bounds.size.width, 2)];
    line2.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [_mainScrollView addSubview:line2];
    _textview=[[UITextView alloc]initWithFrame:CGRectMake(20, 42, [UIScreen mainScreen].bounds.size.width-40, 194)];
//    _textview.alpha=0;
    
    
    _textview.returnKeyType=UIReturnKeyDone;
    _textview.backgroundColor=[UIColor clearColor];
    _textview.delegate=self;
    
     _textview.font=[UIFont systemFontOfSize:BigFont];
    [_mainScrollView addSubview:_textview];
    
    UILabel*line3=[[UILabel alloc]initWithFrame:CGRectMake(0, 320-10, [UIScreen mainScreen].bounds.size.width, 2)];
    line3.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [_mainScrollView addSubview:line3];
    
    
    UIButton*btuploadpic=[[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-40, 280-10, 80, 40)];
    [btuploadpic setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [btuploadpic setTitle:@"上传图片" forState:UIControlStateNormal];
    [_mainScrollView addSubview:btuploadpic];
    UIImageView*imgxiangji=[[UIImageView alloc]initWithFrame:CGRectMake(btuploadpic.frame.origin.x-25, 290-10, 24, 20)];
    
    imgxiangji.image=[UIImage imageNamed:@"icon_camera"];
    [_mainScrollView addSubview:imgxiangji];

    
    
    
    UIButton   *updataImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    updataImgBtn.frame = CGRectMake(5, 350, 55, 55);
    [updataImgBtn setBackgroundImage:[UIImage imageNamed:@"camara_normal_icon"] forState:UIControlStateNormal];
//    [updataImgBtn setBackgroundColor:[UIColor greenColor]];
    [updataImgBtn addTarget:self action:@selector(addImgTapRecognizer) forControlEvents:UIControlEventTouchUpInside];
    [_mainScrollView addSubview:updataImgBtn];
    
    
    
    _imgScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(updataImgBtn.right+5, 330, [UIScreen mainScreen].bounds.size.width - 75, 90.0f+10)];
//      _imgScrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _imgScrollView.showsHorizontalScrollIndicator=NO;
    _imgScrollView.showsVerticalScrollIndicator=NO;
    [_mainScrollView addSubview:_imgScrollView];
    
    
    UILabel*line4=[[UILabel alloc]initWithFrame:CGRectMake(0, 440, [UIScreen mainScreen].bounds.size.width, 2)];
    line4.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [_mainScrollView addSubview:line4];
    
    updata = [UIButton buttonWithType:UIButtonTypeCustom];
    updata.backgroundColor = MainColor;
    [updata setTitle:@"提交" forState:UIControlStateNormal];
    updata.frame = CGRectMake(10, 470, MSW - 20, 45);
    updata.layer.cornerRadius = 5;
    [updata addTarget:self action:@selector(updatashandan) forControlEvents:UIControlEventTouchUpInside];
    [_mainScrollView addSubview:updata];
    
    
    
}


- (void)addImgTapRecognizer
{
    // 弹出选择菜单
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:@"拍照"
                                  otherButtonTitles:@"从手机相册选择",nil];
    [actionSheet showInView:self.view];
}

#pragma mark - actionSheetDelegate
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *imagePicker=nil;
    switch (buttonIndex) {
        case 0:  // 拍照
        {
            // 拍照
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                imagePicker=[[UIImagePickerController alloc] init];
                imagePicker.delegate=self;
                imagePicker.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imagePicker animated:YES completion:nil];
                
                
            }
            
        }
            break;
        case 1:    // 相册
        {
            // 相册
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]){
                imagePicker=[[UIImagePickerController alloc] init];
                imagePicker.delegate=self;
                imagePicker.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
            
        }
            break;
        default:
            break;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
        if (_itemArray.count<6)
        {
    // 将所选择的图片 加入数组
    UIImage * img =[info objectForKey:UIImagePickerControllerOriginalImage];
    
    
    //  设置图片的时间日期 作为图片名
    NSDateFormatter   *formatter = [[NSDateFormatter alloc]init];
    
    formatter.dateFormat = @"yyyyMMddHHmmss";
    
    NSString  *str = [formatter stringFromDate:[NSDate date]];
    
    NSString   *fileName = [NSString stringWithFormat:@"%@.jpg",str];
    
    //            DLog(@"fileName--->>%@",fileName)
    
    //  保存 图片
    [self saveImage:img WithName:fileName];
    
    waitingDialog = [[MBProgressHUD alloc] init];
    [self.view addSubview:waitingDialog];
    [((MBProgressHUD *)waitingDialog) show:YES];
    [self dismissViewControllerAnimated:YES completion:^(void){
    
        [self onPostData];
    }];
    
        }
        else
        {
//            [Instance alertViewShowTitle:nil message:@"发布图片不能超过6张"];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"发布图片不能超过6张" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            [alert show];
            
            
        }

}

//  上传图片
- (void)onPostData
{
   
    {
        NSString *str = TMP_UPLOAD_IMG_PATH;

        NSMutableDictionary  *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:str,@"partAttach", nil];
    
        NSString *url= [NSString stringWithFormat:@"%@/app/home/uploadimg",APPHost];

        NSMutableDictionary * dir=[NSMutableDictionary dictionaryWithCapacity:1];
        [dir setValue:[UserDataSingleton userInformation].uid forKey:@"uid"];
        
        if([str isEqualToString:@""]){

            [RequestPostUploadHelper postRequestWithURL:[NSString stringWithFormat:@"%@",url] postParems:dic  picFilePath:nil picFileName:nil];
                
        }else{
            //有图标上传
            //有图标上传
            NSArray *nameAry=[TMP_UPLOAD_IMG_PATH componentsSeparatedByString:@"/"];
            
            
            NSString *imgURL = [RequestPostUploadHelper postRequestWithURL:url postParems:dic picFilePath:TMP_UPLOAD_IMG_PATH picFileName:[nameAry objectAtIndex:[nameAry count]-1]];
            if (imgURL==nil) {
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请检查您的网络" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                
            }else{
                
                if (_itemArray!=nil) {
                    [_itemArray addObject:imgURL];
                    
                    //            DLog(@"itemArray:%lu",(unsigned long)_itemArray.count)
                    [self setImageView];
                    
                }else{
                    
                    
                }
                
                
                
            }
            

            [(MBProgressHUD *)waitingDialog hide:YES];
        }
        
    }
    
    
}



-(void)setImageView{
    
    [_imgScrollView removeAllSubviews];
    
    CGFloat width =_imgScrollView.frame.size.width/4;
    
    
    for (int i =0; i<_itemArray.count; i++)
    {
        //                DLog(@"%@",_itemArray[i])
        
        UIImageView *imgV =[[UIImageView alloc]initWithFrame:CGRectMake(10.0f+(width+10)*i,5.0f, width, width)];
        
        if ([self.itemArray[i] isKindOfClass:[NSString class]])
        {
            [imgV sd_setImageWithURL:[NSURL URLWithString:_itemArray[i]]placeholderImage:[UIImage imageNamed:DefaultImage]];
            imgV.contentMode = UIViewContentModeScaleToFill;

        }
        else
        {
            [imgV sd_setImageWithURL:[NSURL URLWithString:[_itemArray[i] objectForKey:@"imgurl"]]placeholderImage:[UIImage imageNamed:DefaultImage]];
            imgV.contentMode = UIViewContentModeScaleToFill;

        }
        
      imgV.userInteractionEnabled=YES;
        [_imgScrollView addSubview:imgV];
        
        UIButton *removeBtn = [[UIButton alloc]initWithFrame:CGRectMake((imgV.width)+ (width+10)*i , -1, 20, 20)];
        removeBtn.tag = i;
        removeBtn.backgroundColor = [UIColor clearColor];
        [removeBtn setImage:[UIImage imageNamed:@"delete2"] forState:UIControlStateNormal];
        [removeBtn addTarget:self action:@selector(deleteImageView:) forControlEvents:UIControlEventTouchUpInside];
        [_imgScrollView addSubview:removeBtn];
        
    }
    
    _imgScrollView.contentOffset=CGPointMake((_itemArray.count-1)*width+_itemArray.count*5, 0.0f);
    
    _imgScrollView.contentSize=CGSizeMake(_itemArray.count*width+_itemArray.count*5, _imgScrollView.frame.size.height);
    
}

- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    //    DLog(@"tempImage:%@",tempImage)
    
    NSData *imageData = [[NSData alloc]init];
        if(tempImage.size.width > 400){
        imageData = UIImageJPEGRepresentation([tempImage imageByScalingToSize:CGSizeMake(400, tempImage.size.height * (tempImage.size.width/400))], 0.7);
        //        DLog(@"tempImage:%f",tempImage.size.height * (tempImage.size.width/400))
    }else{
        imageData = UIImageJPEGRepresentation([tempImage imageByScalingToSize:CGSizeMake(tempImage.size.width, tempImage.size.height)], 1.0);
        //        DLog(@"width:%f,height:%f",tempImage.size.width,tempImage.size.height)
        
    }
    
    // 搜索路径目录
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    NSString* documentsDirectory = [paths objectAtIndex:0];
    
    // Now we get the full path to the file
    
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    
    // and then we write it out
    
    //    NSArray *nameAry=[TMP_UPLOAD_IMG_PATH componentsSeparatedByString:@"/"];
    //    DebugLog(@"===new fullPathToFile===%@",fullPathToFile);   // 图片本地路径
    //    DebugLog(@"===new FileName===%@",[nameAry objectAtIndex:[nameAry count]-1]);
    
    [imageData writeToFile:fullPathToFile atomically:YES];
    TMP_UPLOAD_IMG_PATH=fullPathToFile;
}


//  删除图片
-(void)deleteImageView:(id)sender
{
    
   
    
//    [NBAlertView showAlertTitle:nil andMsg:@"确定删除所选图片吗？" cancelButtonTitle:@"取消" otherButtonTitles:@"确定" andBlock:^(NSInteger index, id contxt) {
//        if (index == 1) {
//            [_itemArray removeObjectAtIndex:mytag];
//            [self setImageView];
//        }
//    }];

    
    UIButton *btn = (UIButton *)sender;
    mytag = btn.tag;
       if (_itemArray.count>1) {
       
        [_itemArray removeObjectAtIndex:mytag];
        [self setImageView];
    }else{
        UIAlertView *alert3 = [[UIAlertView alloc] initWithTitle:nil message:@"至少一张图片！" delegate:self cancelButtonTitle:@"确定"otherButtonTitles:nil, nil];
        [alert3 show];
    
    }
    
    
}



-(void)updatashandan{
        updata.userInteractionEnabled=NO;

    if (self.itemArray.count!=0&&[self.itemArray[0] isKindOfClass:[NSString class]])
    {if (_itemArray.count==1) {
        _imgurlstr=[_itemArray objectAtIndex:0];
        
        
        
    }else if (_itemArray.count==2){
        
        _imgurlstr=[NSString stringWithFormat:@"%@;%@",[_itemArray objectAtIndex:0],[_itemArray objectAtIndex:1]];
    }else if (_itemArray.count==3){
        
        _imgurlstr=[NSString stringWithFormat:@"%@;%@;%@",[_itemArray objectAtIndex:0],[_itemArray objectAtIndex:1],[_itemArray objectAtIndex:2]];
    }else if (_itemArray.count==4){
        
        _imgurlstr=[NSString stringWithFormat:@"%@;%@;%@;%@",[_itemArray objectAtIndex:0],[_itemArray objectAtIndex:1],[_itemArray objectAtIndex:2],[_itemArray objectAtIndex:3]];
    }else if (_itemArray.count==5){
        
        _imgurlstr=[NSString stringWithFormat:@"%@;%@;%@;%@;%@",[_itemArray objectAtIndex:0],[_itemArray objectAtIndex:1],[_itemArray objectAtIndex:2],[_itemArray objectAtIndex:3],[_itemArray objectAtIndex:4]];
    }else{
    
    _imgurlstr=[NSString stringWithFormat:@"%@;%@;%@;%@;%@;%@",[_itemArray objectAtIndex:0],[_itemArray objectAtIndex:1],[_itemArray objectAtIndex:2],[_itemArray objectAtIndex:3],[_itemArray objectAtIndex:4],[_itemArray objectAtIndex:5]];
    
    
    }
        
        

    
    }else{
    
        if (_itemArray.count==1) {
            _imgurlstr=[_itemArray objectAtIndex:0][@"imgurl"];
            
            
            
        }else if (_itemArray.count==2){
            
            _imgurlstr=[NSString stringWithFormat:@"%@;%@",[_itemArray objectAtIndex:0][@"imgurl"],[_itemArray objectAtIndex:1][@"imgurl"]];
        }else if (_itemArray.count==3){
            
            _imgurlstr=[NSString stringWithFormat:@"%@;%@;%@",[_itemArray objectAtIndex:0][@"imgurl"],[_itemArray objectAtIndex:1][@"imgurl"],[_itemArray objectAtIndex:2][@"imgurl"]];
        }else if (_itemArray.count==4){
            
            _imgurlstr=[NSString stringWithFormat:@"%@;%@;%@;%@",[_itemArray objectAtIndex:0][@"imgurl"],[_itemArray objectAtIndex:1][@"imgurl"],[_itemArray objectAtIndex:2][@"imgurl"],[_itemArray objectAtIndex:3][@"imgurl"]];
        }else  if (_itemArray.count==5){
            
            _imgurlstr=[NSString stringWithFormat:@"%@;%@;%@;%@;%@",[_itemArray objectAtIndex:0][@"imgurl"],[_itemArray objectAtIndex:1][@"imgurl"],[_itemArray objectAtIndex:2][@"imgurl"],[_itemArray objectAtIndex:3][@"imgurl"],[_itemArray objectAtIndex:4][@"imgurl"]];
        }else if (_itemArray.count==6){
        
         _imgurlstr=[NSString stringWithFormat:@"%@;%@;%@;%@;%@;%@",[_itemArray objectAtIndex:0][@"imgurl"],[_itemArray objectAtIndex:1][@"imgurl"],[_itemArray objectAtIndex:2][@"imgurl"],[_itemArray objectAtIndex:3][@"imgurl"],[_itemArray objectAtIndex:4][@"imgurl"],[_itemArray objectAtIndex:5][@"imgurl"]];
        
        }
        
        

    }
    
   
    if ([_textField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"标题不能为空！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        updata.userInteractionEnabled=YES;
    }
    
    if (_itemArray.count<6 && _itemArray.count!=0&&![_textField.text isEqualToString:@""])
    {
        
        NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
        [dict1 setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
        [dict1 setValue:[UserDataSingleton userInformation].code forKey:@"code"];
        [dict1 setValue:_shopid forKey:@"shopid"];
        [dict1 setValue:_idD forKey:@"id"];
        [dict1 setValue:_textField.text forKey:@"title"];
        
        [dict1 setValue:_textview.text forKey:@"content"];
        [dict1 setValue:_imgurlstr forKey:@"fileurl_tmp"];
        
        [MDYAFHelp AFPostHost:APPHost bindPath:Addshaidan postParam:dict1 getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
            
            DebugLog(@"----%@---%@",responseDic,responseDic[@"msg"]);
            
            if ([responseDic[@"code"]isEqualToString:@"200"]) {
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:responseDic[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                     [self.navigationController popViewControllerAnimated:YES];
                }]];
                [self presentViewController:alert animated:YES completion:nil];

            }else{
                
                updata.userInteractionEnabled=YES;
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络不给力"];
            
            updata.userInteractionEnabled=YES;
        }];
    }else{
        
        
    }
}












-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}




- (void) textViewDidChange:(UITextView *)textView{
    if ([_textview.text length] == 0) {
        [lable setHidden:NO];
    }else{
        [lable setHidden:YES];
    }
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
