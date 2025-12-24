# RevenueCat Setup Guide

This guide walks you through the complete setup process to enable in-app purchases in Waffir using RevenueCat.

---

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Step 1: Create RevenueCat Account & Project](#step-1-create-revenuecat-account--project)
3. [Step 2: Configure App Store Connect (iOS)](#step-2-configure-app-store-connect-ios)
4. [Step 3: Configure Google Play Console (Android)](#step-3-configure-google-play-console-android)
5. [Step 4: Create Products in RevenueCat](#step-4-create-products-in-revenuecat)
6. [Step 5: Create Entitlements](#step-5-create-entitlements)
7. [Step 6: Create Offerings](#step-6-create-offerings)
8. [Step 7: Configure Environment Variables](#step-7-configure-environment-variables)
9. [Step 8: Update Package Identifiers (If Needed)](#step-8-update-package-identifiers-if-needed)
10. [Step 9: Testing](#step-9-testing)
11. [Step 10: Go Live Checklist](#step-10-go-live-checklist)
12. [Troubleshooting](#troubleshooting)

---

## Prerequisites

Before starting, ensure you have:

- [ ] Apple Developer Account (for iOS)
- [ ] Google Play Developer Account (for Android)
- [ ] App already created in App Store Connect
- [ ] App already created in Google Play Console
- [ ] Paid Apps Agreement signed in both stores

---

## Step 1: Create RevenueCat Account & Project

### 1.1 Create Account
1. Go to [RevenueCat Dashboard](https://app.revenuecat.com/)
2. Sign up or log in

### 1.2 Create New Project
1. Click **"+ New Project"**
2. Name it: `Waffir` (or your preferred name)
3. Click **Create Project**

### 1.3 Add iOS App
1. In your project, go to **Apps** in the left sidebar
2. Click **"+ New App"**
3. Select **App Store**
4. Fill in:
   - **App Name**: `Waffir iOS`
   - **Bundle ID**: `net.waffir.app` (must match your Xcode bundle ID)
5. Click **Save**

### 1.4 Add Android App
1. Click **"+ New App"** again
2. Select **Play Store**
3. Fill in:
   - **App Name**: `Waffir Android`
   - **Package Name**: `net.waffir.app` (must match your Android package name)
4. Click **Save**

### 1.5 Get API Keys
1. Go to **API Keys** in the left sidebar (under Project Settings)
2. Copy the **Public SDK Key** for iOS → Save as `REVENUECAT_API_KEY_IOS`
3. Copy the **Public SDK Key** for Android → Save as `REVENUECAT_API_KEY_ANDROID`

> **Important**: These are PUBLIC keys, safe to include in your app. Never share your SECRET keys.

---

## Step 2: Configure App Store Connect (iOS)

### 2.1 Create Subscription Group
1. Log in to [App Store Connect](https://appstoreconnect.apple.com/)
2. Select your app → **Subscriptions** tab
3. Click **"+"** to create a new Subscription Group
4. Name it: `Waffir Premium`

### 2.2 Create Subscription Products
Create **4 subscription products** in the subscription group:

| Reference Name | Product ID | Duration | Price (suggested) |
|----------------|------------|----------|-------------------|
| Waffir Individual Monthly | `waffir_individual_monthly` | 1 Month | $3.99 / 4 SAR |
| Waffir Individual Yearly | `waffir_individual_yearly` | 1 Year | $39.99 / 38 SAR |
| Waffir Family Monthly | `waffir_family_monthly` | 1 Month | $11.99 / 12 SAR |
| Waffir Family Yearly | `waffir_family_yearly` | 1 Year | $99.99 / 100 SAR |

For each product:
1. Click **"+"** next to your subscription group
2. Fill in Reference Name and Product ID
3. Set Subscription Duration
4. Add Subscription Prices (localized)
5. Add App Store Localization (display name, description)
6. Save

### 2.3 Create Shared Secret
1. Go to your app in App Store Connect
2. Navigate to **App Information** → **App-Specific Shared Secret**
3. Click **Generate** if not already created
4. Copy the shared secret

### 2.4 Connect to RevenueCat
1. Go back to RevenueCat Dashboard
2. Select your iOS app
3. Go to **App Settings**
4. Paste the **App-Specific Shared Secret**
5. Save

---

## Step 3: Configure Google Play Console (Android)

### 3.1 Create Subscription Products
1. Log in to [Google Play Console](https://play.google.com/console/)
2. Select your app → **Monetize** → **Subscriptions**
3. Click **"Create subscription"**

Create **4 subscription products**:

| Product ID | Base Plan ID | Billing Period | Price |
|------------|--------------|----------------|-------|
| `waffir_individual` | `monthly` | Monthly | $3.99 / 4 SAR |
| `waffir_individual` | `yearly` | Yearly | $39.99 / 38 SAR |
| `waffir_family` | `monthly` | Monthly | $11.99 / 12 SAR |
| `waffir_family` | `yearly` | Yearly | $99.99 / 100 SAR |

> **Note**: In Google Play, you create one subscription product with multiple base plans for different durations.

For each subscription:
1. Click **"Create subscription"**
2. Enter Product ID (e.g., `waffir_individual`)
3. Add a Base Plan with the billing period
4. Set prices
5. Activate the subscription

### 3.2 Create Service Account for RevenueCat
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select or create a project linked to your Play Console
3. Go to **IAM & Admin** → **Service Accounts**
4. Click **"+ Create Service Account"**
5. Name it: `RevenueCat Integration`
6. Click **Create and Continue**
7. Skip role assignment, click **Done**
8. Click on the created service account
9. Go to **Keys** tab → **Add Key** → **Create new key** → **JSON**
10. Download the JSON file (keep it secure!)

### 3.3 Grant Permissions in Play Console
1. Go to [Google Play Console](https://play.google.com/console/)
2. Go to **Users and permissions** → **Invite new users**
3. Add the service account email (from the JSON file)
4. Grant these permissions:
   - **View app information and download bulk reports**
   - **View financial data, orders, and cancellation survey responses**
   - **Manage orders and subscriptions**
5. Click **Invite user**
6. Go to your app → **Users and permissions** → Add the same service account with **Admin** access

### 3.4 Connect to RevenueCat
1. Go to RevenueCat Dashboard
2. Select your Android app
3. Go to **App Settings** → **Play Store Credentials**
4. Upload the Service Account JSON file
5. Save

---

## Step 4: Create Products in RevenueCat

### 4.1 Add iOS Products
1. In RevenueCat, select your **iOS app**
2. Go to **Products**
3. Click **"+ New Product"**
4. Add each product with the **exact Product ID** from App Store Connect:

| Identifier | Store Product ID |
|------------|------------------|
| `waffir_individual_monthly` | `waffir_individual_monthly` |
| `waffir_individual_yearly` | `waffir_individual_yearly` |
| `waffir_family_monthly` | `waffir_family_monthly` |
| `waffir_family_yearly` | `waffir_family_yearly` |

### 4.2 Add Android Products
1. Select your **Android app**
2. Go to **Products**
3. Click **"+ New Product"**
4. Add each product (use `productId:basePlanId` format):

| Identifier | Store Product ID |
|------------|------------------|
| `waffir_individual_monthly` | `waffir_individual:monthly` |
| `waffir_individual_yearly` | `waffir_individual:yearly` |
| `waffir_family_monthly` | `waffir_family:monthly` |
| `waffir_family_yearly` | `waffir_family:yearly` |

---

## Step 5: Create Entitlements

Entitlements define what users get access to after purchasing.

1. Go to your **Project** → **Entitlements**
2. Click **"+ New Entitlement"**
3. Create **2 entitlements**:

| Identifier | Description |
|------------|-------------|
| `waffir_single` | Individual premium access |
| `waffir_family` | Family premium access |

### 5.1 Attach Products to Entitlements

For **waffir_single**:
1. Click on the entitlement
2. Click **"+ Attach"**
3. Select both iOS and Android apps
4. Attach these products:
   - `waffir_individual_monthly`
   - `waffir_individual_yearly`

For **waffir_family**:
1. Click on the entitlement
2. Click **"+ Attach"**
3. Attach these products:
   - `waffir_family_monthly`
   - `waffir_family_yearly`

---

## Step 6: Create Offerings

Offerings are the packages shown to users.

### 6.1 Create Default Offering
1. Go to **Offerings**
2. Click **"+ New Offering"**
3. Create offering:
   - **Identifier**: `default`
   - **Description**: `Default subscription offering`

### 6.2 Add Packages to Offering
Click on the offering and add **4 packages**:

| Identifier | Product (iOS) | Product (Android) |
|------------|---------------|-------------------|
| `$rc_monthly` | `waffir_individual_monthly` | `waffir_individual_monthly` |
| `$rc_annual` | `waffir_individual_yearly` | `waffir_individual_yearly` |
| `monthly_family` | `waffir_family_monthly` | `waffir_family_monthly` |
| `annual_family` | `waffir_family_yearly` | `waffir_family_yearly` |

> **Note**: `$rc_monthly` and `$rc_annual` are RevenueCat's standard package identifiers.

### 6.3 Set as Current Offering
1. Click the **"..."** menu on your offering
2. Select **"Make Current"**

---

## Step 7: Configure Environment Variables

### 7.1 Update Environment Files

Add your API keys to the environment files:

**`.env.dev`** (for development/testing):
```dotenv
# RevenueCat API Keys
REVENUECAT_API_KEY_IOS=appl_your_ios_dev_key_here
REVENUECAT_API_KEY_ANDROID=goog_your_android_dev_key_here
```

**`.env.staging`** (for staging):
```dotenv
# RevenueCat API Keys
REVENUECAT_API_KEY_IOS=appl_your_ios_staging_key_here
REVENUECAT_API_KEY_ANDROID=goog_your_android_staging_key_here
```

**`.env.production`** (for production):
```dotenv
# RevenueCat API Keys
REVENUECAT_API_KEY_IOS=appl_your_ios_production_key_here
REVENUECAT_API_KEY_ANDROID=goog_your_android_production_key_here
```

> **Tip**: You can use the same keys for all environments, or create separate RevenueCat apps for each environment.

### 7.2 Verify Configuration

After adding keys, run the app and check logs for:
```
[RevenueCat] Successfully initialized RevenueCat
```

If you see an error, double-check your API keys.

---

## Step 8: Update Package Identifiers (If Needed)

If your package identifiers differ from the defaults, update:

**File**: `lib/features/subscription/domain/constants/subscription_constants.dart`

```dart
class SubscriptionConstants {
  // Entitlement IDs (must match RevenueCat dashboard)
  static const String singleEntitlement = 'waffir_single';
  static const String familyEntitlement = 'waffir_family';

  // Package Identifiers (must match RevenueCat offerings)
  static const String monthlySingle = r'$rc_monthly';      // Update if different
  static const String yearlySingle = r'$rc_annual';        // Update if different
  static const String monthlyFamily = 'monthly_family';    // Update if different
  static const String yearlyFamily = 'annual_family';      // Update if different
}
```

---

## Step 9: Testing

### 9.1 Enable Sandbox Testing (iOS)

1. In App Store Connect, go to **Users and Access** → **Sandbox** tab
2. Click **"+"** to create a Sandbox Tester
3. Use a **new email** (not your Apple ID)
4. Fill in details and save

On your **test device**:
1. Sign out of App Store (Settings → App Store → Sign Out)
2. Run the app and try to purchase
3. When prompted, sign in with Sandbox account

### 9.2 Enable License Testing (Android)

1. In Google Play Console, go to **Settings** → **License testing**
2. Add your test email addresses
3. Set **License response** to `RESPOND_NORMALLY`

On your **test device**:
1. Make sure you're signed in with a test account
2. Install the app via `flutter run` or internal testing track
3. Purchases will be test purchases (no real charges)

### 9.3 RevenueCat Debug Mode

The app enables debug logs in non-production environments. Check the console for detailed RevenueCat logs:
- Offerings loaded
- Purchase initiated
- Purchase completed/failed
- Customer info updated

### 9.4 Test Scenarios

Test these scenarios before going live:

- [ ] Purchase Individual Monthly
- [ ] Purchase Individual Yearly
- [ ] Purchase Family Monthly
- [ ] Purchase Family Yearly
- [ ] Cancel purchase mid-flow
- [ ] Restore purchases (on fresh install)
- [ ] Upgrade from Monthly to Yearly
- [ ] Check entitlement after purchase
- [ ] App restart maintains subscription status

---

## Step 10: Go Live Checklist

Before releasing to production:

### RevenueCat Dashboard
- [ ] All products created and active
- [ ] Entitlements configured correctly
- [ ] Offerings set up with all packages
- [ ] Default offering is set as current
- [ ] iOS shared secret configured
- [ ] Android service account configured

### App Store Connect
- [ ] All subscriptions created and approved
- [ ] Subscription Group configured
- [ ] Localized subscription display names
- [ ] Review Information provided

### Google Play Console
- [ ] All subscriptions created and active
- [ ] Base plans configured
- [ ] Pricing set for all regions
- [ ] Subscription benefits described

### App Configuration
- [ ] Production API keys in `.env.production`
- [ ] Package identifiers match RevenueCat
- [ ] Entitlement IDs match RevenueCat
- [ ] Debug logs disabled in production

### Testing
- [ ] Sandbox purchases work (iOS)
- [ ] License test purchases work (Android)
- [ ] Restore purchases works
- [ ] Subscription status persists after app restart

---

## Troubleshooting

### "Service unavailable" message
- **Cause**: RevenueCat not initialized or API key invalid
- **Fix**: Check API keys in environment file, check console for initialization errors

### "Plan not available" message
- **Cause**: Package not found in offerings
- **Fix**: Verify package identifiers match between code and RevenueCat dashboard

### Purchases work in sandbox but not production
- **Cause**: Production products not approved or misconfigured
- **Fix**: Ensure all products are approved in App Store Connect / Google Play Console

### "Already subscribed" but user doesn't have access
- **Cause**: Entitlement not properly attached to product
- **Fix**: In RevenueCat, verify product is attached to correct entitlement

### Customer info not updating
- **Cause**: Cache or network issue
- **Fix**: Call `refreshCustomerInfo()` or restart app

### Android purchases failing
- **Cause**: Service account not properly configured
- **Fix**: Re-upload service account JSON, verify permissions in Play Console

### iOS purchases failing
- **Cause**: Shared secret mismatch or sandbox account issue
- **Fix**: Regenerate shared secret, create new sandbox tester

---

## Useful Links

- [RevenueCat Documentation](https://docs.revenuecat.com/)
- [RevenueCat Flutter SDK](https://docs.revenuecat.com/docs/flutter)
- [App Store Connect Subscriptions](https://developer.apple.com/app-store/subscriptions/)
- [Google Play Billing](https://developer.android.com/google/play/billing)
- [RevenueCat Dashboard](https://app.revenuecat.com/)

---

## Support

If you encounter issues:

1. Check RevenueCat's [Status Page](https://status.revenuecat.com/)
2. Search [RevenueCat Community](https://community.revenuecat.com/)
3. Contact RevenueCat support via dashboard

---

*Last updated: December 2024*
