# YarnBarn — Mom's Crochet Corner 🧶

A responsive crochet catalog with WhatsApp inquiries and an admin product manager. No checkout or payments.

## What is included
- `index.html`: storefront and admin interface
- `config.js`: Supabase public project settings and your WhatsApp number
- `schema.sql`: database, storage bucket, and access policies

## Publish in 6 steps

1. **Create a Supabase project** at https://supabase.com and wait for its database to finish provisioning.
2. In **SQL Editor**, paste and run the contents of `schema.sql`. This creates the `products` table, photo storage, and row-level security policies. Run it once on a fresh project.
3. In **Authentication → Users**, create your admin user with an email and password (or invite them, depending on dashboard options). Copy the user's UUID. In **SQL Editor**, run:
   ```sql
   insert into public.admin_users (user_id) values ('0d91ef0b-ffaa-4b02-ba52-2c6416c26a4c');
   ```
   You must complete any required email confirmation before logging in.
4. In **Project Settings / Connect / API settings** (label depends on Supabase dashboard version), copy your **Project URL** and **anon/publishable key** into `config.js`. **Never use a service_role/secret key in client code.** Set `whatsappNumber` to your number in international format without `+`, spaces, or leading zeros (example for Germany: `491701234567`). Change `currency` if desired.
5. **Publish** by uploading `index.html` and `config.js` to a static host. For example, go to https://app.netlify.com/drop and drag the `yarnbarn` folder there. The site will get a shareable URL. The `schema.sql` file is only for Supabase setup; it need not be publicly hosted.
6. Open the live site, click **Manage shop**, sign in with your approved admin account, and add your first product. Test the public product page and WhatsApp buttons on your phone.

## Important notes
- **Product data is shared** through Supabase: you can manage it from any device after signing in, and customers see your updates.
- **Only approved admin accounts** in `admin_users` can add/edit/delete products or upload photos. Product information and photos are public to everyone.
- Do not publish private contact details in source control except the WhatsApp number you intend customers to see.
- The WhatsApp button opens a prepared message; customers still need to tap Send. They do not order or pay through the website.
- Photo size limit: 5 MB. Accepted formats: JPEG, PNG, WebP, GIF.
- If you want to change the shop name, text, or colors, edit `index.html`.
- Supabase and hosting free tiers, quotas, and pricing can change. Check the provider's current terms.
- For production, configure authentication security settings and consider a privacy notice appropriate for your location and usage.

## Troubleshooting
- **Shop setup needed:** `config.js` still contains placeholders, or was not deployed alongside `index.html`.
- **Cannot log in:** Verify your Supabase user exists, is confirmed, and has an `admin_users` row with their UUID.
- **Permission denied on save:** Check that SQL policies ran successfully and your admin membership exists.
- **Photos do not load:** Check that `product-photos` is a public storage bucket and that the image upload succeeded.

## Local preview
Serve the folder through any local static server, e.g. `python3 -m http.server 8000` then open http://localhost:8000. The backend must still be configured for real product management.
