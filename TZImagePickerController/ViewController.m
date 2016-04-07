//
//  ViewController.m
//  TZImagePickerController
//
//  Created by 谭真 on 15/12/24.
//  Copyright © 2015年 谭真. All rights reserved.
//
//  单鹏飞在此处做过优化 16/4/7
#import "ViewController.h"
#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import "TZTestCell.h"
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
@interface ViewController ()<TZImagePickerControllerDelegate> {
    UICollectionView *_collectionView;
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;

    CGFloat _itemWH;
    CGFloat _margin;
    
    UIView *_imageVew;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
    //[self configCollectionView];
    [self creatselectView];
    [self creatPhoto];
}
-(void)creatselectView{
    _imageVew=[[UIView alloc]initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 300)];
    _imageVew.backgroundColor=[UIColor grayColor];
    [self.view addSubview:_imageVew];
    
}
-(void)creatPhoto{
    //九宫格布局
    CGFloat buttonw =(ScreenWidth-5*5)/4;
    //横向个数
    int totalloc=4;
    //横向的间隔
    CGFloat wSpace = (ScreenWidth - totalloc*buttonw)/(totalloc+1);
    //纵向的间隔
    CGFloat hSpace = 5;
    for (int i = 0; i<_selectedPhotos.count+1; i++) {
        
        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(wSpace +(i%totalloc)*(buttonw+wSpace),hSpace+(i/totalloc)*(hSpace+buttonw), buttonw,buttonw)];
        image.userInteractionEnabled=YES;
        if (_selectedPhotos.count==0) {
            image.image = [UIImage imageNamed:@"AlbumAddBtn"];
             [image addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCategory:)]];
        }else{
            if (i==_selectedPhotos.count) {
                image.image = [UIImage imageNamed:@"AlbumAddBtn"];
                [image addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCategory:)]];
            }else{
        image.image=_selectedPhotos[i];
                UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(buttonw-30, 0, 30, 30)];
                button.tag=i;
                [button setBackgroundImage:[UIImage imageNamed:@"buttonCloseClick"] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
                [image addSubview:button];
                
            }
        }
        
        [_imageVew addSubview:image];
    }
    
}

 
-(void)clickCategory:(UITapGestureRecognizer *)gestureRecognizer
{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:3 delegate:self];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}
-(void)buttonTouch:(UIButton *)button{
        NSLog(@"button.tag = %ld",button.tag);
        [_selectedPhotos removeObjectAtIndex:button.tag];
    for (id objc in _imageVew.subviews) {
        [objc removeFromSuperview];
    }
    [self creatPhoto];
}
- (void)configCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _margin = 4;
    _itemWH = (self.view.tz_width - 2 * _margin - 4) / 4 - _margin;
    layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    layout.minimumInteritemSpacing = _margin;
    layout.minimumLineSpacing = _margin;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(_margin, 120, self.view.tz_width - 2 * _margin, 400) collectionViewLayout:layout];
    CGFloat rgb = 244 / 255.0;
    _collectionView.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];
    _collectionView.contentInset = UIEdgeInsetsMake(4, 0, 0, 2);
    _collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, -2);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
}

#pragma mark UICollectionView

//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return _selectedPhotos.count + 1;
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
//    if (indexPath.row == _selectedPhotos.count) {
//        cell.imageView.image = [UIImage imageNamed:@"AlbumAddBtn"];
//    } else {
//        cell.imageView.image = _selectedPhotos[indexPath.row];
//        cell.imageView.userInteractionEnabled=YES;
//        CGRect imageFrame=cell.imageView.frame;
//        UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(imageFrame.size.width-37, 0, 37, 37)];
//        [button setImage:[UIImage imageNamed:@"buttonCloseClick"] forState:UIControlStateNormal];
//        button.tag=indexPath.row;
//        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.imageView addSubview:button];
//    }
//    return cell;
//}
//-(void)buttonClick:(UIButton*)button{
//    NSLog(@"button.tag = %ld",button.tag);
//    [_selectedPhotos removeObjectAtIndex:button.tag];
//    [button removeFromSuperview];
//    [_collectionView reloadData];
//    
//}
//
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == _selectedPhotos.count) [self pickPhotoButtonClick:nil];
//}

#pragma mark Click Event

- (IBAction)pickPhotoButtonClick:(UIButton *)sender {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:3 delegate:self];
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets) {
    
    }];
    
    // Set the appearance
    // 在这里设置imagePickerVc的外观
//     imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
//     imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
//     imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    
    // Set allow picking video & originalPhoto or not
    // 设置是否可以选择视频/原图
     //imagePickerVc.allowPickingVideo = NO;
    // imagePickerVc.allowPickingOriginalPhoto = NO;
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark TZImagePickerControllerDelegate

/// User click cancel button
/// 用户点击了取消
- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    // NSLog(@"cancel");
}

/// User finish picking photo，if assets are not empty, user picking original photo.
/// 用户选择好了图片，如果assets非空，则用户选择了原图。
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets{
    [_selectedPhotos addObjectsFromArray:photos];
    [self creatPhoto];
    //[_collectionView reloadData];
   // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
}

/// User finish picking video,
/// 用户选择好了视频
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    [_selectedPhotos addObjectsFromArray:@[coverImage]];
    [_collectionView reloadData];
    _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
}


@end
