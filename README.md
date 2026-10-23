# Route to Job: setup with Supabase auth

No server needed. Supabase handles accounts; the site is static files.

## 1. Create the project
1. Sign up at supabase.com and click **New project**.
2. Open **Project Settings > API**. Copy the **Project URL** and the **anon public** key into `config.js`.

## 2. Create the database table
Open **SQL Editor**, paste everything from `schema.sql`, and click **Run**.

## 3. Email and password
Under **Authentication > Providers > Email**, keep it enabled. Leave "Confirm email" on for production, or turn it off while testing.

## 4. Google sign-in
1. In Google Cloud Console, open **APIs & Services > Credentials > Create credentials > OAuth client ID** (type: Web application).
2. Under **Authorized redirect URIs** add: `https://YOUR-PROJECT.supabase.co/auth/v1/callback`
3. In Supabase, open **Authentication > Providers > Google**, enable it and paste the Client ID and Client Secret.

## 5. Allow your site URL
In **Authentication > URL Configuration** set **Site URL** to your live address (for local testing use `http://localhost:3000`) and add the same address under **Redirect URLs**.

## 6. Run locally
```
npx serve .
```
Open the printed address. Do not open index.html by double-clicking, because Google login needs a real http address.

## 7. Deploy
Drag this folder onto Netlify Drop, or push it to GitHub and connect Vercel or Cloudflare Pages. Then add the live URL to step 5.

---

# Premium questions and Razorpay payments

## A. Database
Run `schema_premium.sql` once in the Supabase SQL Editor. It creates the questions table, the premium access tables, and 48 starter questions (24 free, 24 premium). Premium rows are protected by row-level security, so users without a paid plan cannot read them, even by inspecting the page.

Add or edit questions any time in **Table Editor > questions**. Set `is_premium` to true to lock a question. `options` is a JSON list like `["A","B","C","D"]` and `answer` is the position of the right option, starting from 0. You can also import a CSV from the same screen.

## B. Razorpay
1. Create an account at razorpay.com. Stay in **Test mode** until everything works.
2. **Settings > API Keys > Generate key**. Copy the Key Id and Key Secret.

## C. Deploy the two payment functions
Install the Supabase CLI (`npm i -g supabase` or use `npx supabase`), then in this folder run:

```
npx supabase login
npx supabase link --project-ref YOUR-PROJECT-REF
npx supabase secrets set RAZORPAY_KEY_ID=rzp_test_xxx RAZORPAY_KEY_SECRET=xxx PRICE_PAISE=49900 PLAN_DAYS=365
npx supabase functions deploy create-order
npx supabase functions deploy razorpay-webhook --no-verify-jwt
```
`PRICE_PAISE` is the price in paise (49900 = ₹499). Your project ref is the part of your Project URL before `.supabase.co`.

## D. Webhook
In Razorpay go to **Settings > Webhooks > Add new webhook**:
- URL: `https://YOUR-PROJECT-REF.supabase.co/functions/v1/razorpay-webhook`
- Secret: make up a long random string
- Events: `payment.captured` and `order.paid`

Then save the same secret in Supabase:
```
npx supabase secrets set RAZORPAY_WEBHOOK_SECRET=your-random-string
```

## E. Show the price on the site
In `config.js` set `PRICE_LABEL` to match `PRICE_PAISE` (for example "₹499 / year").

## F. Test
Log in, click **Go Pro**, pay with Razorpay test card/UPI details from their docs, and the premium questions unlock within seconds. Check **Table Editor > entitlements** to see the row. When ready, switch Razorpay to Live mode, generate live keys, repeat step C's `secrets set` with them, and create a live webhook.

Never put the Razorpay Key Secret or the service_role key in `config.js` or `index.html`.

---

# Theory and behavioral questions
Run `schema_theory.sql` once in the Supabase SQL Editor. It adds 48 questions (24 free, 24 premium): two theory and two behavioral per company, each with a written answer. Free users can read the free ones; premium ones follow the same locking as before. To add more, use **Table Editor > questions**, set `type` to Theory or Behavioral, put the answer in `answer_text`, and leave `options` and `answer` empty.
