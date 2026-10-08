# Splash Screen Performance Optimization Plan

## Issues Found & Fixed

### 1. ✅ `SplashContent` — Replaced 5 `Timer` + `setState` calls with single `AnimationController` + `AnimatedBuilder`
Before: 5 separate Timer callbacks each calling `setState()`, rebuilding the entire widget tree 5 times.
After: Single `AnimationController` driving all staggered reveals via `AnimatedBuilder`. Only the animating children rebuild.

### 2. ✅ `SplashLogo` — Converted from `StatefulWidget` to `StatelessWidget`
Before: Had its own `AnimationController`, `Tween`, `CurvedAnimation` — separate vsync, separate lifecycle.
After: Pure `StatelessWidget` receiving computed `opacity` and `scale` from parent. Zero controller overhead.

### 3. ✅ `SplashTitle` — Converted from `StatefulWidget` to `StatelessWidget`
Same optimization: removed controller, tween, curved animation. Now receives `opacity` from parent.

### 4. ✅ `SplashSubtitle` — Converted from `StatefulWidget` to `StatelessWidget`
Same optimization: removed controller, tween, curved animation. Now receives `opacity` from parent.

### 5. ✅ `SplashBackground` — Wrapped in `RepaintBoundary`
Entire gradient + glow + grid no longer repaints on every animation frame. Also added inner `RepaintBoundary` around the `CustomPaint` grid.

### 6. ✅ Logo precached before animation + navigation guard
`precacheImage(const AssetImage(AppAssets.logo), context)` called in `initState`. Added `_hasNavigated` flag to prevent double navigation.

### 7. ✅ `SplashProgressIndicator` — Wrapped in `RepaintBoundary`
Progress bar animation repaints isolated from the rest of the tree.

### 8. ✅ `SplashPageIndicator` — Wrapped in `RepaintBoundary`
Page indicator animation repaints isolated from the rest of the tree.

### 9. ✅ Smooth Indicator Entrance & Layout Jump Prevention
- Previously, `SplashProgressIndicator` and `SplashPageIndicator` were inserted using conditional tree rendering (`if (progress >= ...)`), causing elements to abruptly pop in at 83%/94% progress and trigger a layout shift.
- Converted both widgets to receive continuous `opacity` parameters via `_staggeredOpacity` and wrapped in `Opacity`, keeping reserved space constant without layout jumps.

### 10. ✅ Indicator Animation & Timing Alignment
- Enhanced `SplashPageIndicator` with animated pill width expansion (`8px` → `20px`) and color transition for active dot step.
- Aligned `SplashContent` entrance duration and `SplashCubit` delay with `AppDurations.splashAutoNavigate` (3s) so indicators have adequate display time before screen transition.

### 11. ✅ Verification — `flutter analyze lib\features\splash\` → `No issues found!`