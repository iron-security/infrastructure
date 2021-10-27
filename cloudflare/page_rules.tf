// redirect ironsecurity.be -> iron.security
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

// redirect status.iron.security -> uptimerobot
resource "cloudflare_page_rule" "redirect_status_website" {
  actions {
    forwarding_url {
      status_code = "301"
      url         = "https://stats.uptimerobot.com/jBkGzHYl54"
    }
  }

  priority = "1"
  status   = "active"
  target   = "status.iron.security/*"
  zone_id  = var.zone_iron_security
}