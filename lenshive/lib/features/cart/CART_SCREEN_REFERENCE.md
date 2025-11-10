# Cart Screen Reference

## Visual Layout

```
┌────────────────────────────────────┐
│        Cart              [×]       │ ← AppBar
├────────────────────────────────────┤
│  ╔════════════════════════════╗   │
│  ║  [img] Product Name        ║   │ ← Cart Item Card
│  ║  64px  PKR 3,499    [- 2 +]║   │   20px radius, white
│  ║                       [🗑]  ║   │   on #F3F4F6 bg
│  ╚════════════════════════════╝   │
│                                    │
│  ╔════════════════════════════╗   │
│  ║  [img] Product Name        ║   │ ← Another Item
│  ║        PKR 4,999    [- 1 +]║   │
│  ║                       [🗑]  ║   │
│  ╚════════════════════════════╝   │
│                                    │
├────────────────────────────────────┤
│  Subtotal          PKR 18,994      │ ← Summary Card
│  Discount          PKR 1,899       │   (Sticky Footer)
│  Shipping          FREE            │   Subtle elevation
│  ──────────────────────────────    │
│  Total             PKR 17,095      │   18pt semibold
│                                    │
│  ┌──────────────────────────────┐ │
│  │  Proceed to Checkout         │ │ ← Primary Button
│  └──────────────────────────────┘ │
│                    ↑ 12px gap      │
└────────────────────────────────────┘
```

## Empty State

```
┌────────────────────────────────────┐
│             Cart                   │
├────────────────────────────────────┤
│                                    │
│          ⭕ 🛒                     │
│       (Shopping cart icon)         │
│                                    │
│     Your cart is empty             │
│    Add items to get started        │
│                                    │
│  ┌──────────────────────────────┐ │
│  │   Continue Shopping          │ │
│  └──────────────────────────────┘ │
│                                    │
└────────────────────────────────────┘
```

## Features Implemented

### ✅ Cart Item Card
- **64×64px** rounded image (12px radius)
- **Product name** - max 2 lines with ellipsis
- **Unit price** - "PKR X,XXX" in 14px
- **Quantity stepper** - bordered, with +/− buttons
- **Remove button** - trash icon below stepper
- **Warnings:**
  - "Only 5 left" in warning color
  - "Out of stock" in error color
- **Swipe to delete** - dismissible animation (right to left)

### ✅ Summary Section
- **Subtotal** - sum of all items
- **Discount** - shown in green if > 0
- **Shipping** - shows "Free shipping" if PKR 0
- **Total** - 18px semibold
- All prices right-aligned

### ✅ Checkout Flow
1. Tap "Proceed to Checkout"
2. Shows loading spinner
3. Calls `controller.verify()`
4. If issues found:
   - Opens blocking bottom sheet
   - Title: "We updated your cart"
   - Warning icon (amber)
   - Bullet list of adjustments
   - Actions: "Try Again" | "Review Cart"
5. If OK:
   - Navigates to `/checkout`

### ✅ Interactions
- **Increment (+)** → increases quantity, updates total
- **Decrement (−)** → decreases quantity, removes if reaches 0
- **Trash icon** → removes item immediately
- **Swipe right-to-left** → reveals delete background, removes on complete
- **Continue Shopping** (empty state) → navigates to `/home`
- **Proceed to Checkout** → verify + navigate or show issues

### ✅ Widget Keys (for testing)

```dart
// Item cards
Key('cart_item_line_1')
Key('cart_item_line_2')

// Quantity controls
Key('cart_qty_plus_line_1')
Key('cart_qty_minus_line_1')

// Remove buttons
Key('cart_remove_line_1')

// Checkout button
Key('cart_proceed_btn')
```

## Bottom Sheet Layout

```
┌────────────────────────────────────┐
│            ────                    │ ← Handle bar
│                                    │
│  ⚠️  We updated your cart          │
│                                    │
│  Some items were adjusted due to   │
│  availability or price changes:    │
│                                    │
│  • Product A is out of stock       │
│  • Product B quantity reduced      │
│  • Product C price changed         │
│                                    │
│  ┌──────────┐  ┌──────────────┐   │
│  │Try Again │  │ Review Cart  │   │
│  └──────────┘  └──────────────┘   │
│                                    │
└────────────────────────────────────┘
```

## States Handled

### 1. Empty Cart
- Centered illustration
- "Your cart is empty" message
- "Continue Shopping" button → `/home`

### 2. Loading
- Centered circular progress indicator

### 3. Error
- Error icon (red)
- "Failed to load cart" message
- Error description

### 4. Cart with Items
- Scrollable list of cart items
- Sticky summary footer
- Checkout button

### 5. Verification Issues
- Modal bottom sheet
- Warning icon and title
- List of specific issues
- Two action buttons

## Design Tokens Used

| Element | Token |
|---------|-------|
| Background | `DesignTokens.background` (#F3F4F6) |
| Card | `DesignTokens.card` (white) |
| Card Radius | `DesignTokens.radiusCard` (20px) |
| Image Radius | `DesignTokens.radiusInput` (12px) |
| Stepper Radius | `DesignTokens.radiusChip` (12px) |
| Warning Color | `DesignTokens.warning` (#F59E0B) |
| Error Color | `DesignTokens.error` (#EF4444) |
| Success Color | `DesignTokens.success` (#10B981) |
| Spacing | `spaceXs`, `spaceSm`, `spaceMd`, `spaceLg`, `spaceXl` |
| Text Colors | `textPrimary`, `textSecondary` |

## Responsive Behavior

- **Images**: Fixed 64×64px for consistency
- **Cards**: Full width with 16px margins
- **Summary**: Sticks to bottom with 12px gap
- **Bottom Sheet**: Adapts to content height
- **Buttons**: Full width in footer

## Business Logic

### Quantity Rules
- Min: 1 (decreasing from 1 removes item)
- Max: Available stock (enforced by repository)
- Updates totals immediately

### Discount Logic
- 10% off if subtotal > PKR 10,000
- Shown in green

### Shipping Logic
- Free if (subtotal - discount) > PKR 8,000
- Otherwise PKR 250

### Verification Logic
- Called before checkout
- 20% chance of finding issues (mock)
- Issues: out of stock, quantity reduced, price changed
- Blocks checkout until reviewed

## Navigation Flow

```
Cart Screen
    │
    ├─ Empty → "Continue Shopping" → /home
    │
    └─ With Items → "Proceed to Checkout"
           │
           ├─ Verify: OK → /checkout
           │
           └─ Verify: Issues → Bottom Sheet
                  │
                  ├─ "Review Cart" → Close sheet
                  │
                  └─ "Try Again" → Re-verify
```

## Animation Details

- **Swipe to Delete**: Dismissible with red background
- **Loading**: Standard Material CircularProgressIndicator
- **Bottom Sheet**: Slides up from bottom with drag handle
- **State Transitions**: AsyncValue handles loading/error states

## Testing Considerations

### Unit Tests
- Cart calculations (subtotal, discount, shipping, total)
- Quantity increment/decrement logic
- Remove item logic
- Empty state conditions

### Widget Tests
- Empty state renders correctly
- Items display with correct data
- Quantity controls work
- Remove button removes item
- Checkout button triggers verification
- Bottom sheet shows on issues

### Integration Tests
- Full checkout flow
- Verification with issues
- Navigation to home/checkout
- Cart updates persist

## Accessibility

- Semantic labels on all interactive elements
- Sufficient touch target sizes (48×48dp min)
- Color contrast meets WCAG AA standards
- Screen reader friendly structure
- Error messages are descriptive

## Performance Optimizations

- Images load asynchronously with error handling
- List uses `ListView.separated` for efficiency
- State updates are granular (per-item)
- Dismissible animation is hardware-accelerated
- Bottom sheet uses `mainAxisSize: min`

