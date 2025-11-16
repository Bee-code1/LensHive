# Cart Screen Testing Checklist

## Visual Verification

### Design Tokens
- [ ] Background color: #F3F4F6 (`DesignTokens.background`)
- [ ] Card color: #FFFFFF (`DesignTokens.card`)
- [ ] Card radius: 20px (`DesignTokens.radiusCard`)
- [ ] Image radius: 12px (`DesignTokens.radiusInput`)
- [ ] Quantity stepper radius: 12px (`DesignTokens.radiusChip`)
- [ ] Sticky footer has subtle shadow (y=6, blur=24, opacity=0.08)
- [ ] 12px gap between footer and bottom nav

### Spacing
- [ ] Card padding: 12px (`spaceMd`)
- [ ] List item separator: 12px (`spaceMd`)
- [ ] Summary row gaps: 4px (`spaceXs`)
- [ ] Section gaps: 16px (`spaceLg`)
- [ ] Page padding: 16px (`spaceLg`)

### Typography
- [ ] Product name: titleMedium (2 line max)
- [ ] Unit price: bodyMedium 14px gray
- [ ] Summary labels: bodyMedium
- [ ] Total: titleLarge 18px semibold
- [ ] Warnings: bodySmall with color

### Colors
- [ ] Warning text: #F59E0B (warning color)
- [ ] Error text: #EF4444 (error color)
- [ ] Success discount: #10B981 (success color)
- [ ] Border: gray-300 equivalent
- [ ] Text primary: #111827
- [ ] Text secondary: #6B7280

## Functional Tests

### Quantity Changes
- [ ] Click + button → quantity increases
- [ ] Click - button → quantity decreases
- [ ] Quantity updates recalculate subtotal immediately
- [ ] Quantity updates recalculate discount if applicable
- [ ] Quantity updates recalculate shipping if threshold crossed
- [ ] Quantity updates recalculate total
- [ ] Decrement from 1 → item removed
- [ ] Loading state during quantity update (brief)

### Stock Warnings
- [ ] Warning "Only 5 left" appears when quantity > 5 (simulated)
- [ ] Warning appears in warning color (#F59E0B)
- [ ] Out of stock items show "Out of stock" in error color
- [ ] Out of stock items have no quantity controls
- [ ] Out of stock items excluded from total calculations

### Remove Item
- [ ] Trash icon click → item removed
- [ ] Swipe right-to-left → red background appears
- [ ] Complete swipe → item removed
- [ ] List updates smoothly
- [ ] Totals recalculate
- [ ] If last item removed → empty state appears

### Checkout Flow
- [ ] Click "Proceed to Checkout"
- [ ] Loading dialog appears immediately
- [ ] Verification runs (1-2 second delay)
- [ ] Loading dialog closes

#### Verification Success (80% chance)
- [ ] Navigation to /checkout
- [ ] Checkout stub screen appears
- [ ] Shows "Checkout Flow Stubbed. Cart verified."
- [ ] "Back to Cart" button returns to cart

#### Verification Issues (20% chance)
- [ ] Bottom sheet slides up
- [ ] Shows warning icon (amber)
- [ ] Title: "We updated your cart"
- [ ] Description text
- [ ] Bullet list of specific issues
- [ ] "Try Again" button (outlined)
- [ ] "Review Cart" button (primary)
- [ ] Sheet is draggable
- [ ] Sheet is dismissible

### Bottom Sheet Actions
- [ ] "Review Cart" → closes sheet, stays on cart
- [ ] "Try Again" → closes sheet, runs verification again
- [ ] Swipe down → dismisses sheet
- [ ] Tap outside → dismisses sheet
- [ ] Issue list updates based on actual changes

### Empty State
- [ ] Remove all items → empty state appears
- [ ] Shows circular cart icon illustration
- [ ] "Your cart is empty" heading
- [ ] "Add items to get started" subtitle
- [ ] "Continue Shopping" button present
- [ ] "Continue Shopping" → navigates to /home

### Error State
- [ ] If cart fails to load → error icon
- [ ] Shows "Failed to load cart"
- [ ] Shows error message
- [ ] (Manual test: break API)

### Loading State
- [ ] On initial load → centered spinner
- [ ] No flickering between states
- [ ] Smooth transition to content

## Business Logic

### Discount Calculation
- [ ] Subtotal ≤ PKR 10,000 → no discount
- [ ] Subtotal > PKR 10,000 → 10% discount
- [ ] Discount row appears only when > 0
- [ ] Discount shown in green
- [ ] Discount correctly subtracted from total

### Shipping Calculation
- [ ] (Subtotal - Discount) ≤ PKR 8,000 → PKR 250 shipping
- [ ] (Subtotal - Discount) > PKR 8,000 → Free shipping
- [ ] "Free shipping" label appears when PKR 0
- [ ] Shipping correctly added to total

### Total Calculation
- [ ] Total = Subtotal - Discount + Shipping
- [ ] Updates immediately on any change
- [ ] Formatted as "PKR X,XXX"

## Currency Formatting

- [ ] All amounts formatted with thousands separator
- [ ] Format: "PKR 14,999" (no decimals)
- [ ] No trailing zeros
- [ ] Consistent spacing

## Interactions

### Touch Targets
- [ ] Quantity +/- buttons: easy to tap
- [ ] Remove button: easy to tap
- [ ] Swipe area: full card width
- [ ] Checkout button: full width, adequate height

### Feedback
- [ ] Buttons have tap feedback (ink splash)
- [ ] Quantity stepper has visual feedback
- [ ] Swipe shows red delete background
- [ ] Loading states are clear

### Animations
- [ ] Swipe-to-delete animates smoothly
- [ ] Item removal animates (list collapse)
- [ ] Bottom sheet slides from bottom
- [ ] Bottom sheet has drag handle
- [ ] State changes are smooth (no jank)

## Responsive Behavior

- [ ] Cards fill width with margins
- [ ] Images maintain 64×64px size
- [ ] Text wraps properly (2 lines max for names)
- [ ] Summary rows align properly
- [ ] Sticky footer stays at bottom
- [ ] Bottom sheet adapts to content
- [ ] Works on various screen sizes

## Widget Keys (for automation)

- [ ] `cart_item_line_1` exists
- [ ] `cart_qty_plus_line_1` exists
- [ ] `cart_qty_minus_line_1` exists
- [ ] `cart_remove_line_1` exists
- [ ] `cart_proceed_btn` exists

## Edge Cases

- [ ] Empty cart → empty state
- [ ] Single item → no visual issues
- [ ] Many items → scrollable
- [ ] Long product names → ellipsis after 2 lines
- [ ] Very high quantities → no overflow
- [ ] Large totals → proper formatting
- [ ] Network delay → shows loading
- [ ] Multiple rapid taps → no race conditions
- [ ] Back button → navigates correctly

## Integration

- [ ] Cart loads from provider on mount
- [ ] State persists during navigation
- [ ] Navigate away and back → state maintained
- [ ] Bottom nav remains visible
- [ ] Back button works correctly

## Sample Test Scenario

1. **Initial State**
   - Open app → navigate to /cart
   - Should show 4 items
   - Verify subtotal, discount (if > 10k), shipping, total

2. **Quantity Changes**
   - Increase quantity on item 1
   - Verify total updates
   - Decrease quantity back
   - Verify total matches original

3. **Remove Item**
   - Tap trash icon on item 4
   - Verify item removed
   - Verify totals recalculate
   - Verify discount/shipping adjust if needed

4. **Swipe Delete**
   - Swipe item 3 right-to-left
   - See red background
   - Complete swipe
   - Verify item removed

5. **Checkout Success**
   - Tap "Proceed to Checkout"
   - Wait for verification
   - If successful:
     - Navigate to checkout stub
     - See success message
     - Return to cart

6. **Checkout with Issues**
   - Tap "Proceed to Checkout" again
   - Wait for verification
   - If issues (may need to retry):
     - Bottom sheet appears
     - See warning and issue list
     - Tap "Review Cart"
     - Sheet closes
     - Review changes

7. **Empty Cart**
   - Remove all remaining items
   - See empty state
   - Tap "Continue Shopping"
   - Navigate to home

## Performance

- [ ] Cart loads in < 1 second
- [ ] Quantity updates feel instant
- [ ] No lag when scrolling
- [ ] Images load without blocking UI
- [ ] Animations are smooth (60fps)

## Accessibility

- [ ] All buttons have semantic labels
- [ ] Touch targets meet minimum size (48dp)
- [ ] Color contrast is sufficient
- [ ] Error states are clear
- [ ] Loading states are announced

## Notes

- Mock repository has 20% chance of issues on verify
- Issues include: out of stock, quantity reduced, price changed
- Discount threshold: PKR 10,000
- Free shipping threshold: PKR 8,000
- Network delays simulated: 500-1200ms

