
// BSD License. Created by jano@jano.com.es

@interface TableCell : UITableViewCell
@property(nonatomic,strong) UIView *menuView;

-(void) addMenuView;
-(void) removeMenuView;
@end
