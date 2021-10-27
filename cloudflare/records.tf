# main records for public website
resource "cloudflare_record" "ironsecurity_cname" {
  zone_id = var.zone_iron_security
  name    = "iron.security"
  type    = "A"
  value   = "192.0.2.1"
  proxied = true
}


resource "cloudflare_record" "ironsecurity_cname6" {
  zone_id = var.zone_iron_security
  name    = "iron.security"
  type    = "AAAA"
  value   = "100::"
  proxied = true
}

resource "cloudflare_record" "www_ironsecurity_cname" {
  zone_id = var.zone_iron_security
  name    = "www.iron.security"
  type    = "A"
  value   = "192.0.2.1"
  proxied = true
}

resource "cloudflare_record" "www_ironsecurity_cname6" {
  zone_id = var.zone_iron_security
  name    = "www.iron.security"
  type    = "AAAA"
  value   = "100::"
  proxied = true
}

# docs records

resource "cloudflare_record" "ironsecuritydocs_cname" {
  zone_id = var.zone_iron_security
  name    = "docs.iron.security"
  type    = "A"
  value   = "192.0.2.1"
  proxied = true
}


resource "cloudflare_record" "ironsecuritydocs_cname6" {
  zone_id = var.zone_iron_security
  name    = "docs.iron.security"
  type    = "AAAA"
  value   = "100::"
  proxied = true
}

# verification records
resource "cloudflare_record" "github_challenge" {
  zone_id = var.zone_iron_security
  name    = "_github-challenge-iron-security"
  type    = "TXT"
  value   = "c6c0d17bf9"
}

resource "cloudflare_record" "google_challenge" {
  zone_id = var.zone_iron_security
  name    = "iron.security"
  type    = "TXT"
  value   = "google-site-verification=WoAIdZjAy4mljV8GtYNFoobk0qFa0qQfvN1ekA74XFo"
}

# email security (SPF)
resource "cloudflare_record" "ironsecurity_spf" {
  zone_id = var.zone_iron_security
  name    = "iron.security"
  type    = "TXT"
  value   = "v=spf1 include:_spf.google.com -all"
}

# email servers
resource "cloudflare_record" "mx_ironsecurity_4" {
  zone_id  = var.zone_iron_security
  name     = "iron.security"
  priority = "10"
  ttl      = "1"
  type     = "MX"
  value    = "alt4.aspmx.l.google.com"
}

resource "cloudflare_record" "mx_ironsecurity_3" {
  zone_id  = var.zone_iron_security
  name     = "iron.security"
  priority = "10"
  ttl      = "1"
  type     = "MX"
  value    = "alt3.aspmx.l.google.com"
}

resource "cloudflare_record" "mx_ironsecurity_2" {
  zone_id  = var.zone_iron_security
  name     = "iron.security"
  priority = "5"
  ttl      = "1"
  type     = "MX"
  value    = "alt2.aspmx.l.google.com"
}

resource "cloudflare_record" "mx_ironsecurity_1" {
  zone_id  = var.zone_iron_security
  name     = "iron.security"
  priority = "5"
  ttl      = "1"
  type     = "MX"
  value    = "alt1.aspmx.l.google.com"
}

resource "cloudflare_record" "mx_ironsecurity_0" {
  zone_id  = var.zone_iron_security
  name     = "iron.security"
  priority = "1"
  ttl      = "1"
  type     = "MX"
  value    = "aspmx.l.google.com"
}

resource "cloudflare_record" "a_statusironsecurity" {
  zone_id = var.zone_iron_security
  name    = "status.iron.security"
  type    = "A"
  value   = "124.1.2.1"
  proxied = true
}