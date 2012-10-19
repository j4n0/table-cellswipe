
// BSD License. Created by jano@jano.com.es
// This file is commented in insultating detail for beginners.

#import "TableVC.h"


// Visible width of the cell when the cell is animated right.
const CGFloat kVisibleWidth = 100.0;


@interface TableVC()
// Keep a reference to all swiped cells.
@property (nonatomic,strong) NSMutableSet *swipedCells;
@end


@implementation TableVC

#pragma mark - UIViewController

-(void) viewDidLoad {
    [super viewDidLoad];
    [self setupSwipeRecognizers];
    self.swipedCells = [NSMutableSet set];
}


#pragma mark - Swiping

// Setup a left and right swipe recognizer.
-(void) setupSwipeRecognizers
{
    UISwipeGestureRecognizer* leftSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    leftSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.tableView addGestureRecognizer:leftSwipeRecognizer];
    
    UISwipeGestureRecognizer* rightSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    rightSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.tableView addGestureRecognizer:rightSwipeRecognizer];
}


// Called when a swipe is performed.
- (void)swipe:(UISwipeGestureRecognizer *)recognizer
{
    bool doneSwiping = recognizer && (recognizer.state == UIGestureRecognizerStateEnded);
    
    if (doneSwiping)
    {
        // find the swiped cell
        CGPoint location = [recognizer locationInView:self.tableView];
        NSIndexPath* indexPath = [self.tableView indexPathForRowAtPoint:location];
        TableCell* swipedCell = (TableCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        
        if ((recognizer.direction==UISwipeGestureRecognizerDirectionRight) && (swipedCell.frame.origin.x==0) )
        {
            [self shiftLeft:self.swipedCells];  // animate all cells left
            [self shiftRight:swipedCell];       // animate swiped cell right
        }
        else if ((recognizer.direction == UISwipeGestureRecognizerDirectionLeft) && (swipedCell.frame.origin.x==swipedCell.frame.size.width-kVisibleWidth))
        {
            [self shiftLeft:[NSSet setWithObject:swipedCell]]; // animate current cell left
        }
        
    }
}


// Animates the cells to the left to x-origin = 0.
-(void) shiftLeft:(NSMutableSet*)cells
{
    if ([cells count]>0)
    {
        for (TableCell* cell in  cells)
        {
            // shift the cell left and remove its menu view
            CGRect newFrame = CGRectMake(0, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
            [UIView animateWithDuration:0.2 animations:^{
                cell.frame = newFrame;
            } completion:^(BOOL finished) {
                [cell removeMenuView];
            }];
        }
        
        // update the set of swiped cells
        [self.swipedCells minusSet:cells];
    }
}


// Animates the cells to the right to x-origin = (width - kVisibleWidth).
-(void) shiftRight:(TableCell*)cell
{
    bool cellAlreadySwiped = [self.swipedCells containsObject:cell];
    if (!cellAlreadySwiped)
    {
        // add the cell menu view and shift the cell to the right
        [cell addMenuView];
        CGRect newFrame = CGRectMake(cell.frame.size.width-kVisibleWidth, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
        [UIView animateWithDuration:0.2 animations:^{
            cell.frame = newFrame;
        }];
        
        // update the set of swiped cells
        [self.swipedCells addObject:cell];
    }
}


#pragma mark - UIScrollViewDelegate

// un-swipe everything when the user scrolls
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self shiftLeft:self.swipedCells];
}


#pragma mark - UITableViewDelegate

// Un-swipe everything when the user selects a cell.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)newIndexPath
{
    [self shiftLeft:self.swipedCells];
    [self performSelector:@selector(deselectSelectedCell) withObject:nil afterDelay:0.5f];
}

- (void) deselectSelectedCell {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
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


@end
