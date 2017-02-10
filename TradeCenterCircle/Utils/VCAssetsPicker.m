//
//  VCAssetsPicker.m
//  youka
//
//  Created by leijun on 14-7-28.
//  Copyright (c) 2014年 BlueRain. All rights reserved.
//

//# import "Common.h"
# import "VCAssetsPicker.h"
# import "BrowserScroView.h"
# import "AppDelegate.h"
#import "UIButtonExt.h"
# define kThumbnailLength    ([UIScreen mainScreen].bounds.size.width/3 - 3)
# define kThumbnailSize      CGSizeMake(kThumbnailLength, kThumbnailLength)

#pragma mark - Interfaces

@interface VCAssetsGroup : UITableViewController

@end


@interface VCAssetsGroup()

@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) NSMutableArray *groups;

@end


@interface VCAssets : UICollectionViewController

@property (nonatomic, strong) ALAssetsGroup *assetsGroup;
@property (nonatomic, strong) NSMutableArray *groups;
@property (nonatomic, strong) NSMutableArray *checkedTags;
@end

@interface VCAssets ()<UITableViewDelegate,UITableViewDataSource,BrowserScroViewDelegate>

@property (nonatomic,strong) UIButtonExt *finishedBtn;
@property (nonatomic,strong) UIButtonExt *ChanelBtn;
@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, assign) NSInteger numberOfPhotos;
@property (nonatomic, assign) NSInteger numberOfVideos;

@property (nonatomic,strong) UIView *toolView;
@property (nonatomic,strong) UIButtonExt *selectLibraryBtn;
@property (nonatomic,strong) UIButtonExt *preShowBtn;

@property (nonatomic,strong) UITableView *tvLibrary;
@end


@interface CTAssetsGroupViewCell : UITableViewCell

- (void)bind:(ALAssetsGroup *)assetsGroup;

@end

@interface CTAssetsGroupViewCell ()

@property (nonatomic, strong) ALAssetsGroup *assetsGroup;

@end


@interface CTAssetsViewCell : UICollectionViewCell

- (void)bind:(ALAsset *)asset;
@property (nonatomic, strong) UIButtonExt *btCheck;
@property (nonatomic, strong) UIButtonExt *allCheck;
@property (nonatomic, strong) UIImageView *checkImageView;

@end

@interface CTAssetsViewCell ()

@property (nonatomic, strong) ALAsset *asset;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIImage *videoImage;
@property (nonatomic, strong) UIImageView *imageView;
@end


@interface CTAssetsSupplementaryView : UICollectionReusableView

@property (nonatomic, strong) UILabel *sectionLabel;

- (void)setNumberOfPhotos:(NSInteger)numberOfPhotos numberOfVideos:(NSInteger)numberOfVideos;

@end


@interface CTAssetsSupplementaryView ()

@end






#pragma mark - CTAssetsPickerController


@implementation VCAssetsPicker

- (id)init
{
    VCAssetsGroup *groupViewController = [[VCAssetsGroup alloc] init];
    
    if (self = [super initWithRootViewController:groupViewController])
    {
        _maximumNumberOfSelection   = NSIntegerMax;
        _assetsFilter               = [ALAssetsFilter allAssets];
    }
    
    return self;
}
- (void)goBackAnimation
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end




#pragma mark - CTAssetsGroupViewController

@implementation VCAssetsGroup


- (id)init
{
    if (self = [super initWithStyle:UITableViewStylePlain])
    {
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupViews];
    [self setupButtons];
    [self localize];
    [self setupGroup];
    
}


#pragma mark - Setup

- (void)setupViews
{
    
    [self.navigationController.navigationBar setTranslucent:NO];//设置navigationbar的半透明
    self.title = @"navigationcontroller";//设置navigationbar上显示的标题
    [self.navigationController.navigationBar setBarTintColor:HexRGB(0x00b4a2)];//设置navigationbar的颜色
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.tableView.rowHeight = kThumbnailLength + 5;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage stretchImage:@"v12chatbackground6"]];
    self.tableView.backgroundColor =[UIColor whiteColor];
}

- (void)setupButtons
{
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem initWithTitle:@"取消" delegate:self action:@selector(dismiss:) ];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initWithImage:@"login_back" delegate:self action:@selector(dismiss:) ];
        
    
}

- (void)localize
{
    self.title = @"图片库";
}

- (void)setupGroup
{
    if (!self.assetsLibrary)
        self.assetsLibrary = [self.class defaultAssetsLibrary];
    
    if (!self.groups)
        self.groups = [[NSMutableArray alloc] init];
    else
        [self.groups removeAllObjects];
    
    VCAssetsPicker *picker = (VCAssetsPicker *)self.navigationController;
    ALAssetsFilter *assetsFilter = picker.assetsFilter;
    
    ALAssetsLibraryGroupsEnumerationResultsBlock resultsBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        
        if (group)
        {
            [group setAssetsFilter:assetsFilter];
            
            if (group.numberOfAssets > 0)
                [self.groups addObject:group];
            
        }
        else
        {
            [self reloadData];
        }
    };
    
    
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
        
        [self showNotAllowed];
        
    };
    
    // Enumerate Camera roll first
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                                      usingBlock:resultsBlock
                                    failureBlock:failureBlock];
    
    // Then all other groups
    NSUInteger type =
    ALAssetsGroupLibrary | ALAssetsGroupAlbum | ALAssetsGroupEvent |
    ALAssetsGroupFaces | ALAssetsGroupPhotoStream;
    
    [self.assetsLibrary enumerateGroupsWithTypes:type
                                      usingBlock:resultsBlock
                                    failureBlock:failureBlock];
}


#pragma mark - Reload Data

- (void)reloadData
{
    if (self.groups.count == 0)
        [self showNoAssets];
    
    [self.tableView reloadData];
}


#pragma mark - ALAssetsLibrary

+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}


#pragma mark - Not allowed / No assets

- (void)showNotAllowed
{
    self.title              = nil;
    
    UIView *lockedView      = [[UIView alloc] initWithFrame:self.view.bounds];
    UIImageView *locked     = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CTAssetsPickerLocked"]];
    
    
    CGRect rect             = CGRectInset(self.view.bounds, 8, 8);
    UILabel *title          = [[UILabel alloc] initWithFrame:rect];
    UILabel *message        = [[UILabel alloc] initWithFrame:rect];
    
    title.text              = NSLocalizedString(@"This app does not have access to your photos or videos.", nil);
    title.font              = [UIFont boldSystemFontOfSize:17.0];
    title.textColor         = [UIColor colorWithRed:129.0/255.0 green:136.0/255.0 blue:148.0/255.0 alpha:1];
    title.textAlignment     = NSTextAlignmentCenter;
    title.numberOfLines     = 5;
    
    message.text            = NSLocalizedString(@"You can enable access in Privacy Settings.", nil);
    message.font            = [UIFont systemFontOfSize:14.0];
    message.textColor       = [UIColor colorWithRed:129.0/255.0 green:136.0/255.0 blue:148.0/255.0 alpha:1];
    message.textAlignment   = NSTextAlignmentCenter;
    message.numberOfLines   = 5;
    
    [title sizeToFit];
    [message sizeToFit];
    
    locked.center           = CGPointMake(lockedView.center.x, lockedView.center.y - 40);
    title.center            = locked.center;
    message.center          = locked.center;
    
    rect                    = title.frame;
    rect.origin.y           = locked.frame.origin.y + locked.frame.size.height + 20;
    title.frame             = rect;
    
    rect                    = message.frame;
    rect.origin.y           = title.frame.origin.y + title.frame.size.height + 10;
    message.frame           = rect;
    
    [lockedView addSubview:locked];
    [lockedView addSubview:title];
    [lockedView addSubview:message];
    
    self.tableView.tableHeaderView  = lockedView;
    self.tableView.scrollEnabled    = NO;
}

- (void)showNoAssets
{
    UIView *noAssetsView    = [[UIView alloc] initWithFrame:self.view.bounds];
    
    CGRect rect             = CGRectInset(self.view.bounds, 10, 10);
    UILabel *title          = [[UILabel alloc] initWithFrame:rect];
    UILabel *message        = [[UILabel alloc] initWithFrame:rect];
    
    title.text              = NSLocalizedString(@"No Photos or Videos", nil);
    title.font              = [UIFont systemFontOfSize:26.0];
    title.textColor         = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
    title.textAlignment     = NSTextAlignmentCenter;
    title.numberOfLines     = 5;
    
    message.text            = NSLocalizedString(@"You can sync photos and videos onto your iPhone using iTunes.", nil);
    message.font            = [UIFont systemFontOfSize:18.0];
    message.textColor       = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
    message.textAlignment   = NSTextAlignmentCenter;
    message.numberOfLines   = 5;
    
    [title sizeToFit];
    [message sizeToFit];
    
    title.center            = CGPointMake(noAssetsView.center.x, noAssetsView.center.y - 10 - title.frame.size.height / 2);
    message.center          = CGPointMake(noAssetsView.center.x, noAssetsView.center.y + 10 + message.frame.size.height / 2);
    
    [noAssetsView addSubview:title];
    [noAssetsView addSubview:message];
    
    self.tableView.tableHeaderView  = noAssetsView;
    self.tableView.scrollEnabled    = NO;
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.groups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    CTAssetsGroupViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[CTAssetsGroupViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    [cell bind:[self.groups objectAtIndex:indexPath.row]];
    
    return cell;
}


#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kThumbnailLength + 12;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VCAssets *vc = [[VCAssets alloc] init];
    vc.assetsGroup = [self.groups objectAtIndex:indexPath.row];
    vc.groups = self.groups;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Actions

- (void)dismiss:(id)sender
{
    VCAssetsPicker *picker = (VCAssetsPicker *)self.navigationController;
    
    if ([picker.delegate respondsToSelector:@selector(assetsPickerControllerDidCancel:)])
        [picker.delegate assetsPickerControllerDidCancel:picker];
    
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

@end



#pragma mark - CTAssetsGroupViewCell

@implementation CTAssetsGroupViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        UILabel *line = [[UILabel alloc] init];
        line.backgroundColor = [UIColor colorWithRed:(45)/255.0 green:(71)/255.0 blue:(97)/255.0 alpha:1];
        line.frame = CGRectMake(110, kThumbnailLength + 5,[UIScreen mainScreen].bounds.size.width-80, 1);
        [self.contentView addSubview:line];
        
      //  self.textLabel.textColor = FYJ_TITLE_color;
    }
    return self;
}

- (void)bind:(ALAssetsGroup *)assetsGroup
{
    self.assetsGroup            = assetsGroup;
    
    CGImageRef posterImage      = assetsGroup.posterImage;
    size_t height               = CGImageGetHeight(posterImage);
    float scale                 = height / kThumbnailLength;
    self.backgroundColor = [UIColor clearColor];
    self.imageView.image        = [UIImage imageWithCGImage:posterImage scale:scale orientation:UIImageOrientationUp];
    self.textLabel.text         = [NSString stringWithFormat:@"%@(%ld)", [assetsGroup valueForProperty:ALAssetsGroupPropertyName],(long)[assetsGroup numberOfAssets]];
    self.accessoryType          = UITableViewCellAccessoryDisclosureIndicator;
}

- (NSString *)accessibilityLabel
{
    NSString *label = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    
    return [label stringByAppendingFormat:NSLocalizedString(@"%d Photos", nil), [self.assetsGroup numberOfAssets]];
}

@end




#pragma mark - CTAssetsViewController

#define kAssetsViewCellIdentifier           @"AssetsViewCellIdentifier"
#define kAssetsSupplementaryViewIdentifier  @"AssetsSupplementaryViewIdentifier"

@implementation VCAssets

- (id)init
{
    UICollectionViewFlowLayout *layout  = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize                     = kThumbnailSize;
    layout.sectionInset                 = UIEdgeInsetsMake(1.0, 0, 0, 0);
    layout.minimumInteritemSpacing      = 4.0;
    layout.minimumLineSpacing           = 4.0;
    layout.footerReferenceSize          = CGSizeMake(0, 44.0);
    
    if (self = [super initWithCollectionViewLayout:layout])
    {
        self.collectionView.allowsMultipleSelection = YES;
        
        [self.collectionView registerClass:[CTAssetsViewCell class]
                forCellWithReuseIdentifier:kAssetsViewCellIdentifier];
        
        [self.collectionView registerClass:[CTAssetsSupplementaryView class]
                forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                       withReuseIdentifier:kAssetsSupplementaryViewIdentifier];
        
        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
            [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    _checkedTags = [NSMutableArray array];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupViews];
    [self setupButtons];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupAssets];
}

//

#pragma mark - Setup

- (void)setupViews
{
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage stretchImage:@"v12chatbackground6"]];
    self.toolView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-50-63, [UIScreen mainScreen].bounds.size.width, 50)];
    self.toolView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:self.toolView];

    self.preShowBtn = [UIButtonExt buttonWithType:UIButtonTypeCustom];
    self.preShowBtn.frame = CGRectMake(10, 10, 60, 30);
    self.preShowBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.preShowBtn.layer.masksToBounds = YES;
    self.preShowBtn.layer.cornerRadius = 4;
    self.preShowBtn.layer.borderWidth = 1;
    self.preShowBtn.layer.borderColor = HexRGB(0xf4f4f4).CGColor;
    self.preShowBtn.backgroundColor =[UIColor whiteColor]; //[UIColor colorWithHexString:@"#0c9a23"];
    [self.preShowBtn setTitle:@"预览" forState:UIControlStateNormal];
    [self.preShowBtn setTitleColor:HexRGB(0x0c9a23) forState:UIControlStateNormal];
    [self.preShowBtn addTarget:self action:@selector(actionPreShow) forControlEvents:UIControlEventTouchUpInside];
    [self.toolView addSubview:self.preShowBtn];
    
    self.finishedBtn = [[UIButtonExt alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 70 , 10  , 60, 30)];
     [self.finishedBtn setBackgroundColor:HexRGB(0x0c9a23)];
    self.finishedBtn.titleLabel.font = [UIFont systemFontOfSize:16];
   // [self.finishedBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    self.finishedBtn.layer.masksToBounds = YES;
    self.finishedBtn.layer.cornerRadius = 4;
    [self.finishedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.finishedBtn addTarget:self action:@selector(finishPickingAssets:) forControlEvents:UIControlEventTouchUpInside];
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.finishedBtn];
    [self.toolView addSubview:self.finishedBtn];
    [self setSelectedNumOfPhoto:0];

    self.tvLibrary = [[UITableView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-29-40-4*(kThumbnailLength + 5), [UIScreen mainScreen].bounds.size.width, 4*(kThumbnailLength + 5))];
    self.tvLibrary.dataSource = self;
    self.tvLibrary.delegate = self;
    self.tvLibrary.rowHeight = kThumbnailLength + 5;
    self.tvLibrary.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tvLibrary.backgroundColor = [UIColor blackColor];
    self.tvLibrary.hidden = YES;
    [self.view addSubview:self.tvLibrary];
    
}
//点击预览按钮进入
-(void)actionPreShow
{
    if(!self.tvLibrary.hidden)
    {
        [self.tvLibrary setHidden:YES];
    }
    else
    {
        NSMutableArray *tags = [[NSMutableArray alloc] init];
        NSMutableArray *assets = [[NSMutableArray alloc] init];
        
        for (NSIndexPath *indexPath in self.collectionView.indexPathsForSelectedItems)
        {
            [assets addObject:[self.assets objectAtIndex:indexPath.item]];
            [tags addObject:[NSString stringWithFormat:@"%ld",(long)indexPath.item]];
        }
        BrowserScroView *browserScro = [[BrowserScroView alloc] init];
        browserScro.delegate = self;
        browserScro.showLimit = YES;
        browserScro.arrs = assets;
        VCAssetsPicker *vc = (VCAssetsPicker *)self.navigationController;
        browserScro.maxNumberOfSelected = vc.maximumNumberOfSelection;
        browserScro.selectedTag = tags;
        browserScro.currentPage = 0;
        [browserScro show];
    }
}
//点击图片进入
-(void)stepIntoPreShow:(NSInteger)start
{
    NSMutableArray *tags = [[NSMutableArray alloc] init];
    for (NSIndexPath *indexPath in self.collectionView.indexPathsForSelectedItems)
    {
        [tags addObject:[NSString stringWithFormat:@"%ld",(long)indexPath.item]];
    }
    BrowserScroView *browserScro = [[BrowserScroView alloc] init];
    browserScro.delegate = self;
    browserScro.arrs = self.assets;
    if(!start)
    {
        start=0;
    }
    browserScro.showLimit = NO;
    VCAssetsPicker *vc = (VCAssetsPicker *)self.navigationController;
    browserScro.maxNumberOfSelected = vc.maximumNumberOfSelection;
    browserScro.selectedTag = tags;
    browserScro.currentPage = start;
    [browserScro show];
}

#pragma mark  BrowserScro delegate
-(void)browserScroView:(BrowserScroView *)scroView isSelected:(BOOL)isSelected tag:(NSInteger)tag
{
    if(isSelected)
    {
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:tag inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        CTAssetsViewCell *cell = (CTAssetsViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:tag inSection:0]];
      //  cell.btCheck.selected = YES;
         cell.allCheck.selected = YES;
        NSString *indStr = [NSString stringWithFormat:@"%ld",(long)tag];
        if(![_checkedTags containsObject:indStr])
        {
            [_checkedTags addObject:indStr];
        }
    }
    else
    {
        [self.collectionView deselectItemAtIndexPath:[NSIndexPath indexPathForItem:tag inSection:0] animated:YES];
        CTAssetsViewCell *cell = (CTAssetsViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:tag inSection:0]];
       // cell.btCheck.selected = NO;
        cell.allCheck.selected = NO;

        NSString *indStr = [NSString stringWithFormat:@"%ld",(long)tag];
        if([_checkedTags containsObject:indStr])
        {
            [_checkedTags removeObject:indStr];
        }
    }
    [self setTitleWithSelectedIndexPaths:self.collectionView.indexPathsForSelectedItems];
}
-(void)browserScroView:(BrowserScroView *)scroView didSend:(NSArray *)arr
{
    [self finishPickingAssets:nil];
}

-(void)actionSelectLibrary
{
    self.tvLibrary.hidden = !self.tvLibrary.hidden;
}
- (void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setupButtons
{
    
    //UIImage *img = [UIImage imageNamed:@"v12nav_space_icon"];
    self.ChanelBtn = [[UIButtonExt alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
   // [self.finishedBtn setBackgroundImage:img forState:UIControlStateNormal];
    self.ChanelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.ChanelBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [self.ChanelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.ChanelBtn addTarget:self action:@selector(ChanelBtnPickingAssets) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.ChanelBtn];
    [self setSelectedNumOfPhoto:0];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initWithImage:@"login_back" delegate:self action:@selector(pop)];
}

-(void)ChanelBtnPickingAssets
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setSelectedNumOfPhoto:(NSInteger)num
{
    self.finishedBtn.enabled = num > 0;
    VCAssetsPicker *vc = (VCAssetsPicker *)self.navigationController;
    [self.finishedBtn setTitle:[NSString stringWithFormat:@"确定"] forState:UIControlStateNormal];
  [self.ChanelBtn setTitle:[NSString stringWithFormat:@"取消"] forState:UIControlStateNormal];
    if(num > 0)
    {
        self.preShowBtn.enabled = YES;
         self.preShowBtn.backgroundColor =[UIColor whiteColor];
        [self.finishedBtn setBackgroundColor:HexRGB(0x0c9a23)];
        
        [self.finishedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.preShowBtn setTitleColor:HexRGB(0x0c9a23) forState:UIControlStateNormal];
        [self.preShowBtn setTitle:[NSString stringWithFormat:@"预览"] forState:UIControlStateNormal];
         [self.finishedBtn setTitle:[NSString stringWithFormat:@"确定(%ld/%ld)",(long)num,(long)vc.maximumNumberOfSelection] forState:UIControlStateNormal];
         [self.finishedBtn setTitle:[NSString stringWithFormat:@"确定(%ld)",(long)num] forState:UIControlStateNormal];
        
    }
    else
    {
        self.preShowBtn.enabled = NO;
        [self.preShowBtn setTitle:@"预览" forState:UIControlStateNormal];
        [self.finishedBtn setBackgroundColor:HexRGB(0xf4f4f4)];
        [self.preShowBtn setBackgroundColor:HexRGB(0xf4f4f4)];
        [self.finishedBtn setTitleColor:HexRGB(0x999999) forState:UIControlStateNormal];
        [self.preShowBtn setTitleColor:HexRGB(0x999999) forState:UIControlStateNormal];

    }
    
}


- (void)setupAssets
{
    self.title = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    
    if (!self.assets)
        self.assets = [[NSMutableArray alloc] init];
    else
        [self.assets removeAllObjects];
    
    ALAssetsGroupEnumerationResultsBlock resultsBlock = ^(ALAsset *asset, NSUInteger index, BOOL *stop) {
        
        if (asset)
        {
            [self.assets addObject:asset];
            
            NSString *type = [asset valueForProperty:ALAssetPropertyType];
            
            if ([type isEqual:ALAssetTypePhoto])
                self.numberOfPhotos ++;
            if ([type isEqual:ALAssetTypeVideo])
                self.numberOfVideos ++;
        }
        
        else if (self.assets.count > 0)
        {
            [self.collectionView reloadData];
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.assets.count-1 inSection:0]
                                        atScrollPosition:UICollectionViewScrollPositionTop
                                                animated:YES];
        }
    };
    
    [self.assetsGroup enumerateAssetsUsingBlock:resultsBlock];
    
    [self setSelectedNumOfPhoto:0];
}

-(void)actionCheck:(UIButtonExt *)sender
{
    if(!self.tvLibrary.hidden)
    {
        [self.tvLibrary setHidden:YES];
    }
    else
    {
        VCAssetsPicker *vc = (VCAssetsPicker *)self.navigationController;
        
        if(!sender.selected)
        {
            if ([self.collectionView indexPathsForSelectedItems].count >= vc.maximumNumberOfSelection)
            {
                
                
                UIView *alphaView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height + 100)];
                alphaView.backgroundColor =[UIColor blackColor];
                alphaView.alpha = 0.9;
                alphaView.tag = 10000;
                [[AppDelegate sharedInstance].window addSubview:alphaView];
                
                UIView * view =[[UIView alloc]initWithFrame:CGRectMake(10, 100, self.view.frame.size.width - 20, 100)];
                view.backgroundColor = [UIColor whiteColor];
                view.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
                view.layer.masksToBounds = YES;
                view.layer.cornerRadius = 2;
                view.alpha = 1;
                [alphaView addSubview:view];
                
                UILabel * label = [[UILabel alloc]init];//
                label.text = @"最多只能选择9张照片";
                label.textColor = HexRGB(0x666666);
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont systemFontOfSize:14];
                [view addSubview:label];
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(view).with.offset(20);
                    make.left.equalTo(view).with.offset(50);
                    make.right.equalTo(view).with.offset(-50);
                    make.height.mas_equalTo(20);
                    
                }];
                UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 60, view.frame.size.width, 0.3)];
                view1.backgroundColor = [UIColor lightGrayColor];
                [view addSubview:view1];
                
                
                UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(0, 60, view.frame.size.width, 40);
                [button setTitle:@"知道了" forState:UIControlStateNormal];
                button.titleLabel.font =[UIFont systemFontOfSize:14];
                [button setTitleColor:HexRGB(0x666666) forState:UIControlStateNormal];                [button addTarget:self action:@selector(shanchuAlphaView) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:button];
                
                
                
                return;
            }
        }
        sender.selected = !sender.selected;
        if(sender.selected)
        {
            UIImageView * imageView = (UIImageView *)[[sender subviews] objectAtIndex:0];
            imageView.image = [UIImage imageNamed:@"photo_choose"];
            [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:sender.tag inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
            NSString *indStr = [NSString stringWithFormat:@"%ld",(long)sender.tag];
            if(![_checkedTags containsObject:indStr])
            {
                [_checkedTags addObject:indStr];
            }
        }
        else
        {
            UIImageView * imageView = (UIImageView *)[[sender subviews] objectAtIndex:0];

            imageView.image = [UIImage imageNamed:@""];
            [self.collectionView deselectItemAtIndexPath:[NSIndexPath indexPathForItem:sender.tag inSection:0] animated:YES];
            NSString *indStr = [NSString stringWithFormat:@"%ld",(long)sender.tag];
            if([_checkedTags containsObject:indStr])
            {
                [_checkedTags removeObject:indStr];
            }
        }
        [self setTitleWithSelectedIndexPaths:self.collectionView.indexPathsForSelectedItems];
    }
}
-(void)shanchuAlphaView
{
    UIView * view = [[AppDelegate sharedInstance].window viewWithTag:10000];
    [view removeFromSuperview];
}
#pragma mark - Collection View Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = kAssetsViewCellIdentifier;
    
    CTAssetsViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [cell bind:[self.assets objectAtIndex:indexPath.row]];
   // cell.btCheck.tag = indexPath.item;
    cell.allCheck.tag = indexPath.item;
    
    NSString *indStr = [NSString stringWithFormat:@"%ld",(long)indexPath.item];
    if([_checkedTags containsObject:indStr])
    {
       // [cell.btCheck setSelected:YES];
        cell.allCheck.selected = YES;
        cell.checkImageView.image = [UIImage imageNamed:@"photo_choose"];
    }
    else
    {
      //  [cell.btCheck setSelected:NO];
        cell.allCheck.selected = NO;
        cell.checkImageView.image = [UIImage imageNamed:@""];

    }
    [cell.allCheck addTarget:self action:@selector(actionCheck:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    static NSString *viewIdentifiert = kAssetsSupplementaryViewIdentifier;
    
    CTAssetsSupplementaryView *view =
    [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:viewIdentifiert forIndexPath:indexPath];
    
    [view setNumberOfPhotos:self.numberOfPhotos numberOfVideos:self.numberOfVideos];
    
    return view;
}


#pragma mark - Collection View Delegate
//-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    if(!self.tvLibrary.hidden)
//    {
//        [self.tvLibrary setHidden:YES];
//    }
//    [self stepIntoPreShow:indexPath.item];
//}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    VCAssetsPicker *vc = (VCAssetsPicker *)self.navigationController;
    //
    //    return ([collectionView indexPathsForSelectedItems].count < vc.maximumNumberOfSelection);
    if(!self.tvLibrary.hidden)
    {
        [self.tvLibrary setHidden:YES];
        
        return NO;
    }
  //  [self stepIntoPreShow:indexPath.item];
   //   CTAssetsViewCell *cell = (CTAssetsViewCell *)[collectionView subviews];
   //  [cell.btCheck addTarget:self action:@selector(actionCheck:) forControlEvents:UIControlEventTouchUpInside];
    return NO;
}
-(BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(!self.tvLibrary.hidden)
    {
        [self.tvLibrary setHidden:YES];
        return NO;
    }
  //  [self stepIntoPreShow:indexPath.item];
  //   CTAssetsViewCell *cell = (CTAssetsViewCell *)[collectionView superview];
  //  [cell.btCheck addTarget:self action:@selector(actionCheck:) forControlEvents:UIControlEventTouchUpInside];
    return NO;
}
//
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    //[self setTitleWithSelectedIndexPaths:collectionView.indexPathsForSelectedItems];
//    if(![collectionView cellForItemAtIndexPath:indexPath].selected)
//    {
//        [collectionView deselectItemAtIndexPath:indexPath animated:NO];
//    }
//    NSLog(@"sel:::%@",collectionView.indexPathsForSelectedItems);
//}
//
//- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    [self setTitleWithSelectedIndexPaths:collectionView.indexPathsForSelectedItems];
//}


#pragma mark - Title

- (void)setTitleWithSelectedIndexPaths:(NSArray *)indexPaths
{
    // Reset title to group name
    if (indexPaths.count == 0)
    {
        self.title = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
        [self setSelectedNumOfPhoto:0];
        
        return;
    }
    
    BOOL photosSelected = NO;
    BOOL videoSelected  = NO;
    
    for (NSIndexPath *indexPath in indexPaths)
    {
        ALAsset *asset = [self.assets objectAtIndex:indexPath.item];
        
        if ([[asset valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypePhoto])
            photosSelected  = YES;
        
        if ([[asset valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo])
            videoSelected   = YES;
        
        if (photosSelected && videoSelected)
            break;
    }
    
    //  NSString *format;
    
    //  VCAssetsPicker *vc = (VCAssetsPicker *)self.navigationController;
    
    
    [self setSelectedNumOfPhoto:indexPaths.count];
    
    //    UIButtonExt *rightBtn = (UIButtonExt *)self.navigationItem.rightBarButtonItem.customView;
    //    [rightBtn setTitle:[NSString stringWithFormat:@"(%d/%d)",indexPaths.count,vc.maximumNumberOfSelection] forState:UIControlStateNormal];
    /*
     if (photosSelected && videoSelected)
     format = NSLocalizedString(@"%d Items Selected", nil);
     
     else if (photosSelected)
     format = (indexPaths.count > 1) ? NSLocalizedString(@"%d Photos Selected", nil) : NSLocalizedString(@"%d Photo Selected", nil);
     
     else if (videoSelected)
     format = (indexPaths.count > 1) ? NSLocalizedString(@"%d Videos Selected", nil) : NSLocalizedString(@"%d Video Selected", nil);
     
     self.title = [NSString stringWithFormat:format, indexPaths.count];*/
}


#pragma mark - Actions

- (void)finishPickingAssets:(id)sender
{
    if(!self.tvLibrary.hidden)
    {
        [self.tvLibrary setHidden:YES];
    }
    else
    {
        NSMutableArray *assets = [[NSMutableArray alloc] init];
        
        for (NSIndexPath *indexPath in self.collectionView.indexPathsForSelectedItems)
        {
            [assets addObject:[self.assets objectAtIndex:indexPath.item]];
        }
        
        VCAssetsPicker *picker = (VCAssetsPicker *)self.navigationController;
        
        if ([picker.delegate respondsToSelector:@selector(assetsPickerController:didFinishPickingAssets:)])
            [picker.delegate assetsPickerController:picker didFinishPickingAssets:assets];
        
        [picker.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
    }
}

#pragma mark - VCAssets tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.groups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    CTAssetsGroupViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[CTAssetsGroupViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    [cell bind:[self.groups objectAtIndex:indexPath.row]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.assetsGroup = [self.groups objectAtIndex:indexPath.row];
    self.tvLibrary.hidden = YES;
    [self setupAssets];
}
@end



#pragma mark - CTAssetsViewCell

@implementation CTAssetsViewCell

static UIFont *titleFont = nil;

static CGFloat titleHeight;
static UIImage *videoIcon;
static UIColor *titleColor;
static UIImage *checkedIcon;
static UIColor *selectedColor;
static UIColor *strokeColor;

+ (void)initialize
{
    titleFont       = [UIFont systemFontOfSize:12];
    titleHeight     = 20.0f;
    videoIcon       = [UIImage imageNamed:@"CTAssetsPickerVideo"];
    titleColor      = [UIColor whiteColor];
    //checkedIcon     = [UIImage imageNamed:@"photoLibrarySelect"];//[UIImage imageNamed:(!IS_IOS7) ? @"CTAssetsPickerChecked~iOS6" : @"CTAssetsPickerChecked"];
    selectedColor   = [UIColor colorWithWhite:1 alpha:0.3];
    strokeColor     = [UIColor colorWithRed:58.0/255.0 green:174.0/255.0 blue:1 alpha:1];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.opaque                     = YES;
        self.isAccessibilityElement     = YES;
        self.accessibilityTraits        = UIAccessibilityTraitImage;
    }
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kThumbnailLength, kThumbnailLength)];
    [self.contentView addSubview:self.imageView];
//    self.btCheck = [UIButtonExt buttonWithType:UIButtonTypeCustom];
//    self.btCheck.backgroundColor = [UIColor clearColor];
//    self.btCheck.frame  = CGRectMake(kThumbnailLength - 30, 0, 30, 30);
//    [self.btCheck setImage:[UIImage imageNamed:@"选中-对号"] forState:UIControlStateNormal];
//    [self.btCheck setImage:[UIImage imageNamed:@"图片-选中"] forState:UIControlStateSelected];
//    [self.contentView addSubview:self.btCheck];
    
    self.allCheck = [UIButtonExt buttonWithType:UIButtonTypeCustom];
    self.allCheck.frame = CGRectMake(0, 0, kThumbnailLength, kThumbnailLength);
    [self.contentView addSubview:self.allCheck];
    self.checkImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kThumbnailLength - 30, 3, 25, 25)];
    [self.allCheck addSubview:self.checkImageView];
//    if (self.allCheck.selected == YES)
//    {
//        self.checkImageView.image = [UIImage imageNamed:@"图片-选中"];
//    }
//    else
//    {
//        self.checkImageView.image = [UIImage imageNamed:@"选中-对号"];
//    }

    
    return self;
}

- (void)bind:(ALAsset *)asset
{
    self.asset  = asset;
    self.image  = [UIImage imageWithCGImage:asset.thumbnail];
    self.type   = [asset valueForProperty:ALAssetPropertyType];
    // self.title  = [NSDate timeDescriptionOfTimeInterval:[[asset valueForProperty:ALAssetPropertyDuration] doubleValue]];
    self.imageView.image = self.image;
}


@end


#pragma mark - CTAssetsSupplementaryView

@implementation CTAssetsSupplementaryView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _sectionLabel               = [[UILabel alloc] initWithFrame:CGRectInset(self.bounds, 8.0, 8.0)];
        _sectionLabel.font          = [UIFont systemFontOfSize:18.0];
        _sectionLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_sectionLabel];
    }
    
    return self;
}

- (void)setNumberOfPhotos:(NSInteger)numberOfPhotos numberOfVideos:(NSInteger)numberOfVideos
{
    NSString *title;
    
    if (numberOfVideos == 0)
        title = [NSString stringWithFormat:NSLocalizedString(@"%d Photos", nil), numberOfPhotos];
    else if (numberOfPhotos == 0)
        title = [NSString stringWithFormat:NSLocalizedString(@"%d Videos", nil), numberOfVideos];
    else
        title = [NSString stringWithFormat:NSLocalizedString(@"%d Photos, %d Videos", nil), numberOfPhotos, numberOfVideos];
    
    //self.sectionLabel.text = title;
}

@end



