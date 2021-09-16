resource "cloudflare_page_rule" "redirect_be_website" {
  actions {
    forwarding_url {
      status_code = "301"
      url         = "https://iron.security/"
    }
  }

  priority = "1"
  status   = "active"
  target   = "ironsecurity.be/*"
  zone_id  = var.zone_ironsecurity_be
}