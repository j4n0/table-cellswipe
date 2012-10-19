
// BSD License. Created by jano@jano.com.es

#import "TableCell.h"

/* Table view with swipe-able cells.
 *
 * Requirements:
 *   - When the user swipes a cell, the cell is shifted in the direction of the swipe.
 *     The cell is completely shifted beyond the frame except for 'kVisibleWidth' pixels.
 *   - If several cells are swiped at once, all of them except the last are un-shifted.
 *   - If any cell is selected, or the user scrolls the table, all cells are un-shifted.
 */
@interface TableVC : UITableViewController 
@end
