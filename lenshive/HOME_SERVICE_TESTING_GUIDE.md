# Home Service Entry Points - Testing Guide

## 🧪 Comprehensive Testing Checklist

This guide provides a step-by-step testing approach for verifying all Home Service entry points and polished features.

---

## Prerequisites

1. **Flutter Environment**: Ensure Flutter is installed and up to date
2. **Devices**: Test on multiple screen sizes (360px - 430px width)
3. **Branch**: Checkout `feat/cart-home-service-ui`
4. **Dependencies**: Run `flutter pub get`

---

## 🚀 Quick Start Testing

### Option 1: Run on Chrome (Fast)
```bash
cd lenshive
flutter run -d chrome --web-port=8080
```
Then use browser DevTools to test different screen sizes:
- 360 × 740 (Small phone)
- 375 × 812 (iPhone SE/8)
- 390 × 844 (iPhone 14 Pro)
- 414 × 896 (iPhone Plus)
- 430 × 932 (iPhone 14 Pro Max)

### Option 2: Run on Android Emulator
```bash
cd lenshive
flutter run -d emulator-name
```

### Option 3: Run on iOS Simulator
```bash
cd lenshive
flutter run -d simulator-name
```

---

## 📋 Test Cases

### Test Suite 1: Home Screen Entry Point

#### TC1.1: Visual Verification
- [ ] **Navigate to Home Screen** (`/home`)
- [ ] **Verify Card Appearance**:
  - [ ] Card appears between Quiz Banner and Category Tabs
  - [ ] Background is white with subtle border
  - [ ] Border radius is 16px (visually rounded)
  - [ ] Subtle shadow is visible
  - [ ] Icon is `home_repair_service_outlined` in primary blue
  - [ ] Title reads "Book Home Service"
  - [ ] Subtitle reads "Eye tests, fittings & repairs at your doorstep"
  - [ ] Right arrow icon is present

#### TC1.2: Layout on Different Widths
- [ ] **360px width**: Card fills width with 16px margins, no horizontal scroll
- [ ] **375px width**: Card displays properly
- [ ] **390px width**: Card displays properly
- [ ] **414px width**: Card displays properly
- [ ] **430px width**: Card displays properly

#### TC1.3: Interaction
- [ ] **Tap Card**: Card shows ripple effect
- [ ] **Navigation**: Taps navigate to `/home-service/request`
- [ ] **Back Button**: Returns to home screen correctly

#### TC1.4: Dark Mode (if supported)
- [ ] **Switch to Dark Mode**
- [ ] Card background adapts to dark theme
- [ ] Text remains readable
- [ ] Border/shadow adapt appropriately

---

### Test Suite 2: Profile Screen Entry Point

#### TC2.1: Visual Verification
- [ ] **Navigate to Profile Screen** (`/profile`)
- [ ] **Scroll to Account Settings Section**
- [ ] **Verify List Tile**:
  - [ ] Tile appears after "Edit Profile"
  - [ ] Tile appears before "Change Password"
  - [ ] Icon is `home_repair_service_outlined`
  - [ ] Title reads "My Home Service"
  - [ ] Subtitle reads "View and manage your bookings"
  - [ ] Right arrow icon is present
  - [ ] Styling matches other list tiles

#### TC2.2: Interaction
- [ ] **Tap List Tile**: Ripple effect shows
- [ ] **Navigation**: Taps navigate to `/home-service/my`
- [ ] **Back Button**: Returns to profile screen correctly

---

### Test Suite 3: Home Service Request Form - Field Validation

#### TC3.1: Service Type Dropdown
- [ ] **Label**: "Service Needed *" is visible above field
- [ ] **Hint**: "Select a service" appears before selection
- [ ] **Dropdown Opens**: Tap opens dropdown menu
- [ ] **Options Display**: All 5 service types are listed
  - [ ] Eye Test at Home
  - [ ] Frame Fitting
  - [ ] Repair/Adjustment
  - [ ] Contact Lens Fitting
  - [ ] Lens Replacement
- [ ] **Selection**: Selected value displays in field
- [ ] **Validation**: Submit without selection shows error

#### TC3.2: Date Picker
- [ ] **Label**: "Preferred Date & Time *" is visible
- [ ] **Button Height**: Button is at least 48px tall (easy to tap)
- [ ] **Icon**: Calendar icon is visible
- [ ] **Default Text**: "Select Date" before selection
- [ ] **Tap Opens Picker**: Date picker dialog opens
- [ ] **Date Range**: Only dates from tomorrow to 90 days ahead are selectable
- [ ] **Selection**: Selected date displays in format "dd MMM yyyy"
- [ ] **Validation**: Submit without selection shows snackbar error

#### TC3.3: Time Picker
- [ ] **Button Height**: Button is at least 48px tall
- [ ] **Icon**: Clock icon is visible
- [ ] **Default Text**: "Select Time" before selection
- [ ] **Tap Opens Picker**: Time picker dialog opens
- [ ] **Selection**: Selected time displays in format "h:mm a"
- [ ] **Validation**: Submit without selection shows snackbar error

#### TC3.4: Address Field
- [ ] **Label**: "Address *" is visible above field
- [ ] **Hint**: Example Lahore address is shown
- [ ] **Prefix Icon**: Location pin icon is present
- [ ] **Multi-line**: Field expands to 3 lines
- [ ] **Keyboard**: Standard keyboard appears
- [ ] **Validation - Empty**: Submit with empty field shows error
- [ ] **Validation - Too Short**: Submit with <10 chars shows error
- [ ] **Validation - Valid**: 10+ chars passes validation

#### TC3.5: Phone Number Field
- [ ] **Label**: "Phone Number *" is visible above field
- [ ] **Hint**: "+92 300 1234567" is shown
- [ ] **Helper Text**: "Format: +92 3XX XXXXXXX" appears below field
- [ ] **Prefix Icon**: Phone icon is present
- [ ] **Keyboard**: Numeric/tel keyboard appears
- [ ] **Validation - Empty**: Submit with empty field shows error
- [ ] **Validation - Invalid Format**: Non-PK format shows error
- [ ] **Validation - Too Short**: <11 digits shows error
- [ ] **Validation - Valid +92**: Format "+92 300 1234567" passes
- [ ] **Validation - Valid 0**: Format "0300 1234567" passes

#### TC3.6: Notes Field (Optional)
- [ ] **Label**: "Additional Notes (Optional)" is visible
- [ ] **No Asterisk**: Field is clearly marked as optional
- [ ] **Hint**: Placeholder text is visible
- [ ] **Prefix Icon**: Note icon is present
- [ ] **Multi-line**: Field shows 2 lines
- [ ] **No Validation**: Can submit with empty notes field

#### TC3.7: Helper Info Box
- [ ] **Background**: Light blue background (primary with 10% opacity)
- [ ] **Icon**: Info icon in primary color
- [ ] **Text**: "We'll confirm your slot by SMS/WhatsApp."
- [ ] **Border Radius**: Rounded corners (12px)

#### TC3.8: Submit Button
- [ ] **Text**: "Request Booking"
- [ ] **Width**: Full width of container
- [ ] **Height**: Minimum 48px tall
- [ ] **Background**: Primary blue color
- [ ] **Text Color**: White
- [ ] **Position**: Sticky at bottom (doesn't scroll away)
- [ ] **Gap**: 12px gap between button and screen bottom

---

### Test Suite 4: Form Submission Flow

#### TC4.1: Successful Submission
- [ ] **Fill All Required Fields**:
  - [ ] Select service type
  - [ ] Select date (tomorrow or later)
  - [ ] Select time
  - [ ] Enter valid address (10+ chars)
  - [ ] Enter valid phone number
- [ ] **Optional**: Add notes
- [ ] **Tap Submit**: Loading indicator appears
- [ ] **Success**: Success snackbar shows with booking ID
- [ ] **Navigation**: Automatically navigates to `/home-service/my`
- [ ] **Booking List**: New booking appears in list

#### TC4.2: Validation Errors
- [ ] **Tap Submit with Empty Form**:
  - [ ] Service type shows validation error OR snackbar
  - [ ] Date/time shows snackbar error
  - [ ] Address shows inline error
  - [ ] Phone shows inline error
- [ ] **Fill Fields One by One**:
  - [ ] Errors clear as fields are filled
  - [ ] Submit becomes enabled when all required fields are valid

#### TC4.3: Error Handling
- [ ] **Network Error Simulation**: (If mock allows)
  - [ ] Error snackbar appears
  - [ ] Form remains filled (data not lost)
  - [ ] Can retry submission

---

### Test Suite 5: Accessibility Testing

#### TC5.1: Screen Reader (TalkBack/VoiceOver)
- [ ] **Enable Screen Reader**
- [ ] **Service Dropdown**:
  - [ ] Announces "Service type"
  - [ ] Announces "Select the type of service you need"
- [ ] **Date Button**:
  - [ ] Announces "Preferred date"
  - [ ] Announces "Select your preferred appointment date"
  - [ ] Announces "Button"
- [ ] **Time Button**:
  - [ ] Announces "Preferred time"
  - [ ] Announces "Select your preferred appointment time"
  - [ ] Announces "Button"
- [ ] **Address Field**:
  - [ ] Announces "Address"
  - [ ] Announces "Enter your complete address for home service"
- [ ] **Phone Field**:
  - [ ] Announces "Phone number"
  - [ ] Announces "Enter your phone number in Pakistani format"
- [ ] **Notes Field**:
  - [ ] Announces "Additional notes"
  - [ ] Announces "Add any special instructions or requirements"
- [ ] **Submit Button**:
  - [ ] Announces "Request booking"
  - [ ] Announces "Submit your home service booking request"
  - [ ] Announces "Button"

#### TC5.2: Keyboard Navigation (Web/Desktop)
- [ ] **Tab Order**: Fields focus in logical top-to-bottom order
- [ ] **Focus Indicators**: Visible focus states on all fields
- [ ] **Enter Key**: Submits form when focused on submit button
- [ ] **Escape Key**: Closes date/time pickers

#### TC5.3: Touch Targets
- [ ] **Date Picker**: Easy to tap (48px height confirmed)
- [ ] **Time Picker**: Easy to tap (48px height confirmed)
- [ ] **Submit Button**: Easy to tap (48px height confirmed)
- [ ] **Dropdown**: Easy to tap (auto Flutter height)

---

### Test Suite 6: Responsive Design

#### TC6.1: Small Phone (360px)
- [ ] **Home Screen**: Service card fits with no overflow
- [ ] **Request Form**: All fields fit width
- [ ] **Date/Time**: Buttons split 50/50 with readable text
- [ ] **Submit Button**: Full width, no overflow
- [ ] **No Horizontal Scroll**: Entire form navigable vertically

#### TC6.2: Standard Phone (375px - 390px)
- [ ] Same checks as TC6.1
- [ ] Text remains readable
- [ ] Spacing looks appropriate

#### TC6.3: Large Phone (414px - 430px)
- [ ] Same checks as TC6.1
- [ ] Extra space is utilized well (not cramped)
- [ ] No awkward white space

---

### Test Suite 7: Navigation & Bottom Nav

#### TC7.1: Bottom Navigation Visibility
- [ ] **Home Screen** (`/home`): Bottom nav visible
- [ ] **Profile Screen** (`/profile`): Bottom nav visible
- [ ] **Cart Screen** (`/cart`): Bottom nav visible
- [ ] **Request Screen** (`/home-service/request`): Bottom nav HIDDEN
- [ ] **Bookings List** (`/home-service/my`): Bottom nav HIDDEN
- [ ] **Booking Detail** (`/home-service/:id`): Bottom nav HIDDEN

#### TC7.2: Sticky Footer Gap
- [ ] **On Screens with Bottom Nav**:
  - [ ] Sticky footer sits 12px above bottom nav
  - [ ] No overlap between footer and nav
- [ ] **On Screens without Bottom Nav**:
  - [ ] Sticky footer sits at bottom with safe area padding

#### TC7.3: Back Navigation
- [ ] **Request Screen**: Back button returns to home/profile (wherever came from)
- [ ] **Bookings List**: Back button returns to previous screen
- [ ] **Booking Detail**: Back button returns to bookings list

---

### Test Suite 8: User Flow Testing

#### TC8.1: Flow from Home Screen
```
Home → Book Home Service Card → Request Form → Fill Form → Submit → Bookings List
```
- [ ] Complete full flow without errors
- [ ] UI transitions smoothly
- [ ] Data persists correctly

#### TC8.2: Flow from Profile Screen
```
Profile → My Home Service → Bookings List → Tap Booking → Detail Screen
```
- [ ] Complete full flow without errors
- [ ] Can navigate back to profile
- [ ] Can navigate to request form from bookings list

#### TC8.3: Round Trip
```
Home → Request → Submit → List → Detail → Reschedule → List → Home
```
- [ ] Complete round trip
- [ ] No navigation issues
- [ ] State updates correctly

---

### Test Suite 9: Edge Cases

#### TC9.1: Form Persistence
- [ ] **Fill Form Partially**
- [ ] **Navigate Away** (use back button)
- [ ] **Return to Form**
- [ ] **Check**: Form data is lost (expected behavior for now)

#### TC9.2: Rapid Tapping
- [ ] **Fill Form Completely**
- [ ] **Tap Submit Multiple Times Rapidly**
- [ ] **Check**: Only one booking is created (loading prevents duplicates)

#### TC9.3: Date/Time Selection Edge Cases
- [ ] **Try to Select Today's Date**: Should not be allowed (min: tomorrow)
- [ ] **Try to Select Date >90 Days**: Should not be allowed
- [ ] **Select Date then Change**: New selection replaces old

#### TC9.4: Phone Number Formats
- [ ] **Test Format**: +92 300 1234567 → Valid
- [ ] **Test Format**: 0300 1234567 → Valid
- [ ] **Test Format**: 03001234567 → Valid
- [ ] **Test Format**: 923001234567 → Invalid (missing +)
- [ ] **Test Format**: 300 1234567 → Invalid (missing prefix)
- [ ] **Test Format**: +92 30 → Invalid (too short)

---

### Test Suite 10: Visual Regression

#### TC10.1: Design Token Compliance
- [ ] **Colors Match**: Compare with `lib/design/tokens.dart`
  - [ ] Primary: #2F6BFF
  - [ ] Background: #F3F4F6
  - [ ] Card: #FFFFFF
- [ ] **Border Radius Match**:
  - [ ] Card: 20px
  - [ ] Button: 16px
  - [ ] Input: 12px
- [ ] **Spacing Match**:
  - [ ] Card padding: 18px
  - [ ] Field spacing: 16px
  - [ ] Section spacing: 24px
- [ ] **Shadows Match**:
  - [ ] Service card: Subtle shadow
  - [ ] Sticky footer: Subtle shadow

#### TC10.2: Typography
- [ ] **Field Labels**: Title medium weight
- [ ] **Input Text**: Body large size
- [ ] **Button Text**: Label large weight
- [ ] **Helper Text**: Body small size
- [ ] **Hint Text**: Body medium with secondary color

---

## 🐛 Bug Reporting Template

If you find issues during testing, use this template:

```markdown
### Bug Report

**Title**: [Short description]

**Test Case**: TC#.#

**Priority**: High / Medium / Low

**Steps to Reproduce**:
1. 
2. 
3. 

**Expected Result**:
-

**Actual Result**:
-

**Screenshots**:
[Attach if applicable]

**Device/Browser**:
- Device: [e.g., iPhone 14, Chrome DevTools]
- Screen Size: [e.g., 375 × 812]
- OS: [e.g., iOS 17, Windows 11]

**Additional Context**:
-
```

---

## ✅ Test Results Summary

### Completed Test Suites
- [ ] Test Suite 1: Home Screen Entry Point
- [ ] Test Suite 2: Profile Screen Entry Point
- [ ] Test Suite 3: Form Field Validation
- [ ] Test Suite 4: Form Submission Flow
- [ ] Test Suite 5: Accessibility Testing
- [ ] Test Suite 6: Responsive Design
- [ ] Test Suite 7: Navigation & Bottom Nav
- [ ] Test Suite 8: User Flow Testing
- [ ] Test Suite 9: Edge Cases
- [ ] Test Suite 10: Visual Regression

### Overall Status
- **Total Test Cases**: ~150
- **Passed**: ___
- **Failed**: ___
- **Blocked**: ___
- **Skipped**: ___

---

## 📊 Automated Testing (Future Enhancement)

### Widget Tests
```dart
// Example test case
testWidgets('Home service card navigates to request screen', (tester) async {
  await tester.pumpWidget(MyApp());
  await tester.tap(find.text('Book Home Service'));
  await tester.pumpAndSettle();
  expect(find.text('Home Service Booking'), findsOneWidget);
});
```

### Integration Tests
- Full user flow automation
- Form validation automation
- Navigation flow validation

---

## 🎯 Acceptance Criteria

The feature is ready for production when:
- ✅ All test suites pass
- ✅ No critical or high-priority bugs
- ✅ Accessibility score >90%
- ✅ Works on devices 360px - 430px
- ✅ Design tokens strictly followed
- ✅ User flows are smooth and intuitive

---

**Test Plan Version**: 1.0  
**Last Updated**: November 10, 2025  
**Status**: Ready for Testing ✅

