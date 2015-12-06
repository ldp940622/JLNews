//
//  SearchViewController.m
//
//
//  Created by 李大鹏 on 15/11/22.
//
//

#import "SearchViewController.h"
#import "JLNetworking.h"
#import "JLProgressHUD.h"
#import "NSString+Extension.h"
#import "JLDatabase.h"
#import "HistoryCollectionViewCell.h"
#import "UISearchBar+Extension.h"

#define HISTORYFONT [UIFont systemFontOfSize:15.0f]

@interface SearchViewController () <UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSMutableArray <NSString *> *historyArray;
@property (strong, nonatomic) UICollectionView *historyView;

@end

static const NSString *string = @"我是李大鹏,这是shaihdias";
@implementation SearchViewController

- (void)loadView {
    [super loadView];
    self.tableView.mj_header = nil;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.searchResultsUpdater = self;
    _searchController.dimsBackgroundDuringPresentation = NO;
    _searchController.searchBar.tintColor = self.navigationController.navigationBar.barTintColor;
    [_searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = _searchController.searchBar;
    _searchController.searchBar.delegate = self;
    [self.searchController.searchBar changeBackgroundColor:[UIColor whiteColor]];
    _searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    _searchController.searchBar.placeholder = @"请输入关键字进行搜索";
    
    _historyArray = [[JLDatabase sharedManager] getSearchHistory];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _historyView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    _historyView.backgroundColor = [UIColor clearColor];
    _historyView.delegate = self;
    _historyView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    if (searchController.active) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    } else {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    //    [JLProgressHUD sharedProgressHUD]
    NSString *filterStr = @"{\"order_by\":[{\"field\":\"id\",\"direction\":\"desc\"}],\"filters\":[{\"name\":\"title\",\"op\":\"like\",\"val\":\"%data%\"}]}";
    [_historyArray insertObject:searchBar.text atIndex:0];
    [[JLDatabase sharedManager] insertHistory:searchBar.text success:^{
    } failure:^{
        NULL;
    }];
    NSString *filter = [filterStr stringByReplacingOccurrencesOfString:@"data" withString:searchBar.text];
    NSDictionary *parameter = @{ @"q" : filter };
    [[JLNetworking sharedManager] requestWithURL:@"http://127.0.0.1:25000/api/news" method:JLRequestGET parameter:parameter success:^(id responseObject) {
        if ([[responseObject objectForKey:@"num_results"] integerValue] == 0) {
            [[JLProgressHUD sharedProgressHUD] showMessage:@"没有搜索到相关结果" hideDelay:1.0];
            [_historyView reloadData];
        } else {
            [self.newsArray removeAllObjects];
            for (NSDictionary *dic in[responseObject objectForKey:@"objects"]) {
                News *news = [News newsWithDict:dic];
                [self.newsArray addObject:news];
            }
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [_historyView reloadData];
        [[JLProgressHUD sharedProgressHUD] showMessage:@"网络错误" hideDelay:1.0];
    }];
    _searchController.active = NO;
}

#pragma mark - orverride tableview method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.newsArray.count == 0 && _historyArray.count > 0) {
        return 1;
    } else {
        return [super numberOfSectionsInTableView:tableView];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.newsArray.count == 0 && _historyArray.count > 0) {
        return 1;
    } else {
        return [super tableView:tableView numberOfRowsInSection:section];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.newsArray.count == 0 && _historyArray.count > 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"historyCell"];
        //        cell.textLabel.text = @"历史数据";
        [cell.contentView addSubview:_historyView];
        return cell;
    } else {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.newsArray.count == 0 && _historyArray.count > 0) {
        return _historyView.bounds.size.height;
    } else {
        return 100.0f;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.newsArray.count == 0 && _historyArray.count > 0)
        return @"搜索记录";
    else
        return @"";
}

#pragma mark - collectionView method

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (_historyArray.count > 0) {
        return 1;
    }
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _historyArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"HistoryCollectionViewCell";
    UINib *nib = [UINib nibWithNibName:@"HistoryCollectionViewCell" bundle:nil];
    [collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
    HistoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.historyLabel.frame = cell.bounds;
    cell.historyLabel.text = _historyArray[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [_historyArray[indexPath.row] rectByFont:HISTORYFONT andSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(20, 10, 5, 5);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@", _historyArray[indexPath.row]);
    _searchController.searchBar.text = _historyArray[indexPath.row];
    [self.tableView reloadData];
}

@end
