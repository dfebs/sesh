module UserMailerHelper
  COLORS = {
    text: "#c8cbf4",
    background: "#091817",
    links: "#aab7ed"
  }

  STYLES = {
    h1: "color:#{COLORS[:text]}",
    p: "color:#{COLORS[:text]}",
    href: "color:#{COLORS[:links]}",
    body: "background-color:#{COLORS[:background]};padding-left:20vw;padding-right:20vw",
    html: "background-color:#{COLORS[:background]};font-family:Segoe UI,sans-serif;"
  }

  def email_style(element)
    STYLES[element]
  end
end
