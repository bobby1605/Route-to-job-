// Razorpay calls this after a payment. We verify the signature, then unlock the user.
import { createClient } from "npm:@supabase/supabase-js@2";

const enc = new TextEncoder();

async function sign(secret: string, body: string) {
  const key = await crypto.subtle.importKey("raw", enc.encode(secret), { name: "HMAC", hash: "SHA-256" }, false, ["sign"]);
  const mac = await crypto.subtle.sign("HMAC", key, enc.encode(body));
  return [...new Uint8Array(mac)].map((x) => x.toString(16).padStart(2, "0")).join("");
}
function safeEqual(a: string, b: string) {
  if (a.length !== b.length) return false;
  let d = 0;
  for (let i = 0; i < a.length; i++) d |= a.charCodeAt(i) ^ b.charCodeAt(i);
  return d === 0;
}

Deno.serve(async (req) => {
  const body = await req.text();
  const expected = await sign(Deno.env.get("RAZORPAY_WEBHOOK_SECRET")!, body);
  if (!safeEqual(expected, req.headers.get("x-razorpay-signature") ?? "")) {
    return new Response("Bad signature", { status: 401 });
  }

  const ev = JSON.parse(body);
  if (ev.event !== "payment.captured" && ev.event !== "order.paid") return new Response("ignored");

  const pay = ev.payload?.payment?.entity;
  const userId = pay?.notes?.user_id ?? ev.payload?.order?.entity?.notes?.user_id;
  if (!pay?.id || !userId) return new Response("missing data", { status: 400 });

  const admin = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!);

  // Each payment counts once, even if Razorpay sends both events or retries.
  const { error: dup } = await admin.from("payments").insert({
    payment_id: pay.id, user_id: userId, order_id: pay.order_id, amount: pay.amount,
  });
  if (dup) return new Response(dup.code === "23505" ? "already processed" : dup.message, { status: dup.code === "23505" ? 200 : 500 });

  const days = Number(Deno.env.get("PLAN_DAYS") ?? "365");
  const { data: cur } = await admin.from("entitlements").select("expires_at").eq("user_id", userId).maybeSingle();
  const base = cur && new Date(cur.expires_at) > new Date() ? new Date(cur.expires_at) : new Date();
  base.setDate(base.getDate() + days);

  const { error } = await admin.from("entitlements").upsert({
    user_id: userId, expires_at: base.toISOString(), updated_at: new Date().toISOString(),
  });
  if (error) return new Response(error.message, { status: 500 });
  return new Response("ok");
});
