//
//  FBSGirlCollectionVC.m
//  FullScreenBrowser
//
//  Created by HTC on 2016/11/2.
//  Copyright © 2016年 HTC. All rights reserved.
//

#import "FSBGirlCollectionVC.h"

#import "UIImageView+WebCache.h"

#import "FSB-swift.h"

#import "FSBGirlDetailVC.h"


#define Screen_WIDTH                    [UIScreen mainScreen].bounds.size.width
#define ColCell_Item_WIDTH             ((Screen_WIDTH - 3*10 )/2)
#define ColCell_Item_HIGHT             (ColCell_Item_WIDTH +40+2+5+25)

#define K_Img_List @"http://api.bj-yfjn.com/api/getTopicList.php?modelType=street"
#define K_Img_URL @"http://f.tmdtime.com/"

@interface FSBGirlCollectionVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

/**  collection */
@property(nonatomic,strong) UICollectionView *collectionView;
/**  列表模型 */
@property(nonatomic,strong) NSMutableArray *listArray;

@end

@implementation FSBGirlCollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.title = @"街拍美女";
    
    [self initCollectionView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (!self.listArray.count) {
        [self featchList];
    }
}

- (void)featchList{
    HTTPTools * http = [HTTPTools shareHTTPTools];
    
    //from=apple&idfv=AA272AD2-8BBF-4BBE-B78B-B357B9D22259&content=1&listType=all&version=5.5
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"apple" forKey:@"from"];
    [parameters setObject:@"AB432CC9-4CDB-4AAB-A97C-D12457DBA2259" forKey:@"idfv"];
    [parameters setObject:@"1" forKey:@"content"];
    [parameters setObject:@"all" forKey:@"listType"];
    [parameters setObject:@"5.5" forKey:@"version"];
    
    [http HTTPPOSTWithURLString:K_Img_List parameters:parameters progress:^(NSProgress * _Nonnull progress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        
        NSArray * imageArr = responseObject;
        if (imageArr.count) {
            [self.listArray addObjectsFromArray:imageArr];
            
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
    
    NSInteger count = self.listArray.count;
    
    return count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FSBCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FSBCollectionViewCell" forIndexPath:indexPath];
    
    NSString * thumb = [self.listArray[indexPath.row] objectForKey:@"thumb"];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[K_Img_URL stringByAppendingString:thumb]]];
    // http://f.tmdtime.com/data/beautyleg/0/0/45882beautyleg_s.jpg
    
    /*
     {
     extra = 0;
     level = 0;
     model = fei;
     pnum = 60;
     sdate = "2010-08-20";
     sid = 290253;
     sname = "No.001 Fei  \U4e2d\U570b\U4e0a\U6d77";
     sno = 1;
     thumb = "data/beautyleg/1/1/1beautyleg_s.jpg";
     tid = 2;
     }
     */
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
    NSDictionary * imageDic = self.listArray[indexPath.row];
    /*
     {
     extra = 0;
     level = 0;
     model = fei;
     pnum = 60;
     sdate = "2010-08-20";
     sid = 290253;
     sname = "No.001 Fei  \U4e2d\U570b\U4e0a\U6d77";
     sno = 1;
     thumb = "data/beautyleg/1/1/1beautyleg_s.jpg";
     tid = 2;
     }
     */
    FSBGirlDetailVC * vc = [[FSBGirlDetailVC alloc]init];
    vc.title = [imageDic objectForKey:@"sname"];
    vc.tid = [imageDic objectForKey:@"tid"];
    [self.navigationController pushViewController:vc animated:YES];
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
- (NSMutableArray *)listArray{
    if (_listArray == nil) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
