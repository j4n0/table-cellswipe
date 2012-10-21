
// BSD License. Created by jano@jano.com.es

#import "TableCell.h"

@implementation TableCell

// Add the menu subview.
-(void) addMenuView {
    if (self.menuView==nil){
        // This menu usually has buttons with actions to perform on the row.
        self.menuView = [[UIView alloc] initWithFrame:self.frame];
        self.menuView.backgroundColor = [UIColor grayColor];
        [self.superview insertSubview:self.menuView belowSubview:self];
    }
}

// Remove the menu subview.
-(void) removeMenuView {
    if (self.menuView){
        [self.menuView removeFromSuperview];
        self.menuView = nil;
    }
}

// Remove any existing menu view before the cell is reused.
- (void)prepareForReuse {
    [self removeMenuView];
}

@end
