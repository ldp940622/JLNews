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

@interface SearchViewController () <UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating, UINavigationControllerDelegate>
@property (strong, nonatomic) UISearchController *searchController;
//@property (copy, nonatomic) NSArray *resultArray;

@end

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
    //    _searchController.searchBar.backgroundColor = [uico]
    [_searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = _searchController.searchBar;
    _searchController.searchBar.delegate = self;
    _searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    _searchController.searchBar.placeholder = @"请输入关键字进行搜索";
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
    NSString *filterStr = @"{\"order_by\":[{\"field\":\"id\",\"direction\":\"desc\"}],\"filters\":[{\"name\":\"keywords\",\"op\":\"like\",\"val\":\"%data%\"}]}";
    NSString *filter = [filterStr stringByReplacingOccurrencesOfString:@"data" withString:searchBar.text];
    NSDictionary *parameter = @{ @"q" : filter };
    [[JLNetworking sharedManager] requestWithURL:@"http://127.0.0.1:25000/api/news" method:JLRequestGET parameter:parameter success:^(id responseObject) {
        if ([[responseObject objectForKey:@"num_results"] integerValue] == 0) {
            [[JLProgressHUD sharedProgressHUD] showMessage:@"没有搜索到相关结果" hideDelay:1.0];
        } else {
            for (NSDictionary *dic in[responseObject objectForKey:@"objects"]) {
                News *news = [News newsWithDict:dic];
                [self.newsArray addObject:news];
            }
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [[JLProgressHUD sharedProgressHUD] showMessage:@"网络错误" hideDelay:1.0];
    }];
    _searchController.active = NO;
}

/*
 * #pragma mark - Navigation
 *
 * // In a storyboard-based application, you will often want to do a little preparation before navigation
 * - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 *  // Get the new view controller using [segue destinationViewController].
 *  // Pass the selected object to the new view controller.
 * }
 */

@end
