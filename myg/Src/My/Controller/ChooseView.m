//
//  ChooseView.m
//  yyxb
//
//  Created by 杨易 on 15/11/17.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "ChooseView.h"

@implementation ChooseView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
   self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake( MSW / 2 - 110, MSH / 2 - 70 , 220, 140)];
    view1.alpha = 1;
    [self addSubview:view1];
    self.tableView = [[UITableView alloc]initWithFrame:view1.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.tableFooterView = [[UIView alloc]init];

    [view1 addSubview:self.tableView];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:cellName];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    switch (indexPath.row)
    {
        case 0:
            cell.textLabel.text = @"修改头像";
            cell.textLabel.textColor = MainColor;
            break;
        case 1:
            cell.textLabel.text = @"相册";
            break;
        case 2:
            cell.textLabel.text = @"拍照";
            break;
            
        default:
        {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(220 / 2 - 17, 44 / 2 - 15, 34, 30)];
            label.text = @"取消";
            label.textColor = MainColor;
            [cell addSubview:label];
        }
            break;
    }
    
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 1:
        {
            // 判断相机能不能用
            
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                // 实例化 获取图片的控制器
                UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
                
                //从相机 获取图片
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                
                //从相册 获取图片
                //        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                
                // 选择图片 之后 是否 可以进入编辑页面（选择 取消或者 确定）
                imagePicker.allowsEditing = YES;
                
                // 设置代理
                imagePicker.delegate = self;
                
                // 展示 选择图片界面
//                [self presentViewController:imagePicker animated:YES completion:nil];
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:imagePicker,@"imagePickerName", nil];
                NSNotification *notification =[NSNotification notificationWithName:@"photo" object:nil userInfo:dic];
                [[NSNotificationCenter defaultCenter] postNotification:notification];

                [self removeFromSuperview];
            }
        }
            break;
    case 2:
        {
            
        }
            break;
    case 3:
        {
            [self removeFromSuperview];
        }
            break;
        
        default:
            break;
    }

}

#pragma mark - 相机代理
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    DebugLog(@"位置:%@",info);
    // 取出来 选择的图片
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    //self.userImage = image;
    [self.tableView reloadData];
    // 让 选择图片的界面  消失
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    DebugLog(@"取消选择图片");
    
    // 让 选择图片的界面  消失
    [picker dismissViewControllerAnimated:YES completion:nil];
}



@end
