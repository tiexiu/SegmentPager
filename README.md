# SegmentPager
头视图+标题栏+横滚视图 ，scrollView嵌套<br>


下面两种实现方式用的是都是同一套标题栏和横滚视图，实现了比较基础的功能。<br>
横滚标题栏是用UIScrollView实现；下部横滚视图用UICollectionView装载。<br>

STYLE 1:Each SubTableView Can Pull To Refresh<br>
![image](https://github.com/tiexiu/SegmentPager/blob/master/GIF/Each_SubTableView_Can_Pull_To_Refresh.gif)
<br>

结构：<br>
static CGFloat const bannerHeight;<br>
static CGFloat const titleHeight;<br>
static CGFloat const sumBannerTitleHeight =bannerHeight + titleHeight;<br>


<ParentViewController.View><br>
|    |<br>
| <HorizontalCollectionView>                          (frame = parentView.frame , contentSize = (subVCArray.count * parentView.width, parentView.height) )<br>
|    | <SubViewController1.view>                     (frame = horizontalCollectionView.frame , edgeInsets.top = bannerHeight + titleHeight)<br>
|    | <SubViewController2.view>                     (same with SubViewController1)<br>
|    | <SubViewController3.view>                     (same with SubViewController1)<br>
|    |<br>
| <ClearBackgroundView>                                (frame = parentView.frame , color = clearColor)<br>
|    | <BannerView>                                          (frame = 0,0,bannerHeight, backgroundView.width)<br>
|    | <TitleScrollerView>                                   (frame = 0,banner.bottom, titleHeight, backgroundView.width)<br>

结构图：<br>
![image](https://github.com/tiexiu/SegmentPager/blob/master/GIF/style1.gif)
<br>


说明：<br>
把banner和titleScrollView所在的透明父视图在横滚HorizontalCollectionView上方，当HorizontalCollectionView的子tableView上移时也可以做到遮挡banner，主要是用到了clipsToBounds这个属性。<br>
也可以直接把banner，titleScrollView都直接放到横滚HorizontalCollectionView上，在横滚时实时更新banner的frame也可以。<br>

逻辑：<br>
SubViewController继承自抽象类BaseScrollViewConroller, 它的@property (baseScrollView) 指向SubViewControllers的子视图：tableView,CollectionView,ScrollerView。<br>

BaseScrollViewConroller.baseScrollView.scrollDelegate --> ParentViewController --> (负责在当前页面上下滑动时更新TitleScrollView在垂直方向的位置)<br>
HorizontalCollectionView.displayCellDelegate --> ParentViewController --> (负责记录和更新horizontalCollectionView视图左右横滚时Title的位置)<br>

HorizontalCollectionView.scollDelegate --> ParentViewController --> (负责更新TitleScrollView当前的选定标题)<br>
TitleScrollerView.clickDelegate -->ParentVieController --> (负责更新下方横滚视图滚动到哪一页)<br>





STYLE 2:Only Main SuperView Can Pull To Refresh.gif<br>
![image](https://github.com/tiexiu/SegmentPager/blob/master/GIF/Only_Main_SuperView_Can_Pull_To_Refresh.gif)
<br>

结构:<br>

static CGFloat const titleScrollHeight ;<br>
static CGFloat const bannerHeight;<br>

<ParentViewController.View><br>
|    |<br>
| <SuperScrollView>                                             (frame =  parentView.frame , edgeInsets.top = bannerHeight , contentOffset.y = -bannerHeight)<br>
|    |<br>
|    | <BannerView>                                               (frame = (0, -bannerHeight, superView.width, bannerHeight) )<br>
|    | <TitleScrollView>                                           (frame = (0, 0, superView.width, titleScrollHeight) )<br>
|    | <HorizontalCollectionView>                          (frame = (0, titleScrollView.bottom, superView.width, superView.height - titleScrollHeight )<br>
|    |    |<br>
|    |    | <SubViewController1.view>                     (frame = (0, 0, horizontalCollectionView.size) , edgeInsets.top = 0)<br>
|    |    | <SubViewController2.view>                     (same with SubViewController1)<br>
|    |    | <SubViewController3.view>                     (same with SubViewController1)<br>

结构图：<br>
![image](https://github.com/tiexiu/SegmentPager/blob/master/GIF/style2.gif)
<br>

说明：<br>
SuperScrollView 是一个可以上下滚动的scrollView,默认edgeInsets.top=bannerHeight, 上部空白区域放置bannerView; 下部可见区域放titleScrollView和横滚HorizontalCollectionView。
需要重写每个SubViewController.scrollView的一个方法:<br>
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;<br>
当SubViewController.scrollView上下滚动时SuperScrollView也能接受手势上下滚动，然后对滚动事件做处理；<br>
因为TitleScrollView的origin是(0,0),本身无论什么时侯都跟随SuperScrollView的滚动而且一直在SuperScrollView可见区域的最顶部，所以不用对TitleScrollView的位置做处理，需要处理的是
SuperScrollView和SubViewControllers的滚动时机和偏移量。<br>
控制滚动时机用的是setContentOffset，不能使用scrollEnabled或userInteractionEnabled属性，会导致滚动不连贯。<br>


逻辑:<br>
SubViewController继承自抽象类BaseScrollViewConroller, 它的@property (baseScrollView) 指向SubViewControllers的子视图：tableView,CollectionView,ScrollerView。<br>

BaseScrollViewConroller.baseScrollView.scrollDelegate --> ParentViewController --> (负责控制自身的偏移量以及SuperScrollView的滚动状态)<br>
SuperScrollView.scrollDelegate --> ParentViewController --> (接受SubScrollView的指令来确认是否可以滚动，如果不可以滚动，固定自身偏移量)<br>

HorizontalCollectionView.scollDelegate --> ParentViewController --> (负责更新TitleScrollView当前的选定标题)<br>
TitleScrollerView.clickDelegate -->ParentVieController --> (负责更新下方横滚视图滚动到哪一页)<br>



