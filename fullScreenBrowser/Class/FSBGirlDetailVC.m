//
//  FBSGirlDetailVC.m
//  FullScreenBrowser
//
//  Created by HTC on 2016/11/2.
//  Copyright © 2016年 HTC. All rights reserved.
//

#import "FSBGirlDetailVC.h"

#import "UIImageView+WebCache.h"

#import "FSB-Swift.h"

#import "FSBGirlDetailVC.h"

#import "MWPhotoBrowser.h"


#define Screen_WIDTH                    [UIScreen mainScreen].bounds.size.width
#define ColCell_Item_WIDTH             ((Screen_WIDTH - 3*10 )/2)
#define ColCell_Item_HIGHT             (ColCell_Item_WIDTH +40+2+5+25)


#define K_Img_PicList @"http://api.bj-yfjn.com/api/getPicList.php?modelType=street"
#define K_Img_URL @"http://f.tmdtime.com/"

@interface FSBGirlDetailVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,MWPhotoBrowserDelegate>

/**  collection */
@property(nonatomic,strong) UICollectionView *collectionView;
/**  列表模型 */
@property(nonatomic,strong) NSArray *thumbImgArray;
@property(nonatomic,strong) NSArray *bigImgArray;


@end

@implementation FSBGirlDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self initCollectionView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (!self.thumbImgArray.count) {
        [self featchList];
    }
}

- (void)featchList{
    HTTPTools * http = [HTTPTools shareHTTPTools];
    
    //from=apple&idfv=AA272AD2-8BBF-4BBE-B78B-B357B9D22259&content=1&listType=all&version=5.5
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:self.tid forKey:@"tid"];
    
    [http HTTPPOSTWithURLString:K_Img_PicList parameters:parameters progress:^(NSProgress * _Nonnull progress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        
        NSArray * imageArr = responseObject;
        if (imageArr.count) {
            
            NSMutableArray * thumbImgArray = [NSMutableArray array];
            NSMutableArray * bigImgArray = [NSMutableArray array];
            [imageArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [thumbImgArray addObject:[K_Img_URL stringByAppendingString:[obj objectForKey:@"thumb1"]]];
                [bigImgArray addObject:[K_Img_URL stringByAppendingString:[obj objectForKey:@"picture1"]]];
            }];
            
            self.thumbImgArray = [NSArray arrayWithArray:thumbImgArray];
            self.bigImgArray = [NSArray arrayWithArray:bigImgArray];
                
            [self.collectionView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ;
    }];
    
}



#pragma  mark - Collectionviewdelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSInteger count = self.thumbImgArray.count;
    
    return count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FSBCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FSBCollectionViewCell" forIndexPath:indexPath];
    
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:self.thumbImgArray[indexPath.row]]];
    
    return cell;
}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 5, 10, 5);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(ColCell_Item_WIDTH, ColCell_Item_HIGHT);
}

//这个是两行之间的间距（上下cell间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 10;
}


#pragma mark - 点击cell
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    /*
     {
     picture1 = "data/street/59/481/72059street_800.jpg";
     pid = 72059;
     thumb1 = "data/street/59/481/72059street_s.jpg";
     tid = 4391;
     }
     */
    
    //打开照片浏览器
//    // Browser
//    NSMutableArray *photos = [[NSMutableArray alloc] init];
//    MWPhoto *photo;
//    
//    // Photos
//    photo = [MWPhoto photoWithURL:[NSURL URLWithString:self.bigImgArray[indexPath.row]]];
//    [photos addObject:photo];
//    
//    self.photos = photos;
    
    // Create browser
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = YES;
    browser.displayNavArrows = NO;
    browser.displaySelectionButtons = NO;
    browser.alwaysShowControls = NO;
    browser.zoomPhotosToFill = YES;
    
    browser.enableGrid = YES;
    browser.startOnGrid = NO;
    browser.enableSwipeToDismiss = YES;
    [browser setCurrentPhotoIndex:indexPath.row];
    
    // Reset selections
    //        if (displaySelectionButtons) {
    //            _selections = [NSMutableArray new];
    //            for (int i = 0; i < photos.count; i++) {
    //                [_selections addObject:[NSNumber numberWithBool:NO]];
    //            }
    //        }
    
    // Show
    [self.navigationController pushViewController:browser animated:YES];
}


#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.bigImgArray.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.bigImgArray.count)
        return [MWPhoto photoWithURL:[NSURL URLWithString:self.bigImgArray[index]]];
    return nil;
}




#pragma mark - initCollectionView
-(void) initCollectionView{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor= [UIColor blackColor];
    
    self.collectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    
    //    [self.collectionView registerClass:[FSBCollectionViewCell class] forCellWithReuseIdentifier:@"FSBCollectionViewCell"];
    UINib * FSBCollectionViewCell=[UINib nibWithNibName:@"FSBCollectionViewCell" bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:FSBCollectionViewCell forCellWithReuseIdentifier:@"FSBCollectionViewCell"];
    
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    
    [self.view addSubview:self.collectionView];
    
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
