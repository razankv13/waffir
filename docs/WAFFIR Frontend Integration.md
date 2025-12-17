# WAFFIR – Frontend Integration Documentation

> **Version**: FINAL  
> **Backend**: Supabase (PostgreSQL + Edge Functions)  
> **Auth**: Supabase Auth (OTP/Social)  
> **Languages**: Arabic (ar) • English (en)

---

## Table of Contents

1. [Authentication & Bootstrapping](#1-authentication--bootstrapping)
2. [Arabic & Language Rules](#2-arabic--language-rules)
3. [Home & Discovery](#3-home--discovery)
4. [Catalog Pages](#4-catalog-pages)
5. [Deal Details](#5-deal-details)
6. [Favorites](#6-favorites)
7. [Alerts](#7-alerts)
8. [Push Notifications](#8-push-notifications)
9. [Search (Unified)](#9-search-unified)
10. [Subscriptions & Payments](#10-subscriptions--payments)
11. [Family Plans](#11-family-plans)
12. [Savings Stats](#12-savings-stats)
13. [Profile & Settings](#13-profile--settings)

---

## 1. Authentication & Bootstrapping

> ⚠️ **Context**: We do not use email/password. We use Phone (OTP) or Social login. After login, you must strictly load the user's state to determine if they are a subscriber, a family member, or a new user eligible for promos.

### 1.1 Login Methods

#### A. OTP (Phone Number)

```javascript
// 1. Send Code
const { error } = await supabase.auth.signInWithOtp({
  phone: "+966500000000"
});

// 2. Verify Code
const { data, error } = await supabase.auth.verifyOtp({
  phone: "+966500000000",
  token: "123456",
  type: "sms"
});
```

#### B. Social Login

```javascript
// Google
supabase.auth.signInWithOAuth({
  provider: "google",
  options: { redirectTo: "app://callback" }
});

// Apple
supabase.auth.signInWithOAuth({
  provider: "apple",
  options: { redirectTo: "app://callback" }
});
```

### 1.2 The "After-Login" Sequence (Critical)

> 🔴 **Context**: Run these 4 calls immediately after a successful session is established.

#### Step 1: Get Account Summary

Returns basic stats (savings, status).

```javascript
await supabase.rpc("get_my_account_details");
```

#### Step 2: Load User Settings

Gets language (ar/en), city, and marketing consent.

```javascript
await supabase
  .from("user_settings")
  .select("*")
  .eq("user_id", auth.uid())
  .single();
```

#### Step 3: Check Promo Eligibility

> 📝 **Context**: If this returns TRUE, do NOT show them "Start Free Trial" promos.

```javascript
await supabase.rpc("user_has_had_subscription_before");
```

#### Step 4: Check Pending Invites

> 📝 **Context**: If they were invited to a family plan, show the Accept/Reject modal now.

```javascript
const { data: invites } = await supabase.rpc("get_my_family_invites");
```

### 1.3 Deep Link Logic (Family Invites)

> ⚠️ **Context**: If the app opens via a Dynamic Link, do NOT accept automatically. Authenticate first, then call the RPC.

```javascript
await supabase.rpc("respond_family_invite", {
  p_invite_id: inviteId,
  p_action: "accept" // or "reject"
});
```

### 1.4 Logout

```javascript
await supabase.auth.signOut();
```

---

## 2. Arabic & Language Rules

> 📝 **Context**: The app must handle dual-language display gracefully.

### 2.1 Source of Truth

- Check `user_settings.language`
- Default is `en`

### 2.2 Fallback Rule

- When language is `ar`: Display `_ar` fields
- If `_ar` is null/empty: Fallback to the English field

### 2.3 Do Not Translate

The following content should **never** be translated:

- ❌ Promo codes
- ❌ Prices & Currencies
- ❌ URLs & IDs
- ❌ Counts & Booleans
- ❌ Brand names / Model numbers

### 2.4 Field Mapping Reference

| Entity | Arabic Field | English Field |
|--------|-------------|---------------|
| **Stores** | `name_ar` | `name` |
| **Categories** | `name_ar` | `name_en` |
| **Product Deals** | `title_ar`, `description_ar` | `title`, `description` |
| **Store Offers** | `title_ar`, `terms_text_ar`, `store_name_ar` | `title`, `terms_text`, `store_name` |
| **Bank Offers** | `title_ar`, `bank_name_ar`, `merchant_name_ar` | `title`, `bank_name`, `merchant_name` |
| **Banks/Cards** | `name_ar` | `name` |

### 2.5 Select Query Example

> 💡 **Best Practice**: Always select both columns so the frontend can handle the language switch.

```javascript
await supabase
  .from("product_deals")
  .select(`
    id,
    title,
    title_ar,
    subtitle,
    subtitle_ar,
    description,
    description_ar,
    image_url,
    store_id
  `)
  .eq("id", dealId)
  .single();
```

---

## 3. Home & Discovery (The Feeds)

### 3.1 Product Deals Feed

> 📝 **Context**: Pagination handled via limit/offset.

```javascript
await supabase.rpc("get_frontpage_products", {
  p_limit: 20,
  p_offset: 0
});
```

### 3.2 Track View & Like

> 📝 **Context**: Call `track_deal_view` when a user opens a deal details screen.

```javascript
// Track View
await supabase.rpc("track_deal_view", {
  p_deal_type: "product",
  p_deal_id: deal.id
});

// Toggle Like
await supabase.rpc("toggle_deal_like", {
  p_deal_type: "product",
  p_deal_id: deal.id
});
```

---

## 4. Catalog Pages

### 4.1 Store Page

> 📝 **Context**: Shows store info + list of offers.

```javascript
// 1. Load Store Details
await supabase
  .from("stores")
  .select("*")
  .eq("id", storeId)
  .single();

// 2. Load Store Offers
await supabase.rpc("get_store_offers", {
  p_store_id: storeId,
  p_limit: 20,
  p_offset: 0
});

// 3. Toggle Favorite Store
await supabase.rpc("toggle_favorite_store", {
  p_store_id: storeId
});
```

### 4.2 Bank Page

> 📝 **Context**: Shows offers for a specific bank or user's selected cards.

```javascript
// 1. List All Banks (for filter)
await supabase
  .from("banks")
  .select("*")
  .eq("is_active", true);

// 2. Load Offers for a Bank
await supabase.rpc("get_bank_offers", {
  p_bank_id: bankId,
  p_limit: 20,
  p_offset: 0
});

// 3. Get My Cards
await supabase.rpc("get_my_bank_cards");

// 4. Set My Cards (Save user preference)
await supabase.rpc("set_user_bank_cards", {
  p_card_ids: ["uuid1", "uuid2"]
});
```

---

## 5. Deal Details

> 📝 **Context**: When a user clicks a card, load the full details.

### 5.1 Product Deal

```javascript
await supabase
  .from("product_deals")
  .select("*")
  .eq("id", dealId)
  .single();
```

### 5.2 Store Offer

```javascript
await supabase
  .from("store_offers")
  .select("*")
  .eq("id", dealId)
  .single();
```

### 5.3 Bank Offer

```javascript
await supabase
  .from("bank_card_offers")
  .select("*")
  .eq("id", dealId)
  .single();
```

---

## 6. Favorites

### 6.1 Get All Favorites

Returns mixed list of liked products/offers.

```javascript
await supabase.rpc("get_user_favorites");
```

### 6.2 Get Favorite Stores

Returns list of stores user has hearted.

```javascript
await supabase
  .from("user_favorite_stores")
  .select("store_id, stores(*)")
  .eq("user_id", auth.uid());
```

---

## 7. Alerts

> 📝 **Context**: Users subscribe to keywords (e.g., "iPhone").

### 7.1 Manage Alerts

```javascript
// Create
await supabase
  .from("deal_alerts")
  .insert({ keyword: "iphone" });

// List
await supabase
  .from("deal_alerts")
  .select("*")
  .eq("user_id", auth.uid());

// Delete
await supabase
  .from("deal_alerts")
  .delete()
  .eq("id", alertId);
```

### 7.2 Get Suggestions

Returns trending keywords.

```javascript
await supabase.rpc("get_popular_alert_keywords");
```

---

## 8. Push Notifications

> 🔴 **REQUIRED**: Call this on app launch to register the device.

```javascript
await supabase.rpc("upsert_device_token", {
  p_token: deviceToken,
  p_device_type: "ios" // or "android"
});
```

---

## 9. Search (Unified)

> 📝 **Context**: One search bar searches Products, Stores, and Bank Offers simultaneously.

### RPC: `search_all_deals`

**Logic:**
- **Minimum**: 2 characters
- **Debounce**: 300-400ms
- **Navigation**: Based on `deal_type` in response

```javascript
await supabase.rpc("search_all_deals", {
  q: queryText,
  p_limit: 30,
  p_offset: 0
});
```

---

## 10. Subscriptions & Payments

> 🔴 **Context**: Frontend never activates directly. Use Edge Functions.

### 10.1 Get Plans

```javascript
await supabase
  .from("subscription_plans")
  .select("*")
  .eq("is_active", true);
```

### 10.2 Purchase Flow (iOS)

```http
POST /functions/v1/verify-and-activate-subscription
Authorization: Bearer <user_access_token>
Content-Type: application/json

{
  "platform": "ios",
  "transaction_id": "<apple_transaction_id>"
}
```

### 10.3 Purchase Flow (Android)

```http
POST /functions/v1/verify-and-activate-subscription
Authorization: Bearer <user_access_token>
Content-Type: application/json

{
  "platform": "android",
  "purchase_token": "<google_purchase_token>",
  "product_id": "<google_product_id>"
}
```

### 10.4 Post-Purchase Refresh

After success, refresh account state immediately.

```javascript
await supabase.rpc("get_my_account_details");
```

---

## 11. Family Plans

> 📝 **Context**: Only users with `plan_type = 'family'` can see this UI.

### 11.1 Check Family Status

```javascript
const { data: sub } = await supabase
  .from("user_subscriptions")
  .select("is_active, subscription_plans(plan_type)")
  .eq("user_id", auth.uid())
  .eq("is_active", true)
  .maybeSingle();

const isFamilyPlan = sub?.subscription_plans?.plan_type === "family";
```

### 11.2 Manage Group

```javascript
// Create Group
await supabase.rpc("create_family_group");

// Invite Member
await supabase.rpc("create_family_invite", {
  p_email: "test@example.com"
});

// Remove Member (Cooldown Enforced)
await supabase.rpc("remove_family_member", {
  p_member_id: memberUserId
});
```

---

## 12. Savings Stats

> 📝 **Context**: Shows "Total Savings" on profile.

```javascript
await supabase.rpc("get_user_savings", {
  p_year: 2025
});
```

---

## 13. Profile & Settings

### 13.1 Update Profile

```javascript
await supabase.rpc("update_user_profile", {
  p_full_name: "Mustafa",
  p_gender: "male",
  p_avatar_url: "https://cdn/avatar.png"
});
```

### 13.2 Update Settings (Language)

```javascript
await supabase.rpc("update_user_settings", {
  p_language: "ar", // or 'en'
  p_city_id: "uuid",
  p_marketing_consent: true
});
```

### 13.3 Notification Preferences

```javascript
await supabase.rpc("update_notification_settings", {
  p_notify_push_enabled: true,
  p_notify_email_enabled: false
});
```

### 13.4 Delete Account

> 📱 **Required by Apple App Store guidelines**

```javascript
await supabase.rpc("request_account_deletion");
```

---

## Support

For technical support or questions about this integration documentation, please contact the development team.

---

**Last Updated**: December 2024  
**Maintained By**: WAFFIR Development Team