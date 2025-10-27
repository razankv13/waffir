---
description: Comprehensive production readiness audit - checks app quality, security, performance, monetization, and store readiness
---

You are a **Production Readiness Expert** for Flutter apps. Your mission is to audit this Waffir app against world-class production standards and provide a comprehensive readiness report.

## Your Task

Perform a thorough production readiness audit covering:

### 1. App Store Readiness (Critical)
- [ ] App icons present and optimized for all platforms (iOS, Android, macOS, Web)
- [ ] Launch screens/splash screens properly configured
- [ ] App name, bundle ID, version numbers correct across all flavors
- [ ] Privacy policy, terms of service URLs configured
- [ ] App Store screenshots and marketing assets ready
- [ ] App Store Connect metadata complete
- [ ] TestFlight beta testing completed
- [ ] Age rating appropriate and justified
- [ ] App categories selected appropriately
- [ ] Keywords optimized for ASO (App Store Optimization)

### 2. Legal & Compliance
- [ ] Privacy policy present and accessible
- [ ] Terms of service present
- [ ] GDPR compliance (EU users)
- [ ] CCPA compliance (California users)
- [ ] COPPA compliance if targeting children
- [ ] RevenueCat subscription terms clear
- [ ] AdMob consent management working
- [ ] Data collection disclosure complete
- [ ] Third-party SDK disclosures (Supabase, Clarity, Sentry, etc.)
- [ ] Open source licenses attributed

### 3. Security Audit
- [ ] No hardcoded API keys, secrets, or credentials in code
- [ ] Environment variables properly secured (.env not in git)
- [ ] SSL pinning for critical API calls
- [ ] Supabase Row-Level Security (RLS) policies implemented
- [ ] Authentication tokens securely stored (Hive encryption working)
- [ ] Biometric authentication implemented where appropriate
- [ ] Deep link security validated
- [ ] Code obfuscation enabled for release builds
- [ ] ProGuard/R8 rules optimized for Android
- [ ] iOS App Transport Security configured
- [ ] No console.log or print statements in production
- [ ] Sensitive data not logged or tracked

### 4. Performance Optimization
- [ ] App launch time < 2 seconds
- [ ] No memory leaks detected
- [ ] Image assets optimized (WebP where possible)
- [ ] Network calls optimized with caching
- [ ] Lazy loading implemented for heavy screens
- [ ] Bundle size optimized (< 50MB ideal)
- [ ] Tree shaking configured properly
- [ ] Unnecessary dependencies removed
- [ ] Animations run at 60fps consistently
- [ ] Riverpod providers optimized (no unnecessary rebuilds)
- [ ] Database queries optimized (indexed where needed)
- [ ] Frame drops < 1% in production

### 5. Monetization Health
- [ ] RevenueCat properly initialized and tested
- [ ] In-app purchase flows work end-to-end
- [ ] Subscription restoration working
- [ ] Receipt validation implemented
- [ ] AdMob ad units created and configured
- [ ] Ad placement optimized for UX and revenue
- [ ] Premium features clearly differentiated
- [ ] Paywall conversion optimized (A/B tested)
- [ ] Subscription tiers compelling and priced right
- [ ] Free trial period configured appropriately
- [ ] Refund policies clear

### 6. Quality Assurance
- [ ] No critical bugs in production paths
- [ ] Error handling comprehensive (no unhandled exceptions)
- [ ] Offline mode works gracefully
- [ ] Network error states handled properly
- [ ] Loading states shown appropriately
- [ ] Empty states designed and implemented
- [ ] Form validation comprehensive
- [ ] Deep linking works correctly
- [ ] Push notifications working (if Firebase enabled)
- [ ] Analytics tracking key events
- [ ] Crash reporting configured (Sentry)

### 7. User Experience Polish
- [ ] Onboarding flow intuitive and engaging
- [ ] Navigation logical and consistent
- [ ] Loading indicators on all async operations
- [ ] Error messages user-friendly
- [ ] Success feedback provided
- [ ] Haptic feedback where appropriate
- [ ] Dark mode fully supported
- [ ] Localization complete for target languages
- [ ] Accessibility labels present
- [ ] Font scaling works properly
- [ ] Responsive design for tablets
- [ ] Keyboard handling proper

### 8. Testing Coverage
- [ ] Critical user flows have integration tests
- [ ] Unit tests for business logic
- [ ] Widget tests for key components
- [ ] Golden tests for UI consistency
- [ ] Tested on physical devices (not just emulators)
- [ ] Tested on low-end devices
- [ ] Tested in poor network conditions
- [ ] Tested with different OS versions
- [ ] Beta tested with real users
- [ ] Crash-free rate > 99.5%

### 9. Infrastructure & DevOps
- [ ] CI/CD pipeline configured
- [ ] Automated builds working
- [ ] Code signing properly configured
- [ ] Fastlane setup for deployments
- [ ] Version bumping automated
- [ ] Release notes generated automatically
- [ ] Rollback strategy defined
- [ ] Monitoring and alerting configured
- [ ] Backend health checks in place
- [ ] Rate limiting implemented

### 10. Marketing & Growth
- [ ] App Store preview video created
- [ ] Social media assets prepared
- [ ] Landing page created
- [ ] Email marketing prepared
- [ ] Referral program implemented
- [ ] Share functionality working
- [ ] Deep links for marketing campaigns
- [ ] Attribution tracking configured
- [ ] Launch PR strategy defined
- [ ] Influencer outreach prepared

## Execution Steps

1. **Read Project Context**
   - Use `mcp__serena__read_memory` to understand architecture, environment, UI guidelines
   - Read CLAUDE.md for project overview

2. **Audit Each Category**
   - Use `mcp__serena__find_symbol` to locate critical code sections
   - Use `mcp__serena__search_for_pattern` to find potential issues (hardcoded keys, TODO comments, etc.)
   - Read configuration files (.env.example, pubspec.yaml, build files)
   - Check asset directories

3. **Generate Comprehensive Report**
   - Score each category (0-100%)
   - List critical issues (must-fix before launch)
   - List recommended improvements
   - Provide specific file paths and line numbers for issues
   - Estimate time to fix each issue
   - Calculate overall production readiness score

4. **Create Action Plan**
   - Prioritize issues by severity
   - Create todo items for critical fixes
   - Provide code snippets for common fixes
   - Suggest tools and resources

## Output Format

Provide a detailed markdown report with:

```markdown
# Production Readiness Audit Report
**Date**: [Current date]
**Overall Score**: X/100

## Executive Summary
[2-3 sentences on overall readiness]

## Critical Issues (Must Fix Before Launch)
1. [Issue] - [Location] - [Estimated fix time]

## Category Scores
- App Store Readiness: X/100
- Legal & Compliance: X/100
- Security: X/100
- Performance: X/100
- Monetization: X/100
- Quality Assurance: X/100
- User Experience: X/100
- Testing: X/100
- Infrastructure: X/100
- Marketing: X/100

## Detailed Findings
[For each category, list specific findings with file paths]

## Action Plan
[Prioritized list of fixes with time estimates]

## Recommendations
[Best practices and suggestions for improvement]
```

**Remember**: Be thorough but pragmatic. Focus on issues that actually impact launch readiness. Provide actionable feedback with specific file locations and code examples.
