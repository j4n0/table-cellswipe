
// BSD License. Created by jano@jano.com.es

#import "TableVC.h"

@interface TableVC()
@property (nonatomic,strong) NSMutableSet *swipedCells;
@end


@implementation TableVC

#pragma mark - Swiping

- (void)swipeLeft:(UISwipeGestureRecognizer *)recognizer {
    [self swipe:recognizer direction:UISwipeGestureRecognizerDirectionLeft];
}

- (void)swipeRight:(UISwipeGestureRecognizer *)recognizer {
    [self swipe:recognizer direction:UISwipeGestureRecognizerDirectionRight];
}


-(void) setupGestureRecognizers
{
    UISwipeGestureRecognizer* leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.tableView addGestureRecognizer:leftSwipeGestureRecognizer];
    
    UISwipeGestureRecognizer* rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.tableView addGestureRecognizer:rightSwipeGestureRecognizer];
}


- (void)swipe:(UISwipeGestureRecognizer *)recognizer direction:(UISwipeGestureRecognizerDirection)direction
{
    if ( recognizer && (recognizer.state == UIGestureRecognizerStateEnded) )
    {
        // find swiped cell
        CGPoint location = [recognizer locationInView:self.tableView];
        NSIndexPath* indexPath = [self.tableView indexPathForRowAtPoint:location];
        TableCell* cell = (TableCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        
        [self animateCell:cell direction:recognizer.direction];
    }
}


-(void) animateCell:(TableCell*)cell direction:(UISwipeGestureRecognizerDirection)direction
{        
    if ( (direction == UISwipeGestureRecognizerDirectionRight) && (cell.frame.origin.x==0) ){
        
        if ([self.swipedCells count]>0){
            [self animateLeft:self.swipedCells];
        }
        [self animateRight:cell];
        
    } else if ( (direction == UISwipeGestureRecognizerDirectionLeft) && (cell.frame.origin.x!=0) ){
        [self animateLeft:[NSSet setWithObject:cell]];
    }
}


-(void) animateLeft:(NSMutableSet*)cells
{
    for (TableCell* cell in  cells){
        CGRect newFrame = CGRectMake(0, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
        [UIView animateWithDuration:0.2 animations:^{
            cell.frame = newFrame;
        } completion:^(BOOL finished) {
            [cell removeMenuView];
            [self.swipedCells removeObject:cell];
        }];
    }
}


-(void) animateRight:(TableCell*)cell
{
    const CGFloat kVisibleWidth = 100.0;

    if (![self.swipedCells containsObject:cell]){
        [self.swipedCells addObject:cell];
        [cell addMenuView];
        CGRect newFrame = CGRectMake(cell.frame.size.width-kVisibleWidth, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
        [UIView animateWithDuration:0.2 animations:^{
            cell.frame = newFrame;
        }];
    }
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.swipedCells count]>0){
        [self animateLeft:self.swipedCells];
    }
}


#pragma mark - UITableViewDelegate

- (void) deselect:(id)sender {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)newIndexPath {
    [self performSelector:@selector(deselect:) withObject:nil afterDelay:0.5f];
    [self animateLeft:self.swipedCells];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65.0;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* const identifier = @"Cell";
    TableCell *cell = (TableCell*)[self.tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%d",[indexPath row]];
    return cell;
}


#pragma mark - UIViewController

-(void) viewDidLoad {
    [super viewDidLoad];
    [self setupGestureRecognizers];
    self.swipedCells = [NSMutableSet set];
}

@end
