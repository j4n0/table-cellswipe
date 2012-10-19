
// BSD License. Created by jano@jano.com.es

#import "TableCell.h"

@implementation TableCell

-(void) addMenuView {
    if (self.menuView==nil){
        self.menuView = [[UIView alloc] initWithFrame:self.frame];
        self.menuView.backgroundColor = [UIColor grayColor];
        [self.superview insertSubview:self.menuView belowSubview:self];
    }
}

-(void) removeMenuView {
    if (self.menuView){
        [self.menuView removeFromSuperview];
        self.menuView = nil;
    }
}

- (void)prepareForReuse {
    [self removeMenuView];
}

@end
