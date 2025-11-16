# Style Sweep Checklist - Hardcoded Colors Audit

## 🎯 Objective
Identify and fix all hardcoded colors (Colors.white, Colors.black, hex values) to use theme values.

---

## ✅ Fixed Files

### **1. lib/features/home_service_user/ui/my_home_service_bookings_screen.dart**
- ✅ Removed `backgroundColor: DesignTokens.background` from Scaffold
- ✅ Removed FilterChip hardcoded colors (selectedColor, backgroundColor, labelStyle)
- ✅ Updated empty state icon: `color: Theme.of(context).colorScheme.onSurfaceVariant`
- **Status:** COMPLETE

---

## 🚨 Priority Files (Screens - Manual Review Required)

### **HIGH PRIORITY: Core Screens**

#### **1. lib/screens/login_screen.dart**
**Issues Found:** 11 instances
```
Line 85:  backgroundColor: Colors.green,
Line 100: backgroundColor: Colors.red,
Line 144: backgroundColor: backgroundColor,
Line 171: color: isDark ? Colors.white : primaryColor,
Line 185: color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey[200]!,
Line 190: color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
Line 303: backgroundColor: primaryColor,
Line 304: foregroundColor: Colors.white,
Line 317: Colors.white,
Line 326: color: Colors.white,
```
**Recommended Fixes:**
- Remove explicit `backgroundColor` from Scaffold
- Replace `Colors.green` → `colorScheme.tertiaryContainer` or `colorScheme.primary`
- Replace `Colors.red` → `colorScheme.errorContainer`
- Replace `Colors.white` → `colorScheme.onPrimary` or `colorScheme.surface`
- Replace `Colors.black.withOpacity()` → `colorScheme.shadow` or remove
- Replace `Colors.grey[200]` → `colorScheme.surfaceContainerHighest`
- Replace button colors with theme button styles

**Priority:** 🔴 **CRITICAL** (User authentication flow)

---

#### **2. lib/screens/home_screen.dart**
**Issues Found:** 8 instances
```
Line 44:  backgroundColor: Theme.of(context).scaffoldBackgroundColor,  ✅ (OK - using theme)
Line 227: : AppColors.white,
Line 231: ? Colors.white.withOpacity(0.1)
Line 237: color: Colors.black.withOpacity(0.05),
Line 268: ? Colors.white
Line 278: ? Colors.white.withOpacity(0.7)
Line 288: ? Colors.white.withOpacity(0.5)
Line 401: backgroundColor: Theme.of(context).colorScheme.secondary,  ✅ (OK - using theme)
```
**Recommended Fixes:**
- Replace `AppColors.white` → `colorScheme.onPrimary`
- Replace `Colors.white.withOpacity(0.1)` → `colorScheme.onPrimary.withValues(alpha: 0.1)`
- Replace `Colors.black.withOpacity(0.05)` → remove (use elevation instead)
- Update banner gradient to use theme colors only

**Priority:** 🔴 **CRITICAL** (Main landing page)

---

#### **3. lib/screens/profile_screen.dart**
**Issues Found:** 1 instance
```
Line 49: color: Colors.black.withOpacity(0.2),
```
**Recommended Fixes:**
- Replace with `Colors.black.withValues(alpha: 0.2)` OR remove shadow (use Card elevation)

**Priority:** 🟡 **MEDIUM** (Settings/profile page)

---

### **MEDIUM PRIORITY: Supporting Screens**

#### **4. lib/screens/cart_screen.dart**
**Status:** Needs review
**Priority:** 🟡 **MEDIUM**

#### **5. lib/screens/product_detail_screen.dart**
**Status:** Needs review
**Priority:** 🟡 **MEDIUM**

#### **6. lib/screens/splash_screen.dart**
**Status:** Needs review
**Priority:** 🟢 **LOW** (Temporary screen)

#### **7. lib/screens/registration_screen.dart**
**Status:** Needs review
**Priority:** 🔴 **HIGH** (User onboarding flow)

---

## 📦 Feature Files (12 files)

### **Quiz Feature (11 files)**
```
lib/features/quiz/widgets/option_chip.dart
lib/features/quiz/steps/step5_comfort_budget_notes.dart
lib/features/quiz/steps/step2_screen_work_reflections.dart
lib/features/quiz/steps/quiz_step3_preferences.dart
lib/features/quiz/steps/quiz_step2_usage.dart
lib/features/quiz/steps/quiz_step1_basics.dart
lib/features/quiz/result/recommendation_screen.dart
lib/features/quiz/result/new_recommendation_screen.dart
lib/features/quiz/steps/step4_lifestyle_thickness_handling.dart
lib/features/quiz/steps/step3_sunlight_auto_night_sensitivity.dart
lib/features/quiz/steps/step1_who.dart
```
**Priority:** 🟢 **LOW** (Feature screens - can be batch-updated)

### **Cart Feature (1 file)**
```
lib/features/cart/EXAMPLE_USAGE.dart
```
**Priority:** 🟢 **LOW** (Example file, not used in production)

---

## 🧩 Widget Files (1 file)

#### **lib/widgets/enhanced_product_card.dart**
**Status:** Needs review
**Priority:** 🟡 **MEDIUM** (Used on Home screen)

---

## 🎯 Recommended Action Plan

### **Phase 1: Critical Screens (Do Immediately)**
1. ✅ ~~lib/features/home_service_user/ui/my_home_service_bookings_screen.dart~~ (DONE)
2. 🔴 lib/screens/login_screen.dart
3. 🔴 lib/screens/home_screen.dart
4. 🔴 lib/screens/registration_screen.dart

### **Phase 2: Supporting Screens**
5. lib/screens/profile_screen.dart
6. lib/screens/cart_screen.dart
7. lib/screens/product_detail_screen.dart
8. lib/widgets/enhanced_product_card.dart

### **Phase 3: Feature Screens (Batch Update)**
9. All quiz screens (11 files)
10. lib/screens/splash_screen.dart

---

## 📋 Manual Testing Checklist

### **After Fixes, Test:**

#### **1. Home Screen Test**
- [ ] Launch app → Login
- [ ] Home screen appears immediately (not blank)
- [ ] Product cards display correctly
- [ ] "Find Your Perfect Lens" banner uses theme colors
- [ ] "Book Home Service" banner uses theme colors
- [ ] Cart badge shows correct count

#### **2. Dark Mode Toggle Test**
- [ ] Navigate to Account tab
- [ ] Toggle dark mode switch
- [ ] **Home tab:** Background, cards, text adapt to dark theme
- [ ] **Customize tab:** UI adapts to dark theme
- [ ] **My Orders tab:** UI adapts to dark theme
- [ ] **Bookings tab:** Cards, empty state, filter chips adapt to dark theme
- [ ] **Account tab:** Profile header, settings cards adapt to dark theme
- [ ] **Bottom Navigation Bar:** Background, icons, labels adapt to dark theme

#### **3. Navigation Bar Test**
- [ ] Bottom nav visible on all 5 tabs
- [ ] Selected tab shows indicator pill (primary container color)
- [ ] Selected icon/label uses onPrimaryContainer color
- [ ] Unselected icons/labels use onSurfaceVariant color
- [ ] No hardcoded colors visible

#### **4. Bookings Screen Test**
- [ ] Navigate to Bookings tab
- [ ] If empty: Icon uses onSurfaceVariant color
- [ ] If empty: "No bookings found" text uses theme colors
- [ ] Filter chips use theme colors (no hardcoded blue/white)
- [ ] Booking cards use theme colors
- [ ] Status pills use appropriate colors

#### **5. Login Screen Test** (After fixing)
- [ ] Background uses theme surface color
- [ ] Logo/text uses theme colors
- [ ] Input fields use theme colors
- [ ] Login button uses theme primary color
- [ ] Error messages use theme error color
- [ ] No white/black hardcoded colors visible

---

## 🔍 Detection Pattern

Use this regex to find hardcoded colors:
```regex
Colors\.(white|black)|Color\(0x|0xff[0-9A-Fa-f]|Colors\.[a-z]+\[|AppColors\.
```

---

## ✅ Theme Color Mapping Reference

| Old (Hardcoded) | New (Theme) | Usage |
|----------------|-------------|-------|
| `Colors.white` | `colorScheme.surface` | Backgrounds |
| `Colors.white` | `colorScheme.onPrimary` | Text/icons on primary |
| `Colors.black` | `colorScheme.onSurface` | Primary text |
| `Colors.grey` | `colorScheme.surfaceVariant` | Secondary surfaces |
| `Colors.grey` | `colorScheme.onSurfaceVariant` | Secondary text |
| `Colors.blue` | `colorScheme.primary` | Primary color |
| `Colors.red` | `colorScheme.error` | Error states |
| `Colors.green` | `colorScheme.tertiary` | Success states |
| `Colors.orange` | `colorScheme.secondary` | Warning states |
| `Colors.black.withOpacity(0.1)` | Remove (use elevation) | Shadows |
| `Colors.white.withOpacity(0.7)` | `colorScheme.onPrimary.withValues(alpha: 0.7)` | Semi-transparent |
| `AppColors.*` | `colorScheme.*` | Theme colors |
| `DesignTokens.*` | `colorScheme.*` | Theme colors |

---

## 📊 Summary Statistics

| Category | Total Files | Fixed | Remaining |
|----------|-------------|-------|-----------|
| **Core Screens** | 7 | 1 (14%) | 6 (86%) |
| **Feature Screens** | 12 | 1 (8%) | 11 (92%) |
| **Widget Files** | 1 | 0 (0%) | 1 (100%) |
| **TOTAL** | 20 | 2 (10%) | 18 (90%) |

---

## 🎯 Next Steps

1. **Immediate:** Fix login_screen.dart and home_screen.dart
2. **Test:** Run app and verify Home shows after login
3. **Test:** Toggle dark mode and verify all tabs adapt
4. **Review:** Complete manual testing checklist
5. **Continue:** Fix remaining screens in priority order

---

**Last Updated:** November 10, 2025  
**Status:** 🟡 IN PROGRESS (2/20 files complete)

