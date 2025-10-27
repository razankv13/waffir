---
description: Comprehensive Flutter performance audit and optimization - finds bottlenecks, memory leaks, frame drops, and provides fixes
---

You are a **Flutter Performance Optimization Expert**. Your mission is to audit this Waffir app for performance issues and provide optimization recommendations to achieve 60fps consistently with minimal memory footprint.

## Your Task

Perform a comprehensive performance audit and optimization:

### 1. Performance Profiling Areas

**Startup Performance**
- [ ] Analyze app initialization sequence in main.dart
- [ ] Check for blocking operations during startup
- [ ] Verify async initialization is properly implemented
- [ ] Measure time to first frame
- [ ] Check for unnecessary service initializations

**Runtime Performance**
- [ ] Identify widget rebuild bottlenecks
- [ ] Find unnecessary provider recalculations
- [ ] Locate synchronous I/O operations
- [ ] Detect animation jank
- [ ] Find expensive build() methods

**Memory Management**
- [ ] Check for memory leaks in streams
- [ ] Verify controller disposal
- [ ] Find retained references
- [ ] Check image cache management
- [ ] Analyze provider lifecycle

**Network Performance**
- [ ] Audit API call efficiency
- [ ] Check for redundant requests
- [ ] Verify caching strategies
- [ ] Analyze payload sizes
- [ ] Check for parallel request opportunities

**Rendering Performance**
- [ ] Find oversized images
- [ ] Check for unnecessary repaints
- [ ] Verify RepaintBoundary usage
- [ ] Analyze shader compilation
- [ ] Check for opacity/clipping issues

## Audit Checklist

### Widget Optimization
- [ ] Use `const` constructors everywhere possible
- [ ] Implement `RepaintBoundary` for expensive widgets
- [ ] Use `ListView.builder` instead of `ListView` with many items
- [ ] Implement `AutomaticKeepAliveClientMixin` appropriately
- [ ] Use `CachedNetworkImage` for remote images
- [ ] Avoid rebuilding entire screens on state changes
- [ ] Use `AnimatedBuilder` instead of `setState` for animations
- [ ] Implement pagination for long lists
- [ ] Use `Selector` or `Consumer` to limit Riverpod rebuilds
- [ ] Avoid deep widget trees (> 10 levels)

### Riverpod Optimization
- [ ] Providers have appropriate scope (not too global)
- [ ] Using `.select()` to limit rebuilds
- [ ] Family providers properly disposed
- [ ] No unnecessary provider dependencies
- [ ] StreamProviders use `autoDispose` where appropriate
- [ ] AsyncNotifiers properly manage loading states
- [ ] No synchronous heavy computations in providers
- [ ] Provider composition optimized

### Image & Asset Optimization
- [ ] Images are in appropriate formats (WebP preferred)
- [ ] Images are properly sized (not loading 4K images for thumbnails)
- [ ] SVG assets used for icons where appropriate
- [ ] Image caching configured properly
- [ ] No image loading on main thread
- [ ] Placeholder images are lightweight
- [ ] Shimmer effects use efficient rendering

### Network Optimization
- [ ] API responses are paginated
- [ ] Using Dio interceptors for caching
- [ ] Implementing request debouncing
- [ ] Parallel requests where possible
- [ ] Retry logic with exponential backoff
- [ ] Request cancellation implemented
- [ ] GraphQL batch queries (if using GraphQL)
- [ ] WebSocket connections managed efficiently

### Database & Storage Optimization
- [ ] Hive boxes opened once and reused
- [ ] Database queries use indexes
- [ ] Batch operations where possible
- [ ] Lazy loading for large datasets
- [ ] Proper transaction management
- [ ] Supabase queries optimized with select()
- [ ] No blocking I/O on main thread

### Code Optimization
- [ ] No expensive computations in build()
- [ ] Using `compute()` for heavy CPU tasks
- [ ] Streams properly closed/disposed
- [ ] Controllers disposed in dispose()
- [ ] No memory leaks in controllers
- [ ] Avoid using `GlobalKey` excessively
- [ ] Minimize use of `Opacity` widget
- [ ] Avoid `ClipPath` and `ClipRRect` in animations

### Build Optimization
- [ ] Code splitting implemented
- [ ] Deferred loading for heavy features
- [ ] Tree shaking enabled
- [ ] Obfuscation configured
- [ ] Source maps generated
- [ ] --split-debug-info configured
- [ ] Web: CanvasKit vs HTML renderer choice optimized
- [ ] Bundle size analyzed and optimized

## Common Flutter Performance Antipatterns to Find

```dart
// ANTI-PATTERN: Non-const widget
class MyWidget extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(child: Text('Hello')); // Should be const
  }
}

// ANTI-PATTERN: Expensive operations in build
class MyWidget extends StatelessWidget {
  Widget build(BuildContext context) {
    final data = expensiveComputation(); // Move to provider/controller
    return Text(data);
  }
}

// ANTI-PATTERN: Not using ListView.builder
ListView(children: List.generate(1000, (i) => Item(i))); // Use builder

// ANTI-PATTERN: Memory leak - not disposing
class _MyScreenState extends State<MyScreen> {
  final controller = TextEditingController();
  // Missing dispose() method
}

// ANTI-PATTERN: Unnecessary rebuilds
Consumer<MyProvider>(
  builder: (context, provider, child) {
    return ComplexWidget(data: provider.entireState); // Use select()
  }
)

// ANTI-PATTERN: Synchronous I/O
final file = File('path').readAsStringSync(); // Use async version
```

## Execution Steps

1. **Read Architecture & Code Style Memories**
   ```
   mcp__serena__read_memory: architecture
   mcp__serena__read_memory: code_style_conventions
   ```

2. **Analyze Startup Performance**
   - Read main.dart, main_*.dart files
   - Check initialization sequence
   - Identify blocking operations

3. **Audit Widgets for Performance Issues**
   - Use `mcp__serena__search_for_pattern` to find:
     - Non-const constructors
     - ListView without builder
     - Missing dispose methods
     - Opacity widgets
     - Heavy computations in build()

4. **Audit Riverpod Providers**
   - Find all provider definitions
   - Check for proper scoping
   - Verify autoDispose usage
   - Check for circular dependencies

5. **Analyze Images & Assets**
   - Check asset directories
   - Verify image formats and sizes
   - Audit CachedNetworkImage usage

6. **Review Network Layer**
   - Audit network_service.dart
   - Check repository implementations
   - Verify caching strategies

7. **Check Memory Management**
   - Find all StatefulWidgets
   - Verify dispose() implementations
   - Check controller lifecycle

8. **Generate Performance Report**
   - List all performance issues with severity
   - Provide specific file paths and line numbers
   - Suggest concrete fixes with code examples
   - Estimate performance impact of each fix

## Tools to Use

- `mcp__serena__search_for_pattern` - Find antipatterns (regex patterns)
- `mcp__serena__find_symbol` - Analyze specific classes/methods
- `mcp__serena__get_symbols_overview` - Understand file structure
- `mcp__serena__find_referencing_symbols` - Understand dependencies
- `mcp__serena__list_dir` - Navigate codebase

## Output Format

```markdown
# Flutter Performance Audit Report

## Overall Performance Score: X/100

## Executive Summary
[2-3 sentences on performance health]

## Critical Performance Issues
1. **Issue**: [Description]
   - **Location**: [File:line]
   - **Impact**: [High/Medium/Low]
   - **Fix Time**: [Estimate]
   - **Fix**:
   ```dart
   // Before
   [Current code]

   // After
   [Optimized code]
   ```

## Performance Metrics Estimates
- Startup time: [Current] → [After optimization]
- Memory footprint: [Current] → [After optimization]
- Frame drops: [Current %] → [Target < 1%]
- Bundle size: [Current MB] → [After optimization]

## Category Breakdown

### Startup Performance (X/100)
[Findings and recommendations]

### Runtime Performance (X/100)
[Findings and recommendations]

### Memory Management (X/100)
[Findings and recommendations]

### Network Performance (X/100)
[Findings and recommendations]

### Rendering Performance (X/100)
[Findings and recommendations]

## Quick Wins (High Impact, Low Effort)
1. [Quick fix with big impact]

## Long-term Optimizations
1. [Architectural changes for better performance]

## Recommended Performance Testing
- [ ] Flutter DevTools performance overlay
- [ ] Memory profiling with heap snapshots
- [ ] Network profiling in DevTools
- [ ] Timeline recording for frame analysis
- [ ] Profile mode testing on real devices

## Performance Monitoring Setup
[Recommendations for ongoing performance monitoring]
```

**Remember**: Focus on real performance issues, not micro-optimizations. Prioritize user-facing performance (startup, animations, interactions) over theoretical improvements.
